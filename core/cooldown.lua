local _, ns = ...
local E = ns.E

--[[
    Blizzard:
        hooksecurefunc
]]

hooksecurefunc(E.Cooldowns, "Handle", function(cooldown)
    cooldown.Timer:ClearAllPoints()
    cooldown.Timer:SetPoint("TOPLEFT", -7, 0)
    cooldown.Timer:SetPoint("BOTTOMRIGHT", 9, 0)
end)
