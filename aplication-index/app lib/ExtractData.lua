--local M = {}

function ExtractData(GET)
	--data to be answered:
	local response = ""

	
	--local GET = get_object.findkeys(payload)
	--payload = nil

	

	--First omit(delete) the cmd table(if it exist obivious):
	if (GET["cmd.id"] ~= nil) then
		
		--First comand: restart:
		if GET["cmd.id"] == "reset" then
			tmr.alarm(6, 3000, 0, function() node.restart() end)
		
		elseif GET["cmd.id"]== "setstaconfig" then
		wifi.sta.config(GET["cmd.nm"], GET["cmd.pwd"])
		
		elseif GET["cmd.id"]== "setapconfig" then
		wifi.ap.config({ssid=GET["cmd.nm"], pwd=GET["cmd.pwd"]})
		
		elseif GET["cmd.id"]== "getip" then
		local ap1, ap2, ap3 = wifi.ap.getip()
		local sta1, sta2, sta3 = wifi.sta.getip()
		response = {
			ap_ip = ap1,
			ap_msk = ap2,
			ap_gtw = ap3,
			ap_mac = wifi.ap.getmac(),
			--ap_rssi = 100,
			sta_ip = sta1,
			sta_msk = sta2,
			sta_gtw = sta3,
			sta_mac = wifi.sta.getmac()--,
			--sta_rssi = wifi.sta.getrssi()
		}
		response = cjson.encode(response)
		
		elseif GET["cmd.id"]== "getdevicetype" then
		response = cjson.encode({type="mod1", sw="1.0", hw="1.0", chipid=node.chipid(), code="MOD1SW1.50HW1.00CHIPID"..node.chipid()}) --MOD1SW1.50HW1.00CHIPIDXXX

		elseif GET["cmd.id"]== "getstaconfig" then
		response = cjson.encode({wifi.sta.getconfig()})
		
		elseif GET["cmd.id"]== "getapconfig" then
		response = cjson.encode({wifi.ap.getconfig()})
		---------- Specific Module Comands ---------
		elseif GET["cmd.id"]== "settime" then
			local rtc_set = require("ds1307rtc_wt")
			rtc_set.setTime(require("i2cutils_wt"),{tonumber(GET["cmd.s"]),tonumber(GET["cmd.min"]),tonumber(GET["cmd.h"]),tonumber(GET["cmd.w"]),tonumber(GET["cmd.d"]),tonumber(GET["cmd.m"]),tonumber(GET["cmd.y"])})--setTime(sec,min,hours,week,day,month,yy)
		
		elseif GET["cmd.id"]== "gettime" then
		local tm = rtc.getTime(i2cutils_rd)
		response = cjson.encode(tm)

		elseif GET["cmd.id"]== "geteventlst" then
		response = cjson.encode(db)

		elseif GET["cmd.id"]== "getNameConfig" then
		local _dbm = require("dbm")
		local _config = _dbm.readDB("config.db")
		response = cjson.encode(_config)
		
		--elseif GET["cmd.id"] == "setNameConfig" then
		--local _config = {
		--	ModName = GET["cmd.ModName"],
		--	RGBName = GET["cmd.RGBName"],
		--	Out1Name = GET["cmd.Out1Name"],
		--	Out2Name = GET["cmd.Out2Name"],
		--	Out3Name = GET["cmd.Out3Name"]
		--}
		--local _dbm = require("dbm")
		--_dbm.saveDB("config.db", _config)

		elseif GET["cmd.id"] == "editnameconfig" then
		local _dbm = require("dbm")
		local _config = _dbm.readDB("config.db")
		local settbl = require("data_settbvalue")
		settbl.settbvalue(GET.data, _config, false, {'protect'})
		--Save data recived:
		_dbm.saveDB("config.db", _config)

		
		elseif GET["cmd.id"] == "editeventlst" then
		local settbl = require("data_settbvalue")
		settbl.settbvalue(GET.data, db, false, {'protect'})
		--Save data recived:
		local _dbm = require("dbm")
		_dbm.saveDB("events.db", db)

		elseif GET["cmd.id"]== "setrgb" then
		local rgb = require("rgb")
		rgb.set(GET["cmd.r"], GET["cmd.g"], GET["cmd.b"])

		elseif GET["cmd.id"]== "turn" then
		mod.cmdToMods( GET["cmd.m0"], GET["cmd.m1"])
		--mod.digOutCmd(GET["cmd.m0"], "M0", 3, function() end) --(Command, module, alarm NO and one second function)
		--mod.digOutCmd(GET["cmd.m1"], "M1", 4, function() end) --(Command, module, alarm NO and one second function)

		elseif GET["cmd.id"]== "alarm" then
			if(GET["cmd.arg"]== "reset") then
				alarm.alarmed = false
			elseif (GET["cmd.arg"]== "arm") then
				alarm.armed = true
			elseif (GET["cmd.arg"]== "disarm") then
				alarm.armed = false
			elseif (GET["cmd.arg"]== "getstatus") then
				response = cjson.encode({status=alarm})
			end
		end
		---------- Specific Module Comands ---------
	else
		--Change the db with the data recived:
		--local kToj = require("data_keystojson")
		--kToj.keystojson(GET, db, "protect")
		--GET, kToj = nil
		
		--Save data recived:
		--local dbm = require("dbm")
		--dbm.saveDB("events.db", db)
		--dbm = nil
		--print("No command requested!")
	end

	return response
end

--return M