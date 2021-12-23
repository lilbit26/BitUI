local _, ns = ...
local Z = ns.Z
local S = Z:GetModule("Skins")

--[[
    Libraries:
        LibStub

    Kui_Nameplates:
        KuiNameplates
        KuiNameplatesCore
]]

S:AddSkin("Kui_Nameplates", function()
    local addon = KuiNameplates
    local core = KuiNameplatesCore
    local kui = LibStub("Kui-1.0")

    local plugin = addon:NewPlugin("BitUI", 101, 5)
    if not plugin then return end

    function plugin:Create(frame)
    end

    function plugin:Initialise()
        self:RegisterMessage("Create")
    end
end)
