local setmetatable = setmetatable

local _M = {}

local mt = { __index = _M }

function _M:new( topicName, mnsClient )
	
	local instance = {
		topicName = topicName,
		mnsClient = mnsClient
	}

	return setmetatable( instance, mt )
	
end


return _M
