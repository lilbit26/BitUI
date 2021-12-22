local _, ns = ...
local Z, E = ns.Z, ns.E
local B = Z:GetModule("Blizzard")

--[[
    Blizzard:
        ChatFrame1EditBoxLanguage
]]

function B:Chat()
    -- edit box language
    E:ForceHide(ChatFrame1EditBoxLanguage)
end
