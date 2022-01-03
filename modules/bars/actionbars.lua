local _, ns = ...
local Z = ns.Z
local B = Z:GetModule("Bars")

--[[
    ls_UI:
        LSActionBar1
]]

-- not tested
function B:ActionBars()
    local bar = LSActionBar1

    Z:RegisterEvent("UNIT_ENTERED_VEHICLE", function(unit, ui)
        if unit == "player" and ui then
            if bar._config.visible and bar._config.fade.enabled then
                bar:DisableFading()

                if bar.UpdateButtons then
                    bar:UpdateButtons("SetAlpha", 1)
                end
            end
        end
    end)

    Z:RegisterEvent("UNIT_EXITED_VEHICLE", function(unit)
        if unit == "player" then
            if bar._config.visible and bar._config.fade.enabled then
                bar:EnableFading()
            end
        end
    end)
end
