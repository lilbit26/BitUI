local _, ns = ...
local Z = ns.Z
local UF = Z:GetModule("UnitFrames")

--[[
    ls_UI:
        LSTargetFrame
]]

function UF:Target()
    local frame = LSTargetFrame
    if not frame then return end

    self:Auras(frame)
    self:Castbar(frame)
end
