dofile("credentials.lua")
dofile("config.lua")
dofile("wifi.lua")
dofile("thingspeak.lua")
dofile('thermometer.lua')

local WIFI_NAME = d_config.wifis[d_config.wifi]
local WIFI_PASSWORD = d_credentials[d_config.wifi]

local THINGSPEAK_CHANNEL_FIELD = 2

d_wifi.connect(WIFI_NAME, WIFI_PASSWORD, function()
    d_wifi.printConnectionDetails()

    local thingspeakApi = d_thingspeak.new(d_credentials.thingspeak_api_key)

    local function measureAndLogTemperature()
        return thingspeakApi:update(
            THINGSPEAK_CHANNEL_FIELD,
            d_thermometer.measureTemperature()
        )
    end

    measureAndLogTemperature()

    tmr.alarm(
        0,
        d_config.timeout_between_measures_in_seconds * 1000,
        1,
        measureAndLogTemperature
    )
end)
