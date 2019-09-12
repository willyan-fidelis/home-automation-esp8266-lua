local M = {}

function M.SndMsg (_ip, _msg, _OnDisconectFunc, _OnRcvFunc, _OnNotRcvFunc)
	
	local skResultOk = false
	M.sk=net.createConnection(net.TCP, 0)

	M.sk:on("receive", function(sck, c)
		skResultOk = true
		_OnRcvFunc(c)
	end )

	M.sk:on("disconnection", function(sck, c)
		if (skResultOk == false) then
			_OnNotRcvFunc()
		end
		_OnDisconectFunc()
	end )

	M.sk:connect(80,_ip)	
	M.sk:on("connection", function(sck,c)
	
		--_OnConectFunc()
		print("connected!")
		M.sk:send("GET ".._msg.." HTTP/1.1\r\nHost: ".._ip.."\r\n\r\n")
	end)
	
end

return M




--[[
local M = {}

function M.SndMsg (_ip, _msg, _OnConectFunc, _OnDisconectFunc, _OnRcvFunc, _OnNotRcvFunc)
	
	local skResultOk = false
	M.sk=net.createConnection(net.TCP, 0)

	M.sk:on("receive", function(sck, c)
		skResultOk = true
		_OnRcvFunc(c)
	end )

	M.sk:on("disconnection", function(sck, c)
		if (skResultOk == false) then
			_OnNotRcvFunc()
		end
		_OnDisconectFunc()
	end )

	M.sk:connect(80,_ip)	
	M.sk:on("connection", function(sck,c)
	
		_OnConectFunc()
		M.sk:send("GET ".._msg.." HTTP/1.1\r\nHost: ".._ip.."\r\n\r\n")
	end)
	
end

return M
--]]