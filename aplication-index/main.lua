---------------------------- require section ----------------------------
--Load the basic basic data for teh first time:
local _dbm = require("dbm")
db = _dbm.readDB("db.db")-- The 'db' table is the old 'event' table!
general = _dbm.readDB("general.db")

--Load the I2C Utilities:
i2cutils_rd = require("i2cutils_rd")
--Load the sisten real clock:
rtc = require("ds1307rtc_rd")
--Load module functions:
mod = require("mod1DigOut")
--Load the Device Number:
require("version_info")
---------------------------- require section ----------------------------

--Now configure the wifi "ap" data:
--wifi.setmode(wifi.STATIONAP)
--wifi.setmode(wifi.SOFTAP)
gpio.mode(1, gpio.INPUT)
--Check if it is required to into in Config Mode or Go DefaultMode:
--if (gpio.read(1) == 0) then --Pin1(sda) is the GPIO5
if (false) then
	--Default Mode:
	gpio.mode(6, gpio.INPUT)
	gpio.mode(7, gpio.INPUT)
	--if (gpio.read(6) == 1 or gpio.read(7) == 1) then
	if (false) then
		print("Go to default data!")
		--Put default data here!
		--wifi.setmode(wifi.STATIONAP)
		wifi.ap.config({ssid="HomeSense_"..node.chipid(), pwd="0123456789"})
	else
		--Config Mode:
		print("Config Mode On!")
		wifi.setmode(wifi.STATIONAP)
	end
