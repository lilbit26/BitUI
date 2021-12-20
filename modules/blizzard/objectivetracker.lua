local _, ns = ...
local Z = ns.Z
local B = Z:GetModule("Blizzard")

--[[
    Blizzard:
        ObjectiveTrackerFrame
        UIParent
]]

function B:ObjectiveTracker()
    local x, y = -20, -320

    local frame = ObjectiveTrackerFrame
    frame:SetMovable(false)
    frame:SetParent(UIParent)
    frame:ClearAllPoints()
    frame:SetPoint("TOPRIGHT", x, y)

    frame.HeaderMenu.MinimizeButton:HookScript("OnClick", function()
        frame:SetPoint("TOPRIGHT", x, y)
    end)
end
