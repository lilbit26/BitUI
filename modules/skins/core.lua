local _, ns = ...
local Z = ns.Z
local S = Z:AddModule("Skins")

--[[
    Blizzard:
        IsAddOnLoaded
]]

local skins = {}

function S:AddSkin(addon, callback)
    skins[addon] = callback
end

function S:LoadSkins()
    for addon, callback in pairs(skins) do
        local loaded, finished = IsAddOnLoaded(addon)
        if loaded and finished then
            callback()

            skins[addon] = nil
        end
    end
end

function S:Load()
    self:LoadSkins()

    Z:RegisterEvent("ADDON_LOADED", function(addon)
        local callback = skins[addon]

        if callback then
            callback()

            skins[addon] = nil
        end
    end)
end
