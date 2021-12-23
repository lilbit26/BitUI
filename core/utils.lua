local _, ns = ...
local Z = ns.Z

--[[
    Blizzard:
        CreateFrame
]]

function Z:HandleFont(object, font, size, flag, shadow)
    local f, s = object:GetFont()

    f = font or f
    s = size or s

    if flag then
        object:SetFont(f, s, flag)
    else
        object:SetFont(f, s, "")
    end

    if shadow == false then
        object:SetShadowOffset(0, 0, 0, 0)
        object:SetShadowOffset(0, 0)
    else
        object:SetShadowColor(0, 0, 0, 1)
        object:SetShadowOffset(1, -1)
    end
end
