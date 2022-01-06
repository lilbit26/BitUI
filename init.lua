local _, ns = ...
local Z = ns.Z

--[[
    Blizzard:
        GetPhysicalScreenSize
        SetCVar

        UIParent
]]

-- constants
Z.assetPath = "Interface\\AddOns\\ls_UI\\assets\\"
Z.iconCoords = {4 / 64, 60 / 64, 4 / 64, 60 / 64}

Z:RegisterEvent("PLAYER_LOGIN", function()
    -- UI scale
    local _, height = GetPhysicalScreenSize()

    UIParent:SetScale(768 / height)

    -- camera
    SetCVar("test_cameraDynamicPitch", 1)
    SetCVar("test_cameraDynamicPitchBaseFovPad", 0.7)
    SetCVar("test_cameraDynamicPitchBaseFovPadDownScale", 1)

    UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED") -- disable blizzard's popup

    -- modules
    Z:LoadModules()
end)
