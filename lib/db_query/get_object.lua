local M = {}

function M.findkeys(_request,_maxInitPos) -- _maxInitPos -> Maximum initial start characters position allowed.
    --print(_request)
    local x, y = string.find(_request, "/?{(.-)}?/", 1) --Find the smallest sequence begining with '/?{' and ending with '}?/'
    if (x == nil or y == nil or x > _maxInitPos) then
        return {}
    end
    print(x.." | "..y)
    local vars=string.sub(_request, x,y-2)
    print(vars)


    --This code checks avoid to recive the same msg twice:
    if (_maxInitPos <= 20) then
        print("vars before: "..vars)
        vars = string.gsub(vars, "%%22", '"') --Quotation marks(") arrives as "%22". So we need find this pattern adding "%"("%" in lua is a special char, so it must add other). Result: replace '%22' by '"'.
        vars = string.gsub(vars, "%%20", ' ')  --Replace the "%20" for blank space("%20")
        print("vars after: "..vars)
    end


    if (_maxInitPos == -1) then
        vars = _request
    end

    local obj = {}
    if pcall(function ()
        obj = cjson.decode(vars)
    end)
    then
        print("GetObject ok!")
        print(cjson.encode(obj))
        return obj
    else
        print("GetObject not ok!")
        return {none="true"}
    end
end



return M
