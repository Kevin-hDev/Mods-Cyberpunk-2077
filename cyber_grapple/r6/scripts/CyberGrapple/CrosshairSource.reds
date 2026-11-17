// Whose crosshair shows with empty hands or fists: the first line of the crosshair's settings. The settings' class
// and the rule that reads this are made from Apex Grapple's, with the patches of fabrique/grapple_spec.py.
// Kevin, 16 November 2026: a simple line with two positions, the mod's name or the game, above the line of shapes.
// Game: this mod draws nothing, and the game shows what it shows there, which is no crosshair.
enum CyberGrappleCrosshairSource {
  Mod = 0,
  Game = 1
}
