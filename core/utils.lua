local _, ns = ...
local Z = ns.Z

--[[
    Blizzard:
        CreateFrame
]]

function Z:HookAddOn(name, callback)
    self:RegisterEvent("ADDON_LOADED", function(addOnName)
        if name == addOnName then
            callback()
        end
    end)
end

do
    local hidden = CreateFrame("Frame")
    hidden:Hide()

    function Z:Hide(object)
        if type(object) == "string" then
            object = _G[object]
        end

        object:SetParent(hidden)

        if object.UnregisterAllEvents then
            object:UnregisterAllEvents()
        end
    end
end
