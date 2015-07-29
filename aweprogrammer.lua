-- aweprogrammer.lua

local awful = require("awful")
local naughty = require("naughty")
local quake = require("quake")

local client = client
local pairs = pairs
local print = print
local USE_T = true
local dir = "~/"

function programmer_key(language)
    --[[awful.prompt.run({ prompt = "Progect folder: " },
        mypromptbox[mouse.screen].widget, function(text)
        naughty.notify({ text = "you entered: " .. text })
        dir = text
    end)]]--
    if language == "python" then
        os.execute("cd ~/ && xterm -e python")
    end
end
