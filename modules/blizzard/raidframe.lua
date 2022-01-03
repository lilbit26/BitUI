local _, ns = ...
local Z, E = ns.Z, ns.E
local B = Z:GetModule("Blizzard")

--[[
    Blizzard:
        hooksecurefunc

        CompactPartyFrame
        DebuffTypeColor
        IsInGroup
        IsInRaid
        UnitGroupRolesAssigned

        CompactPartyFrame_OnLoad
        CompactRaidGroup_InitializeForGroup
        CompactRaidGroup_UpdateBorder

        MEMBERS_PER_RAID_GROUP
        NUM_RAID_GROUPS
]]

local roleIcons = {
    ["TANK"] = {100 / 256, 131 / 256, 2 / 256, 33 / 256},
    ["HEALER"] = {68 / 256, 99 / 256, 2 / 256, 33 / 256},
    ["DAMAGER"] = {35 / 256, 66 / 256, 2 / 256, 33 / 256}
}

function B:RaidFrame()
    hooksecurefunc("CompactPartyFrame_Generate", function ()
        if CompactPartyFrame and CompactPartyFrame.title then
            CompactPartyFrame.title:SetText("")
        end
    end)

    hooksecurefunc("CompactRaidGroup_InitializeForGroup", function(frame)
        if frame and frame.title then
            E:ForceHide(frame.title)
        end
    end)

    hooksecurefunc("CompactRaidGroup_UpdateBorder", function(frame)
        local borderFrame = frame.borderFrame
        if borderFrame.handled then return end

        E:ForceHide(_G[borderFrame:GetName() .. "BorderTopLeft"])
        E:ForceHide(_G[borderFrame:GetName() .. "BorderTopRight"])
        E:ForceHide(_G[borderFrame:GetName() .. "BorderBottomLeft"])
        E:ForceHide(_G[borderFrame:GetName() .. "BorderBottomRight"])
        E:ForceHide(_G[borderFrame:GetName() .. "BorderTop"])
        E:ForceHide(_G[borderFrame:GetName() .. "BorderBottom"])
        E:ForceHide(_G[borderFrame:GetName() .. "BorderLeft"])
        E:ForceHide(_G[borderFrame:GetName() .. "BorderRight"])

        local border = E:CreateBorder(frame.borderFrame)
        border:SetTexture(Z.assetPath .. "border-thick")
        border:SetSize(16)
        border:SetOffset(-8)

        for i = 1, MEMBERS_PER_RAID_GROUP do
            local unitFrame = _G[frame:GetName() .. "Member" .. i]

            -- inlay
            local inlay = E:CreateBorder(unitFrame, "OVERLAY", -7)
            inlay:SetOffset(-9)
            inlay:SetTexture(Z.assetPath .. "unit-frame-inlay-none")
            inlay:SetAlpha(0.8)

            if i == 1 then
                inlay.TOPLEFT:SetTexture(Z.assetPath .. "unit-frame-inlay-both")
                inlay.TOPRIGHT:SetTexture(Z.assetPath .. "unit-frame-inlay-both")
                -- inlay.TOPLEFT:SetAlpha(1)
                -- inlay.TOPRIGHT:SetAlpha(1)
            elseif i == MEMBERS_PER_RAID_GROUP then
                inlay.BOTTOMLEFT:SetTexture(Z.assetPath .. "unit-frame-inlay-both")
                inlay.BOTTOMRIGHT:SetTexture(Z.assetPath .. "unit-frame-inlay-both")
            end

            -- sep
            if i ~= MEMBERS_PER_RAID_GROUP then
                local left = borderFrame:CreateTexture(nil, "OVERLAY")
                left:SetTexture(Z.assetPath .. "border-thick-sep")
                left:SetTexCoord(0.421875, 0.53125, 0.609375, 0.53125, 0.421875, 0.03125, 0.609375, 0.03125)
                left:SetSize(16 / 2, 12 / 2)
                left:SetPoint("BOTTOMLEFT", unitFrame, "BOTTOMLEFT", 1, -3)
                left:SetSnapToPixelGrid(false)
                left:SetTexelSnappingBias(0)
                E:SmoothColor(left)

                local right = frame.borderFrame:CreateTexture(nil, "OVERLAY")
                right:SetTexture(Z.assetPath .. "border-thick-sep")
                right:SetTexCoord(0.21875, 0.53125, 0.40625, 0.53125, 0.21875, 0.03125, 0.40625, 0.03125)
                right:SetSize(16 / 2, 12 / 2)
                right:SetPoint("BOTTOMRIGHT", unitFrame, "BOTTOMRIGHT", -1, -3)
                right:SetSnapToPixelGrid(false)
                right:SetTexelSnappingBias(0)
                E:SmoothColor(right)

                local mid = frame.borderFrame:CreateTexture(nil, "OVERLAY")
                mid:SetTexture(Z.assetPath .. "border-thick-sep", "REPEAT", "REPEAT")
                mid:SetTexCoord(0.015625, 1, 0.203125, 1, 0.015625, 0, 0.203125, 0)
                mid:SetPoint("TOPLEFT", left, "TOPRIGHT", 0, 0)
                mid:SetPoint("BOTTOMRIGHT", right, "BOTTOMLEFT", 0, 0)
                mid:SetSnapToPixelGrid(false)
                mid:SetTexelSnappingBias(0)
                E:SmoothColor(mid)
            end
        end

        local bg = borderFrame:CreateTexture(nil, "BACKGROUND", nil, -7)
        bg:SetTexture("Interface\\HELPFRAME\\DarkSandstone-Tile", "REPEAT", "REPEAT")
        bg:SetAllPoints()
        bg:SetHorizTile(true)
        bg:SetVertTile(true)

        borderFrame:ClearAllPoints()
        borderFrame:SetPoint("TOPLEFT", _G[frame:GetName() .. "Member1"], 1, -1)
        borderFrame:SetPoint("BOTTOMRIGHT", _G[frame:GetName() .. "Member" .. MEMBERS_PER_RAID_GROUP], -1, 1)

        borderFrame.handled = true
    end)

    hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", function(frame)
        if frame.roleIcon then
            local role = UnitGroupRolesAssigned(frame.unit)
            if (role == "TANK" or role == "HEALER" or role == "DAMAGER") then
                frame.roleIcon:SetTexture(Z.assetPath .. "unit-frame-icons")
                frame.roleIcon:SetSize(14, 14)
                frame.roleIcon:SetTexCoord(unpack(roleIcons[role]))
            end
        end
    end)

    hooksecurefunc("CompactUnitFrame_UtilSetBuff", function(buffFrame)
        buffFrame.icon:SetTexCoord(unpack(Z.iconCoords))

        if not buffFrame.bg then
            local bg = buffFrame:CreateTexture(nil, "BACKGROUND")
            bg:SetTexture("Interface\\BUTTONS\\WHITE8X8")
            bg:SetVertexColor(0, 0, 0, 1)
            bg:SetPoint("TOPLEFT", -1, 1)
            bg:SetPoint("BOTTOMRIGHT", 1, -1)

            buffFrame.bg = bg
        end

        buffFrame.count:ClearAllPoints()
        buffFrame.count:SetPoint("TOPLEFT", 1, 0)
        buffFrame.count:SetPoint("BOTTOMRIGHT", 1, 0)
        buffFrame.count:SetJustifyH("CENTER")
        buffFrame.count:SetJustifyV("MIDDLE")
        buffFrame.count:SetParent(buffFrame.cooldown)
        Z:HandleFont(buffFrame.count, nil, 10, "OUTLINE", false)
    end)

    hooksecurefunc("CompactUnitFrame_UtilSetDebuff", function(debuffFrame)
        debuffFrame.icon:SetTexCoord(unpack(Z.iconCoords))

        if not debuffFrame.bg then
            local bg = debuffFrame:CreateTexture(nil, "BACKGROUND")
            bg:SetTexture("Interface\\BUTTONS\\WHITE8X8")
            bg:SetPoint("TOPLEFT", -1, 1)
            bg:SetPoint("BOTTOMRIGHT", 1, -1)

            debuffFrame.bg = bg
        end

        local r, g, b = debuffFrame.border:GetVertexColor()
        debuffFrame.bg:SetVertexColor(r, g, b)
        E:ForceHide(debuffFrame.border)

        debuffFrame.count:ClearAllPoints()
        debuffFrame.count:SetPoint("TOPLEFT", 1, 0)
        debuffFrame.count:SetPoint("BOTTOMRIGHT", 1, 0)
        debuffFrame.count:SetJustifyH("CENTER")
        debuffFrame.count:SetJustifyV("MIDDLE")
        debuffFrame.count:SetParent(debuffFrame.cooldown)
        Z:HandleFont(debuffFrame.count, nil, 10, "OUTLINE", false)

        debuffFrame:SetSize(20, 20)
    end)

    hooksecurefunc("DefaultCompactUnitFrameSetup", function(frame)
        E:ForceHide(frame.background)

        frame.healthBar:SetStatusBarTexture(Z.assetPath .. "statusbar-texture")

        frame.totalAbsorb:SetTexture(Z.assetPath .. "absorb", "REPEAT", "REPEAT")
        frame.totalAbsorb:SetVertexColor(53 / 256, 187 / 256, 244 / 256)
        frame.totalAbsorb:SetHorizTile(true)
        frame.totalAbsorb:SetVertTile(true)
        E:ForceHide(frame.totalAbsorbOverlay)

        frame.overAbsorbGlow:ClearAllPoints()
        frame.overAbsorbGlow:SetPoint("BOTTOMLEFT", frame.healthBar, "BOTTOMRIGHT", -5, 0)
        frame.overAbsorbGlow:SetPoint("TOPLEFT", frame.healthBar, "TOPRIGHT", -5, 0)
        frame.overAbsorbGlow:SetWidth(12)

        frame.roleIcon:ClearAllPoints()
        frame.roleIcon:SetPoint("TOPLEFT", 6, -6)

        frame.name:ClearAllPoints()
        frame.name:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
        frame.name:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
        frame.name:SetJustifyH("CENTER")
        frame.name:SetJustifyV("BOTTOM")

        frame.statusText:ClearAllPoints()
        frame.statusText:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
        frame.statusText:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
        frame.statusText:SetJustifyH("CENTER")
        frame.statusText:SetJustifyV("TOP")

        frame.buffFrames[1]:ClearAllPoints()
        frame.buffFrames[1]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
        for i = 1, #frame.buffFrames do
            if i > 1 then
                frame.buffFrames[i]:ClearAllPoints()
                frame.buffFrames[i]:SetPoint("TOPRIGHT", frame.buffFrames[i - 1], "TOPLEFT", -3, 0)
            end
            frame.buffFrames[i]:SetSize(20, 20)
        end

        frame.debuffFrames[1]:ClearAllPoints()
        frame.debuffFrames[1]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 4, 4)
        for i = 2, #frame.debuffFrames do
            frame.debuffFrames[i]:ClearAllPoints()
            frame.debuffFrames[i]:SetPoint("BOTTOMLEFT", frame.debuffFrames[i - 1], "BOTTOMRIGHT", 3, 0)
        end

        if frame.dispelDebuffFrames then
            for i = 1, #frame.dispelDebuffFrames do
                frame.dispelDebuffFrames[i]:Hide()
            end
        end

        E:ForceHide(frame.horizTopBorder)
        E:ForceHide(frame.horizBottomBorder)
        E:ForceHide(frame.vertLeftBorder)
        E:ForceHide(frame.vertRightBorder)
        E:ForceHide(frame.horizDivider)

        frame.selectionHighlight:ClearAllPoints()
        frame.selectionHighlight:SetPoint("TOPLEFT", 2, -2)
        frame.selectionHighlight:SetPoint("BOTTOMRIGHT", -2, 2)

        frame.aggroHighlight:ClearAllPoints()
        frame.aggroHighlight:SetPoint("TOPLEFT", 2, -2)
        frame.aggroHighlight:SetPoint("BOTTOMRIGHT", -2, 2)
        frame.aggroHighlight:SetTexCoord(0.00781250, 0.55468750, 0.28906250, 0.55468750)
    end)

    hooksecurefunc("CompactRaidFrameContainer_ApplyToFrames", function(_, _, func, ...)

    end)

    if IsInGroup() then
        if IsInRaid() then
            for i = 1, NUM_RAID_GROUPS do
                local frame = _G["CompactRaidGroup"..i]

                if frame then
                    CompactRaidGroup_InitializeForGroup(frame, i)
                    CompactRaidGroup_UpdateBorder(frame)
                end
            end
        else
            local frame = CompactPartyFrame
            if frame then
                CompactPartyFrame_OnLoad(frame)
                CompactRaidGroup_UpdateBorder(frame)

                if frame.title then
                    frame.title:SetText("")
                end
            end
        end
    end
