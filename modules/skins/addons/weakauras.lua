local _, ns = ...
local Z, E = ns.Z, ns.E
local S = Z:GetModule("Skins")

--[[
    Blizzard:
        hooksecurefunc

    WeakAuras:
        WeakAuras
]]

-- from NDui by siweia
local function UpdateTexCoord(icon)
    if icon.handling then return end
    icon.handling = true

    local width, height = icon:GetSize()
    if width > 0 and height > 0 then
        local l, r, t, b = unpack(Z.iconCoords)
        local ratio = width / height

        if ratio > 1 then
            local offset = (1 - 1 / ratio) / 2
            t = t + offset
            b = b - offset
        elseif ratio < 1 then
            local offset = (1 - ratio) / 2
            l = l + offset
            r = r - offset
        end

        icon:SetTexCoord(l, r, t, b)
    end

    icon.handling = nil
end

local function Icon(region)
    if region.handled then return end

    UpdateTexCoord(region.icon)
    hooksecurefunc(region.icon, "SetTexCoord", UpdateTexCoord)

    local border, glow = region.border, region.border

    if not border then
        border = E:CreateBorder(region)
        border:SetTexture("Interface\\AddOns\\ls_UI\\assets\\border-thin")
        border:SetSize(16)
        border:SetOffset(-8)
    end

    if not glow then
        glow = region:CreateTexture(nil, "OVERLAY") -- TODO: sub layer
        glow:SetAtlas("bags-newitem")
        glow:SetPoint("TOPLEFT", -8, 8)
        glow:SetPoint("BOTTOMRIGHT", 8, -8)
        glow:SetAlpha(0.5)
        glow:Hide()

        local anim = glow:CreateAnimationGroup()
        anim:SetLooping("REPEAT")

        local animIn = anim:CreateAnimation("Alpha")
        animIn:SetDuration(0.25)
        animIn:SetOrder(1)
        animIn:SetFromAlpha(0.5)
        animIn:SetToAlpha(1)
        animIn:SetSmoothing("IN")

        local animOut = anim:CreateAnimation("Alpha")
        animOut:SetDuration(0.25)
        animOut:SetOrder(2)
        animOut:SetFromAlpha(1)
        animOut:SetToAlpha(0.5)
        animOut:SetSmoothing("OUT")

        glow.anim = anim
    end

    local cooldown = region.cooldown
    E.Cooldowns.Handle(cooldown)

    -- TODO: size and position
    local size = region:GetSize()
    size = E:Round(12 / 32 * size)
    cooldown.config.text.size = size
    cooldown:UpdateFont()

    region.handled = true
end

local function AuraBar(region)
    if region.handled then return end

    region.handled = true
end

S:AddSkin("WeakAuras", function()
    local icon = WeakAuras.regionTypes.icon
    local aurabar = WeakAuras.regionTypes.aurabar

    local CreateIcon, ModifyIcon = icon.create, icon.modify
    local CreateAurabar, ModifyAurabar = aurabar.create, aurabar.modify

    icon.create = function(parent)
        local region = CreateIcon(parent)
        Icon(region)
        return region
    end

    icon.modify = function(parent)
        local region = ModifyIcon(parent)
        Icon(region)
        return region
    end

    aurabar.create = function(parent)
        local region = CreateAurabar(parent)
        AuraBar(region)
        return region
    end

    aurabar.modify = function(parent)
        local region = ModifyAurabar(parent)
        AuraBar(region)
        return region
    end

end)
