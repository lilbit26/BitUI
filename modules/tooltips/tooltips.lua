local _, ns = ...
local Z, E = ns.Z, ns.E
local T = Z:AddModule("Tooltips")

--[[
    Blizzard:
        GetGuildInfo
        IsShiftKeyDown
        UnitIsPlayer

        GameTooltip
        GameTooltipStatusBar
        GameTooltipTextLeft2
]]

function T:Load()
    GameTooltip.NineSlice:SetBorderColor(0, 0, 0, 0)

    local border = E:CreateBorder(GameTooltip.NineSlice)
    border:SetTexture(Z.assetPath .. "border-thin")
    border:SetSize(16)
    border:SetOffset(-13)

    hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip)
        tooltip:ClearAllPoints()
        tooltip:SetPoint("BOTTOMRIGHT", _G["LSTooltipAnchor"], "BOTTOMRIGHT", -5, -5)
    end)

    GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip)
        if tooltip:IsForbidden() then return end

        local _, unit = tooltip:GetUnit()
        if unit and UnitIsPlayer(unit) then
            local guildName, guildRankName = GetGuildInfo(unit)
            if guildName then
                if IsShiftKeyDown() then
                    if guildRankName then
                        guildName = string.format("%s|cff888987 [%s]|r", guildName, guildRankName)
                    end
                end

                GameTooltipTextLeft2:SetText(guildName)
            end
        end
    end)

    E:ForceHide(GameTooltipStatusBar)
    GameTooltipStatusBar:SetScript("OnShow", nil)
    GameTooltipStatusBar:SetScript("OnValueChanged", nil)
end
