

lgt = adc.readvdd33(0) 
if not((old_lgt + tol >= lgt) and (old_lgt - tol <= lgt)) then
    print("Changed!")
else
    print("Same Light Level!")
end
old_lgt = lgt


obj = cjson.decode('{"cmd.id":"getdevicetype"}')
print(obj["cmd.id"])


wifi.setmode(wifi.STATIONAP)
wifi.setmode(wifi.SOFTAP)
wifi.sta.config("net_virtua129", "3614682970")
wifi.sta.config("GVT-DCEA", "S1F4519897")
wifi.sta.config("NET_2G4CD467", "B34CD467")
wifi.sta.config("Anderson", "chitos42")
wifi.sta.config("int15", "5067000326")
wifi.sta.config("WiFi-Arnet-bx8z", "YEYYKMF3AW")
wifi.sta.config("AndroidAP", "willyanfidelis")
wifi.sta.config("Depto Cba 1B", "departamento1b")
wifi.sta.config("Depto Cba 2B", "departamento2b")
wifi.sta.config("Depto Cba 3C", "departamento3c")
wifi.sta.config("VIVO-30F0", "C6624B30F0")
wifi.sta.config("will1985", "C6624B30F0")

station_cfg={}
station_cfg.save=true
station_cfg.ssid="Depto Cba 3C" station_cfg.pwd="departamento3c"

wifi.sta.config(station_cfg)

cfg={}
cfg.ssid="fidelis"
cfg.pwd="12345678"
wifi.ap.config(cfg)

print(wifi.sta.getip())
print(wifi.ap.getip())
general.EnbSTA = true
wifi.ap.config({ssid="HomeSense_"..node.chipid(), pwd="0123456789"})


MQTTPublish("/HomeSense/FromDevice/Log/", "c")
MQTTPublish("/HomeSense/FromDevice/Response/", "123")
MQTTPublish("", "")
m:close()
MQTT_STATUS = false
print(MQTT_STATUS)

--wifi.setmode(wifi.STATIONAP)
--cfg={}
--cfg.ssid="net_virtua129"
--cfg.pwd="3614682970"
--wifi.ap.config(cfg)
--cfg =
--{
--    ip="192.168.1.1",
--    netmask="255.255.255.0",
--    gateway="192.168.1.1"
--}
--wifi.ap.setip(cfg)







pin=5
pin=0
gpio.mode(0, gpio.OUTPUT)
gpio.write(pin, gpio.HIGH)
gpio.write(pin, gpio.LOW)

data = {pins = {0,5,0}, status = {M0 = false,M1 = false,M2 = false}}
print(gpio.read(6))

mod.cmdToMods(2,0,0)


pin=1
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.HIGH)
gpio.write(pin, gpio.LOW)

gpio.LOW = 1
print(gpio.LOW)
print(gpio.HIGH)

lgt = adc.read(0)--adc.readvdd33(0) 
print("Light value: "..lgt)

mod.cmdToMods(1,1,0)
mod.cmdToMods(2,2,0)
alarm = {false = true, alarmed = false}

pin=8
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.HIGH)
gpio.write(pin, gpio.LOW)


pin=4
gpio.mode(pin, gpio.INPUT)
print(gpio.read(pin))

print(mod.data.status["M"..tostring(0)])

function abc()
    print("hey patric!")
end
gpio.mode(7, gpio.INT)
gpio.trig(7, 'both', abc)



gpio.mode(7, gpio.OUTPUT)



dbm = require("dbm")
mod.types = dbm.readDB("IOProperty.db")
print(node.flashsize())


function init() 
     print("init");
end
function abc(_init) 
     _init()
end
block = { 
     startup = init
abc(init)
abc(function() print("initt") end)
gpio.mode(0, gpio.OUTPUT)

majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info()
print("NodeMCU "..majorVer.."."..minorVer.."."..devVer)


abc = {10,20}--, false, false, false, false, false, false}
abc=nil


abc = 0
number |= 1 << x;

bit.set(abc, 1)
bit.set(abc, 2)
print(bit.isset(abc, 2))

for i=1,7,1
do 
    if (bit.isset(abc, i)) then
        print(i)
    end    
end

tm = rtc.getTime(i2cutils_rd)
print(tm.wk)
print(db.te["i1"].wk_days["i1"])
print(db.te["i1"].wk_days["i"..tostring(tm.wk)])









print(net.dns.getdnsserver(0))
print(net.dns.getdnsserver(1)) 
net.dns=nil

net.dns.resolve("", function(sk, ip)
    if (ip == nil or general.ServNm == "") then print("DNS fail!") else print(ip) end
end)


local _dbm = require("dbm")
general = _dbm.readDB("general.db")
_dbm = nil
print(general.ServNm)
general.ServNm="192.168.0.20"

if (general.ServNm == "") then
print("Server Not Configured!")
end

print(sckt_msg_sz)

abc = '{\"cmd.id\":\"turn\",\"cmd.m0\":3,\"cmd.m1\":3}'
obj = cjson.decode(abc)
print(cjson.encode(obj))

print(type(cjson.encode({status="error"})))
print(cjson.encode({"cmd.m1":3,"cmd.id":"turn","cmd.m0":3}))
_data, _ctrl, _response = nil

sckt()
setRGB = nil

rgb = require("rgb")
rgb.set({100,50,30})

mth = require("map")

function setRGB(values)
    local out = {8,6,7}
    local mth = require("map")
    for k in pairs(out) do
        --Start/Setup:
        pwm.setup(out[k], 500, pwm.getduty(out[k]))
        pwm.start(out[k])
        --Set:
        pwm.setduty(out[k], mth.map(values[k], 0, 100, 0, 1023))
    end
end


if(true) then
mth = require("map")
local _dbm = require("dbm")
anlogCtrl = _dbm.readDB("anlogCtrl.db")-- The 'db' table is the old 'event' table!

end
print(adc.read(0))
--print(mth.map(10, 0, 100, 0, 1023))
print(mth.map(5000, anlogCtrl.inMin, anlogCtrl.inMax, anlogCtrl.outMin, anlogCtrl.outMax))


if () then
    mth.map(5000, anlogCtrl.inMin, anlogCtrl.inMax, anlogCtrl.outMin, anlogCtrl.outMax)
end
end    

print(_number)

function abc(x)
    print("X is: "..function)
end

sckt(3,"NADA")   --Send Log '1' with 'Oie' argument
sckt(-1,"")     --Get command list

dofile("main.lua");
m:publish("/topic",'{"cmd.id":"turn","cmd.m0":3,"cmd.m1":3}',0,0, function(client) print("sent") end)

GET = get_object.findkeys('{"cmd.id":"turn","cmd.m0":3,"cmd.m1":3}',-1)
print(GET["cmd.id"])


require("main")

MQTTPublish("/HomeSense/FromDevice/Log/", "pin7"..gpio.read(7))
