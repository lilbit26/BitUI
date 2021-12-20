local _, ns = ...
local Z = ns.Z
local M = Z:AddModule("Misc")

--[[
    Blizzard:
        StaticPopupDialogs

        DELETE_ITEM_CONFIRM_STRING
]]

function M:Delete()
    hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"], "OnShow", function(arg1)
        arg1.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
    end)
end

function M:Load()
    self:Cursor()
    self:Delete()
end
