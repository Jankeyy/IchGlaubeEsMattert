local me = peripheral.find("me_bridge")

if not me then 
    print("Keine Bridge gefunden")
    return
end

local function prettifyItemName(rawName)
    local name = rawName

    -- Mod-Präfix entfernen
    name = string.match(name, ":(.+)") or name

    -- Unterstriche durch Leerzeichen ersetzen
    name = string.gsub(name, "_", " ")

    -- Jeden Wortanfang groß machen
    name = string.gsub(name, "(%a)([%w']*)", function(first, rest)
        return string.upper(first) .. string.lower(rest)
    end)

    return name
end

local items = me.getItems()

for _, item in ipairs(items) do
    print(prettifyItemName(item.name))
end