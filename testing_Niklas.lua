local me = peripheral.find("me_bridge")

if not me then 
    print("Keine Bridge gefunden")
end

local items = me.getItems()

for _, item in ipairs(items) do
    print(item.name)
end