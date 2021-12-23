local _, ns = ...
local Z, E = ns.Z, ns.E
local S = Z:GetModule("Skins")

--[[
    Blizzard:
        UIParent

    Details:
        Details
]]

S:AddSkin("Details", function()
    local instance = Details:GetInstance(1)
    if instance.handled then return end

    local x = -20
    local y = 20
    local winWidth = 300
    local barHeight = 22
    local barNum = 7

    local base = instance.baseframe

    base:ClearAllPoints()
    base:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", x, y)
    instance:SetSize(winWidth, barHeight * barNum)
    instance:SaveMainWindowPosition()
    instance:RestoreMainWindowPosition()
    instance:LockInstance(true)

    local border = E:CreateBorder(base) -- TODO: sub layer
    border:SetTexture(Z.assetPath .. "border-thick")
    border:SetSize(16)
    border:SetOffset(-8)

    -- TODO: bg


    -- TODO: handle bars (gump:CreateNewLine)

    instance.handled = true
end)