else
	--wifi.setmode(wifi.SOFTAP)
	wifi.setmode(wifi.STATIONAP)
		if (general.EnbSTA) then
			wifi.setmode(wifi.STATION)
			local a, b, _, _ = wifi.sta.getconfig()
			wifi.sta.config(a,b)
		end
		-- Peridioc/Event Tasks section --------------------->>>

			--RGB Board:
			if (general.InpRGB) then
				local rgb = require("rgb")
				rgb.set({0,0,0})
				allowReadInp2,rgbCase = true
				--function onRGB()
				--end

				-- Proportional tasks --
				-- function map(x, in_min, in_max, out_min, out_max)
				-- 	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
				-- end
				-- function prop()
				-- 	local out = map(adc.read(0), anlogCtrl.inMin, anlogCtrl.inMax, anlogCtrl.outMin, anlogCtrl.outMax)
				-- 	rgb.set({out,out,out})
				-- end
				-- local _dbm = require("dbm")
				-- anlogCtrl = _dbm.readDB("anlogCtrl.db")
				-- Proportional tasks -

				gpio.mode(2, gpio.INT)
				gpio.trig(2, 'both', function()
					--function onRGB()
					tmr.alarm(6, 1000, 0, function() allowReadInp2 = true end)
					if (not allowReadInp2) then
						return
					end
					local rgb = require("rgb")
					if (rgbCase) then
						rgb.set({1023,1023,1023})
						mod.cmdToMods(1, 1)
						--print("RGB turned on!")
					else
						rgb.set({0,0,0})
						mod.cmdToMods(2, 2)
						--print("RGB turned off!")
					end
					allowReadInp2 = false
					rgbCase = not rgbCase
					--end
				end)
			--2 Inputs and 2 outpus Board:
			else
				--On Motion event:
				function onMotion()
					--Presence Event(pe) - Verify and execute:

					--[[ -- (REVIEW) THIS CODE WORKS WELL, DON'T REMOVE. IT WILL BE IMPLEMENTED ON NEXT MODULE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
					--Alarm:
					if (alarm.armed) then
						alarm.alarmed = true
					end
					--]] -- (REVIEW) THIS CODE WORKS WELL, DON'T REMOVE. IT WILL BE IMPLEMENTED ON NEXT MODULE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

					--print("Moviment detected!")

					--aftPeTmr = 0 --After Presence Sensor Event Timer
					--First check all events that has no delay time:
					--for k in pairs(db.pe) do
					--	if (db.pe[k].enb and (db.pe[k].prd == act_prd_id or db.pe[k].prd == 0)) then
					--		if (0 == db.pe[k].dy_min) then
					--			mod.cmdToMods(db.pe[k].cmd.m0,db.pe[k].cmd.m1)
					--			--print("Cmd executed - onMotion")
					--		end
					--	end
					--end

					--Now create the alarm that will  monitor all delayed events:
					--tmr.alarm(1, 1000, 1, function()
						--Now we must increment the actual 'presence event timer':
						--aftPeTmr = aftPeTmr + 1 --After Presence Sensor Event Timer
						--if (aftPeTmr >= 999) then
						--	aftPeTmr = 0
						--end
						--print("Time spent after the presence sensor acts: "..tostring(aftPeTmr))

						MsgPublish("/HomeSense1985/FromDevice/Log/", "mot") --Log over the internet

						local i = 0
						for k in pairs(db.pe) do
							if (db.pe[k].enb and (db.pe[k].prd == act_prd_id or db.pe[k].prd == 0)) then
								--if (aftPeTmr == db.pe[k].dy_min or 0 == db.pe[k].dy_min) then
								mod.cmdToMods(db.pe[k].cmd.m0,db.pe[k].cmd.m1)
								if (db.pe[k].dy_sec > 0) then --Now 'dy_sec' is turn off time(afeter the turn the light)
									tmr.alarm(i, 1000 * db.pe[k].dy_sec + 1, 0, function()
										mod.cmdToMods(0,0)
										--print("Cmd executed - onMotion")
									end)
								end
								--end
							end
							i = i + 1
						end
					--end)
				end
				gpio.mode(2, gpio.INT)
				gpio.trig(2, 'up', onMotion)
				--When the pin 7 is activated, so the output M0 must be changged:
				allowReadInp = true
				function OnPin7()
					--tmr.alarm(6, 1500, 0, function() allowReadInp = true end)


					if (allowReadInp) then

						--mod.cmdToMods(3, 0, function() allowReadInp = true end, function() end)
						mod.digOutCmd(general.Inp2, "M1", 3, function()
							MsgPublish("/HomeSense1985/FromDevice/Log/", "pin7_"..gpio.read(7)) --Log over the internet
							allowReadInp = true
						end) --(Command, module, alarm NO and one second function)
						--print("Cmd executed - OnPin7")
					end
					allowReadInp = false
				end
				gpio.mode(7, gpio.INT)
				gpio.trig(7, 'both', OnPin7)

				--When the pin 6 is activated, so the output M1 must be changged:
				allowReadInp6 = true
				function OnPin6()

					if (allowReadInp6) then

						--mod.cmdToMods(0, 3, function() end, function() allowReadInp6 = true end)
						mod.digOutCmd(general.Inp1, "M0", 4, function()
							MsgPublish("/HomeSense1985/FromDevice/Log/", "pin6_"..gpio.read(6)) --Log over the internet
							allowReadInp6 = true
						end) --(Command, module, alarm NO and one second function)
						--print("Cmd executed - OnPin6")
					end
					allowReadInp6 = false
				end
				gpio.mode(6, gpio.INT)
				gpio.trig(6, 'both', OnPin6)
			end

			--Periodic task. The amaller time that will be scaned is one minute:
			--On every second event:
			function onEveryOneSec ()
				--Publish a empty request every one second only to ensure that the connection is ok:
				MsgPublish("", "")

				-- if (general.InpRGB) then
				-- 	prop()
				-- end

				--Get the actual time:
				local tm = rtc.getTime(i2cutils_rd)
				--print("One minute spent! Time: "..tostring(tm.hrs).." hrs "..tostring(tm.min).." min")

				--First check if a new period is coming:
				for k in pairs(db.prd) do
					if ((tm.hrs > db.prd[k].h1 or (tm.hrs == db.prd[k].h1 and tm.min >= db.prd[k].m1)) and (tm.hrs <= db.prd[k].h2 and tm.min < db.prd[k].m2)) then
						act_prd_id = tonumber(string.sub(k, 2, 2))
						--print("Period ID: "..act_prd_id)
					else
						act_prd_id = 0
					end
				end

				--Time Events(te) - Verify and execute:
				for k in pairs(db.te) do
					--if (db.te[k].enb) then
						if (db.te[k].enb and db.te[k].StDn == false and tm.hrs == db.te[k].h and tm.min == db.te[k].m and db.te[k].wk_days["i"..tostring(tm.wk)] == true) then
							mod.cmdToMods(db.te[k].cmd.m0,db.te[k].cmd.m1)
							db.te[k].StDn = true
						else
							db.te[k].StDn = false
						end
					--end
				end
				--Light Event(lgt_e) - Verify and execute:
				local lgt = adc.read(0)--adc.readvdd33(0)
				--print("Light value: "..lgt)
				local tol = general.tol--50--300
				if not((old_lgt + tol >= lgt) and (old_lgt - tol <= lgt)) then--This 'if' code ensure that it will occurs only once!
				--print("Light Level was changed!")
					for k in pairs(db.lgtyp) do

						if ((db.lgtyp[k] + tol >= lgt) and (db.lgtyp[k] - tol <= lgt)) then
							for kk in pairs(db.lgt_e) do
								if ((db.lgt_e[kk].enb == true) and (db.lgt_e[kk].typ == tonumber(string.sub(k, 2, 2)))) then
									mod.cmdToMods(db.lgt_e[kk].m0,db.lgt_e[kk].m1)
									--print("Cmd executed - onEveryOneSec")
								end
							end
						end
					end
				end--This 'if' code ensure that it will occurs only once!
				old_lgt = lgt--Save the last light value to the next scan

				--Check if the static ip changed. In positive case log this status on the clound:
				--if (last_sta_ip) then ... TODO - IMPLEMENT THIS LOGIC!

				--Now check on the server if has any cmd request:
				--sckt()
			end
			tmr.alarm(2, 30000, 1, onEveryOneSec)
		--end
		--Peridioc/Event Tasks section ---------------------<<<

		--Server MQTT Listener / MsgPublish ---------------------------------->>>
		--local skt = require("mqtt")
		--general.EnbMQTT = false
		if (general.EnbMQTT) then
			dofile("mqtt.lua");
		else
			function MsgPublish(_topic, _msg)
				--bufferedMsg = bufferedMsg or {}

				local count = 0
				for i in pairs(bufferedMsg) do
				    --print(bufferedMsg[i])
				    count = count + 1
				end
				print(count.._msg)

				--If the queue is full:
				if(count >= 20) then--Max size allowed
				    return false
				end
				--Else insert:
				table.insert(bufferedMsg, _msg)
				return true
			end
		end
		bufferedMsg = bufferedMsg or {}
		MsgPublish("/HomeSense1985/FromDevice/Log/", "init")
		--Server MQTT Listener / MsgPublish----------------------------------<<<
	--end)
