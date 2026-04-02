---@class ModSdk
---@field version string
---@field _funcFromMod table<string, function>
---@field _funcCounter integer

ModSdk = {}

ModSdk["version"] = "1.0"
ModSdk["_funcFromMod"] = {}
ModSdk["_funcCounter"] = 0


ModSdk.RegisterFunction = function(func)
    ModSdk._funcCounter = ModSdk._funcCounter + 1
    local funcId = "func_" .. ModSdk._funcCounter
    ModSdk._funcFromMod[funcId] = func
    return funcId
end

ModSdk.RunFuncFromMod = function()
    local count = ModSdk._funcCounter
    for i = 1, count do
        local funcId = "func_" .. i
        local func = ModSdk._funcFromMod[funcId]
        if type(func) == "function" then
            func()
        end
    end
end

function RunFuncFromMod()
    ModSdk.RunFuncFromMod()
end
