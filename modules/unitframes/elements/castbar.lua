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
    if self.handled then return end

    if self._config.detached then
        local parent = self.TexParent
        parent.border:SetTexture(Z.assetPath .. "border-thick")

        E:ForceHide(parent.Tube[5])
    else
        local holder = self.Holder
        local frame = self.__owner
        local parent = self.borderParent
        local height = self._config.height

        parent:SetPoint("BOTTOM", frame, "BOTTOM", 0, -(height + 2))
        parent:SetSize(frame:GetWidth() - 16, height + 8)

        holder:ClearAllPoints()
        holder:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 0, 0)
        holder:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)

        holder:SetHeight(height)
    end

    self.handled = true
end

function UF:Castbar(frame)
    local castbar = frame.Castbar
    local holder = castbar.Holder

    castbar.TexParent:ClearAllPoints()
    castbar.TexParent:SetAllPoints(holder)

    UpdateIcon_Hook(castbar)
    hooksecurefunc(castbar, "UpdateIcon", UpdateIcon_Hook)

    if castbar._config.detached then
        local time, text = castbar.Time, castbar.Text

        time:SetPoint("RIGHT", castbar, "RIGHT", -4, 0)
        text:SetPoint("LEFT", castbar, "LEFT", 4, 0)

        local inlay = E:CreateBorder(self, "OVERLAY", 6)
        inlay:SetTexture(Z.assetPath .. "unit-frame-inlay-right")
        inlay:SetAlpha(0.8)
    else
        frame:SetFrameStrata("MEDIUM")
        castbar:SetFrameStrata("LOW")

        if frame.unit == "player" and frame.ClassPower then
            frame.ClassPower:SetFrameStrata("LOW")
        end

        castbar.Text:SetJustifyV("BOTTOM")
        castbar.Time:SetJustifyV("BOTTOM")

        local parent = CreateFrame("Frame", nil, castbar)
        castbar.borderParent = parent

        local border = E:CreateBorder(parent, "OVERLAY", 6)
        border:SetTexture(Z.assetPath .. "border-thin")

        castbar.TexParent.border:Hide()

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
    end

    UpdateSize_Hook(castbar)
    hooksecurefunc(castbar, "UpdateSize", UpdateSize_Hook)
end
