local addonName, ns = ...
local Z, E = ns.Z, ns.E
local S = Z:GetModule("Skins")

--[[
    BigWigs:
        BigWigs
        BigWigsAPI
]]

S:AddSkin("BigWigs", function()
    BigWigsAPI:RegisterBarStyle(addonName, {
        apiVersion = 1,
        version = 1,
        barSpacing = 6,
        barHeight = 20,
        fontSizeNormal = 12,
        -- fontSizeEmphasized = 13,
        fontOutline = "NONE",
        ApplyStyle = function(bar)
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
            sep:SetTexCoord(1 / 16, 13 / 16, 0 / 8, bar:GetHeight() / 4)
            sep:SetSize(12 / 2, bar:GetHeight())
            sep:SetVertTile(true)
            sep:SetPoint("LEFT", bar.candyBarIconFrame, "RIGHT", -2, 0)
            sep:SetSnapToPixelGrid(false)
            sep:SetTexelSnappingBias(0)

            bar.handled = true
        end,
        -- BarStopped = function(bar) end,
        GetStyleName = function() return "BitUI" end,
    })

    -- disable nameplate bars
    Z:RegisterEvent("ADDON_LOADED", function(addon)
        if addon ~= "BigWigs_Plugins" then return end

        local plugin = BigWigs:GetPlugin("Bars")
        plugin.BigWigs_StartNameplateBar = function() end
    end)
end)
