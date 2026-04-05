---provide a mock environment of GML VM
---@readonly
---@meta

---@alias GMLFunction function

---@param name string
---@return GMLFunction|nil
function getgmlfunction(name)
    print("[MOCK] Attempted to get unknown GML function: " .. name)
    return nil
end
