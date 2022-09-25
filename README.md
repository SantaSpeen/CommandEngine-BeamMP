# CommandEngine

## About

* Status: **WIP**

CommandEngine is plugin for BeamMP.\
Plugin for handle commands from client chat or server console.

## Wiki

**Installation**\
Copy `CommandEngine` dir to `Resources/Server/`

**Add command to engine**

```lua

-- Plugin body 

function onInit()
    
    -- Plugin init then

    -- Firstly: Wait to mod initialization
    log("Wait CommandEngine init..")
    local isCommandEngineReady = false
    while not isCommandEngineReady do
        local Future = MP.TriggerGlobalEvent("CE_isReady")
        while not Future:IsDone() do MP.Sleep(100) end
        local result = Future:GetResults()
        if result[1] == true then isCommandEngineReady = true end
    end

    -- Secondary: Register commands 
    MP.TriggerGlobalEvent("CE_addCommand", {
            ban = { "banUser", "a", { "ban  <name> [reason]", "Ban user." }},
            unban = { "unbanUser", "a", { "unban <name>", "Unban user." }},
            banlist = { "seeBanList", "a", "See ban list on server."}
        }
    )
    
end 
```
This is real example from [AdminTools](https://github.com/SantaSpeen/AdminTools-BeamMP/blob/master/Resources/Server/AdminTools/AdminTools.lua#L41)
