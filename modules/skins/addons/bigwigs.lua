local addonName, ns = ...
local Z, E = ns.Z, ns.E

--[[
    BigWigs:
        BigWigsAPI
]]

Z:HookAddOn("BigWigs", function()
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

            E:SetStatusBarSkin(bar, "HORIZONTAL-")

            local sep = bar:CreateTexture(nil, "OVERLAY")
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
        GetStyleName = function() return "ls_UI style bar skin" end,
    })
end)
