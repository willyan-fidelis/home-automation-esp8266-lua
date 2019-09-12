--local moduleName = "data"
local M = {}
--_G[moduleName] = M


function M.keystojson(_findkeys, _tobeset, _notallowedkey)
	for k, v in pairs(_findkeys) do
	
	local tb = _tobeset
	for kk, vv in string.gmatch(k, "(%w+%p-)") do
		--print("kk: "..kk)
		
		if (kk == _notallowedkey) then
			print("Key protected!")
			break
		elseif (type(tb[kk])=="table") then
			tb = tb[kk]
			--print(tb[kk])
			--print(kk)
		elseif (tb[kk] ~= nil) then
			if (type(tb[kk])=="number") then
				tb[kk] = tonumber(v)
				print("Value changed!")
			elseif (type(tb[kk])=="string") then
				tb[kk] = tostring(v)
				print("Value changed!")
			elseif (type(tb[kk])=="boolean") then
				if (v == "true") then
					tb[kk] = true
					print("Value changed!")
				elseif (v == "false") then
					tb[kk] = false
					print("Value changed!")
				end
			end
		end
		
	end
		
		
		
	end
end

return M