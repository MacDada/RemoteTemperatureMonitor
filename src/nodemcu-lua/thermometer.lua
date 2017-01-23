dofile("config.lua")

local SENSOR_ERROR_TEMPERATURE = 85;

local dsApi = require("ds18b20")

local function doMeasureTemperature(thermometerAddress)
    local temperature = dsApi.read(thermometerAddress, dsApi.C)

    print("Measured temp ".. temperature.." for sensor "..thermometerAddress)

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
            table.insert(temperatures, doMeasureTemperature(thermometerAddress))
        end

        return temperatures
    end
}
