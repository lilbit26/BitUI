local _, ns = ...
local Z, E = ns.Z, ns.E
local A = Z:AddModule("Auras")

--[[
    ls_UI:
        LSBuffHeader
        LSDebuffHeader
        LSTotemHeader
]]

local var = {
    countX = 1,
    countY = -1,

    debuff = {
        cdX = 0,
        cdY = -1
    }
}

local function HandleButton(button, header)
    if button.handled then return end

    if header == LSDebuffHeader then
        button.Cooldown:ClearAllPoints()
        button.Cooldown:SetPoint("TOPLEFT", var.debuff.cdX, var.debuff.cdY)
        button.Cooldown:SetPoint("BOTTOMRIGHT", var.debuff.cdX, var.debuff.cdY)
    end

    button.TextParent:ClearAllPoints()
    button.TextParent:SetPoint("TOPLEFT", 0, 0)
    button.TextParent:SetPoint("BOTTOMRIGHT", var.countX, var.countX)

    button.handled = true
end

function A:Load()
    for _, header in pairs({LSBuffHeader, LSDebuffHeader}) do
        local buttons = header._buttons or {header:GetChildren()}
        for _, button in next, buttons do
            HandleButton(button, header)
        end

        header:HookScript("OnAttributeChanged", function(arg1, _, arg3)
            if type(arg3) == "table" and arg3.TextParent then
                HandleButton(arg3, arg1)
            end
        end)
    end

    E:ForceHide(LSTotemHeader)
end
