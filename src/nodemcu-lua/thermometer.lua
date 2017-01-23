dofile("config.lua")

local SENSOR_ERROR_TEMPERATURE = 85;

local dsApi = require("ds18b20")

local function humanReadableSensorAddress(addr)
    -- https://bigdanzblog.wordpress.com/2015/04/25/esp8266-and-ds18b20-transmitting-temperature-data/
    return string.format(
        "%02X-%02X-%02X-%02X-%02X-%02X-%02X-%02X",
        addr:byte(1),
        addr:byte(2),
        addr:byte(3),
        addr:byte(4),
        addr:byte(5),
        addr:byte(6),
        addr:byte(7),
        addr:byte(8)
    )
end

local function doMeasureTemperature(thermometerAddress)
    local temperature = dsApi.read(thermometerAddress, dsApi.C)

    print(
        "Measured temp "..temperature
        .." for sensor "..humanReadableSensorAddress(thermometerAddress)
    )

    if (SENSOR_ERROR_TEMPERATURE == temperature) then
        print("Error while measuring temperature, trying again...")

        return doMeasureTemperature(thermometerAddress)
    end

    return temperature
end

d_thermometer = {
    initialized = false,

    initialize = function()
        dsApi.setup(d_config.thermometer_input_pin)

        d_thermometer.initialized = true
    end,

    measureTemperature = function()
        if (false == d_thermometer.initialized) then
            d_thermometer.initialize()
        end

        local addrs = dsApi.addrs()

        print("Total DS18B20 sensors: "..table.getn(addrs))

        local temperatures = {}

        for _, thermometerAddress in pairs(addrs) do
            local readableAddress = humanReadableSensorAddress(thermometerAddress)
            local temperature = doMeasureTemperature(thermometerAddress)

            temperatures[readableAddress] = temperature
        end

        return temperatures
    end
}
