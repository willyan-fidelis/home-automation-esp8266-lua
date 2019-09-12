--local moduleName = "get"
local M = {}
--_G[moduleName] = M

function M.findkeys(_request)
local _, _, method, path, vars = string.find(_request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(_request, "([A-Z]+) (.+) HTTP");
        end
if (vars == nil) then
	return {}
end
print("vars: "..vars)
        local _GET = {}
        if (vars ~= nil)then
			for k, v in string.gmatch(vars, "(%w+%.-%w-%.-%w-%.-%w-%.-%w-%.-%w+)=(%w+)") do--&*
                _GET[k] = v
				print("k["..k.."]:"..v)
            end
        end
   return _GET
end

return M