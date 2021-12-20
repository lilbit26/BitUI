local _, ns = ...
local Z = ns.Z
local B = Z:GetModule("Blizzard")

--[[
    Blizzard:
        ChatFrame1EditBoxLanguage
]]

function B:Chat()
    -- edit box language
    Z:Hide(ChatFrame1EditBoxLanguage)
end
