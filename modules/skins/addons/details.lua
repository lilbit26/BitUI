local _, ns = ...
local Z, E = ns.Z, ns.E
local S = Z:GetModule("Skins")

--[[
    Blizzard:
        hooksecurefunc

        UIParent

    Details:
        Details
]]

local var = {
    window = {
        width = 300,
        position = {
            point = "BOTTOMRIGHT",
            rPoint = "BOTTOMRIGHT",
            x = -20,
            y = 20
        }
    },
    statusbar = {
        height = 22,
        count = 7,
        text = {
            size = 12
        }
    }
}

local function HandleStatusBar(bar)
    if bar.handled then return end

    local parent = CreateFrame("Frame", nil, bar)
    parent:SetFrameStrata("TOOLTIP")
    parent:SetFrameLevel(20)

    local glass = parent:CreateTexture(nil, "OVERLAY")
    glass:SetTexture("Interface\\AddOns\\ls_UI\\assets\\statusbar-glass")
    glass:SetPoint("TOPLEFT", bar, "TOPLEFT", -bar:GetHeight(), 0)
    glass:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)

    local sep = parent:CreateTexture(nil, "OVERLAY")
    sep:SetTexture("Interface\\AddOns\\ls_UI\\assets\\statusbar-sep", "REPEAT", "REPEAT")
    sep:SetTexCoord(1 / 16, 13 / 16, 0 / 8, bar:GetHeight() / 4)
    sep:SetSize(12 / 2, bar:GetHeight())
    sep:SetVertTile(true)
    sep:SetPoint("LEFT", bar, "LEFT", -3, 0)
    sep:SetSnapToPixelGrid(false)
    sep:SetTexelSnappingBias(0)

    local left = parent:CreateTexture(nil, "OVERLAY", nil, 7)
    left:SetTexture("Interface\\AddOns\\ls_UI\\assets\\border-thick-sep")
    left:SetTexCoord(0.421875, 0.53125, 0.609375, 0.53125, 0.421875, 0.03125, 0.609375, 0.03125)
    left:SetSize(16 / 2, 12 / 2)
    left:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -bar:GetHeight(), -4)
    left:SetSnapToPixelGrid(false)
    left:SetTexelSnappingBias(0)
    E:SmoothColor(left)

    local right = parent:CreateTexture(nil, "OVERLAY", nil, 7)
    right:SetTexture("Interface\\AddOns\\ls_UI\\assets\\border-thick-sep")
    right:SetTexCoord(0.21875, 0.53125, 0.40625, 0.53125, 0.21875, 0.03125, 0.40625, 0.03125)
    right:SetSize(16 / 2, 12 / 2)
    right:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, -4)
    right:SetSnapToPixelGrid(false)
    right:SetTexelSnappingBias(0)
    E:SmoothColor(right)

    local mid = parent:CreateTexture(nil, "OVERLAY", nil, 7)
    mid:SetTexture("Interface\\AddOns\\ls_UI\\assets\\border-thick-sep", "REPEAT", "REPEAT")
    mid:SetTexCoord(0.015625, 1, 0.203125, 1, 0.015625, 0, 0.203125, 0)
    mid:SetPoint("TOPLEFT", left, "TOPRIGHT", 0, 0)
    mid:SetPoint("BOTTOMRIGHT", right, "BOTTOMLEFT", 0, 0)
    mid:SetSnapToPixelGrid(false)
    mid:SetTexelSnappingBias(0)
    E:SmoothColor(mid)

    bar.sep = {left, right, mid}

    bar.handled = true
end

S:AddSkin("Details", function()
    local instance = Details:GetInstance(1)
    if not instance then return end

    local base = instance.baseframe

    base:ClearAllPoints()
    base:SetPoint(
        var.window.position.point,
        UIParent,
        var.window.position.rPoint,
        var.window.position.x,
        var.window.position.y
    )
    instance:SetSize(var.window.width, var.statusbar.height * var.statusbar.count)
    instance:SaveMainWindowPosition()
    instance:RestoreMainWindowPosition()
    instance:LockInstance(true)

    local parent = CreateFrame("Frame", nil, UIParent)
    parent:SetAllPoints(base)
    parent:SetFrameStrata("HIGH")

    local border = E:CreateBorder(parent)
    border:SetTexture(Z.assetPath .. "border-thick")
    border:SetSize(16)
    border:SetOffset(-8)

    local bg = base:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture("Interface\\HELPFRAME\\DarkSandstone-Tile", "REPEAT", "REPEAT")
    bg:SetHorizTile(true)
    bg:SetVertTile(true)

    for i = 1, var.statusbar.count do
        local bar = _G["DetailsBarra_Statusbar_" .. 1 .. "_" .. i]
        HandleStatusBar(bar)

        if i == var.statusbar.count then
            for _, tex in pairs(bar.sep) do
                tex:Hide()
            end
        end
    end

    local func = Details.gump.CreateNewLine
    Details.gump.CreateNewLine = function(gump, instancia, index)
        local row = func(gump, instancia, index)

        HandleStatusBar(row.statusbar)

        return row
    end

    local stretch = base.button_stretch
    stretch:HookScript("OnMouseDown", function(_, button)
        if button ~= "LeftButton" then return end

        parent:SetFrameStrata("TOOLTIP")
        parent:SetFrameLevel(20)

        local bar = _G["DetailsBarra_Statusbar_1_" .. var.statusbar.count]
        for _, tex in pairs(bar.sep) do
            tex:Show()
        end
    end)

    stretch:HookScript("OnMouseUp", function(_, button)
        if button ~= "LeftButton" then return end

        parent:SetFrameStrata("HIGH")
        parent:SetFrameLevel(0)

        local bar = _G["DetailsBarra_Statusbar_1_" .. var.statusbar.count]
        for _, tex in pairs(bar.sep) do
            tex:Hide()
        end
    end)

    instance:InstanceColor(0, 0, 0, 0, false, true)
    instance:SetBarSettings(var.statusbar.height, "LS", true, nil, "Solid", false, {0, 0, 0, 0}, 1, nil, true, 0)
    instance:SetBarTextSettings(var.statusbar.text.size, nil, {1, 1, 1}, false, false, false, false, false, nil, 1, false)
    instance:SetBarFollowPlayer(true)
end)
