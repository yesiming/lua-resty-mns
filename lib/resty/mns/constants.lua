

local _M = {
	GET = "GET",
	PUT = "PUT",
	POST = "POST",
	DELETE_METHOD = "DELETE",

	HOST = "Host",
	CURRENT_VERSION = "2015-06-06",
	CONTENT_TYPE = "Content-Type",
	CONTENT_LENGTH = "Content-Length",
	SECURITY_TOKEN = "security-token",
	DATE = "Date",
	MNS_VERSION = "x-mns-version",
	MNS_PREFIX = "x-mns-prefix",
	MNS_MARKER = "x-mns-marker",
	MNS_RETNUM = "x-mns-ret-number",
	AUTHORIZATION = "Authorization",
	CONTENT_MD5 = "Content-MD5",
	LOCATION = "Location",
	CANONICALIZED_MNS_HEADER_PREFIX = "x-mns-",
	MNS_XML_NAMESPACE_V1 = "http://mns.aliyuncs.com/doc/v1",
	DEFAULT_CONTENT_TYPE = "text/xml,charset=UTF-8",

	
	MESSAGE_NOT_EXIST = "MessageNotExist",
	QUEUE_NOT_EXIST = "QueueNotExist",
	TOPIC_NOT_EXIST = "TopicNotExist",
	SUBSCRIPTION_NOT_EXIST = "SubscriptionNotExist",
	QUEUE_ALREADY_EXIST = "QueueAlreadyExist",
	TOPIC_ALREADY_EXIST = "TopicAlreadyExist",
	SUBSCRIPTION_ALREADY_EXIST = "SubscriptionAlreadyExist",
	STATE_CONFLICT = "StateConflict",
	REQUEST_TIMEOUT = "RequestTimeout",

	BEGIN_CURSOR = "begin",
	NEXT_CURSOR = "next",

	HTTP_PREFIX = "http://",
	HTTPS_PREFIX = "https://",

	NOTIFY_STRATEGY_BACKOFF_RETRY = "BACKOFF_RETRY",
	NOTIFY_STRATEGY_EXPONENTIAL_DECAY_RETRY = "EXPONENTIAL_DECAY_RETRY",
	SUBSCRIPTION_STATE_ACTIVE = "Active",
	SUBSCRIPTION_STATE_INACTIVE = "Inactive",

	ERROR_TAG = "Error",
	QUEUE = "Queue",
	QUEUES = "Queues",
	TOPIC = "Topic",
	TOPICS = "Topics",
	SUBSCRIPTION = "Subscription",
	SUBSCRIPTIONS = "Subscriptions",
	QUEUE_URL = "QueueURL",
	TOPIC_URL = "TopicURL",
	SUBSCRIPTION_URL = "SubscriptionURL",
	QUEUE_NAME = "QueueName",
	MESSAGE = "Message",
	REQUEST_ID = "RequestId",
	HOST_ID = "HostId",
	MESSAGE_ID = "MessageId",
	MESSAGE_BODY = "MessageBody",
	MESSAGE_BODY_MD5 = "MessageBodyMD5",
	RECEIPT_HANDLE = "ReceiptHandle",
	ENQUEUE_TIME = "EnqueueTime",
	FIRST_DEQUEUE_TIME = "FirstDequeueTime",
	NEXT_VISIBLE_TIME = "NextVisibleTime",
	DEQUEUE_COUNT = "DequeueCount",
	PRIORITY = "Priority",
	CODE = "Code",
	CREATE_TIME = "CreateTime",
	LAST_MODIFY_TIME = "LastModifyTime",
	VISIBILITY_TIMEOUT = "VisibilityTimeout",
	DELAY_SECONDS = "DelaySeconds",
	MAXIMUM_MESSAGE_SIZE = "MaximumMessageSize",
	MESSAGE_RETENTION_PERIOD= "MessageRetentionPeriod",
	ACTIVE_MESSAGES = "ActiveMessages",
	INACTIVE_MESSAGES = "InactiveMessages",
	DELAY_MESSAGES = "DelayMessages",
	POLLING_WAIT_SECONDS = "PollingWaitSeconds",
	ERROR_MESSAGE = "ErrorMessage",
	ERROR_CODE = "ErrorCode",
	NEXT_MARKER = "NextMarker",
	MESSAGE_COUNT = "MessageCount",
	LOGGING_BUCKET = "LoggingBucket",
	LOGGING_ENABLED = "LoggingEnabled",

	ENDPOINT = "Endpoint",
	BACKOFF_RETRY_STR = "BACKOFF_RETRY",
	EXPONENTIAL_DECAY_RETRY_STR = "EXPONENTIAL_DECAY_RETRY",
	XML_STR = "XML",
	SIMPLIFIED_STR = "SIMPLIFIED",
	JSON_STR = "JSON",
	NOTIFY_STRATEGY_STR = "NotifyStrategy",
	CONTENT_FORMAT_STR = "NotifyContentFormat",
	SUBSCRIPTION_NAME = "SubscriptionName",
	TOPIC_OWNER = "TopicOwner",
	TOPIC_NAME = "TopicName",
}

return _M