// Generated by CoffeeScript 1.3.3
(function() {
  var CONFIG_ROOT, PROJECT_NAME, client, zookeeper;

  zookeeper = require('node-zookeeper-client');

  CONFIG_ROOT = "/hades/configs/";

  PROJECT_NAME = "test";

  client = zookeeper.createClient('localhost:2181/hades/config/', {
    sessionTimeout: 10000
  });

  client.create();

  client.connect();

}).call(this);