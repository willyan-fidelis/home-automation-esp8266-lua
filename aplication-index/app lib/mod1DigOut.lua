--local moduleName = "mod_functions"
local M = {}

M.data = {types={M0 = 0, M1 = 0}, pins={M0 = 8, M1 = 5}, status = {M0 = false, M1 = false}}


--function M.init()
	--gpio.mode(0, gpio.OUTPUT)
	--gpio.write(0, gpio.HIGH) --this is the unique output that must be forced high, becouse the pin 0 differ from others fisicaly.
	--gpio.mode(5, gpio.OUTPUT)

	--local _dbm = require("dbm")
	--M.data.types = _dbm.readDB("IOProperty.db")
--end
----------------------- Commom Functions section -----------------------
--Pass the comand to all modules on the chip:
function M.cmdToMods(_cmdM0,_cmdM1)
	M.data.types.M0 = general.M0
	M.data.types.M1 = general.M1
    M.digOutCmd(_cmdM0, "M0", 3, function() end)
    M.digOutCmd(_cmdM1, "M1", 4, function() end)
	--M.data = {status = {M0 = _cmdM0, M1 = _cmdM1}}
end

--Digital output comands(Command, module, alarm NO and one second function):
function M.digOutCmd(_cmd, _mod, _tmr_alarm, _func) -- *1=TurnOn, *2=TurnOff, #3Toggle
local gpio_LOW = 0
local gpio_HIGH = 1

--If _mod(pin 0 gpio16) is detected, so the logic must be inverted becouse this pin differ from others.
if (_mod == "M0") then
	gpio_LOW = 1
	gpio_HIGH = 0
end

	if (_cmd == 3) then
		if (M.data.status[_mod]) then
			gpio.mode(M.data.pins[_mod], gpio.OUTPUT)
			gpio.write(M.data.pins[_mod], gpio_LOW)
			M.data.status[_mod] = false
		else
			gpio.mode(M.data.pins[_mod], gpio.OUTPUT)
			gpio.write(M.data.pins[_mod], gpio_HIGH)
			M.data.status[_mod] = true
		end
	elseif(_cmd == 1) then
		gpio.mode(M.data.pins[_mod], gpio.OUTPUT)
		gpio.write(M.data.pins[_mod], gpio_HIGH)
		M.data.status[_mod] = true
	elseif (_cmd == 2) then
		gpio.mode(M.data.pins[_mod], gpio.OUTPUT)
		gpio.write(M.data.pins[_mod], gpio_LOW)
		M.data.status[_mod] = false
	end

	--This timer avoid the input be activated twice per second and this timer turn-off the output of type 'pulsing':
	tmr.alarm(_tmr_alarm, 1000, 0, function()
		if (M.data.types[_mod] == 1) then
			gpio.mode(M.data.pins[_mod], gpio.OUTPUT)
			gpio.write(M.data.pins[_mod], gpio_LOW)
			M.data.status[_mod] = false
		end
		_func()
	end)




end
----------------------- Commom Functions section -----------------------

return M
