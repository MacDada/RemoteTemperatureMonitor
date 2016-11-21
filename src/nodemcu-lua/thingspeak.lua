d_thingspeak = {
    apiHost = 'api.thingspeak.com'
}

d_thingspeak.__index = d_thingspeak

function d_thingspeak.new(apiKey, apiIp)
    local settings = {}
    setmetatable(settings, d_thingspeak)
    settings.apiKey = apiKey
    settings.apiIp = apiIp or "184.106.153.149"

    return settings
end

function d_thingspeak:update(fieldNumber, value)
    local request = "POST "
        .."/update"
        .."?api_key="..self.apiKey
        .."&field"..fieldNumber.."="..value.." "
        .."HTTP/1.1\r\n"
        .."Host: "..self['apiHost'].."\r\n"
        .."Accept: */*\r\n"
        .."User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
        .."\r\n"

    local conn = net.createConnection(net.TCP, 0)

    conn:on("receive", function(conn, payload)
        print("received payload:")
        print(payload)
    end)

    conn:on("connection", function(conn)
        print("Sending request")

        -- hiding apiKey as it is secret
        print(string.gsub(request, self.apiKey, 'X_secret_apiKey_X'))

        conn:send(request)
    end)

    conn:on("sent", function(conn)
        print("Closing connection")
        conn:close()
    end)

    conn:on("disconnection", function(conn)
        print("Disconnected from "..self.apiHost)
        conn:close()
    end)

    print("Connecting to "..self.apiHost)
    conn:connect(80, self.apiIp)
end
