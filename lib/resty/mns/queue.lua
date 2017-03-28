local request = require "resty.mns.request"
local response = require "resty.mns.response"
local constants = require "resty.mns.constants"

local setmetatable = setmetatable

local log = ngx.log
local DEBUG = ngx.DEBUG
local INFO = ngx.INFO
local ERR = ngx.ERR

local _M = {}

local mt = { __index = _M }

function _M:new( queueName, mnsClient )
	
	local instance = {
		queueName = queueName,
		mnsClient = mnsClient
	}

	return setmetatable( instance, mt )
	
end

function _M:sendMessage( messageBody, delaySeconds, priority )
	local queueRequest = request:SendMessageRequest(self.queueName, messageBody, delaySeconds, priority)

	local mnsClient = self.mnsClient
	local res, err = mnsClient:request(queueRequest)
	if not res then
		return false, err
	end

	local queueResponse, err = response:SendMessageResponse(res)
	if not queueResponse then
		return false, err
	end

	return queueResponse.result
end

function _M:BatchSendMessage( messageList )
	local queueRequest = request:BatchSendMessageRequest(self.queueName, messageList)

	local mnsClient = self.mnsClient
	local res, err = mnsClient:request(queueRequest)
	if not res then
		return nil, err
	end

	local queueResponse, err = response:BatchSendMessageResponse(res)
	if not queueResponse then
		return nil, err
	end

	return queueResponse
end

function _M:peekMessage( )
	local queueRequest = request:PeekMessageRequest(self.queueName)

	local mnsClient = self.mnsClient
	local res, err = mnsClient:request(queueRequest)
	if not res then
		return nil, err
	end

	local queueResponse, err = response:PeekMessageResponse(res)
	if not queueResponse then
		return nil, err
	end

	return queueResponse.message
end

function _M:batchPeekMessage( numOfMessages )
	local queueRequest = request:BatchPeekMessageRequest(self.queueName, numOfMessages)

	local mnsClient = self.mnsClient
	local res, err = mnsClient:request(queueRequest)
	if not res then
		return nil, err
	end

	local queueResponse = response:BatchPeekMessageResponse(res)
	if not queueResponse then
		return nil, err
	end

	return queueResponse.messages
end

function _M:receiveMessage( )
	local queueRequest = request:ReceiveMessageRequest(self.queueName)

	local mnsClient = self.mnsClient
	local res, err = mnsClient:request(queueRequest)
	if not res then
		return nil, err
	end

	local queueResponse, err = response:ReceiveMessageResponse(res)
	if not queueResponse then
		return nil, err
	end

	return queueResponse.message
end

function _M:receiveMessageDelay( waitForSeconds )
	local queueRequest = request:ReceiveMessageRequest(self.queueName, waitForSeconds)

	local mnsClient = self.mnsClient
	local res, err = mnsClient:request(queueRequest)
	if not res then
		return nil, err
	end

	local queueResponse = response:ReceiveMessageResponse(res)
	if not queueResponse then
		return nil, err
	end

	return queueResponse.message
end

function _M:batchReceiveMessage( numOfMessages )
	local queueRequest = request:BatchReceiveMessageRequest(self.queueName, numOfMessages)

	local mnsClient = self.mnsClient
	local res, err = mnsClient:request(queueRequest)
	if not res then
		return nil, err
	end

	local queueResponse = response:BatchReceiveMessageResponse(res)
	if not queueResponse then
		return nil, err
	end

	return queueResponse.messages
end

function _M:batchReceiveMessageDelay( numOfMessages, waitForSeconds )
	local queueRequest = request:BatchReceiveMessageRequest(self.queueName, numOfMessages, waitForSeconds)

	local mnsClient = self.mnsClient
	local res, err = mnsClient:request(queueRequest)
	if not res then
		return nil, err
	end

	local queueResponse = response:BatchReceiveMessageResponse(res)
	if not queueResponse then
		return nil, err
	end

	return queueResponse.messages
end

function _M:deleteMessage( receiptHandle )
	local queueRequest = request:DeleteMessageRequest(self.queueName, receiptHandle)

	local mnsClient = self.mnsClient
	local res, err = mnsClient:request(queueRequest)
	if not res then
		return nil, err
	end

	local queueResponse = response:DeleteMessageResponse(res)
	if not queueResponse then
		return nil, err
	end

	return true
end

function _M:batchDeleteMessage( receiptHandles )
	local queueRequest = request:BatchDeleteMessageRequest(self.queueName, receiptHandles)

	local mnsClient = self.mnsClient
	local res, err = mnsClient:request(queueRequest)
	if not res then
		return nil, err
	end

	local queueResponse = response:BatchDeleteMessageResponse(res)
	if not queueResponse then
		return nil, err
	end

	return queueResponse
end

function _M:changeMessageVisibility( receiptHandle, visibilityTimeout )
local queueRequest = request:ChangeMessageVisibilityRequest(self.queueName, receiptHandle, visibilityTimeout)

	local mnsClient = self.mnsClient
	local res, err = mnsClient:request(queueRequest)
	if not res then
		return nil, err
	end

	local queueResponse = response:ChangeMessageVisibilityResponse(res)
	if not queueResponse then
		return nil, err
	end

	return queueResponse.result
end

return _M