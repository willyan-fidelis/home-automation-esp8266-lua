--Create server and listen:
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        
        print("New Ethernet msg recived!")

        local server = require("server_getdata")
        local _datacount, _data = server.getdata(client,request)

        --http://192.168.0.138/?lgtyp.i1.vl=899/
        local dbm = require("dbm")
        local db = dbm.readDB("events.lua")
        
        local data = require("data_keystojson")
        print("Numero de parametros alterados na DB: "..tostring(data.keystojson(_data, db, false, {"status", "protected"})))
        dbm.saveDB("events.lua", db)


        
        client:send("Hello Fidelis")
        
    client:on("sent",function(conn) conn:close() end)
    end)
--print("New Ethernet msg recived!")
collectgarbage()
end)

dbm = require("dbm")
db = dbm.readDB("events.db")
db.lgtyp.i1.vl = 930