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

local function OnSizeChanged(self, _, h)
    local border, cut = self.border, self.cut

    if cut then
        border[cut]:Hide()
        border[cut .. "LEFT"]:Hide()
        border[cut .. "RIGHT"]:Hide()

        local tile = (h - 8) / 16
        if tile > 0 then
            border.LEFT:SetTexCoord(0, 0.125, 0, tile)
            border.RIGHT:SetTexCoord(0.125, 0.25, 0, tile)

            border.LEFT:SetPoint(cut .. "LEFT", self, -8, 0)
            border.RIGHT:SetPoint(cut .. "RIGHT", self, 8, 0)
        else
            border.LEFT:Hide()
            border.RIGHT:Hide()
        end
    else
        local offset = (16 - h) / 2
        if offset < 0 then return end

        border.TOPLEFT:SetSize(16, 16 - offset)
        border.TOPRIGHT:SetSize(16, 16 - offset)
        border.BOTTOMLEFT:SetSize(16, 16 - offset)
        border.BOTTOMLEFT:SetSize(16, 16 - offset)

        border.TOPLEFT:SetTexCoord(0.5, 0.625, 0, 16 - offset / 16)
        border.TOPRIGHT:SetTexCoord(0.625, 0.75, 0, 16 - offset / 16)
        border.BOTTOMLEFT:SetTexCoord(0.75, 0.875, offset / 16, 1)
        border.BOTTOMRIGHT:SetTexCoord(0.875, 1, offset / 16, 1)

        border.LEFT:Hide()
        border.RIGHT:Hide()
    end
end

function Z:HandleStatusBar(object, flag, cut)
    if object.Tube then
        for i = 1, 4 do
            E:ForceHide(object.Tube[i])
        end

        if flag == "thick" then
            local inlay = E:CreateBorder(object, "OVERLAY")
            inlay:SetTexture(Z.assetPath .. "unit-frame-inlay-both")
            inlay:SetAlpha(0.8)

            E:ForceHide(object.Tube[5])
        end
    else
        local glass = object:CreateTexture(nil, "OVERLAY")
        glass:SetTexture(Z.assetPath .. "statusbar-glass")
        glass:SetAllPoints()
    end

    local border = object.border
    if not border then
        border = E:CreateBorder(object)
        border:SetTexture(Z.assetPath .. "border-" .. flag)
        border:SetSize(16)
        border:SetOffset(-8)

        object.border = border
    end

    object.cut = cut
    OnSizeChanged(object, object:GetWidth(), object:GetHeight())
    object:HookScript("OnSizeChanged", OnSizeChanged)
end
