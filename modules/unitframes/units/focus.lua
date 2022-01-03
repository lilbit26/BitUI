local _, ns = ...
local Z = ns.Z
local UF = Z:GetModule("UnitFrames")

--[[
    ls_UI:
        LSFocusFrame
]]

function UF:Focus()
    local frame = LSFocusFrame
    if not frame then return end

    self:Castbar(frame)
end
