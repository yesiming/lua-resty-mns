local mns_queue = require "resty.mns.queue"
local mns_topic = require "resty.mns.topic"
local CONS = require "resty.mns.constants"
local http = require 'resty.http'

local strfind = string.find
local strsub = string.sub
local format = string.format
local ipairs = ipairs
local pairs = pairs
local type = type
local setmetatable = setmetatable

local re_match = ngx.re.match
local hmac_sha1 = ngx.hmac_sha1
local encode_base64 = ngx.encode_base64
local now = ngx.time
local http_time = ngx.http_time

local log = ngx.log
local DEBUG = ngx.DEBUG
local INFO = ngx.INFO
local ERR = ngx.ERR

local _M = {}

local mt = { __index = _M }

local ok, new_tab = pcall(require, "table.new")
if not ok then
    new_tab = function (narr, nrec) return {} end
end

function _M:new( endpoint, accessid, accesskey, ststoken, connPoolSize, timeout, connectTimeout)

	connPoolSize = connPoolSize or 200
	timeout = timeout or 35000
	connectTimeout = connectTimeout or 35000

	local instance = {
		endpoint = endpoint,
		accessid = accessid,
		accesskey = accesskey,
		ststoken = ststoken,
		connPoolSize = connPoolSize,
		timeout = timeout,
		connectTimeout = connectTimeout
	}

	return setmetatable( instance, mt )
end

function _M:updateAccessId( accessid, accesskey, ststoken )
	if not accessid then self.accessid = accessid end
	if not accesskey then self.accesskey = accesskey end
	if not ststoken then self.ststoken = ststoken end
end

function _M:getAccountAttributes()
	
end

function _M:getQueueRef( queueName )
	if not queueName or #queueName == 0 then
		return nil, 'queue name is null'
	end
	
	local queue = mns_queue:new(queueName, self)

	return queue
end

function _M:getTopicRef( topicName )
	local topic = mns_topic:new(topicName, self)

	return topic
end

function _M:signRequest( request )
	if self.ststoken then
		request:setHeader(CONS.SECURITY_TOKEN, self.ststoken)
	end

	local canonicalizedResource = request:generateCanonicalizedResource()
	local requestBody = request:generateRequestBody()
	local contentLength = #requestBody

	local pos = strfind(self.endpoint, '//') + 2
	request:setHeader(CONS.HOST, strsub(self.endpoint, pos, #self.endpoint))
	request:setHeader(CONS.CONTENT_TYPE, CONS.DEFAULT_CONTENT_TYPE)
	request:setHeader(CONS.DATE, http_time(now()))
	request:setHeader(CONS.MNS_VERSION, CONS.CURRENT_VERSION)
	if contentLength > 0 then
        request:setHeader(CONS.CONTENT_LENGTH, format('%d', contentLength))
    end

    request:setHeader(CONS.AUTHORIZATION, self:sign(request, canonicalizedResource))
end

function _M:sign( request, canonicalizedResource )
	local origin = ""
	origin = origin .. request:getMethod()
	origin = origin .. '\n'
	local key_tab = {CONS.CONTENT_MD5, CONS.CONTENT_TYPE, CONS.DATE}
	for _, v in ipairs(key_tab) do
		local value = request:getHeader(v)
		if value and type(value) ~= 'table' then 
			origin = origin .. value			
		end
		origin = origin .. '\n'
	end

	local header = request:getHeader()
	local regex_pattern = '^' .. CONS.CANONICALIZED_MNS_HEADER_PREFIX .. '.*$'
	if header and type(header) == 'table' then
		for k, v in pairs(header) do
			if re_match(k, regex_pattern) then
				origin = origin .. k .. ':' .. v .. '\n'
			end
		end
	end

	origin = origin .. canonicalizedResource

	--log(DEBUG, origin)

	local digest = hmac_sha1(self.accesskey, origin)

	local base64_str = encode_base64(digest)

	return "MNS " .. self.accessid .. ':' .. base64_str 
end

function _M:sendRequest( request )
	local httpc = http:new()

	httpc:set_timeout(self.connectTimeout)

	request:setHeader('Connection', 'keep-alive')
	local url = self.endpoint .. request:generateCanonicalizedResource()

	local try_count = 3
	local res, err
	while try_count > 0 do 
		res, err = httpc:request_uri(
			url, 
			{
				method = request:getMethod(),
				body = request:getRequestBody(),
				headers = request:getHeader()
			}
		)

		--log(DEBUG, request:getRequestBody())

		try_count = try_count - 1

		if res and res.status > 500 then 
			log(ERR, 'failed to request, status: ', res.status, ' error: ', err, ' left try ', try_count, ' times')
		else
			break	
		end
	end 

	httpc:set_keepalive(self.timeout, self.connPoolSize)

	if res and res.body then
		log(DEBUG, res.body)
	end

	return res
end

function _M:request( request )
	self:signRequest(request)

	return self:sendRequest(request)
end


return _M