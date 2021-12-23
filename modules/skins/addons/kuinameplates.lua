local _, ns = ...
local Z, E = ns.Z, ns.E
local S = Z:GetModule("Skins")

--[[
    Blizzard:
        hooksecurefunc

        CreateFrame
        UnitGUID
        UnitIsUnit
        UnitName

    Libraries:
        LibStub

    Kui_Nameplates:
        KuiNameplates
        KuiNameplatesCore
]]

S:AddSkin("Kui_Nameplates", function()
    local addon = KuiNameplates
    local core = KuiNameplatesCore
    local profile = core.profile

    local plugin = addon:NewPlugin("BitUI", 101, 5)
    if not plugin then return end

    function plugin:Create(frame)
        local health, bg = frame.HealthBar, frame.bg

        health:ClearAllPoints()
        health:SetAllPoints(bg)

        local backgound = frame:CreateTexture(nil, "BACKGROUND")
        backgound:SetTexture("Interface\\BUTTONS\\WHITE8X8")
        backgound:SetVertexColor(0, 0, 0, 1)
        backgound:SetPoint("TOPLEFT", bg, "TOPLEFT", -2, 2)
        backgound:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", 2, -2)
        frame.backgound = backgound

        local glass = frame:CreateTexture(nil, "OVERLAY", nil, 7)
        glass:SetTexture(Z.assetPath .. "statusbar-glass")
        glass:SetAllPoints(health)

        -- TODO: if frame.NameText then do ?
        hooksecurefunc(frame, "UpdateNameTextPosition", function()
            if frame.IN_NAMEONLY then return end

            local text = frame.NameText
            text:ClearAllPoints()
            text:SetPoint("BOTTOM", bg, "TOP", 1, profile.name_vertical_offset)
            text:SetJustifyH("CENTER")
            text:SetJustifyV("BOTTOM")
        end)
        frame:UpdateNameTextPosition()

        -- TODO: if frame.SpellName then do ?
        hooksecurefunc(frame, "UpdateSpellNamePosition", function()
            local text = frame.SpellName
            text:ClearAllPoints()
            text:SetJustifyH("CENTER")
            text:SetJustifyV("CENTER")
            text:SetPoint("CENTER", frame.CastBar, "CENTER", 1, profile.castbar_name_vertical_offset)
        end)
        frame:UpdateSpellNamePosition()

        local target = frame.TargetName
        if not target then
            target = frame:CreateFontString(nil, "OVERLAY")
            target:SetPoint("TOP", bg, "BOTTOM", 1, -profile.name_vertical_offset)
            target:SetJustifyH("CENTER")
            target:SetJustifyV("TOP")
        end
    end

    function plugin:Show(frame)
        if frame.IN_NAMEONLY then
            frame.background:Hide()
            frame.TargetName:Hide()
        else
            local name, target = frame.NameText, frame.TargetName
            local font, size = name:GetFont()

            Z:HandleFont(target, font, size)

            frame.state.target_guid = UnitGUID(frame.unit .. "target")
            self:TargetChanged(frame)
        end
    end

    function plugin:Hide(frame)
        frame.TargetName:Hide()
    end

    function plugin:GainedTarget(frame)
        frame.backgound:SetVertexColor(1, 1, 1, 1)
    end

    function plugin:LostTarget(frame)
        frame.backgound:SetVertexColor(0, 0, 0, 1)
    end

    function plugin:TargetChanged(frame)
        if frame.state.personal or frame.IN_NAMEONLY then return end

        local guid = frame.state.target_guid
        local text = frame.TargetName

        if guid then
            local unit = frame.unit .. "target"

            if UnitIsUnit(unit, "player") then
                text:SetText("YOU")
                text:SetTextColor(1, 0, 0)
            else
                unit:SetText(UnitName(unit))
                unit:SetTextColor(E:GetUnitColor(unit, true, true))
            end

            text:Show()
        else
            text:Hide()
        end
    end

    function plugin:CastBarShow(frame)
        local bar, icon = frame.CastBar, frame.SpellIcon
        local background, bg = frame.background, frame.bg
        local target = frame.TargetName

        background:ClearAllPoints()
        background:SetPoint("TOPLEFT", profile.castbar_icon and icon or bg, "TOPLEFT", -2, 2)
        background:SetPoint("BOTTOMRIGHT", bar.bg, "BOTTOMRIGHT", 2, -2)

        target:ClearAllPoints()
        target:SetPoint("TOP", bar.bg, "BOTTOM", 1, -profile.name_vertical_offset)

        if bar.handled then return end

        local glass = frame:CreateTexture(nil, "OVERLAY", nil, 7)
        glass:SetTexture(Z.assetPath .. "statusbar-glass")
        glass:SetAllPoints(bar)

        bar:ClearAllPoints()
        bar:SetAllPoints(bar.bg)

        bar.bg:ClearAllPoints()
        bar.bg:SetPoint("TOPLEFT", bg, "BOTTOMLEFT", 0, -2)
        bar.bg:SetPoint("TOPRIGHT", bg, "BOTTOMRIGHT", 0, -2)
        bar.bg:SetHeight(profile.castbar_height)

        if profile.castbar_icon then
            icon:ClearAllPoints()
            icon:SetAllPoints(icon.bg)

            icon.bg:ClearAllPoints()
            icon.bg:SetPoint("TOPRIGHT", bg, "TOPRIGHT", -2, 0)
            icon.bg:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -2, 0)
            icon.bg:SetWidth(profile.frame_height + profile.castbar_height + 2)
        end

        bar.handled = true
    end

    function plugin:CastBarHide(frame)
        local background, bg = frame.background, frame.bg
        local target = frame.TargetName

        background:ClearAllPoints()
        background:SetPoint("TOPLEFT", bg, "TOPLEFT", -2, 2)
        background:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", 2, -2)

        target:ClearAllPoints()
        target:SetPoint("TOP", bg, "BOTTOM", 1, -profile.name_vertical_offset)
    end

    function plugin:Initialise()
        local update = CreateFrame("Frame")

        update.elapsed = 0
        update:SetScript("OnUpdate", function(_, elapsed)
            update.elapsed = update.elapsed + elapsed
            if update.elapsed >= .25 then
                for _, frame in addon:Frames() do
                    if frame:IsShown() and frame.unit then
                        local guid = UnitGUID(frame.unit .. "target")

                        if guid ~= frame.state.target_guid then
                            frame.state.target_guid = guid

                            addon:DispatchMessage("TargetChanged", frame)
                        end
                    end
                end

                update.elapsed = 0
            end
        end)

        self:RegisterMessage("Create")
        self:RegisterMessage("Show")
        self:RegisterMessage("Hide")
        self:RegisterMessage("GainedTarget")
        self:RegisterMessage("LostTarget")
        self:RegisterMessage("TargetChanged")
        self:RegisterMessage("CastBarShow")
        self:RegisterMessage("CastBarHide")

        self:AddCallback("Auras", "PostCreateAuraButton", function(frame, button)
            local icon, bg = button.icon, button.bg

            frame.x_spacing = 2
            frame.y_spacing = 2
            frame.num_per_row = 4

            icon:ClearAllPoints()
            icon:SetPoint("TOPLEFT", bg, "TOPLEFT", 2, -2)
            icon:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -2, 2)

            local cooldown = E.Cooldowns.Create(button)
            cooldown.config.text.v_alignment = "BOTTOM"
            cooldown:UpdateFont()
            button.cooldown = cooldown

            hooksecurefunc(button, "UpdateCooldown", function(arg1)
                arg1.cd:Hide()
            end)

            -- TODO: point
            local count = button.count
            count:ClearAllPoints()
            count:SetPoint("TOPLEFT", 1, -1)
            count:SetPoint("TOPLEFT", 1, -1)
            count:SetJustifyH("RIGHT")
            count:SetJustifyV("TOP")

            hooksecurefunc(core, "AurasButton_SetFont", function()
                Z:HandleFont(count, nil, nil, "OUTLINE", false)
            end)
        end)
    end
end)
