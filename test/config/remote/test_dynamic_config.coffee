ConfigBundles = require("../../../src/index").ConfigBundles
ZkClient = require("../../zk_test_util").ZkClient
ZkClient.init()
ConfigFile = "/Users/vernonzheng/Project/github/hades-node-client/test/setting/test_hades_remote.json"
#TEST_REMOTE_NODE = "tiny_video_redis"
TEST_REMOTE_NODE = "testDynamic"

ConfigBundles.on(ConfigBundles.EVENT_READY, ->
	setInterval( =>
		console.log("node value:"+ConfigBundles.getDynamic(TEST_REMOTE_NODE))
	,1000)
)
ConfigBundles.on(ConfigBundles.EVENT_FAIL, ->
	console.log("ConfigBundles receive EVENT_CONFIG_FAIL!!")
)
ConfigBundles.init(ConfigFile)

#use ./modify_data.js to modify zookeeper data

