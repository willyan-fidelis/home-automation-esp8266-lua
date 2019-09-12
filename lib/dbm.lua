--local moduleName = "dbm"
local M = {}
--_G[moduleName] = M

function M.readDB(_fileName)
	file.open(_fileName, "r")
	local db = cjson.decode(file.read())
	file.close()

	return db
end

function M.saveDB(_fileName, _dbName)
	file.open(_fileName, "w+")
	file.write(cjson.encode(_dbName))
	file.close()
end

return M
