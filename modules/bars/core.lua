local _, ns = ...
local Z = ns.Z
local B = Z:AddModule("Bars")

function B:Load()
    self:ActionBars()
    self:XPBar()
end
