local me = peripheral.find("me_bridge")
local mon = peripheral.find("monitor")

if not me then
    print("Keine ME Bridge gefunden")
    return
end

if not mon then
    print("Kein Monitor gefunden")
    return
end

mon.setTextScale(0.5)
mon.setBackgroundColor(colors.black)
mon.setTextColor(colors.white)
mon.clear()

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

local function getSortedItems()
    local rawItems = me.getItems()
    local items = {}

    for _, item in ipairs(rawItems) do
        table.insert(items, {
            displayName = prettifyItemName(item.name),
            amount = item.amount or item.count or 0
        })
    end

    table.sort(items, function(a, b)
        return a.displayName < b.displayName
    end)

    return items
end

local scroll = 0

local function draw()
    local items = getSortedItems()
    local w, h = mon.getSize()

    mon.setBackgroundColor(colors.black)
    mon.clear()

    -- Kopfzeile
    mon.setCursorPos(1, 1)
    mon.setTextColor(colors.cyan)
    mon.write("ME Storage Bus Items")

    mon.setCursorPos(1, 2)
    mon.setTextColor(colors.lightGray)
    mon.write(string.rep("-", w))

    local maxLines = h - 2

    for i = 1, maxLines do
        local index = i + scroll
        local item = items[index]

        if not item then break end

        local y = i + 2
        local amountText = " x" .. tostring(item.amount)

        local maxNameLen = w - #amountText
        local name = item.displayName

        if #name > maxNameLen then
            name = string.sub(name, 1, math.max(1, maxNameLen - 3)) .. "..."
        end

        mon.setCursorPos(1, y)
        mon.setTextColor(colors.white)
        mon.write(name)

        mon.setCursorPos(math.max(1, w - #amountText + 1), y)
        mon.setTextColor(colors.yellow)
        mon.write(amountText)
    end

    -- Fußzeile
    mon.setCursorPos(1, h)
    mon.setTextColor(colors.gray)
    mon.write("Up/Down scroll  R refresh")
end

draw()

while true do
    local event, key = os.pullEvent("key")

    if key == keys.up then
        if scroll > 0 then
            scroll = scroll - 1
            draw()
        end
    elseif key == keys.down then
        scroll = scroll + 1
        draw()
    elseif key == keys.r then
        draw()
    end
end