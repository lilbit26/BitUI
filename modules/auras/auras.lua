local _, ns = ...
local Z, E = ns.Z, ns.E
local A = Z:AddModule("Auras")

--[[
    ls_UI:
        LSBuffHeader
        LSDebuffHeader
        LSTotemHeader
]]

function A:Load()
    local function HandleButton(button, header)
        if button.handled then return end

        button.TextParent:ClearAllPoints()
        button.TextParent:SetPoint("TOPLEFT", 1, -1)
        button.TextParent:SetPoint("BOTTOMRIGHT", 1, -1)

        if header == LSDebuffHeader then
            button.Cooldown:ClearAllPoints()
            button.Cooldown:SetPoint("TOPLEFT", 0, -1)
            button.Cooldown:SetPoint("BOTTOMRIGHT", 0, -1)
        end

        button.handled = true
    end

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
