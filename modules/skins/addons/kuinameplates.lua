local _, ns = ...
local Z = ns.Z

--[[
    Libraries:
        LibStub

    Kui_Nameplates:
        KuiNameplates
        KuiNameplatesCore
]]

Z:HookAddOn("Kui_Nameplates", function()
    local addon = KuiNameplates
    local core = KuiNameplatesCore
    local kui = LibStub("Kui-1.0")

    local plugin = addon:NewPlugin("BitUI", 101, 5)
    if not plugin then return end

    function plugin:Create(frame)
    end

    function plugin:OnEnable()
        for _, frame in addon:Frames() do
            self:Create(frame)
        end
    end
end)
