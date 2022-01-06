local _, ns = ...
local Z, E = ns.Z, ns.E
local UF = Z:GetModule("UnitFrames")

--[[
    ls_UI:
        LSPetFrame
]]

local var = {
    height = 8
}

local function UpdateSize_Hook(self)
    self:SetHeight(var.height)

    local mover = E.Movers:Get(self, true)
    if mover then
        mover:UpdateSize()
    end
end

function UF:Pet()
    local frame = LSPetFrame
    if not frame then return end

    frame.Border:SetTexture(Z.assetPath .. "border-thin")
    frame.Inlay:Hide()

    local glass = frame.TextParent:CreateTexture(nil, "OVERLAY")
    glass:SetTexture(Z.assetPath .. "statusbar-glass")
    glass:SetAllPoints()

    UpdateSize_Hook(frame)
    hooksecurefunc(frame, "UpdateSize", UpdateSize_Hook)

    Z:CutStatusBar(frame, "TOP")
end