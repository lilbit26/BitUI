local _, ns = ...
local Z, E = ns.Z, ns.E
local B = Z:GetModule("Bars")

--[[
    Blizzard:
        hooksecurefunc

    ls_UI:
        LSUIXPBar
]]

function B:XPBar()
    local bar = LSUIXPBar
    if not bar then return end

    bar.TexParent.Border:SetTexture(Z.assetPath .. "border-thick")
    E:ForceHide(bar.TexParent.Tube[5])

    local inlay = E:CreateBorder(bar.TexParentject, "OVERLAY")
    inlay:SetTexture(Z.assetPath .. "unit-frame-inlay-both")
    inlay:SetAlpha(0.8)
end
