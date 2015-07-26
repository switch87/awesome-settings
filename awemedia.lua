-- awemedia.lua

local awful = require("awful")
local client = client
local pairs = pairs
local print = print
local USE_T = true

function media_key(key)
    os.execute("/home/gp/.config/awesome/mediakeys.sh "..key)
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

function get_player_status(player)
    os.execute("/home/gp/.config/awesome/playerStatus.sh "..player)
    for line in  io.lines("/tmp/awesomeps1") do
        status = line
    end


    return status
    
end
--[[function sleep(n)
    local t0 = clock()
    while clock() - t0 <= n do end
end]]--

--[[
--note to self:
--io.popen gives more control over bash commands)
--]]
