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

    hooksecurefunc(bar, "UpdateSize", function()
        local parent = bar.TexParent

        parent.border:SetTexture(Z.assetPath .. "border-thick")
        E:ForceHide(parent.Tube[5])

        if not parent.inlay then
            local inlay = E:CreateBorder(parent, "OVERLAY")
            inlay:SetTexture(Z.assetPath .. "unit-frame-inlay-both")
            inlay:SetAlpha(0.8)

            parent.inlay = inlay
        end
    end)
    bar:UpdateSize()
end