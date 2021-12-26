local _, ns = ...
local Z = ns.Z
local UF = Z:GetModule("UnitFrames")

--[[
    Blizzard:
        hooksecurefunc
]]

function UF:Castbar(frame)
    hooksecurefunc(frame.Castbar, "PostCastStart", function(bar)
        if bar.handled then return end

        bar.TexParent:ClearAllPoints()
        bar.TexParent:SetAllPoints(bar.Holder)

        if bar.Icon then
            bar.Icon:SetPoint("TOPLEFT", bar.Holder, "TOPLEFT", 0, 0)
            bar:SetPoint("TOPLEFT", 2 + bar.Holder:GetHeight() * 1.5, 0)
            bar:SetPoint("BOTTOMRIGHT", 0, 0)
        else
            bar:SetAllPoints()
        end

        bar.handled = true
    end)

    -- frame.Castbar:SetFrameLevel(frame:GetFrameLevel() + 10)
end
