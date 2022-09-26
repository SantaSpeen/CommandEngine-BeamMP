---
--- Created by SantaSpeen.
--- DateTime: 25.09.2022 13:38
---

-- -- -- -- -- Init functions -- -- -- -- --

function log(...)
    print("[".. pluginName .."] " .. tostring(...))
end

function SplitString (str, char)
    local res = {};
    for i in string.gmatch(str, "[^" .. char .. "]+") do
        table.insert(res, i)
    end
    return res
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- Init Variables -- -- -- -- --

pluginName = "CommandEngine"
prefix = "/"
-- Table settings: cmd_name = { "event", "mode", { "command syntax", "Help note." } }
-- Mods settings: a - all mode; c - only console; u - only from user;
commandsStorage = {
    help = { "CE_help", "c", "displays this help."},
    stop = { "shutdownServer", "c", "Also as exit."}
}
pluginPath = FS.GetParentFolder(string.gsub(debug.getinfo(1).source,"\\", "/"))

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- Register Events -- -- -- -- -

log("Register global events.")
MP.RegisterEvent("CE_addCommand", "addCommandToStorage")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --



function getCommand(commandName, handlerMode)
    for k, v in pairs(commandsStorage) do
        if commandName == k then
            local mode = v[2]
            if mode == "s" then
                return nil
            elseif mode == "a" then
                return v
            elseif mode == handlerMode then
                return v
            end
        end
    end
end

function chatHandler(sender_id, sender_name, message)
    if message:sub(1,1) ~= prefix then return 0 end
    local cmd = SplitString(message:sub(2), prefix)[1]
    cmdSettings = getCommand(cmd, "u")
    if cmdSettings then
        local Future = MP.TriggerGlobalEvent(cmdSettings[1], sender_id, sender_name)
        while not Future:IsDone() do MP.Sleep(100) end
        local Results = Future:GetResults()
        MP.SendChatMessage(sender_id, Results[1])
    end
end

function consoleHandler(cmd)
    cmdSettings = getCommand(cmd, "c")
    if cmdSettings then
        local Future = MP.TriggerGlobalEvent(cmdSettings[1], -1, "console")
        while not Future:IsDone() do MP.Sleep(100) end
        local Results = Future:GetResults()
        return Results[1]
    end
end

function addCommandToStorage(commands)
    log(commands)
    for k,v in pairs(commands) do commandsStorage[k] = v end
end

function printHelpCommandEngine(...)
    local wrap = function (text)
        local ltext = string.len(text)
        if ltext > 24 then
            return string.sub(text, 1, 20) .. "... "
        end
        return text .. string.sub("                        ", 1, 24 - ltext)
    end
    local helpMessage = "CommandEngine Console:\nM       Syntax                  What it does\n    Commands:\n"  --> I hate this
    for k, v in pairs(commandsStorage) do
        helpNote = v[3]
        if type(helpNote) == "table" then
            helpMessage = helpMessage .. v[2] .. "       " .. wrap(v[3][1]) .. v[3][2] .. "\n"
        else
            helpMessage = helpMessage .. v[2] .. "       " .. wrap(k) .. v[3] .. "\n"
        end
    end
    return helpMessage
end

function isCommandEngineReady() return true end
function shutdown() exit() return "Goodbye!" end


function onInit()
    log("Register default events.")
    MP.RegisterEvent("onConsoleInput", "consoleHandler")
    MP.RegisterEvent("onChatMessage", "chatHandler")
    MP.RegisterEvent("CE_help", "printHelpCommandEngine")
    MP.RegisterEvent("shutdownServer", "shutdown")
    log("Ready.")
    MP.RegisterEvent("CE_isReady", "isCommandEngineReady")
end
