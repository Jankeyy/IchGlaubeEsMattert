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

local function prettifyItemName(rawName)
    local name = rawName
    name = string.match(name, ":(.+)") or name
    name = string.gsub(name, "_", " ")
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

    mon.setCursorPos(1, 1)
    mon.setTextColor(colors.cyan)
    mon.write("ME Storage Bus Items")

    mon.setCursorPos(1, 2)
    mon.setTextColor(colors.lightGray)
    mon.write(string.rep("-", w))

    local maxLines = h - 3
    local maxScroll = math.max(0, #items - maxLines)

    if scroll > maxScroll then
        scroll = maxScroll
    end

    for i = 1, maxLines do
        local index = i + scroll
        local item = items[index]
        if not item then break end

        local y = i + 2
        local amountText = " x" .. tostring(item.amount)
        local maxNameLen = w - #amountText - 1
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

    mon.setCursorPos(1, h)
    mon.setTextColor(colors.gray)
    mon.write("Auto refresh | Up/Down")
end

while true do
    draw()

    local timer = os.startTimer(2)

    while true do
        local event, p1 = os.pullEvent()

        if event == "timer" and p1 == timer then
            break
        elseif event == "key" then
            if p1 == keys.up and scroll > 0 then
                scroll = scroll - 1
                draw()
            elseif p1 == keys.down then
                scroll = scroll + 1
                draw()
            end
        end
    end
end