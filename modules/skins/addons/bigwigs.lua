local addonName, ns = ...
local Z, E = ns.Z, ns.E
local S = Z:GetModule("Skins")

--[[
    Blizzard:
        GetPhysicalScreenSize
        UIParent

    BigWigs:
        BigWigs
        BigWigsAPI
        BigWigsAnchor
]]

local var = {
    bar = {
        height = 24,
        spacing = 10
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

                bar.candyBarBar:ClearAllPoints()
                bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", var.bar.height * 1.5 + 2, 0)
                bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
            end

            bar.candyBarDuration:ClearAllPoints()
            bar.candyBarDuration:SetPoint("TOPRIGHT", bar.candyBarBar, "TOPRIGHT", -6, 1)
            bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -6, 0)
            bar.candyBarDuration:SetJustifyH("CENTER")
            bar.candyBarDuration:SetJustifyV("MIDDLE")

            bar.candyBarLabel:ClearAllPoints()
            bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 6, 1)
            bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -6, 0)
            bar.candyBarLabel:SetJustifyH("LEFT")
            bar.candyBarLabel:SetJustifyV("MIDDLE")

            if bar.handled then return end

            local parent = CreateFrame("Frame", nil, bar)
            parent:SetPoint("TOPLEFT", 0, 0)
            parent:SetPoint("BOTTOMRIGHT", 0, 0)
            parent:SetFrameLevel(bar:GetFrameLevel() + 1)

            local border = E:CreateBorder(parent)
            border:SetTexture("Interface\\AddOns\\ls_UI\\assets\\border-thick")
            border:SetSize(16)
            border:SetOffset(-8)

            local inlay = E:CreateBorder(bar.candyBarBar, "OVERLAY", 6)
            inlay:SetTexture(Z.assetPath .. "unit-frame-inlay-right")
            inlay:SetAlpha(0.8)

            local sep = parent:CreateTexture(nil, "OVERLAY")
            sep:SetTexture(Z.assetPath ..  "statusbar-sep", "REPEAT", "REPEAT")
            sep:SetPoint("LEFT", icon, "RIGHT", -2, 0)
            sep:SetSize(12 / 2, var.bar.height)
            sep:SetTexCoord(1 / 16, 13 / 16, 0 / 8, var.bar.height / 4)
            sep:SetVertTile(true)
            sep:SetSnapToPixelGrid(false)
            sep:SetTexelSnappingBias(0)

            bar.handled = true
        end,
        GetStyleName = function() return "BitUI" end,
    })

    Z:RegisterEvent("ADDON_LOADED", function(addon)
        if addon ~= "BigWigs_Plugins" then return end

        -- disable
        local bars = BigWigs:GetPlugin("Bars")
        bars.BigWigs_StartNameplateBar = function() end

        -- disable
        local infoBox = BigWigs:GetPlugin("InfoBox")
        infoBox.BigWigs_ShowInfoBox = function() end

        -- pixel perfect anchor
        local anchor = BigWigsAnchor

        anchor.RefixPosition = function(self)
            local db = bars.db.profile

            self:ClearAllPoints()
            if db[self.x] and db[self.y] then
                self:SetPoint("TOPLEFT", UIParent, "TOPLEFT", db[self.x], db[self.y])
            else
                self:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 568, -506)
            end
            self:SetWidth(db[self.w] or bars.defaultDB[self.w])
            self:SetHeight(db[self.h] or bars.defaultDB[self.h])
        end

        anchor:SetScript("OnDragStop", function(self)
            local db = bars.db.profile

            self:StopMovingOrSizing()
            local s = self:GetEffectiveScale()
            db[self.x] = self:GetLeft()
            db[self.y] = self:GetTop() - select(2, GetPhysicalScreenSize())
            bars:UpdateGUI()
        end)
    end)
end)
