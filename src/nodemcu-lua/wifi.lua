d_wifi = {}

function d_wifi.printConnectionDetails()
    if not d_wifi.isConnected() then
        print("No wifi connection!")
        return
    end

    local ssid = wifi.sta.getconfig()
    print('Connected to: "'..ssid..'"')
     
    local ip, netmask, gateway = wifi.sta.getip()
    print('ip: "'..ip..'"')
    print('netmask: "'..netmask..'"')
    print('gateway: "'..gateway..'"')
end

function d_wifi.isConnected()
    return nil ~= wifi.sta.getip()
end

function d_wifi.connect(ssid, pass, onReady)
    print('Connecting to "'..ssid..'"')
    
    wifi.setmode(wifi.STATION)
    wifi.sta.config(ssid, pass)
--    wifi.sta.setip({
--        ip = "192.168.0.26",
--        netmask = "255.255.255.0",
--        gateway = "192.168.0.1"
--    })
    wifi.sta.connect()
    
    tmr.alarm(1, 1000, 1, function() 
        if not d_wifi.isConnected() then 
            print("Wifi not ready, waiting...") 
        else 
            tmr.stop(1)
            onReady()
        end 
    end)
end
