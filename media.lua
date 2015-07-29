-- awemedia.lua

local awful = require("awful")
local client = client
local pairs = pairs
local print = print
local USE_T = true

function media_key(key)
    awful.util.spawn("/home/gp/.config/awesome/mediakeys.sh "..key)
end

function volume(chanel, sign)
    os.execute("amixer -D pulse set "..chanel.." 1+ unmute")
    os.execute("amixer sset "..chanel.." 3%"..sign)
end

function mute(chanel)
    os.execute("amixer -D pulse set "..chanel.." 1+ toggle")
end

function app_is_active(app_name, clients)
    for i, c in pairs(clients) do
        if app_name == c.instance then
            return true
        end
    end
    return false
end

