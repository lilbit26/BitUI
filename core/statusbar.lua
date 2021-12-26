local _, ns = ...
local Z, E = ns.Z, ns.E

--[[
    Blizzard:
        hooksecurefunc
]]

hooksecurefunc(E, "SetStatusBarSkin", function(_, object, flag)
    for i = 1, 4 do
        E:ForceHide(object.Tube[i])
    end

    if not object.border then
        local border = E:CreateBorder(object)
        border:SetTexture(Z.assetPath .. "border-thin")
        border:SetSize(16)
        border:SetOffset(-8)

        object.border = border
    end
end)
