dofile("credentials.lua")
dofile("config.lua")
dofile("wifi.lua")
dofile("thingspeak.lua")

d_wifi.connect(d_config["wifis"][d_config["wifi"]], d_credentials[d_config["wifi"]], function()
    d_wifi.printConnectionDetails()

    local ts = d_thingspeak.new(d_credentials["thingspeak_api_key"])

    ds = require("ds18b20")
    pin = d_config["thermometer_input_pin"]
    ds.setup(pin)

    addrs = ds.addrs()
    if (addrs ~= nil) then
        -- bug: always showing 0:
        -- https://github.com/nodemcu/nodemcu-firmware/issues/429
        print("Total DS18B20 sensors: "..table.getn(addrs))
    end

    local function measureTemp()
        local temp = ds.read(addrs[1], ds.C)
        print("Measured temp: "..temp)

        if (85 == temp) then
            print("Measuring temp error, trying again...")
            return measureTemp()
        else
            return temp
        end
    end

    tmr.alarm(0, d_config["timeout_between_measures_in_seconds"]*1000, 1, function()
        ts:update(2, measureTemp())
    end)
end)
