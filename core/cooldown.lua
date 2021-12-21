local _, ns = ...
local E = ns.E

--[[
    Blizzard:
        hooksecurefunc
]]

hooksecurefunc(E.Cooldowns, "Handle", function(cooldown)
    local timer = cooldown.Timer

    timer:ClearAllPoints()
    timer:SetPoint("TOPLEFT", -7, 0)
    timer:SetPoint("BOTTOMRIGHT", 9, 0)
end)
