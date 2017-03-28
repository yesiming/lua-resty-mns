local CONS = require "resty.mns.constants"
local log = ngx.log
local DEBUG = ngx.DEBUG
local encode_base64 = ngx.encode_base64

local setmetatable = setmetatable
local ipairs = ipairs

local _M = {}

local mt = { __index = _M }

function _M:getMethod( )
	return self.method
end

function _M:setHeader( type, value )
	local header = self.header
	if not header then
		header = {}
		self.header = header
	end

	header[type] = value
end

function _M:getHeader( type )
	if not type then
		return self.header
	else
		return self.header[type]
	end
end

function _M:generateCanonicalizedResource( )
	local canonicalizedResource = self.resourcePath
	if self.queryString and #self.queryString > 0 then
		canonicalizedResource = canonicalizedResource .. '?' .. self.queryString
	end

	return canonicalizedResource
end

function _M:getRequestBody( )
	return self.requestBody
end

function _M:generateRequestBody( )
	return self.requestBody
end

function _M:QueueRequest( method )
	local instance = {
		method = method,
		resourcePath = '/queues'
	}

	return setmetatable(instance, mtss)
end

function _M:MessageRequest( method, queuename )
	local instance = {
		method = method,
		queuename = queuename
	}

	if queuename then
		instance.resourcePath = "/queues/" .. queuename .. "/messages"
	end

	return setmetatable( instance, mt)
end

function _M:SendMessageRequest( queuename, messageBody, delaySeconds, priority )
	delaySeconds = delaySeconds or -1
	priority = priority or -1

	local request = self:MessageRequest(CONS.POST, queuename)

	request.queryString = ""
	request.requestBody = '<?xml version="1.0" encoding="UTF-8"?><Message xmlns="' .. CONS.MNS_XML_NAMESPACE_V1 
							.. '"><MessageBody>' .. encode_base64(messageBody) .. '</MessageBody>';

	if delaySeconds > 0 then
		request.requestBody = request.requestBody .. '<DelaySeconds>' .. delaySeconds .. '</DelaySeconds>'
	end

	if priority > 0 then
		request.requestBody = request.requestBody .. '<Priority>' .. priority .. '</Priority>'
	end

	request.requestBody = request.requestBody .. '</Message>'

	return request
end

function _M:BatchSendMessageRequest( queuename, messageList )
	local request = self:MessageRequest(CONS.POST, queuename)

	request.queryString = ""
	request.requestBody = '<?xml version="1.0" encoding="UTF-8"?><Messages xmlns="' .. CONS.MNS_XML_NAMESPACE_V1	.. '>'

	for _, v in ipairs(messageList) do

		if v.messageBody then
			
			request.requestBody = request.requestBody .. '<Message>'

			request.requestBody = request.requestBody ..'<MessageBody>' .. encode_base64(v.messageBody) .. '</MessageBody>';

			if v.delaySeconds and v.delaySeconds > 0 then
				request.requestBody = request.requestBody .. '<DelaySeconds>' .. delaySeconds .. '</DelaySeconds>'
			end

			if v.priority and v.priority > 0 then
				request.requestBody = request.requestBody .. '<Priority>' .. priority .. '</Priority>'
			end

			request.requestBody = request.requestBody .. '</Message>'
		end

	end

	request.requestBody = request.requestBody .. '</Messages>'

	return request
end

function _M:PeekMessageRequest( queuename )
	local request = self:MessageRequest(CONS.GET, queuename)

	request.queryString = 'peekonly=true'
	request.requestBody = ''

	return request
end

function _M:BatchPeekMessageRequest( queuename, numOfMessages )
	local request = self:MessageRequest(CONS.GET, queuename)

	request.queryString = 'peekonly=true&numOfMessages=' .. numOfMessages
	request.requestBody = ''
	return request
end

function _M:ReceiveMessageRequest( queuename, waitSeconds )
	local request = self:MessageRequest(CONS.GET, queuename)
	
	if waitSeconds and waitSeconds > 0 then
		request.queryString = 'waitseconds=' .. waitseconds
	else
		request.queryString = ''
	end

	request.requestBody = ''
	return request
end

function _M:BatchReceiveMessageRequest( queuename, numOfMessages, waitseconds )
	local request = self:MessageRequest(CONS.GET, queuename)

	request.queryString = 'numOfMessages=' .. numOfMessages
	if waitseconds and waitseconds > 0 then
		request.queryString = request.queryString .. '&waitseconds=' .. waitseconds
	end

	request.requestBody = ''
	return request
end

function _M:DeleteMessageRequest( queuename, receiptHandle )
	local request = self:MessageRequest(CONS.DELETE_METHOD, queuename)

	request.queryString = 'ReceiptHandle=' .. receiptHandle
	request.requestBody = ''
	return request
end

function _M:BatchDeleteMessageRequest( queuename, receiptHandles )
	local request = self:MessageRequest(CONS.DELETE_METHOD, queuename)

	request.queryString = ''

	request.requestBody = '<?xml version="1.0" encoding="UTF-8"?><ReceiptHandles xmlns="' .. CONS.MNS_XML_NAMESPACE_V1 .. '>'

	for _, v in ipairs(receiptHandles) do
		request.requestBody = request.requestBody .. '<ReceiptHandle>' .. v .. '</ReceiptHandle>'
	end

	request.requestBody = request.requestBody .. '</ReceiptHandles>'

	return request
end

function _M:ChangeMessageVisibilityRequest( queuename, receiptHandle, visibilityTimeout )
	local request = self:MessageRequest(CONS.PUT, queuename)

	request.queryString = 'receiptHandle=' .. receiptHandle .. '&visibilityTimeout=' .. visibilityTimeout

	request.requestBody = ''

	return request
end

function _M:SubscriptionRequest( method, topicName, subscriptionName )
	
end

function _M:GetAccountAttributesRequest( )
	
end

function _M:SetAccountAttributesRequest(  )
	-- body
end

return _M