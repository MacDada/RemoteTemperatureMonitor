dofile("credentials.lua")
dofile("config.lua")
dofile("wifi.lua")
dofile("thingspeak.lua")

local wifiName = d_config.wifis[d_config.wifi]
local wifiPassword = d_credentials[d_config.wifi]

d_wifi.connect(wifiName, wifiPassword, function()
    d_wifi.printConnectionDetails()

    local thingspeakApi = d_thingspeak.new(d_credentials.thingspeak_api_key)

    local dsApi = require("ds18b20")
    local pin = d_config.thermometer_input_pin
    dsApi.setup(pin)

    local addrs = dsApi.addrs()
    if (addrs ~= nil) then
        -- bug: always showing 0:
        -- https://github.com/nodemcu/nodemcu-firmware/issues/429
        print("Total DS18B20 sensors: "..table.getn(addrs))
    end

    local function measureTemperature()
        local temperature = dsApi.read(addrs[1], dsApi.C)
        print("Measured temp: ".. temperature)

        if (85 == temperature) then
            print("Measuring temp error, trying again...")
            return measureTemperature()
        else
            return temperature
        end
    end

    tmr.alarm(0, d_config.timeout_between_measures_in_seconds*1000, 1, function()
        thingspeakApi:update(2, measureTemperature())
    end)
end)
