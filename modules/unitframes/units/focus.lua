local _, ns = ...
local Z = ns.Z
local UF = Z:GetModule("UnitFrames")

--[[
    ls_UI:
        LSFocusFrame
]]

function UF:Focus()
    local frame = LSFocusFrame

    self:Castbar(frame)
end
