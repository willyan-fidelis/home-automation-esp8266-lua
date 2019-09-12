local M = {}
--------------------------- Old ---------------------------
----M.data = {status = {r = 0, g = 0, b = 0}}
--function M.start()
--    pwm.setup(8, 500, pwm.getduty(8))
--    pwm.setup(6, 500, pwm.getduty(6))
--    pwm.setup(7, 500, pwm.getduty(7))    
--    pwm.start(8)
--    pwm.start(6)
--    pwm.start(7)
--end
----function M.stop()
----    pwm.stop(8)
----    pwm.stop(6)
----    pwm.stop(7)
----    --M.data = {status = {r = 0, g = 0, b = 0}}
----end
--function M.set(_r, _g, _b)
--M.start() --This is necessary only to ensure that the outputs is on correct mode.
--local mth = require("map")
--    pwm.setduty(8, mth.map(_r, 0, 100, 0, 1023))
--    pwm.setduty(6, mth.map(_g, 0, 100, 0, 1023))
--    pwm.setduty(7, mth.map(_b, 0, 100, 0, 1023))
--    --M.data = {status = {r = _r, g = _g, b = _b}}
--end
--------------------------- Old ---------------------------

--------------------------- New ---------------------------
function M.set(values) --This function must be tested yet!
    local out = {8,6,7} --Output Pins!
    --local mth = require("map")
    for k in pairs(out) do
        --Start/Setup:
        pwm.setup(out[k], 500, pwm.getduty(out[k]))
        pwm.start(out[k])
        --Set:
        --pwm.setduty(out[k], mth.map(values[k], 0, 100, 0, 1023))
        if (values[k] > 1023) then
            values[k] = 1023
        end
        pwm.setduty(out[k],values[k])
    end
end
--set({10,20,30})
--------------------------- New ---------------------------
return M