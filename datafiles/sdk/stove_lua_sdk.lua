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

--- @param meta table 食物元数据（结构与 GML typedef / JSON 字段一致，camelCase）
Stove.RegisterModFood = function(meta)
    local func = Stove.GetGmlFunction("gml_register_mod_food")
    if (func ~= nil) then
        func(meta)
    else
        print("warn: failed to register food (register_food_from_json missing)")
    end
end

return Stove
