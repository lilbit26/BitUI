local _, ns = ...
local Z = ns.Z
local B = Z:AddModule("Blizzard")

function B:Load()
    self:Chat()
    self:Fonts()
    self:ObjectiveTracker()
    self:RaidFrame()
    self:RaidFrameManager()
end
