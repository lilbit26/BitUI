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

        if frame.unit:match("boss%d?$") then
            aura.count:ClearAllPoints()
            aura.count:SetPoint("TOPRIGHT", 1, 1)
            aura.count:SetPoint("BOTTOMLEFT", 1, 1)
        else
            aura.cd:SetDrawSwipe(false)

            aura.count:ClearAllPoints()
            aura.count:SetPoint("TOPRIGHT", 2, -1)
            aura.count:SetPoint("BOTTOMLEFT", 2, -1)
        end

        aura.handled = true
    end)
end
