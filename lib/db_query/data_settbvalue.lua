local M = {}

function M.settbvalue(_toBeGetTb, _toBeSetTb, _createifnotext, _notallowedkeys, _elementconcat)
	local _changed = 0
	
	local actelement = ""
	
	for k, v in pairs(_toBeGetTb) do
		
		local _discartkey = 0
		for kk, vv in pairs(_notallowedkeys) do
			if (vv ==k) then
				_discartkey = 1
			end
		end
		
		if (_discartkey == 1) then
			print("* The key '"..k.."' is not allowed to be modifyed!")
		else
			
			if (_elementconcat == nil) then
				actelement = k
			else
				actelement = _elementconcat.."."..k
			end
			
			if type(_toBeGetTb[k])=="table" and _toBeSetTb[k] ~= nil then
				_changed = _changed + M.settbvalue(_toBeGetTb[k], _toBeSetTb[k], _createifnotext, _notallowedkeys, actelement)
			elseif type(_toBeGetTb[k])=="table" and _toBeSetTb[k] == nil  then
				if (_createifnotext == false) then
					print("* Table '"..actelement.."' doesn't exist on target table!")
				else
					_toBeSetTb[k] = {}
					print("* Table '"..actelement.."' was criated on target table!")
					_changed = _changed + M.settbvalue(_toBeGetTb[k], _toBeSetTb[k], _createifnotext, _notallowedkeys, actelement)
				end
			else
				if (_toBeSetTb[k] == nil) then
					if (_createifnotext == false) then
						print("* Element '"..actelement.."' doesn't exist on target table!")
					else
						_toBeSetTb[k] = ""
						print("* Element '"..actelement.."' was criated on target table!")
					end
				end
				
				if (_toBeGetTb[k] ~= nil and _toBeSetTb[k] ~= nil and type(_toBeSetTb[k]) ~= "table") then
					if (_toBeGetTb[k] ~= _toBeSetTb[k]) then
                    
                        if (type(_toBeGetTb[k]) == type(_toBeSetTb[k])) then
                            print("* Changed element '"..actelement.."' from: '"..tostring(_toBeSetTb[k]).."' to: '"..tostring(_toBeGetTb[k]).."'")
                            _toBeSetTb[k] = _toBeGetTb[k]
                            _changed = _changed + 1
                        else
                            print("* Element '"..actelement.."' was not changed! Reason: Diferent types!")
                        end
						
					else
						print("* Element '"..actelement.."' doesn't changed. Its value continuous being '"..tostring(_toBeSetTb[k]).."'.")
					end
				end
			end
		end
	end
	
	return _changed
end

return M