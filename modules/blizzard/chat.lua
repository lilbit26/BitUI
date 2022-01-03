local _, ns = ...
local Z, E = ns.Z, ns.E
local B = Z:GetModule("Blizzard")

--[[
    Blizzard:
        ChatFrame1EditBox
        ChatFrame1EditBoxLanguage
]]

function B:Chat()
    ChatFrame1EditBox:SetAltArrowKeyMode(false)

    -- edit box language
    E:ForceHide(ChatFrame1EditBoxLanguage)
end
