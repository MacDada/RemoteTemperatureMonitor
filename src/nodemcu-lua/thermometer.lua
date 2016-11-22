dofile("config.lua")

local SENSOR_ERROR_TEMPERATURE = 85;

local dsApi = require("ds18b20")

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

        local temperature = dsApi.read(addrs[1], dsApi.C)
        print("Measured temp: ".. temperature)

        if (SENSOR_ERROR_TEMPERATURE == temperature) then
            print("Measuring temp error, trying again...")
            return measureTemperature()
        else
            return temperature
        end
    end
}
