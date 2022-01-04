local _, ns = ...
local Z = ns.Z
local B = Z:GetModule("Blizzard")

--[[
    Blizzard:
        ObjectiveTrackerFrame

    ls_UI:
        LSOTFrameHolder
]]

function B:ObjectiveTracker()
    local frame = ObjectiveTrackerFrame
    local holder = LSOTFrameHolder

    frame:ClearAllPoints()
    frame:SetPoint("TOPRIGHT", holder, "TOPRIGHT", 0, 0)

    frame.HeaderMenu.MinimizeButton:HookScript("OnClick", function()
        frame:SetPoint("TOPRIGHT", holder, "TOPRIGHT", 0, 0)
    end)
end
