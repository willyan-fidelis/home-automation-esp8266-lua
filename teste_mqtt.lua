--https://github.com/mqtt/mqtt.github.io/wiki/public_brokers

-- init mqtt client with logins(UserName and Password), keepalive timer 120sec
m = mqtt.Client("clientid", 120, "bvxpyvvg", "cYgr4xM3VKdz")--m11.cloudmqtt.com
m = mqtt.Client("clientid", 120, "willyan.sergio.fidelis@gmail.com", "dd4dd3f3")--mqtt.dioty.co
-- init mqtt client without logins, keepalive timer 120s
m = mqtt.Client("clientid", 120)

-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client don't send keepalive packet
--m:lwt("/lwt", "offline", 0, 0)

m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") end)

-- on publish message receive event
m:on("message", function(client, topic, data) 
  print(topic .. ":" ) 
  if data ~= nil then
    print(data)
  end
end)

-- for TLS: m:connect("192.168.11.118", secure-port, 1)
m:connect("iot.eclipse.org", 1883, 0,
m:connect("test.mosquitto.org", 1883, 0, --Not ok!
m:connect("dev.rabbitmq.com", 1883, 0, --Not ok!
m:connect("broker.mqttdashboard.com", 1883, 0,
m:connect("q.m2m.io", 1883, 0, --offline
m:connect("mqtt.simpleml.com", 1883, 0, --Not ok
m:connect("mqtt.dioty.co", 1883, 0, --Topic must be: "/willyan.sergio.fidelis@gmail.com/"
m:connect("m11.cloudmqtt.com", 14113, 0,
function(client)
    print("connected")
    -- subscribe topic with qos = 0
    m:subscribe("/topic",0, function(client) print("subscribe success") end)
    -- publish a message with data = hello, QoS = 0, retain = 0
    m:publish("/topic","hello",0,0, function(client) print("sent") end)
end, 
function(client, reason)
    print("failed reason: "..reason)
end)

-- Calling subscribe/publish only makes sense once the connection
-- was successfully established. In a real-world application you want
-- move those into the 'connect' callback or make otherwise sure the 
-- connection was established.

-- subscribe topic with qos = 0
--m:subscribe("/topic",0, function(client) print("subscribe success") end)
-- publish a message with data = hello, QoS = 0, retain = 0
--m:publish("/topic","hello",0,0, function(client) print("sent") end)

m:close();
-- you can call m:connect again

dofile("main.lua");

dofile("mqtt.lua");
