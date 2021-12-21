local _, ns = ...
local Z = ns.Z
local M = Z:GetModule("Misc")

--[[
    Blizzard:
        C_Timer
        CreateFrame
        GetCursorPosition
        GetScaledCursorPosition
        Lerp

        UIParent
]]

-- from FreeUI by Solor

local pollingRate, numLines = 0.01, 45
local lines = {}
for i = 1, numLines do
    local line = UIParent:CreateLine()
    line:SetThickness(Lerp(5, 1, (i - 1) / numLines))
    line:SetColorTexture(1, 1, 1)

    local startA, endA = Lerp(1, 0, (i - 1) / numLines), Lerp(1, 0, i / numLines)
    line:SetGradientAlpha('HORIZONTAL', 1, 1, 1, startA, 1, 1, 1, endA)

    lines[i] = {line = line, x = 0, y = 0}
end

local function GetLength(startX, startY, endX, endY)
    local dx, dy = endX - startX, endY - startY

    if dx < 0 then
        dx, dy = -dx, -dy
    end

    return math.sqrt((dx * dx) + (dy * dy))
end

local function UpdateTrail()
    local startX, startY = GetScaledCursorPosition()

    for i = 1, numLines do
        local info = lines[i]

        local endX, endY = info.x, info.y
        if GetLength(startX, startY, endX, endY) < 0.1 then
            info.line:Hide()
        else
            info.line:Show()
            info.line:SetStartPoint('BOTTOMLEFT', UIParent, startX, startY)
            info.line:SetEndPoint('BOTTOMLEFT', UIParent, endX, endY)
        end

        info.x, info.y = startX, startY
        startX, startY = endX, endY
    end
end

local function AddTrail()
    C_Timer.NewTicker(pollingRate, UpdateTrail)
end

local x = 0
local y = 0
local speed = 0

local function UpdateGlow(self, elapsed)
    local dX = x
    local dY = y
    x, y = GetCursorPosition()
    dX = x - dX
    dY = y - dY
    local weight = 2048 ^ -elapsed
    speed = math.min(weight * speed + (1 - weight) * math.sqrt(dX * dX + dY * dY) / elapsed, 1024)
    local size = speed / 6 - 16
    if (size > 0) then
        local scale = UIParent:GetEffectiveScale()
        self.texture:SetHeight(size)
        self.texture:SetWidth(size)
        self.texture:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale)
        self.texture:Show()
    else
        self.texture:Hide()
    end
end

local function AddGlow()
    local frame = CreateFrame('Frame', nil, UIParent)
    frame:SetFrameStrata('TOOLTIP')

    local texture = frame:CreateTexture()
    texture:SetTexture([[Interface\Cooldown\star4]])
    texture:SetBlendMode('ADD')
    texture:SetAlpha(0.5)
    frame.texture = texture

    frame:SetScript('OnUpdate', UpdateGlow)
end

function M:Cursor()
    AddTrail()
    AddGlow()
end
