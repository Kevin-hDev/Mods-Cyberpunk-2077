# Mods Cyberpunk 2077

Mods for Cyberpunk 2077 2.5, written in redscript: movement mods inspired by Apex Legends, a grapple arm implant, and a patch for the Mod Settings menu.

| Mod | What it does | Version |
|---|---|---|
| [Auto Sprint](auto_sprint/) | Sprint starts by itself as soon as you move forward, you set the sprint and walk speeds, and V no longer needs to jump to get over some curbs | 1.0.0 |
| [Omni Sprint](omni_sprint/) | Sprint in every direction: sideways, diagonally and backwards | 1.0.0 |
| [Omni Slide](omni_slide/) | Slide in every direction and look wherever you want during the slide without being stopped | 1.0.0 |
| [Axle Slide](axle_slide/) | Steer your slides with the move keys, slide faster with a speed boost, and farther | 1.0.0 |
| [Air Strafe](air_strafe/) | Steer your momentum in the air through 360 degrees with the move keys without losing speed, and tap strafe | 1.0.0 |
| [Wall Climb](wall_climb/) | Climb any wall in Night City, sideways and upward | 1.0.0 |
| [Apex Grapple](apex_grapple/) | A grappling hook: aim at a surface, the hook flies out, and the rope pulls you while your aim steers you | 1.1.5 |
| [Cyber Grapple](cyber_grapple/) | Apex Grapple's grappling hook as an arm implant: bought from ripperdocs, upgraded tier by tier, with charges | 1.0.1 |
| [Mod Settings Navigator](mod_settings_navigator/) | Favourites and pages in the list of Mod Settings, foldable settings sections, and a menu that reopens on the mod and the line you were on | 1.0.1 |

Each folder holds the mod exactly as it ships on Nexus Mods: its `r6` folder mirrors the game folder.

## Installing a mod

1. Install [redscript](https://www.nexusmods.com/cyberpunk2077/mods/1511). Omni Sprint, Omni Slide and Axle Slide also need [TweakXL](https://www.nexusmods.com/cyberpunk2077/mods/4197). Cyber Grapple also needs TweakXL 1.9.0 or newer, Codeware and RED4ext. Mod Settings Navigator also needs Mod Settings, Codeware and [RED4ext](https://www.nexusmods.com/cyberpunk2077/mods/2380). [RedFileSystem](https://www.nexusmods.com/cyberpunk2077/mods/13378) is optional for it: it gives the favourites and keeps them, and the folded sections, between game launches.
2. Optional: [Mod Settings](https://www.nexusmods.com/cyberpunk2077/mods/4885) to change the settings in Settings > Mods, and [Codeware](https://www.nexusmods.com/cyberpunk2077/mods/7780) for the menu texts in English, French and Simplified Chinese. Each mod's Nexus page says what else they bring.
3. Copy the mod's `r6` folder into the game folder, next to `bin`.

The hook and rope of Apex Grapple and of Cyber Grapple are drawn from an `archive` folder that is built over a mesh taken from the game: it is not in this repository, only in each mod's Nexus archive. Cyber Grapple's grapple scripts are made from Apex Grapple's by a tool that is not in this repository either: their first lines say so.

## Reporting a problem

Report it in the Bugs tab of the mod's Nexus page, and say what you were doing when it happened, where you were, and which version of the game and of the mod you are on.

## License

Every mod in this repository is under the [Mozilla Public License 2.0](LICENSE), except Apex Grapple and Cyber Grapple. Copyright 2026 Kevin-hDev.

You may use, change and share the code of the MPL-2.0 mods, in your own mods too, as long as the files you take stay under the MPL-2.0 and you share your changes to them.

Apex Grapple is under the [PolyForm Strict License 1.0.0](apex_grapple/r6/scripts/ApexGrapple/LICENSE) since version 1.1.5: you may use it for free to play, but you may not share it elsewhere, sell it or change its code without my permission. Its versions up to 1.1.4 stay under the MPL-2.0. Cyber Grapple, made from Apex Grapple's code, is under the [same license](cyber_grapple/r6/scripts/CyberGrapple/LICENSE) from its first version. Game assets, redscript, RED4ext, Codeware, TweakXL and Mod Settings are not relicensed by this repository.
