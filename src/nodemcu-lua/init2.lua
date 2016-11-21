dofile("credentials.lua")
dofile("config.lua")
dofile("wifi.lua")
dofile("thingspeak.lua")

local WIFI_NAME = d_config.wifis[d_config.wifi]
local WIFI_PASSWORD = d_credentials[d_config.wifi]

d_wifi.connect(WIFI_NAME, WIFI_PASSWORD, function()
    d_wifi.printConnectionDetails()

    local thingspeakApi = d_thingspeak.new(d_credentials.thingspeak_api_key)

    dofile('thermometer.lua')

    tmr.alarm(0, d_config.timeout_between_measures_in_seconds*1000, 1, function()
        thingspeakApi:update(2, d_thermometer.measureTemperature())
    end)
end)
