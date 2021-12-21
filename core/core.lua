local addonName, ns = ...

--[[
    Blizzard:
        CreateFrame

    ls_UI:
        ls_UI
]]

-- ls_UI
local E = unpack(ls_UI)
ns.E = E

-- mine
local Z = {}
ns.Z = Z

_G[addonName] = {
    [1] = ns.Z
}

-- events
do
    local events = {}
    local eventHandler = CreateFrame("Frame")

    eventHandler:SetScript("OnEvent", function(_, event, ...)
        for callback in pairs(events[event]) do
            callback(...)
        end
    end)

    function Z:RegisterEvent(event, callback)
        if not events[event] then
            events[event] = {}

            eventHandler:RegisterEvent(event)
        end

        events[event][callback] = true
    end

    function Z:UnregisterEvent(event, callback)
        local callbacks = events[event]

        if callbacks and callbacks[callback] then
            callbacks[callback] = nil

            if not next(callbacks) then
                events[event] = nil

                eventHandler:UnregisterEvent(event)
            end
        end
    end
end

-- modules
do
    local modules = {}

    function Z:AddModule(name)
        modules[name] = {}

        return modules[name]
    end

    function Z:GetModule(name)
        return modules[name]
    end

    function Z:LoadModules()
        for _, module in next, modules do
            module:Load()
        end
    end
end