end

function B:RaidFrameManager()
    hooksecurefunc("CompactRaidFrameManager_Collapse", function(frame)
        frame.toggleButton:SetPoint("RIGHT", -7, 0)

        if frame.sep then
            frame.sep:Hide()
        end
    end)

    hooksecurefunc("CompactRaidFrameManager_Expand", function(frame)
        frame.toggleButton:SetPoint("RIGHT", -8, 0)

        if frame.sep then
            frame.sep:Show()

            if not IsInRaid() then
                for _, tex in pairs(frame.sep.sep2) do
                    tex:Hide()
                end
            end
        end
    end)

    hooksecurefunc("CompactRaidFrameManager_UpdateShown", function(frame)
        if frame.handled then return end

        local texParent = CreateFrame("Frame", nil, frame)
        texParent:SetPoint("TOPLEFT", frame, "TOPLEFT", -10, 2)
        texParent:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)

        E:ForceHide(_G[frame:GetName() .. "BorderTopLeft"])
        E:ForceHide(_G[frame:GetName() .. "BorderTopRight"])
        E:ForceHide(_G[frame:GetName() .. "BorderBottomLeft"])
        E:ForceHide(_G[frame:GetName() .. "BorderBottomRight"])
        E:ForceHide(_G[frame:GetName() .. "BorderTop"])
        E:ForceHide(_G[frame:GetName() .. "BorderBottom"])
        E:ForceHide(_G[frame:GetName() .. "BorderRight"])

        local border = E:CreateBorder(texParent)
        border:SetTexture(Z.assetPath .. "border-thick")
        border:SetSize(16)
        border:SetOffset(-16)

        E:ForceHide(_G[frame:GetName() .. "DisplayFrameHeaderDelineator"])
        E:ForceHide(_G[frame:GetName() .. "DisplayFrameFilterOptionsFooterDelineator"])

        local sep = CreateFrame("Frame", nil, texParent)
        sep:SetAllPoints()

        local left1 = sep:CreateTexture(nil, "OVERLAY")
        left1:SetTexture(Z.assetPath .. "border-thick-sep")
        left1:SetTexCoord(0.421875, 0.53125, 0.609375, 0.53125, 0.421875, 0.03125, 0.609375, 0.03125)
        left1:SetSize(16 / 2, 12 / 2)
        left1:SetPoint("TOPLEFT", frame, "TOPLEFT", -10, -21)
        left1:SetSnapToPixelGrid(false)
        left1:SetTexelSnappingBias(0)
        E:SmoothColor(left1)

        local right1 = sep:CreateTexture(nil, "OVERLAY")
        right1:SetTexture(Z.assetPath .. "border-thick-sep")
        right1:SetTexCoord(0.21875, 0.53125, 0.40625, 0.53125, 0.21875, 0.03125, 0.40625, 0.03125)
        right1:SetSize(16 / 2, 12 / 2)
        right1:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -7, -21)
        right1:SetSnapToPixelGrid(false)
        right1:SetTexelSnappingBias(0)
        E:SmoothColor(right1)

        local mid1 = sep:CreateTexture(nil, "OVERLAY")
        mid1:SetTexture(Z.assetPath .. "border-thick-sep", "REPEAT", "REPEAT")
        mid1:SetTexCoord(0.015625, 1, 0.203125, 1, 0.015625, 0, 0.203125, 0)
        mid1:SetPoint("TOPLEFT", left1, "TOPRIGHT", 0, 0)
        mid1:SetPoint("BOTTOMRIGHT", right1, "BOTTOMLEFT", 0, 0)
        mid1:SetSnapToPixelGrid(false)
        mid1:SetTexelSnappingBias(0)
        E:SmoothColor(mid1)

        local left2 = sep:CreateTexture(nil, "BACKGROUND")
        left2:SetTexture(Z.assetPath .. "border-thick-sep")
        left2:SetTexCoord(0.421875, 0.53125, 0.609375, 0.53125, 0.421875, 0.03125, 0.609375, 0.03125)
        left2:SetSize(16 / 2, 12 / 2)
        left2:SetPoint("BOTTOMLEFT", frame.displayFrame.filterOptions, "BOTTOMLEFT", -10, 6)
        left2:SetSnapToPixelGrid(false)
        left2:SetTexelSnappingBias(0)
        E:SmoothColor(left2)

        local right2 = sep:CreateTexture(nil, "BACKGROUND")
        right2:SetTexture(Z.assetPath .. "border-thick-sep")
        right2:SetTexCoord(0.21875, 0.53125, 0.40625, 0.53125, 0.21875, 0.03125, 0.40625, 0.03125)
        right2:SetSize(16 / 2, 12 / 2)
        right2:SetPoint("BOTTOMRIGHT", frame.displayFrame.filterOptions, "BOTTOMRIGHT", -8, 6)
        right2:SetSnapToPixelGrid(false)
        right2:SetTexelSnappingBias(0)
        E:SmoothColor(right2)

        local mid2 = sep:CreateTexture(nil, "BACKGROUND")
        mid2:SetTexture(Z.assetPath .. "border-thick-sep", "REPEAT", "REPEAT")
        mid2:SetTexCoord(0.015625, 1, 0.203125, 1, 0.015625, 0, 0.203125, 0)
        mid2:SetPoint("TOPLEFT", left2, "TOPRIGHT", 0, 0)
        mid2:SetPoint("BOTTOMRIGHT", right2, "BOTTOMLEFT", 0, 0)
        mid2:SetSnapToPixelGrid(false)
        mid2:SetTexelSnappingBias(0)
        E:SmoothColor(mid2)

        sep:Hide()

        sep.sep2 = {left2, right2, mid2}
        frame.sep = sep

        frame.toggleButton:SetPoint("RIGHT", -7, 0)

        frame.handled = true
    end)
end
