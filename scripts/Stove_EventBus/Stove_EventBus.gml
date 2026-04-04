/// 


function StoveEventBus() constructor {
    /// @type {Array<Real>} 
    self.event_registry = []

    /// @param {Struct.StoveEvent} _event 
    static publish = function(_event) {
        if (!array_contains(self.event_registry, _event.type)) {
            return
        }
        // TODO: publish event
    }

    static enable_event = function(_event_type) {
        if (!array_contains(self.event_registry, _event_type)) {
            array_push(self.event_registry, _event_type)
        }
    }

    static disable_event = function(_event_type) {
        var _idx = array_find_index(self.event_registry, _event_type)
        if (_idx != -1) {
            array_delete(self.event_registry, _idx, 1);
        }
    }
}