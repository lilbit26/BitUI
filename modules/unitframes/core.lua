local _, ns = ...
local Z = ns.Z
local UF = Z:AddModule("UnitFrames")

function UF:Load()
    self:Player()
    self:Target()
    self:Focus()
    self:Boss()
end
