EventBus = {}

EventBus["_callbacks"] = {}

EventBus["_callbackCounter"] = 0


--- @return string
EventBus.register = function(func)
    EventBus["_callbackCounter"] = EventBus["_callbackCounter"] + 1
    local callbackId = "callback_" .. EventBus["_callbackCounter"]
    EventBus["_callbacks"][callbackId] = func
    return callbackId
end

EventBus.unregister = function(callbackId)
    EventBus["_callbacks"][callbackId] = nil
end
