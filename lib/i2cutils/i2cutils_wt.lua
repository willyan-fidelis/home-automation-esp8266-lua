--https://github.com/DrRob/fishy-wifi/blob/master/lux/i2cutils.lua

-- This code provides some basic helper functions dealing with i2c devices
-- Much of this code was inspired by Santos and others on esp8266.com
-- Adapted by Aeprox@github for use in ESPlogger

--local moduleName = "i2cutils"
local M = {}
--_G[moduleName] = M

function M.write_reg(dev_addr, reg_addr, reg_val)
  local id = 0
  i2c.start(id)
  i2c.address(id, dev_addr, i2c.TRANSMITTER)
  i2c.write(id, reg_addr)
  i2c.write(id, reg_val)
  i2c.stop(id)
  --print("write command 0x"..string.format("%02X",reg_addr),"0x"..string.format("%02X",reg_val))
end

return M
