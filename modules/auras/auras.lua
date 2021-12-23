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
            if button and button.TextParent then
                button.TextParent:ClearAllPoints()
                button.TextParent:SetPoint("TOPLEFT", 1, -1)
                button.TextParent:SetPoint("BOTTOMRIGHT", 1, -1)
            end
        end)
    end
end
