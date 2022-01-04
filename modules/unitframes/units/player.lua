local _, ns = ...
local Z, E = ns.Z, ns.E
local UF = Z:GetModule("UnitFrames")

--[[
    Blizzard:
        CreateFrame

    ls_UI:
        LSPlayerFrame
]]

local var = {
    resource = {
        name = "BitUIResourceFrame",
        width = 48 * 6 + 4 * 5 - 2,
        height = 20
    },
    classPower = {
        height = 10
    }
}

local function HandleBar(bar)
    local resource = _G[var.resource.name]
    local top = bar.__owner.Insets.Top

    local parent = CreateFrame("Frame", nil, bar)
    parent:SetPoint("TOP", resource, "TOP", 0, var.classPower.height)
    parent:SetSize(resource:GetWidth() - 32, var.classPower.height + 8)

    local border = E:CreateBorder(parent, "OVERLAY", 6)
    border:SetTexture(Z.assetPath .. "border-thin")

    local glass = bar:CreateTexture(nil, "OVERLAY")
    glass:SetTexture(Z.assetPath .. "statusbar-glass")
    glass:SetAllPoints()

    local bg = bar:CreateTexture(nil, "BACKGROUND", nil, -7)
    bg:SetAllPoints(parent)
    bg:SetTexture("Interface\\HELPFRAME\\DarkSandstone-Tile", "REPEAT", "REPEAT")
    bg:SetHorizTile(true)
    bg:SetVertTile(true)

    bar:ClearAllPoints()
    bar:SetPoint("TOPLEFT", parent, "TOPLEFT")
    bar:SetPoint("TOPRIGHT", parent, "TOPRIGHT")
    bar:SetHeight(var.classPower.height)

    hooksecurefunc(bar, "Hide", function()
        top:Collapse()
    end)
    hooksecurefunc(bar, "Show", function()
        top:Collapse()
    end)
    hooksecurefunc(bar, "SetShown", function()
        top:Collapse()
    end)
end

function UF:Player()
    local frame = LSPlayerFrame
    if not frame then return end

    local power = frame.Power
    local addPower, classPower = frame.AdditionalPower, frame.ClassPower
    local top, bottom = frame.Insets.Top, frame.Insets.Bottom

    power:SetFrameStrata("MEDIUM")
    frame.TextParent:SetFrameStrata("MEDIUM")

    local resource = CreateFrame("Frame", var.resource.name, UIParent)
    resource:SetPoint("BOTTOM", UIParent, "CENTER", 0, -300)
    resource:SetSize(var.resource.width, var.resource.height)
    resource:SetFrameLevel(frame:GetFrameLevel() + 7)

    local border = E:CreateBorder(resource, "OVERLAY", 6)
    border:SetTexture(Z.assetPath .. "border-thick")

    local inlay = E:CreateBorder(resource, "OVERLAY", 6)
    inlay:SetTexture(Z.assetPath .. "unit-frame-inlay-both")
    inlay:SetAlpha(0.8)

    local bg = power:CreateTexture(nil, "BACKGROUND", nil, -7)
    bg:SetAllPoints()
    bg:SetTexture("Interface\\HELPFRAME\\DarkSandstone-Tile", "REPEAT", "REPEAT")
    bg:SetHorizTile(true)
    bg:SetVertTile(true)

    power:ClearAllPoints()
    power:SetAllPoints(resource)

    hooksecurefunc(addPower, "PostUpdate", function(_, cur, max)
        if cur == max then
            addPower:Hide()
        else
            addPower:Show()
        end
    end)

    HandleBar(addPower)
    HandleBar(classPower)

    if E.PLAYER_CLASS == "MONK" then
        HandleBar(frame.Stagger)
    elseif E.PLAYER_CLASS == "DEATHKNIGHT" then
        HandleBar(frame.Runes)
    end

    top:Collapse()
    bottom:Collapse()

    self:Castbar(frame)
end
