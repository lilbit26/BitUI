local _, ns = ...
local Z = ns.Z
local B = Z:GetModule("Blizzard")

--[[
    Blizzard:
        ChatBubbleFont
]]

function B:Fonts()
    -- chat bubble
    Z:HandleFont(ChatBubbleFont, nil, 10)
end
