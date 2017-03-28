local CONS = require 'resty.mns.constants'
local setmetatable = setmetatable

local _M = {}

function _M:new(  )
	local instance = {}

	return setmetatable(instance, {__index = _M})
end

function _M:initFromXml( node ) 
	if node.MessageId then self.MessageId = node.MessageId:value() end
	if node.ReceiptHandle then self.ReceiptHandle = node.ReceiptHandle:value() end
	if node.MessageBodyMD5 then self.MessageBodyMD5 = node.MessageBodyMD5:value() end
	if node.MessageBody then self.MessageBody = node.MessageBody:value() end
	if node.EnqueueTime then self.EnqueueTime = node.EnqueueTime:value() end
	if node.NextVisibleTime then self.NextVisibleTime = node.NextVisibleTime:value() end
	if node.FirstDequeueTime then self.FirstDequeueTime = node.FirstDequeueTime:value() end
	if node.DequeueCount then self.DequeueCount = node.DequeueCount:value() end
	if node.Priority then self.Priority = node.Priority:value() end
end

function _M:getMessageId( )
	return self.MessageId
end

function _M:getReceiptHandle( )
	return self.ReceiptHandle
end

function _M:getMessageBody( )
	return self.MessageBody
end

function _M:getMessageBodyMD5(  )
	return self.MessageBodyMD5
end

function _M:getEnqueueTime( )
	return self.EnqueueTime
end

function _M:getFirstDequeueTime( )
	return self.FirstDequeueTime
end

function _M:getNextVisibleTime( )
	return self.NextVisibleTime
end

function _M:getDequeueCount( )
	return self.DequeueCount
end

function _M:getPriority( )
	return self.Priority
end

return _M