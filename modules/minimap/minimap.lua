local _, ns = ...
local Z = ns.Z
local M = Z:AddModule("Minimap")

--[[
    Blizzard:
        GuildInstanceDifficulty
        Minimap
        MiniMapChallengeMode
        MiniMapInstanceDifficulty
]]

function M:Load()
    -- difficulty
    local angle = math.rad(135)
    local w = Minimap:GetWidth() / 2 + 5
    local h = Minimap:GetHeight() / 2 + 5

    MiniMapChallengeMode:SetParent(Minimap)
    MiniMapChallengeMode:ClearAllPoints()
    MiniMapChallengeMode:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * w, math.sin(angle) * h)

    MiniMapInstanceDifficulty:SetParent(Minimap)
    MiniMapInstanceDifficulty:ClearAllPoints()
    MiniMapInstanceDifficulty:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * w, math.sin(angle) * h)

    GuildInstanceDifficulty:SetParent(Minimap)
    GuildInstanceDifficulty:ClearAllPoints()
    GuildInstanceDifficulty:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * w, math.sin(angle) * h)

    -- clock
    local ticker = Minimap.Clock.Ticker
    if ticker then
        ticker:ClearAllPoints()
        ticker:SetPoint("TOPLEFT", 4, -8)
        ticker:SetPoint("BOTTOMRIGHT", -4, 8)
    end
end
