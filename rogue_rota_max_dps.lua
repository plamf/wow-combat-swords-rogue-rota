-- Global Variables
RogueRota = {}
RogueRota.TickTime = 2
RogueRota.FirstTick = 0
RogueRota.Energy = 100
RogueRota.f = CreateFrame("Frame", "Energy", UIParent)
RogueRota.f:RegisterEvent("UNIT_ENERGY")
RogueRota.f:SetScript("OnEvent", function(self, event)
    if (UnitMana("player") == (RogueRota.Energy + 20)) then
        RogueRota.FirstTick = GetTime()
    end
    RogueRota.Energy = UnitMana("player")
end)

-- Spell Names
RogueRota.name = {
    [1] = "Slice and Dice",
    [2] = "Adrenaline Rush",
    [3] = "Sinister Strike",
    [4] = "Eviscerate",
    [5] = "Blade Flurry"
}

-- Local Variables
local f = CreateFrame("GameTooltip", "f", UIParent, "GameTooltipTemplate")

-- Function to get the next energy tick time
function RogueRota:GetNextTick()
    local i, now = RogueRota.FirstTick, GetTime()
    while true do
        if (i > now) then
            return (i - now)
        end
        i = i + RogueRota.TickTime
    end
end

-- Function to check if a buff is active
function RogueRota:IsActive(name)
    for i = 0, 31 do
        f:SetOwner(UIParent, "ANCHOR_NONE")
        f:ClearLines()
        f:SetPlayerBuff(GetPlayerBuff(i, "HELPFUL"))
        local buff = fTextLeft1:GetText()
        if (not buff) then break end
        if (buff == name) then
            return true, GetPlayerBuffTimeLeft(GetPlayerBuff(i, "HELPFUL"))
        end
        f:Hide()
    end
    return false, 0
end

-- Function to handle the rotation
function RogueRota:MaxDps()
    if (not UnitIsPlayer("target")) then
        local active, timeLeft = RogueRota:IsActive(RogueRota.name[1]) -- Slice and Dice
        local Aactive, AtimeLeft = RogueRota:IsActive(RogueRota.name[2]) -- Adrenaline Rush
        local Bactive, BtimeLeft = RogueRota:IsActive(RogueRota.name[5]) -- Blade Flurry
        local cP = GetComboPoints("player")
        local energy = UnitMana("player")

        -- Maintain Slice and Dice as soon as there is at least 1 combo point
        if cP >= 1 and (not active or timeLeft < 2) then
            CastSpellByName(RogueRota.name[1]) -- Slice and Dice
            return
        end

        -- Use Sinister Strike to generate combo points
        if cP < 5 and energy >= 40 then
            CastSpellByName(RogueRota.name[3]) -- Sinister Strike
            return
        end

        -- Use Eviscerate as finisher if Slice and Dice is active
        if active and cP >= 5 then
            CastSpellByName(RogueRota.name[4]) -- Eviscerate
            return
        end

        -- Use Adrenaline Rush and Blade Flurry initially together
        if not Aactive and not Bactive then
            CastSpellByName(RogueRota.name[2]) -- Adrenaline Rush
            CastSpellByName(RogueRota.name[5]) -- Blade Flurry
            return
        end

        -- Use Blade Flurry again after 2 minutes, while Adrenaline Rush is still on cooldown
        local ACD = GetSpellCooldown(RogueRota.name[2])
        local BCD = GetSpellCooldown(RogueRota.name[5])
        if ACD > 0 and BCD == 0 then
            CastSpellByName(RogueRota.name[5]) -- Blade Flurry
            return
        end
    end
end
