local _, ns = ...
local Z = ns.Z
local UF = Z:GetModule("UnitFrames")

--[[
    Blizzard:
        hooksecurefunc
]]

function UF:Auras(frame)
    hooksecurefunc(frame.Auras, "PostUpdateIcon", function(_, _, aura)
        if aura.handled then return end

        aura.cd:SetDrawSwipe(false)

        aura.count:ClearAllPoints()
        aura.count:SetPoint("TOPRIGHT", 1, -1)
        aura.count:SetPoint("BOTTOMLEFT", 1, -1)

        aura.handled = true
    end)
end
