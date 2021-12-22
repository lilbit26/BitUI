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
    GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip)
        if tooltip:IsForbidden() then return end

        local unit = tooltip:GetUnit()
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