end
------------------------ Initialization section ------------------------>>>
--Now configure all I2C devices:
local i2c_init = require("i2cutils_init")
i2c_init.initialise(0x68, 0, 1, 3) --RTC (dev_addr, init_reg_addr, sda, scl)

--Variable initialise:
--aftPeTmr = 0 --After Presence Sensor Event Timer
old_lgt = adc.read(0)--adc.readvdd33(0) --Last(old) Light Value
act_prd_id = 0 --Actual "prd" id is initialized with 0.
------------------------ Initialization section ------------------------<<<


------------------------- Server Tasks section ------------------------->>>
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
	conn:on("sent",function(conn) conn:close() end)
	conn:on("receive",function(conn,payload)--http://192.168.0.138/?lgtyp.i1.vl=899/
		print("New data arrived from HTTP Request!")
		--local response = ""

		local GET = get_object.findkeys(payload,20)
		payload = nil
		response = ExtractData(GET)

		conn:send(response)
	end)
	--conn:on("sent",function(conn) conn:close() end)
end)
------------------------- Server Tasks section -------------------------<<<
get_object = require("get_object")
function ExtractData(GET)
	MsgPublish("/HomeSense1985/FromDevice/Log/", "req")

	--data to be answered:
	local response = ""


	--local GET = get_object.findkeys(payload)
	--payload = nil

	--- Error handling ---
	if pcall(function ()
		--Error handling(Try This code) --->>>

		--First omit(delete) the cmd table(if it exist obivious):
		if (GET["cmd.id"] ~= nil) then
			--MsgPublish("/HomeSense1985/FromDevice/Log/", "200") --Log over the internet

			--First comand: restart:
			if GET["cmd.withrestart"] == "yes" then
				print("Restarting..")
				tmr.alarm(6, 3000, 0, function() node.restart() end)
			end

			--If the number is not null AND is not -1 AND is differ from the device number. In this case we have a requeste error:
			if GET["cmd._number"] ~= nil and GET["cmd._number"] ~= "-1" and  GET["cmd._number"] ~= _number then
			response = {status= "Error - Number differ from requested!"}

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
			--response = cjson.encode(response)

			elseif GET["cmd.id"]== "getdevicetype" then
			response = require("version_info")--cjson.encode({type="mod1", sw="1.0", hw="1.0", chipid=node.chipid(), code="MOD1SW1.50HW1.00CHIPID"..node.chipid()}) --MOD1SW1.50HW1.00CHIPIDXXX

			elseif GET["cmd.id"]== "getstaconfig" then
			--response = cjson.encode({wifi.sta.getconfig()})
			response = {wifi.sta.getconfig()}

			elseif GET["cmd.id"]== "getapconfig" then
			--response = cjson.encode({wifi.ap.getconfig()})
			response = {wifi.ap.getconfig()}
			---------- Specific Module Comands ---------
			elseif GET["cmd.id"]== "settime" then
				local rtc_set = require("ds1307rtc_wt")
				rtc_set.setTime(require("i2cutils_wt"),{tonumber(GET["cmd.s"]),tonumber(GET["cmd.min"]),tonumber(GET["cmd.h"]),tonumber(GET["cmd.w"]),tonumber(GET["cmd.d"]),tonumber(GET["cmd.m"]),tonumber(GET["cmd.y"])})--setTime(sec,min,hours,week,day,month,yy)

			elseif GET["cmd.id"]== "gettime" then
			local tm = rtc.getTime(i2cutils_rd)
			--response = cjson.encode(tm)
			response = tm

			elseif GET["cmd.id"]== "get_tb" then
			--response = cjson.encode(_G[GET["cmd.tb_name"]])
			response = _G[GET["cmd.tb_name"]]

			--elseif GET["cmd.id"]== "geteventlst" then
			--response = cjson.encode(db)

			--Save data recived:
			--_dbm.saveDB("config.db", _config)

			--Edit and Save Global tables:
			elseif GET["cmd.id"] == "edit_tb" then
			local settbl = require("data_settbvalue")
			settbl.settbvalue(GET.data, _G[GET["cmd.tb_name"]], false, {'protect'})
			--Save data recived:
			local _dbm = require("dbm")
			_dbm.saveDB(GET["cmd.tb_name"]..".db", _G[GET["cmd.tb_name"]])

			--elseif GET["cmd.id"] == "editeventlst" then
			--local settbl = require("data_settbvalue")
			--settbl.settbvalue(GET.data, db, false, {'protect'})

			--Save data recived:
			--local _dbm = require("dbm")
			--_dbm.saveDB("db.db", db)

			elseif GET["cmd.id"]== "setrgb" then
			--local rgb = require("rgb")
			----rgb.set(GET["cmd.r"], GET["cmd.g"], GET["cmd.b"])
			--rgb.set({GET["cmd.r"], GET["cmd.g"], GET["cmd.b"]})
			pwm.setduty(GET["cmd.out"],GET["cmd.v"])

			elseif GET["cmd.id"]== "turn" then
			mod.cmdToMods( GET["cmd.m0"], GET["cmd.m1"])

			--elseif GET["cmd.id"]== "getstatus" then
			--response = cjson.encode({out=mod.data.status, Light=adc.read(0),Sensor=gpio.read(2),InputM0=gpio.read(7),InputM1=gpio.read(6)})
			end


			---------- Specific Module Comands ---------
		else
			--Nothing requested!
		end

		--Error handling(Try This code) ---<<<
	end)
	then
		--Error handling(No error was thrown) --->>>
		print("ok")
		if (response == "") then
			--response=cjson.encode({status="ok"})
			local _ip,_,_,_ = wifi.sta.getip()
			response = cjson.encode({out=mod.data.status,rgb={pwm.getduty(8),pwm.getduty(6),pwm.getduty(7)},Light=adc.read(0),Sensor=gpio.read(2),InputM0=gpio.read(7),InputM1=gpio.read(6),devid = GET["cmd.devid"], ip = _ip, status = "ok", number=_number, bufferMsg=bufferedMsg})
		else
			response.devid = GET["cmd.devid"]
			response.status = response.status or "ok"
			response.bufferMsg = bufferedMsg
			response = cjson.encode(response)
		end
		--Error handling(No error was thrown) ---<<<
	else
		--Error handling(Any error was thrown) --->>>
		print("not ok")
		response=cjson.encode({status="error"})
		--Error handling(Any error was thrown) ---<<<
	end
	bufferedMsg = {}
	return response
	--return cjson.encode({response = response,devid = GET["cmd.devid"]})
end
