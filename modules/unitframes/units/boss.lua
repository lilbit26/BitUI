local _, ns = ...
local Z = ns.Z
local UF = Z:GetModule("UnitFrames")

function UF:Boss()
    for i = 1, 5 do
        local frame = _G["LSBoss" .. i .. "Frame"]

        if frame then
            self:Auras(frame)
            self:Castbar(frame)
        end
    end
end
