local _, ns = ...
local Z, E = ns.Z, ns.E

--[[
    Blizzard:
        hooksecurefunc
]]

hooksecurefunc(E, "SetStatusBarSkin", function(_, object, flag)
    for i = 1, 4 do
        Z:Hide(object.Tube[i])
    end

    if not object.Border then
        local border = E:CreateBorder(object)
        border:SetTexture(Z.assetPath .. "border-thin")
        border:SetSize(16)
        border:SetOffset(-8)
        object.Border = border
    end
end)
