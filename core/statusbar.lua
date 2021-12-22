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

    local border = object.border

    if not border then
        border = E:CreateBorder(object)
        border:SetTexture(Z.assetPath .. "border-thin")
        border:SetSize(16)
        border:SetOffset(-8)
    end
end)
