--RTC module. Use DS1307 RTC
--More information: http://www.esp8266.com/viewtopic.php?f=21&t=2742&p=15651&hilit=ds1307+nodemcu#p15651
--Requiered modules: 'i2cutils'

--local moduleName = "rtc"
local M = {}
--_G[moduleName] = M


--i2cutils.initialise(0x68, 0, 6, 7) --Use this configuration for this module.


function M.getTime(_inject_i2cutils_rd)
	--"bcdToDec" function:
	local function bcdToDec(val)
		local hl=bit.rshift(val, 4)
		local hh=bit.band(val,0xf)
		local hr = string.format("%d%d", hl, hh)
		local ret = string.format("%d%d", hl, hh)
		if (ret == nil) then
			return -1
		else
			return ret
		end
	end
	
	--"getTime" function:
	local tm = {}
	local tmKeys = {"sec", "min", "hrs", "wk", "day", "mth", "yy"}
	for i=1,7 do
		tm[tmKeys[i]] = tonumber(bcdToDec(string.byte(_inject_i2cutils_rd.read_reg(0x68,bit.band(i - 1,0xFF),1))))
	end
	return tm
end

return M