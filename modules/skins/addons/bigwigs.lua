local addonName, ns = ...
local Z, E = ns.Z, ns.E
local S = Z:GetModule("Skins")

--[[
    BigWigs:
        BigWigs
        BigWigsAPI
]]

local var = {
    bar = {
        height = 16,
        spacing = 6
    },
    text = {
        size = 12
    }
}

S:AddSkin("BigWigs", function()
    BigWigsAPI:RegisterBarStyle(addonName, {
        apiVersion = 1,
        version = 1,
        barSpacing = var.bar.spacing,
        barHeight = var.bar.height,
        fontSizeNormal = var.text.size,
        fontOutline = "NONE",
        ApplyStyle = function(bar)
            local icon = bar.candyBarIconFrame

            if bar.iconPosition == "LEFT" then
                icon:SetTexCoord(8 / 64, 56 / 64, 9 / 64, 41 / 64)
                icon:ClearAllPoints()
                icon:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
                icon:SetSize(var.bar.height * 1.5, var.bar.height)
            end

            bar.candyBarDuration:ClearAllPoints()
            bar.candyBarDuration:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 4, 0)
            bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -4, 0)
            bar.candyBarDuration:SetJustifyH("RIGHT")
            bar.candyBarDuration:SetJustifyV("MIDDLE")

            bar.candyBarLabel:ClearAllPoints()
            bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 4, 0)
            bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -4, 0)
            bar.candyBarLabel:SetJustifyH("LEFT")
            bar.candyBarLabel:SetJustifyV("MIDDLE")

            if bar.handled then return end

            local parent = CreateFrame("Frame", nil, bar)
            parent:SetAllPoints()
            parent:SetFrameLevel(bar:GetFrameLevel() + 1)

            local border = E:CreateBorder(parent)
            border:SetTexture("Interface\\AddOns\\ls_UI\\assets\\border-thin")
            border:SetSize(16)
            border:SetOffset(-8)

            local glass = parent:CreateTexture(nil, "OVERLAY")
            glass:SetTexture("Interface\\AddOns\\ls_UI\\assets\\statusbar-glass")
            glass:SetAllPoints()

            local sep = parent:CreateTexture(nil, "OVERLAY")
            sep:SetTexture(Z.assetPath ..  "statusbar-sep", "REPEAT", "REPEAT")
            sep:SetTexCoord(1 / 16, 13 / 16, 0 / 8, var.bar.height / 4)
            sep:SetSize(12 / 2, var.bar.height)
            sep:SetVertTile(true)
            sep:SetPoint("LEFT", icon, "RIGHT", -2, 0)
            sep:SetSnapToPixelGrid(false)
            sep:SetTexelSnappingBias(0)

            bar.handled = true
        end,
        GetStyleName = function() return "BitUI" end,
    })

    -- disable plugins
    Z:RegisterEvent("ADDON_LOADED", function(addon)
        if addon ~= "BigWigs_Plugins" then return end

        local bars = BigWigs:GetPlugin("Bars")
        bars.BigWigs_StartNameplateBar = function() end

        local infoBox = BigWigs:GetPlugin("InfoBox")
        infoBox.BigWigs_ShowInfoBox = function() end
    end)
end)
