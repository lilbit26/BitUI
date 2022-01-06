local _, ns = ...
local Z = ns.Z
local B = Z:GetModule("Blizzard")

--[[
    Blizzard:
        ChatBubbleFont
]]

local var = {
    chatBubble = {
        size = 10
    }
}

function B:Fonts()
    -- chat bubble
    Z:HandleFont(ChatBubbleFont, nil, var.chatBubble.size)
end
