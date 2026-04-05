Stove = {}

--- @type table<string, GMLFunction|nil>
Stove["gmlFunctions"] = {}

--- @param name string
--- @return GMLFunction|nil
Stove.GetGmlFunction = function(name)
    local func = Stove["gmlFunctions"][name]

    if (func == nil) then
        func = getgmlfunction(name)
        if (func ~= nil) then
            Stove["gmlFunctions"][name] = func
        else
            print("warn: failed to get gml function - " .. tostring(name))
        end
    end

    return func
end

return Stove
