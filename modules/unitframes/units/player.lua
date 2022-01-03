local _, ns = ...
local Z, E = ns.Z, ns.E
local UF = Z:GetModule("UnitFrames")

--[[
    Blizzard:
        CreateFrame

    ls_UI:
        LSPlayerFrame
]]

function UF:Player()
    local frame = LSPlayerFrame
    if not frame then return end

    local power = frame.Power
    local addPower, classPower = frame.AdditionalPower, frame.ClassPower
    local top, bottom = frame.Insets.Top, frame.Insets.Bottom

    local size = 48
    local num = 6
    local height1 = 20
    local height2 = 10

    power:SetFrameStrata("MEDIUM")
    frame.TextParent:SetFrameStrata("MEDIUM")

    local resource = CreateFrame("Frame", "BitUIResourceFrame", UIParent)
    resource:SetPoint("BOTTOM", UIParent, "CENTER", 0, -300)
    resource:SetSize(size * num + 4 * (num - 1) - 2, height1)
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

    local function HandleBar(bar)
        local parent = CreateFrame("Frame", nil, bar)
        parent:SetPoint("TOP", resource, "TOP", 0, height2)
        parent:SetSize(resource:GetWidth() - 32, height2 + 8)

        local cpBorder = E:CreateBorder(parent, "OVERLAY", 6)
        cpBorder:SetTexture(Z.assetPath .. "border-thin")

        local glass = bar:CreateTexture(nil, "OVERLAY")
        glass:SetTexture("Interface\\AddOns\\ls_UI\\assets\\statusbar-glass")
        glass:SetAllPoints()

        local cpBg = bar:CreateTexture(nil, "BACKGROUND", nil, -7)
        cpBg:SetAllPoints(parent)
        cpBg:SetTexture("Interface\\HELPFRAME\\DarkSandstone-Tile", "REPEAT", "REPEAT")
        cpBg:SetHorizTile(true)
        cpBg:SetVertTile(true)

        bar:ClearAllPoints()
        bar:SetPoint("TOPLEFT", parent, "TOPLEFT")
        bar:SetPoint("TOPRIGHT", parent, "TOPRIGHT")
        bar:SetHeight(height2)

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
