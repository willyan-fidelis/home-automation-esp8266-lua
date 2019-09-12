--RTC module. Use DS1307 RTC
--More information: http://www.esp8266.com/viewtopic.php?f=21&t=2742&p=15651&hilit=ds1307+nodemcu#p15651
--Requiered modules: 'i2cutils'

--local moduleName = "rtc"
local M = {}
--_G[moduleName] = M


--i2cutils.initialise(0x68, 0, 6, 7) --Use this configuration for this module.

function M.setTime(_inject_i2cutils_wt,_time)--M.setTime(sec,min,hours,week,day,month,yy)
	--"decToBcd" function:
	local function decToBcd(val)
		local d = string.format("%d",tonumber(val / 10))
		local d1 = tonumber(d*10)
		local d2 = val - d1
		return tonumber(d*16+d2)
	end
	
	--local i2cutils = require("i2cutils_wt")
	
	--"setTime" function:
	for i,v in ipairs(_time) do
		_inject_i2cutils_wt.write_reg(0x68, bit.band(i - 1,0xFF), decToBcd(v))
		tmr.delay(100)
	end
end

return M