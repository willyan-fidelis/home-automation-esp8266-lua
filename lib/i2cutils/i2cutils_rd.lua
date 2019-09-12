--https://github.com/DrRob/fishy-wifi/blob/master/lux/i2cutils.lua

-- This code provides some basic helper functions dealing with i2c devices
-- Much of this code was inspired by Santos and others on esp8266.com
-- Adapted by Aeprox@github for use in ESPlogger

--local moduleName = "i2cutils"
local M = {}
--_G[moduleName] = M

--  read a single byte from register
function M.read_reg(dev_addr, reg_addr, byte_no)
  local id = 0
  i2c.start(id)
  i2c.address(id, dev_addr, i2c.TRANSMITTER)
  i2c.write(id,reg_addr)
  i2c.stop(id)
  i2c.start(id)
  i2c.address(id, dev_addr,i2c.RECEIVER)
  local c=i2c.read(id,byte_no)
  --print("read command 0x"..string.format("%02X",reg_addr),"0x"..string.format("%02X",string.byte(c)))
  i2c.stop(id)
  return c
end

return M
