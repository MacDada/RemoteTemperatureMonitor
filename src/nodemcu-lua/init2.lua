dofile("credentials.lua")
dofile("config.lua")
dofile("wifi.lua")
dofile("thingspeak.lua")
dofile('thermometer.lua')

local WIFI_NAME = d_config.wifis[d_config.wifi]
local WIFI_PASSWORD = d_credentials[d_config.wifi]

local repeat_delayed_by_seconds = function(seconds, callback)
    callback()

    tmr.alarm(
        0, -- alarm id
        seconds * 1000,
        tmr.ALARM_AUTO,
        callback
    )
end

-- table.getn() does not count entries with non–numeric keys :(
-- http://stackoverflow.com/a/2705804/666907
local function tableLength(table)
    local count = 0

    for _ in pairs(table) do
        count = count + 1
    end

    return count
end

local function assignTemperaturesToThingSpeakChartFields(temperatures)
    local fieldsTemperatures = {}

    for thermometerAddress, temperature in pairs(temperatures) do
        local fieldNumber = d_config["thermometers_thingspeak_fields"][thermometerAddress]

        if nil ~= fieldNumber then
            fieldsTemperatures[fieldNumber] = temperature
        else
            print('Thermometer with address '..thermometerAddress..' has no assigned ThingSpeak field!')
        end
    end

    return fieldsTemperatures
end

d_wifi.connect(WIFI_NAME, WIFI_PASSWORD, function()
    d_wifi.printConnectionDetails()

    local thingspeakApi = d_thingspeak.new(d_credentials.thingspeak_api_key)

    local function measureAndLogTemperatures()
        local temperatures = d_thermometer.measureTemperature()

        if tableLength(temperatures) > 0 then
            thingspeakApi:update(
                assignTemperaturesToThingSpeakChartFields(temperatures)
            )
        else
            print('There are no temperatures to publish')
        end
    end

    repeat_delayed_by_seconds(
        d_config.timeout_between_measures_in_seconds,
        measureAndLogTemperatures
    )
end)
