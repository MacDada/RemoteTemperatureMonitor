dofile("config.lua")

local SENSOR_ERROR_TEMPERATURE = 85;

local dsApi = require("ds18b20")

dsApi.setup(d_config.thermometer_input_pin)

local addrs = dsApi.addrs()

if (addrs ~= nil) then
    -- bug: always showing 0:
    -- https://github.com/nodemcu/nodemcu-firmware/issues/429
    print("Total DS18B20 sensors: "..table.getn(addrs))
end

local function measureTemperature()
    local temperature = dsApi.read(addrs[1], dsApi.C)
    print("Measured temp: ".. temperature)

    if (SENSOR_ERROR_TEMPERATURE == temperature) then
        print("Measuring temp error, trying again...")
        return measureTemperature()
    else
        return temperature
    end
end

d_thermometer = {
    measureTemperature = measureTemperature
}
