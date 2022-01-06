local _, ns = ...
local Z = ns.Z
local UF = Z:GetModule("UnitFrames")

--[[
    ls_UI:
        LSFocusFrame
]]

function UF:Focus()
    local frame = LSFocusFrame
    if not frame then return end

    local status = frame.Status
    status:ClearAllPoints()
    status:SetPoint("RIGHT", frame, "BOTTOMRIGHT", -4, -1)
    status:SetJustifyH("RIGHT")

    self:Castbar(frame)
end
