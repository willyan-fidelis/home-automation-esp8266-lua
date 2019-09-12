--https://github.com/mqtt/mqtt.github.io/wiki/public_brokers

--It was tested and it is working well:
-------- m11.cloudmqtt.com --------
-- general.pwd = "cYgr4xM3VKdz"
-- general.user = "bvxpyvvg"
-- general.port = 14113
-- general.ServNm = "m11.cloudmqtt.com"
-------- m11.cloudmqtt.com --------


-------- broker.mqttdashboard.com --------
-- general.pwd = ""
-- general.user = ""
-- general.port = 1883
-- general.ServNm = "broker.mqttdashboard.com"
-------- broker.mqttdashboard.com --------

-------- iot.eclipse.org --------
-- general.pwd = ""
-- general.user = ""
-- general.port = 1883
-- general.ServNm = "iot.eclipse.org"
-------- iot.eclipse.org --------

-------- MQTT --------
-- general.pwd = ""
-- general.user = ""
-- general.port = 1883
-- general.ServNm = "broker.hivemq.com"
-- general.path = ""
-------- MQTT --------

-------- MQTT --------
-- general.pwd = "mj7aCVs7Fe8wqcEDaj"
-- general.user = "UcSQ0Oteo578lxspev"
-- general.port = 1883
-- general.ServNm = "broker.bevywise.com"
-- general.path = ""
-------- MQTT --------

-- Not working yet:

-------- MQTT --------(Funciona, mas conecta e logo em seguida fica offline)
-- general.pwd = ""
-- general.user = "40jgralDA6WPWqt6OIOlpIBDIl86K12FS9J79SyyOkbyBtsd17ogDNHaZE6zvW2b"
-- general.port = 1883
-- general.ServNm = "mqtt.flespi.io"
-- general.path = ""
-------- MQTT --------

-------- MQTT -------- (Works at ESP but not at websocket APP)
-- general.pwd = "dd4dd3f3"
-- general.user = "willyan.sergio.fidelis@gmail.com"
-- general.port = 1883
-- general.ServNm = "mqtt.dioty.co"
-- general.path = "/willyan.sergio.fidelis@gmail.com"
-------- MQTT --------

-------- MQTT --------(Parece funcionar mas nao chega as menssagens de do lado do ESP nem do APP)
-- general.pwd = "C05C079E0B6AB10FC4291FB9FE325DB8"
-- general.user = "U000265"
-- general.port = 1883
-- general.ServNm = "m.thingscale.io"
-- general.path = ""
-------- MQTT --------



--On Events:
MQTT_STATUS = false
m = mqtt.Client(_number, 0, general.user, general.pwd)--m11.cloudmqtt.com
--m:on("connect", function(client)
--    print ("connected!!!")
--end)
m:on("offline", function(client)
    print ("offline")
    MQTT_STATUS = false
end)

function MsgPublish(_topic, _msg)
    if (MQTT_STATUS) then

        if (_msg == "") then
            print("MQTT STATUS Ok!")
            return
        end
        MQTT_STATUS = m:publish(_topic.._number.."/",_msg,2,0, function(client) print("Sent: ".._topic.._msg) end)
        print("Will send: ".._topic.._msg)
        if (not MQTT_STATUS ) then
            print("MQTT Requested failed!")
            m:close()
        end
    else
        --MQTTConnect(m:publish(_topic.._number.."/",_msg,2,0, function(client) print("Sent: ".._topic.._msg) end))
        --MQTTConnect(MsgPublish(_topic, _msg))

        --function MQTTConnect(_func)
            --print("vvv")
            --m:close()
            --print("xxx")
            --Create an MQTT connection:
            m:connect(general.ServNm, general.port, 0, 0,
            function(client)
                MQTT_STATUS = true

                print("connected")

                --m:publish("/HomeSense1985/FromDevice/Log/".._number,"100",0,0, function(client) print("sent") end)
                --MsgPublish("/HomeSense1985/FromDevice/Log/", "100")
                --if (type == "function") then
                --    _func()
                --end

                --m:publish(_topic.._number.."/",_msg,2,0, function(client) print("Sent: ".._topic.._msg) end)
                MsgPublish(_topic, _msg)

                MsgPublish("/HomeSense1985/FromDevice/Log/", "con")
                --m:publish("/HomeSense1985/FromDevice/Log/".._number.."/","101",2,0, function(client)
                --    print("Sent: 101")
                m:subscribe("/HomeSense1985/ToDevice/".._number.."/",0, function(client) print("subscribe success") end)
                --end)

                -- subscribe topic with qos = 0
                --m:subscribe("/HomeSense1985/ToDevice/".._number,0, function(client) print("subscribe success") end)
                -- publish a message with data = hello, QoS = 0, retain = 0
                -- m:publish("/HomeSense1985/FromDevice/".._number,"hello",0,0, function(client) print("sent") end)
            end,
            function(client, reason)
                print("failed reason: "..reason)
            end)

        --end


    end
end

-- on publish message receive event
m:on("message", function(client, topic, data)
print("Data Recived from MQTT: "..topic .. ":" )
if data ~= nil then
    print(data)
    local GET = get_object.findkeys(data,20)
    local response = ExtractData(GET)
    --m:publish("/HomeSense1985/FromDevice/Response/".._number,response,0,0, function(client) print("Sent") end)
    MsgPublish("/HomeSense1985/FromDevice/Response/", response)
    --MsgPublish("/HomeSense1985/FromDevice/Log/", "req")
end
end)
