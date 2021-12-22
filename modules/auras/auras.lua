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
        header:HookScript("OnAttributeChanged", function(_, _, button)
            local parent = button.TextParent

            parent:ClearAllPoints()
            parent:SetPoint("TOPLEFT", 1, -1)
            parent:SetPoint("BOTTOMRIGHT", 1, -1)
        end)
    end
end
