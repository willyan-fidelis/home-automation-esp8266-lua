--https://github.com/DrRob/fishy-wifi/blob/master/lux/i2cutils.lua

-- This code provides some basic helper functions dealing with i2c devices
-- Much of this code was inspired by Santos and others on esp8266.com
-- Adapted by Aeprox@github for use in ESPlogger

--local moduleName = "i2cutils"
local M = {}
--_G[moduleName] = M

-- initialize i2c with our id and pins in slow mode :-)
function M.initialise(dev_addr, init_reg_addr, sda, scl)
  local id = 0
  i2c.setup(id, sda, scl, i2c.SLOW)
end

return M
