# Combat Sword Rotation for Maximum DPS
This is my optimized rotation for Combat Sword Rogues in Vanilla/Classic World of Warcraft.

Based on https://github.com/Geigerkind/RogueRota and modified for my build.

## What does it do?
1. `Sinister Strike` to build combo points
2. Always keep `Slice and Dice` active
3. If `Adrenaline Rush` and `Blade Flurry` is ready, cast both
4. Cast `Blade Flurry` a second time before `Adrenaline Rush` is ready again
5. If `Slice and Dice` is active but we got 5 combo points, cast `Eviscerate`

## Prerequisites and usage
1. Combat Swords build, like https://www.wowhead.com/classic/guide/classes/rogue/dps-talent-builds-pve#combat-swords-19-32-0-rogue-talent-build
2. Super Macro Addon: https://github.com/Monteo/SuperMacro
3. Copy the entire script into the LUA Section of your SuperMacro
4. Call the Macro with `/run RogueRota:MaxDps()`
5. Spam it
