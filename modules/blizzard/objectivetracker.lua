local _, ns = ...
local Z, E = ns.Z, ns.E
local B = Z:GetModule("Blizzard")

--[[
    Blizzard:
        ObjectiveTrackerFrame

    ls_UI:
        LSOTFrameHolder
]]

local var = {
    x = -20,
    y = -320
}

function B:ObjectiveTracker()
    local frame = ObjectiveTrackerFrame

    frame:SetMovable(false)
    frame:SetParent(UIParent)

    frame:ClearAllPoints()
    frame:SetPoint("TOPRIGHT", var.x, var.y)

    frame.HeaderMenu.MinimizeButton:HookScript("OnClick", function()
        frame:SetPoint("TOPRIGHT", var.x, var.y)
    end)

    E:ForceHide(LSOTFrameHolder)
end
