local setmetatable = setmetatable

local _M = {}

local mt = { __index = _M }

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

function _M:SubscriptionRequest( method, topicName, subscriptionName )
	local instance = {
		method = method,
		topicName = topicName,
		subscriptionName = subscriptionName
	}

	if topicName and subscriptionName then
		instance.resourcePath = "/topics/" .. topicName .. "/subscriptions/" .. subscriptionName
	end

	return setmetatable( instance, mt )
end

function _M:GetAccountAttributesRequest( )
	local instance = {
		method = "GET",
		queryString = "accountmeta=true",
		resourcePath = "/",
		requestBody = ""
	}

	return setmetatable( instance, mt )
end

function _M:SetAccountAttributesRequest(  )
	-- body
end

return _M