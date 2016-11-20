-- Safe load init2.lua
-- https://github.com/nodemcu/nodemcu-firmware/issues/305

local countdown = 3

print("Loading init2.lua in...")
tmr.alarm(0, 1000, 1, function()
    print(countdown)
    countdown = countdown - 1
    
    if 0 == countdown then
        tmr.stop(0)
        countdown = nil
        
        local s, err
        if file.open("init2.lc") then
            file.close()
            s, err = pcall(function() dofile("init2.lc") end)
            if not s then print(err) end
        elseif file.open("init2.lua") then
            file.close()
            s, err = pcall(function() dofile("init2.lua") end)
            if not s then print(err) end
        else
            print("No file init2.lua!")
        end
    end
end)
