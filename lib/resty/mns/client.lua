local setmetatable = setmetatable

local _M = {}

local mt = { __index = _M }

local ok, new_tab = pcall(require, "table.new")
if not ok then
    new_tab = function (narr, nrec) return {} end
end

function _M:new( endpoint, accessid, accesskey, ststoken, connPoolSize = 200, timeout = 35, connectTimeout = 35)
	local instance = {
		endpoint = endpoint,
		accessid = accessid,
		accesskey = accesskey,
		ststoken = ststoken,
		connPoolSize = connPoolSize,
		timeout = timeout,
		connectTimeout = connPoolSize
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