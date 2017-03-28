local setmetatable = setmetatable
local ipairs = ipairs
local xml = require 'xmlSimple'.newParser()
local mns_message = require 'resty.mns.message'
local CONS = require 'resty.mns.constants'
local log = ngx.log
local DEBUG = ngx.DEBUG
local INFO = ngx.INFO
local ERR = ngx.ERR

local _M = {}

local mt = { __index = _M }

local function toxml( xmlStr )
	local data = xml:ParseXmlText(xmlStr)
	if data and data:numChildren() > 0 then
		return data:children()[1]
	else
		return nil
	end
end

function _M:new( res )
	if not res then
		return nil, 'error response'
	end

	local instance = {
		status = res.status,
		headers = res.headers
	}

	if res.body and #res.body > 0 then
		local node = toxml(res.body)
		if not node or type(node) ~= 'table' then
			log(ERR, 'parse xml error')
			return nil, 'parse xml error'
		else
			instance.xmlNode = node
		end
	end

	return setmetatable(instance, {__index = _M})
end

function _M:SendMessageResponse( res )
	local response, err = self:new(res)	
	if not response then
		return nil, err
	end

	if response.status ~= 201 then
		if response.status == 404 then
			return nil, CONS.MESSAGE_NOT_EXIST
		else
			return nil, 'bad status code: ' .. response.status
		end
	end

	local sendMessageResult_node = response.xmlNode
	if sendMessageResult_node:name() ~= 'Message' or sendMessageResult_node:numChildren() == 0 then
		return nil, 'no result of sendMessage'
	end

	local result = {}
	if sendMessageResult_node.MessageId then 
		result.MessageId = sendMessageResult_node.MessageId:value() 
	end

	if sendMessageResult_node.MessageBodyMD5 then 
		result.MessageBodyMD5 = sendMessageResult_node.MessageBodyMD5:value() 
	end

	if sendMessageResult_node.ReceiptHandle then 
		result.ReceiptHandle = sendMessageResult_node.ReceiptHandle:value() 
	end

	response.result = result

	return response
end

function _M:BatchSendMessageResponse( res )
	local response, err = self:new(res)	
	if not response then
		return nil, err
	end

	if response.status ~= 200 then
		if response.status == 404 then
			return nil, CONS.MESSAGE_NOT_EXIST
		else
			return nil, 'bad status code: ' .. response.status
		end
	end

	local sendMessageResults_node = response.xmlNode
	if sendMessageResults_node:name() ~= 'Messages' or sendMessageResults_node:numChildren() == 0 then
		return nil, 'no result of sendMessage'
	end

	local result_list = {}
	local sendMessageResults = sendMessageResults_node:children()

	for i, v in ipairs(sendMessageResults) do
		local result = {}
		if v.MessageId then 
			result.MessageId = v.MessageId:value() 
		end

		if v.MessageBodyMD5 then 
			result.MessageBodyMD5 = v.MessageBodyMD5:value() 
		end

		if v.ReceiptHandle then 
			result.ReceiptHandle = v.ReceiptHandle:value()
		end
		
		result_list[i] = result
	end

	response.result = result_list

	return response
end

function _M:PeekMessageResponse( res )
	local response, err = self:new(res)	
	if not response then
		return nil, err
	end

	if response.status ~= 200 then
		if response.status == 404 then
			return nil, CONS.MESSAGE_NOT_EXIST
		else
			return nil, 'bad status code: ' .. response.status
		end
	end

	local message = mns_message:new()

	message:initFromXml(response.xmlNode)

	response.message = message

	return response
end

function _M:BatchPeekMessageResponse( res )
	local response, err = self:new(res)	
	if not response then
		return nil, err
	end

	if response.status ~= 200 then
		if response.status == 404 then
			return nil, CONS.MESSAGE_NOT_EXIST
		else
			return nil, 'bad status code: ' .. response.status
		end
	end

	local messages_node = response.xmlNode
	if messages_node:name() ~= 'Messages' or messages_node:numChildren() == 0 then
		return nil, 'error return xml'
	end

	response.messages = {}
	local message_node_list = messages_node:children()
	for i, v in ipairs(message_node_list) do
		local message = mns_message:new()
		message:initFromXml(v)
		if message:getMessageId() then
			response.messages[i] = message
		end
	end

	return response
end

function _M:ReceiveMessageResponse( res )
	local response, err = self:new(res)	
	if not response then
		return nil, err
	end

	if response.status ~= 200 then
		if response.status == 404 then
			return nil, CONS.MESSAGE_NOT_EXIST
		else
			return nil, 'bad status code: ' .. response.status
		end
	end

	--log(DEBUG, 'get message')

	local message = mns_message:new()

	message:initFromXml(response.xmlNode)

	response.message = message

	return response
end

function _M:BatchReceiveMessageResponse( res )
	local response, err = self:new(res)	
	if not response then
		return nil, err
	end

	if response.status ~= 200 then
		if response.status == 404 then
			return nil, CONS.MESSAGE_NOT_EXIST
		else
			return nil, 'bad status code: ' .. response.status
		end
	end

	local messages_node = response.xmlNode
	if messages_node:name() ~= 'Messages' or messages_node:numChildren() == 0 then
		return nil, 'error return xml'
	end

	response.messages = {}
	local message_node_list = messages_node:children()
	for i, v in inpairs(message_node_list) do
		local message = mns_message:new()
		message:initFromXml(v)
		if message:getMessageId() then
			response.messages[i] = message
		end
	end

	return response
end

function _M:DeleteMessageResponse( res )
	local response, err = self:new(res)	
	if not response then
		return nil, err
	end

	if response.status ~= 204 then
		if response.status == 404 then
			return nil, CONS.QUEUE_NOT_EXIST
		else
			return nil, 'bad status code: ' .. response.status
		end
	end

	return response
end

function _M:BatchDeleteMessageResponse( res )
	local response, err = self:new(res)	
	if not response then
		return nil, err
	end

	if response.status ~= 204 then
		return response
	end

	return response
end

function _M:ChangeMessageVisibilityResponse( res )
	local response, err = self:new(res)	
	if not response then
		return nil, err
	end

	if response.status ~= 200 then
		if response.status == 404 then
			return nil, CONS.MESSAGE_NOT_EXIST
		else
			return nil, 'bad status code: ' .. response.status
		end
	end

	local result = {}
	result.ReceiptHandle = response.xmlNode.ReceiptHandle
	result.NextVisibleTime = response.xmlNode.NextVisibleTime

	return response
end

return _M