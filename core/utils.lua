local _, ns = ...
local Z, E = ns.Z, ns.E

--[[
    Blizzard:
        CreateFrame
]]

E.FormatNumber = function(_, v)
	if v >= 1E6 then
		return string.format("%.2fM", v / 1E6)
	elseif v >= 1E3 then
		return string.format("%.1fK", v / 1E3)
	else
		return v
	end
end

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
