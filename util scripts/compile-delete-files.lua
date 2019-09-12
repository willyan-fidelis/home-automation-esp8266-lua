--Create all lc files - Compile all lua files:
l = file.list();
for k,v in pairs(l) do
  print("name:"..k..", size:"..v)

  if (string.find(k, "lua") ~= nil) then
    node.compile(k)
    print("ok")
  end

end

--Delete all files:
l = file.list();
for k,v in pairs(l) do
  print("name:"..k..", size:"..v)
  file.remove(k)
end

--Delete all files with "sufix":
sufix = ".lua"
--sufix = ".lc"
l = file.list();
for k,v in pairs(l) do
  print("name:"..k..", size:"..v)

  if (string.find(k, sufix) ~= nil) then
    file.remove(k)
    print("Deleted!")
  end

end
