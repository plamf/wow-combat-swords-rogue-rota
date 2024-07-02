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

-- Spells
RogueRota.spells = {
    SliceAndDice = "Slice and Dice",
    AdrenalineRush = "Adrenaline Rush",
    SinisterStrike = "Sinister Strike",
    Eviscerate = "Eviscerate",
    BladeFlurry = "Blade Flurry"
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
    if not UnitIsPlayer("target") then
        local sliceActive, sliceTimeLeft = RogueRota:IsActive(RogueRota.spells.SliceAndDice)
        local adrenalineActive = RogueRota:IsActive(RogueRota.spells.AdrenalineRush)
        local bladeFlurryActive = RogueRota:IsActive(RogueRota.spells.BladeFlurry)
        local comboPoints = GetComboPoints("player")
        local energy = UnitMana("player")

        -- Maintain Slice and Dice if there are 3 or fewer combo points
        if comboPoints >= 1 and comboPoints <= 3 and (not sliceActive or sliceTimeLeft < 2) then
            CastSpellByName(RogueRota.spells.SliceAndDice)
            return
        end

        -- Use Eviscerate as finisher if there are 5 combo points
        if comboPoints >= 5 then
            CastSpellByName(RogueRota.spells.Eviscerate)
            return
        end

        -- Use Sinister Strike to generate combo points
        if comboPoints < 5 and energy >= 40 then
            CastSpellByName(RogueRota.spells.SinisterStrike)
            return
        end

        -- Use Adrenaline Rush when it is not active
        if not adrenalineActive then
            CastSpellByName(RogueRota.spells.AdrenalineRush)
            CastSpellByName(RogueRota.spells.BladeFlurry)
        end

        -- Use Blade Flurry when it is not active
        if not bladeFlurryActive then
            CastSpellByName(RogueRota.spells.BladeFlurry)
        end
    end
end
