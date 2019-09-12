tmr.alarm(0, 5000, 0, function() --15000

--tmr.alarm(1, 5000, 1, function()
--    print("XYZ")
--end)

uart.on("data", "\r",
  function(data)
    --print("receive from uart:", data)
    uart.write(0, "Data Recived: "..data)
    if data=="quit\r" then
      uart.on("data") -- unregister callback function
    end
end, 0)

end)
