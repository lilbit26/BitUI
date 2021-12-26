local _, ns = ...
local Z = ns.Z
local A = Z:AddModule("Auras")

--[[
    ls_UI:
        LSBuffHeader
        LSDebuffHeader
]]

function A:Load()
    for _, header in pairs({LSBuffHeader, LSDebuffHeader}) do
        local buttons = header._buttons or {header:GetChildren()}
        for _, button in next, buttons do
            button:HookScript("OnAttributeChanged", function(arg1)
                if arg1.handled then return end

                arg1.TextParent:ClearAllPoints()
                arg1.TextParent:SetPoint("TOPLEFT", 1, -1)
                arg1.TextParent:SetPoint("BOTTOMRIGHT", 1, -1)

                arg1.handled = true
            end)
        end
    end
end
