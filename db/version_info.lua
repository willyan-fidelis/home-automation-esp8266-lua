--return cjson.encode({type="mod1", sw="1.0", hw="1.0", chipid=node.chipid(), date="MOD1SW1.50HW1.00CHIPID"..node.chipid()}) --MOD1SW1.50HW1.00CHIPIDXXX

local _type = "1.0"
local _sw = "1.7"
local _hw="1.0"
_number="20161220.001."..node.chipid() -- Represents the date, the sequencial number(into one day) and the chipid->Year(....) + month(..) + day(..) + Sequence Number(...)
local _ip, _, _ = wifi.sta.getip()

--return cjson.encode({type=_type, sw=_sw, hw=_hw, number=_number})
return {type=_type, sw=_sw, hw=_hw, number=_number, ip=_ip}
