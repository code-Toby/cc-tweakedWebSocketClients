local H = ""
if (fs.exists("/cloud.lc")) then
    term.clear()
    term.setCursorPos(1,1)
    print("What would you like to do?")
    print("(1) > Use last host")
    print("(2) > Use new host")
    
    local input = read()
    
    if input == "1" then
        term.setCursorPos(1,1)
        term.clear()
        local ClFile = fs.open("/cloud.lc", "r")
        H = ClFile.readAll()
        ClFile.close()
    end
    if input == "2" then
        term.setCursorPos(1,1)
        term.clear()
        write("Please enter a <Host:port>: ")
        H = read()
        
        local ClFile = fs.open("/cloud.lc", "w")
        ClFile.write(H)
        ClFile.close()
    end
else
    term.setCursorPos(1,1)
    term.clear()
    write("Please enter a <Host:port>: ")
    H = read()
    
    local ClFile = fs.open("cloud.lc","w")
    ClFile.write(H)
    ClFile.close()
end

local ws = assert(http.websocket(H))
print("connected to: "..H)

local TabID = shell.openTab("shell")
--shell.switchTab(TabID)

term.clear()
term.setCursorPos(1,1)
print("What dir would you like to backup?: ")
print("# use / at the end of your folder name")
local DirToCopy = '/'..read()

function FindFilesAndStuff(Dir, webs)
    local Files = fs.list(Dir)
    local Dir_ = Dir
    local Fls = {}

    for _, v in pairs(Files) do
        local Type = fs.isDir(Dir..v)
        if Type == true then
            print("DIR ["..v.."]")
            Dir_ = Dir..v..'/'
            FindFilesAndStuff(Dir_, webs)
        end
        if Type == false then
            print("FILE ["..v.."]")
            table.insert(Fls, {v, Dir_})
        end

        
    end

    for _, v_ in pairs(Fls) do
        local fl = fs.open(v_[2]..v_[1], "r")
        local dt = fl.readAll()
        local Tbl = {
            ["Name"] = v_[1],
            ["Data"] = dt,
            ["Dir"] = v_[2]
        }

        webs.send(textutils.serializeJSON(Tbl))
    end
end

FindFilesAndStuff(DirToCopy, ws)
ws.close()