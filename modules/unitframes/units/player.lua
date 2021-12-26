local _, ns = ...
local Z, E = ns.Z, ns.E
local UF = Z:GetModule("UnitFrames")

--[[
    ls_UI:
        LSPlayerFrame
]]

function UF:Player()
    local frame = LSPlayerFrame

    self:Castbar(frame)
end
