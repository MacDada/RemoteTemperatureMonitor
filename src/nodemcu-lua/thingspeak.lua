local function string_replace(subject, find, replace)
    return string.gsub(subject, find, replace)
end

-- source: http://lua-users.org/wiki/StringRecipes
local function url_encode(str)
    str = string.gsub(str, "\n", "\r\n")
    str = string.gsub(
        str,
        "([^%w %-%_%.%~])",
        function (c)
            return string.format("%%%02X", string.byte(c))
        end
    )
    str = string.gsub(str, " ", "+")

    return str
end

local function value_or_default_when_nil(value, default)
    return nil == value and default or value
end

d_thingspeak = {
    apiHost = 'api.thingspeak.com'
}

d_thingspeak.__index = d_thingspeak

function d_thingspeak.new(apiKey, apiIp, hideApiKeyInLogs)
    local settings = {}
    setmetatable(settings, d_thingspeak)

    settings.apiKey = apiKey
    settings.apiIp = apiIp or "184.106.153.149"
    settings.hideApiKeyInLogs = value_or_default_when_nil(hideApiKeyInLogs, true)

    return settings
end

-- fields is a table with field numbers as keys
function d_thingspeak:update(fields)
    local fieldsString = ''

    for fieldNumber, fieldValue in pairs(fields) do
       fieldsString = fieldsString
           ..'&field'
           ..tonumber(fieldNumber)
           ..'='
           ..url_encode(fieldValue)
    end

    local request = "POST "
        .."/update"
        .."?api_key="..self.apiKey
        ..fieldsString.." "
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

        if self.hideApiKeyInLogs then
            print(string_replace(request, self.apiKey, 'X_secret_apiKey_X'))
        else
            print(request)
        end

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
