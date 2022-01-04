local _, ns = ...
local Z, E = ns.Z, ns.E

--[[
    Blizzard:
        CreateFrame
]]

-- cooldown
hooksecurefunc(E.Cooldowns, "Handle", function(cooldown)
    local timer = cooldown.Timer

    timer:ClearAllPoints()
    timer:SetPoint("TOPLEFT", -7, 0)
    timer:SetPoint("BOTTOMRIGHT", 9, 0)
end)

-- statusbar
hooksecurefunc(E, "SetStatusBarSkin", function(_, object, flag)
    for i = 1, 4 do
        E:ForceHide(object.Tube[i])
    end

    if not object.border then
        local border = E:CreateBorder(object)
        border:SetTexture(Z.assetPath .. "border-thin")
        border:SetSize(16)
        border:SetOffset(-8)

        object.border = border
    end
end)

-- utils
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
