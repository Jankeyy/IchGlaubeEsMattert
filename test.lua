me = peripheral.find("me_bridge")
drives = me.getDrives()
cells = me.getCells()

print("Gefundene Drives")

for index, drive in pairs(drives) do
    used = drive.usedBytes or 0
    total = drive.totalBytes or 0

    print(string.format("Slot %d: %d / %d Bytes genutzt", index, used, total))
end