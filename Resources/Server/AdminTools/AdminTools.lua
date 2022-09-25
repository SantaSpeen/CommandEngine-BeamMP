---
--- Created by SantaSpeen.
--- DateTime: 25.09.2022 13:38
---
jsonLib = require('json')

pluginConfigFile = "config.json"
pluginName = "AdminTools"

pluginPath = debug.getinfo(1).source:gsub("\\","/")
pluginPath = string.gsub(pluginPath, pluginName + ".lua", "")

-- -- -- -- -- Init functions -- -- -- -- --

function log(...)
    print("[AdminTools] " .. tostring(...))
end

function stringToTable(str, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    local i = 1
    for s in string.gmatch(str, "([^"..sep.."]+)") do
        t[i] = s
        i = i + 1
    end
    return t
end

function jsonReadFile(path)
    local jsonFile, error = io.open(path,"r")
    if error then return nil, error end
    local jsonText = jsonFile:read("*a")
    jsonFile:close()
    return jsonLib.parse(jsonText), false
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --


function onInit()
    log("Start init")
    log("Plugin path: " .. pluginPath)
    log("Reading config..")
    if jsonReadFile(pluginConfigFile) then

    end
    log("Init complete.")
end
