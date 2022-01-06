local _, ns = ...
local Z, E = ns.Z, ns.E
local UF = Z:GetModule("UnitFrames")

--[[
    Blizzard:
        hooksecurefunc

        CreateFrame
]]

local function UpdateIcon_Hook(self)
    local holder = self.Holder

    if self.Icon then
        self.Icon:SetPoint("TOPLEFT", holder, "TOPLEFT", 0, 0)
        self:SetPoint("TOPLEFT", 2 + self._config.height * 1.5, 0)
        self:SetPoint("BOTTOMRIGHT", 0, 0)
    else
        self:SetAllPoints()
    end
end

local function UpdateSize_Hook(self)
    if self._config.detached then return end

    local holder = self.Holder
    local frame = self.__owner
    local height = self._config.height

    holder:ClearAllPoints()
    holder:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 16, -height - 2)
    holder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -16, -height - 2)

    holder:SetHeight(height)
end

function UF:Castbar(frame)
    local castbar = frame.Castbar
    local holder, parent = castbar.Holder, castbar.TexParent

    parent:ClearAllPoints()
    parent:SetAllPoints(holder)

    UpdateIcon_Hook(castbar)
    hooksecurefunc(castbar, "UpdateIcon", UpdateIcon_Hook)

    if castbar._config.detached then
        local time, text = castbar.Time, castbar.Text

        time:ClearAllPoints()
        time:SetPoint("TOPLEFT", castbar, "TOPLEFT", 6, 1)
        time:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", -6, 0)
        time:SetJustifyH("RIGHT")
        time:SetJustifyV("MIDDLE")

        text:ClearAllPoints()
        text:SetPoint("TOPLEFT", castbar, "TOPLEFT", 6, 1)
        text:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", -6, 0)
        text:SetJustifyH("LEFT")
        text:SetJustifyV("MIDDLE")

        local inlay = E:CreateBorder(castbar, "OVERLAY", 6)
        inlay:SetTexture(Z.assetPath .. "unit-frame-inlay-right")
        inlay:SetAlpha(0.8)

        parent.Border:SetTexture(Z.assetPath .. "border-thick")
        E:ForceHide(parent.Tube[5])
    else
        local name = frame.Name

        if name then
            local p, rT, rP, x, y = name:GetPoint()

            if frame.Castbar:IsShown() then
                name:ClearAllPoints()
                name:SetPoint(p, holder, rP, 0, -4)
            end

            hooksecurefunc(frame.Castbar, "Show", function()
                name:ClearAllPoints()
                name:SetPoint(p, holder, rP, 0, -4)
            end)

            hooksecurefunc(frame.Castbar, "Hide", function()
                name:ClearAllPoints()
                name:SetPoint(p, rT, rP, x, y)
            end)
        end

        Z:CutStatusBar(parent, "TOP")
    end

    UpdateSize_Hook(castbar)
    hooksecurefunc(castbar, "UpdateSize", UpdateSize_Hook)
end
