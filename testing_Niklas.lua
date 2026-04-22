local me = peripheral.find("me_bridge")

if not me then 
    print("Keine Bridge gefunden")
    return
end

local items = me.getItems()

for _, item in ipairs(items) do
    local name = item.name

    -- Mod-Präfix entfernen
    name = string.match(name, ":(.+)") or name

    -- Unterstriche durch Leerzeichen ersetzen
    name = string.gsub(name, "_", " ")

    print(name)
end