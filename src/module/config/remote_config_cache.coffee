util = require('util')
LOCAL_IP = require("../util/ip_util").LOCAL_IP
Log = require("../log/log")


KEY_WHITE_IP_LIST = "_whiteIpList"
KEY_VERSION_CONTROL = "_versionControl"
KEY_GLOBAL_LOCK = "_globalLock"
SYS_KEYS = [KEY_VERSION_CONTROL, KEY_WHITE_IP_LIST, KEY_GLOBAL_LOCK]

class RemoteConfigCache

	constructor : ->
		@_inited = false
		@_cache = {}
		@_sys = {}

	init : ->
		if not @_inited
			@_cache = {}
			@_inited = true
			@_status = {}

	set : (key, value)->
		Log.debug("remote config cache key:#{key}, value:#{value}")
		if key in SYS_KEYS
			@_sys[key] = value
			return
		return if not @isAllowUpdate()
		@_cache[key] = value
		return

	setDataBytes : (key, bytes)->
		return if not bytes
		try
			_obj = JSON.parse(bytes)
			@set(key, _obj)
		catch err
			Log.error("RemoteConfigCache setData error for key :#{key}, may be JSON Object error:#{err}")

	get : (key)->
		@_cache[key]

	getLastModifyTime : ->
		@_cache[KEY_VERSION_CONTROL]?.lastModifyTime

	# check local is in whiteIpList and global lock is false
	isAllowUpdate : ->
		_whiteIpList = @_sys[KEY_WHITE_IP_LIST]
		return true if not _whiteIpList or not util.isArray(_whiteIpList)
		return true if LOCAL_IP in _whiteIpList
		return false

	isNeedUpdate : (centerVerData)->
		return false if not centerVerData
		_centerVerObj = JSON.parse(centerVerData)
		#TODO test @_sys[KEY_VERSION_CONTROL] 不存在时，这个等式成立吗？
		if @_sys[KEY_VERSION_CONTROL]?.lastModifyTime < _centerVerObj.lastModifyTime
			@set(KEY_VERSION_CONTROL, _centerVerObj)
			return true
		return false

	getStatus : ->
		JSON.stringify(@_status)


_instance = new RemoteConfigCache()
_instance.KEY_VERSION_CONTROL = KEY_VERSION_CONTROL

exports.RemoteConfigCache = _instance
