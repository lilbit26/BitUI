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

function Z:HandleFont(object, font, size, flag, shadow)
    local f, s = object:GetFont()

    f = font or f
    s = size or s

    if flag then
        object:SetFont(f, s, flag)
    else
        object:SetFont(f, s, "")
    end

    if shadow == false then
        object:SetShadowOffset(0, 0, 0, 0)
        object:SetShadowOffset(0, 0)
    else
        object:SetShadowColor(0, 0, 0, 1)
        object:SetShadowOffset(1, -1)
    end
end
