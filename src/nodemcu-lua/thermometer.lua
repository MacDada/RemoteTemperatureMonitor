dofile("config.lua")

local SENSOR_ERROR_TEMPERATURE = 85;

local dsApi = require("ds18b20")

local function tableKeyForValue(table, value)
    for tableKey, tableValue in pairs(table) do
        if (value == tableValue) then
            return tableKey
        end
    end
end

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

local function thermometerAddressToName(address)
    local readableAddress = humanReadableSensorAddress(address)

    local name = tableKeyForValue(d_config.thermometers_names_addresses, readableAddress)

    if nil == name then
        print("No assigned name for thermometer with address " ..readableAddress)

        return "<no name>"
    end

    return name
end

local function doMeasureTemperature(thermometerAddress)
    local temperature = dsApi.read(thermometerAddress, dsApi.C)

    print(
        "Measured temp "..temperature
        .. ' for sensor named "' ..thermometerAddressToName(thermometerAddress)..'"'
        .. ' with address "' ..humanReadableSensorAddress(thermometerAddress)
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

        local detectedThermometerAddresses = dsApi.addrs()

        print("Total DS18B20 sensors: "..table.getn(detectedThermometerAddresses))

        local temperatures = {}

        for _, thermometerAddress in pairs(detectedThermometerAddresses) do
            local thermometerName = thermometerAddressToName(thermometerAddress)
            local temperature = doMeasureTemperature(thermometerAddress)

            temperatures[thermometerName] = temperature
        end

        return temperatures
    end
}
