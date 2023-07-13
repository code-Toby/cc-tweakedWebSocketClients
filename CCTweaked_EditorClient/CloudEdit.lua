local H = ""
if not fs.exists("/cloud.lc") then
    write("please enter <host:port>: ")
    H = read()
    local fl = fs.open("/cloud.lc","w")
    fl.write(H)
else
    print("What would you like to do:")
    print("(1) use last host")
    print("(2) use new host")
    
    local r = read()
    
    if r == "1" then 
        term.clear()
        term.setCursorPos(1,1)
        local fl = fs.open("/cloud.lc","r")
        H = fl.readAll()
    end
    if r == "2" then
        term.clear()
        term.setCursorPos(1,1)
        write("please enter <host:port>: ")
        H = read()
        
        local fl = fs.open("/cloud.lc","w")
        fl.write(H)
        fl.close()
    end
end
local ws = assert(http.websocket("ws://"..H))
print("connected to: "..H)

local TabID = shell.openTab("shell")
shell.switchTab(TabID)

if not fs.exists("/CloudEditFiles") then
    fs.makeDir("/CloudEditFiles")
end

function printTable(tbl)
    for k, v in pairs(tbl) do
        print(v)
    end
end

while true do
    local WSData = ws.receive()
    local data = textutils.unserialiseJSON(WSData)
    
    local FlName = data["Name"]
    local FlData = data["Data"]
    
    if FlName == nil then return end
    
    local currFl = fs.open("/CloudEditFiles/"..FlName,"w")
    currFl.write(FlData)
    currFl.close()
    print("wrote to file: "..FlName)
  
end