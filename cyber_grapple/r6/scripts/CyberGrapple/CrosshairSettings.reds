// Made by fabrique/grapple.py from Apex Grapple's CrosshairSettings.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The crosshair shown with empty hands or fists (Crosshair.reds): settings shared by every profile, in a group of
// their own above them, because the crosshair shows before any key is pressed. Without Mod Settings the fields keep
// the values written here. A field is never renamed: Mod Settings keeps the player's value under its name.
// Defaults (Kevin, 9 November 2026): shown, simple crosshair, yellow, at the game's size; the range indicator on, red
// out of range (10 November 2026).

enum CyberGrappleCrosshairShape {
  Simple = 0,
  Basic = 1,
  Shotgun = 2,
  SmartRifle = 3,
  TechCircle = 4,
  TechHex = 5,
  Launcher = 6,
  MantisBlades = 7,
  HeavyMachineGun = 8,
  Dot = 9
}

enum CyberGrappleCrosshairColor {
  Yellow = 0,
  White = 1,
  Red = 2,
  Green = 3,
  Turquoise = 4
}

public class CyberGrappleCrosshairSettings {
  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Crosshair")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-CrosshairSource")
  @runtimeProperty("ModSettings.description", "CyberGrapple-CrosshairSource-Description")
  @runtimeProperty("ModSettings.displayValues.Mod", "CyberGrapple-CrosshairSource-Mod")
  @runtimeProperty("ModSettings.displayValues.Game", "CyberGrapple-CrosshairSource-Game")
  public let source: CyberGrappleCrosshairSource = CyberGrappleCrosshairSource.Mod;

  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Crosshair")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-CrosshairPick")
  @runtimeProperty("ModSettings.description", "CyberGrapple-CrosshairPick-Description")
  @runtimeProperty("ModSettings.displayValues.Simple", "CyberGrapple-CrosshairShape-Simple")
  @runtimeProperty("ModSettings.displayValues.Basic", "CyberGrapple-CrosshairShape-Basic")
  @runtimeProperty("ModSettings.displayValues.Shotgun", "CyberGrapple-CrosshairShape-Shotgun")
  @runtimeProperty("ModSettings.displayValues.SmartRifle", "CyberGrapple-CrosshairShape-SmartRifle")
  @runtimeProperty("ModSettings.displayValues.TechCircle", "CyberGrapple-CrosshairShape-TechCircle")
  @runtimeProperty("ModSettings.displayValues.TechHex", "CyberGrapple-CrosshairShape-TechHex")
  @runtimeProperty("ModSettings.displayValues.Launcher", "CyberGrapple-CrosshairShape-Launcher")
  @runtimeProperty("ModSettings.displayValues.MantisBlades", "CyberGrapple-CrosshairShape-MantisBlades")
  @runtimeProperty("ModSettings.displayValues.HeavyMachineGun", "CyberGrapple-CrosshairShape-HeavyMachineGun")
  @runtimeProperty("ModSettings.displayValues.Dot", "CyberGrapple-CrosshairShape-Dot")
  public let shape: CyberGrappleCrosshairShape = CyberGrappleCrosshairShape.Simple;

  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Crosshair")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-CrosshairColor")
  @runtimeProperty("ModSettings.description", "CyberGrapple-CrosshairColor-Description")
  @runtimeProperty("ModSettings.displayValues.Yellow", "CyberGrapple-CrosshairColor-Yellow")
  @runtimeProperty("ModSettings.displayValues.White", "CyberGrapple-CrosshairColor-White")
  @runtimeProperty("ModSettings.displayValues.Red", "CyberGrapple-CrosshairColor-Red")
  @runtimeProperty("ModSettings.displayValues.Green", "CyberGrapple-CrosshairColor-Green")
  @runtimeProperty("ModSettings.displayValues.Turquoise", "CyberGrapple-CrosshairColor-Turquoise")
  public let color: CyberGrappleCrosshairColor = CyberGrappleCrosshairColor.Yellow;

  // In per cent of the game's crosshairs: the game's dot is too small (Kevin, 9 November 2026). 60 by default since
  // 16 November 2026 (Kevin: "Taille du reticule on va mettre 60%").
  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Crosshair")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-CrosshairSize")
  @runtimeProperty("ModSettings.description", "CyberGrapple-CrosshairSize-Description")
  @runtimeProperty("ModSettings.step", "10.0")
  @runtimeProperty("ModSettings.min", "50.0")
  @runtimeProperty("ModSettings.max", "200.0")
  public let size: Float = 60.0;

  // The range indicator (CrosshairRange.reds). Its colour is red: a change of colour is seen at a glance, even in
  // daylight (docs/apex-grapple/portee/conception.md, decision 2).
  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Crosshair")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-CrosshairRange")
  @runtimeProperty("ModSettings.description", "CyberGrapple-CrosshairRange-Description")
  public let rangeIndicator: Bool = true;

  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Crosshair")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-CrosshairOutOfRangeColor")
  @runtimeProperty("ModSettings.description", "CyberGrapple-CrosshairOutOfRangeColor-Description")
  @runtimeProperty("ModSettings.displayValues.Yellow", "CyberGrapple-CrosshairColor-Yellow")
  @runtimeProperty("ModSettings.displayValues.White", "CyberGrapple-CrosshairColor-White")
  @runtimeProperty("ModSettings.displayValues.Red", "CyberGrapple-CrosshairColor-Red")
  @runtimeProperty("ModSettings.displayValues.Green", "CyberGrapple-CrosshairColor-Green")
  @runtimeProperty("ModSettings.displayValues.Turquoise", "CyberGrapple-CrosshairColor-Turquoise")
  @runtimeProperty("ModSettings.dependency", "rangeIndicator")
  public let outOfRangeColor: CyberGrappleCrosshairColor = CyberGrappleCrosshairColor.Red;
}

// The game's own theme colours (main_colors.inkstyle, 2.5), without their dark outline (Kevin: « sans les contours
// sombres »). Turquoise is the game's crosshair colour (Crosshair.mainColor = MainColors.Blue).
public func CyberGrappleCrosshairTint(color: CyberGrappleCrosshairColor) -> HDRColor {
  if Equals(color, CyberGrappleCrosshairColor.White) {
    return new HDRColor(1.0, 1.0, 1.0, 1.0);
  }
  if Equals(color, CyberGrappleCrosshairColor.Red) {
    return new HDRColor(1.1761, 0.3809, 0.3476, 1.0);
  }
  if Equals(color, CyberGrappleCrosshairColor.Green) {
    return new HDRColor(0.1137, 0.9294, 0.5137, 1.0);
  }
  if Equals(color, CyberGrappleCrosshairColor.Turquoise) {
    return new HDRColor(0.3686, 0.9647, 1.0, 1.0);
  }
  return new HDRColor(1.1192, 0.8441, 0.2565, 1.0);
}
