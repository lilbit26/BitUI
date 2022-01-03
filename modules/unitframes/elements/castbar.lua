local _, ns = ...
local Z, E = ns.Z, ns.E
local UF = Z:GetModule("UnitFrames")

--[[
    Blizzard:
        hooksecurefunc

        CreateFrame
]]

function UF:Castbar(frame)
    local castbar = frame.Castbar
    local holder = castbar.Holder

    castbar.TexParent:ClearAllPoints()
    castbar.TexParent:SetAllPoints(holder)

    hooksecurefunc(castbar, "UpdateIcon", function()
        if castbar.Icon then
            castbar.Icon:SetPoint("TOPLEFT", holder, "TOPLEFT", 0, 0)
            castbar:SetPoint("TOPLEFT", 2 + castbar._config.height * 1.5, 0)
            castbar:SetPoint("BOTTOMRIGHT", 0, 0)
        else
            castbar:SetAllPoints()
        end
    end)
    castbar:UpdateIcon()

    if castbar._config.detached then
        local time, text = castbar.Time, castbar.Text

        time:SetPoint("RIGHT", castbar, "RIGHT", -4, 0)
        text:SetPoint("LEFT", castbar, "LEFT", 4, 0)

        hooksecurefunc(castbar, "UpdateSize", function()
            if castbar.handled then return end

            local parent = castbar.TexParent
            parent.border:SetTexture(Z.assetPath .. "border-thick")

            local inlay = E:CreateBorder(castbar, "OVERLAY", 6)
            inlay:SetTexture(Z.assetPath .. "unit-frame-inlay-right")
            inlay:SetAlpha(0.8)

            E:ForceHide(parent.Tube[5])

            castbar.handled = true
        end)
        castbar:UpdateSize()
    else
        frame:SetFrameStrata("MEDIUM")
        castbar:SetFrameStrata("LOW")

        if frame.unit == "player" and frame.ClassPower then
            frame.ClassPower:SetFrameStrata("LOW")
        end

        castbar.Text:SetJustifyV("BOTTOM")
        castbar.Time:SetJustifyV("BOTTOM")

        local parent = CreateFrame("Frame", nil, castbar)

        local border = E:CreateBorder(parent, "OVERLAY", 6)
        border:SetTexture(Z.assetPath .. "border-thin")

        castbar.TexParent.border:Hide()

        hooksecurefunc(castbar, "UpdateSize", function()
            local height = castbar._config.height

            parent:SetPoint("BOTTOM", frame, "BOTTOM", 0, -(height + 2))
            parent:SetSize(frame:GetWidth() - 16, height + 8)

            holder:ClearAllPoints()
            holder:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 0, 0)
            holder:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)

            holder:SetHeight(height)
        end)
        castbar:UpdateSize()

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
end
