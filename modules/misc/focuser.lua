local _, ns = ...
local Z = ns.Z
local M = Z:GetModule("Misc")

--[[
    Blizzard:
        InCombatLockdown
        IsInGroup
        IsInRaid
        SetOverrideBindingClick

        MEMBERS_PER_RAID_GROUP
        NUM_RAID_GROUPS

    ls_UI:
        LSPlayerFrame
        LSPetFrame
        LSTargetFrame
        LSTargetTargetFrame
        LSBoss1Frame
        LSBoss2Frame
        LSBoss3Frame
        LSBoss4Frame
        LSBoss5Frame
]]

local modifier = "shift"
local button = "1"

local pending = {}

local function Handle(object)
    if object.handled then return end

    if not InCombatLockdown() then
        object:SetAttribute(modifier .. "-type" .. button, "focus")

        object.handled = true
        pending[object] = nil
    else
        pending[object] = true
    end
end

local function HandleRaid()
    if not IsInGroup() then return end

    if IsInRaid() then
        for i = 1, NUM_RAID_GROUPS do
            for j = 1, MEMBERS_PER_RAID_GROUP do
                local frame = _G["CompactRaidGroup" .. i .."Member" .. j]

                if frame then
                    Handle(frame)
                end
            end
        end
    else
        for i = 1, MEMBERS_PER_RAID_GROUP do
            local frame = _G["CompactPartyFrameMember" .. i]

            if frame then
                Handle(frame)
            end
        end
    end
end

function M:Focuser()
    local focuser = CreateFrame("CheckButton", "Focuser", UIParent, "SecureActionButtonTemplate")
    focuser:SetAttribute("type1", "macro")
    focuser:SetAttribute("macrotext", "/focus mouseover")
    SetOverrideBindingClick(_G["Focuser"], true, modifier .. "-BUTTON" .. button, "Focuser")

    for _, frame in pairs({
        LSPlayerFrame,
        LSPetFrame,
        LSTargetFrame,
        LSTargetTargetFrame,
        LSBoss1Frame,
        LSBoss2Frame,
        LSBoss3Frame,
        LSBoss4Frame,
        LSBoss5Frame
    }) do
        if frame then
            Handle(frame)
        end
    end

    HandleRaid()
    Z:RegisterEvent("GROUP_ROSTER_UPDATE", function()
        HandleRaid()
    end)

    Z:RegisterEvent("PLAYER_REGEN_ENABLED", function()
        if next(pending) then
            for object in next, pending do
                Handle(object)
            end
        end
    end)
end
