// The crosshair shown with empty hands or fists (Crosshair.reds): settings shared by every profile, in a group of
// their own above them, because the crosshair shows before any key is pressed. Without Mod Settings the fields keep
// the values written here. A field is never renamed: Mod Settings keeps the player's value under its name.
// Defaults (Kevin, 9 November 2026): shown, simple crosshair, yellow, at the game's size.

enum ApexGrappleCrosshairShape {
  Off = 0,
  Simple = 1,
  Basic = 2,
  Shotgun = 3,
  SmartRifle = 4,
  TechCircle = 5,
  TechHex = 6,
  Launcher = 7,
  MantisBlades = 8,
  HeavyMachineGun = 9,
  Dot = 10
}

enum ApexGrappleCrosshairColor {
  Yellow = 0,
  White = 1,
  Red = 2,
  Green = 3,
  Turquoise = 4
}

public class ApexGrappleCrosshairSettings {
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Crosshair")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-CrosshairShape")
  @runtimeProperty("ModSettings.description", "ApexGrapple-CrosshairShape-Description")
  @runtimeProperty("ModSettings.displayValues.Off", "ApexGrapple-CrosshairShape-Off")
  @runtimeProperty("ModSettings.displayValues.Simple", "ApexGrapple-CrosshairShape-Simple")
  @runtimeProperty("ModSettings.displayValues.Basic", "ApexGrapple-CrosshairShape-Basic")
  @runtimeProperty("ModSettings.displayValues.Shotgun", "ApexGrapple-CrosshairShape-Shotgun")
  @runtimeProperty("ModSettings.displayValues.SmartRifle", "ApexGrapple-CrosshairShape-SmartRifle")
  @runtimeProperty("ModSettings.displayValues.TechCircle", "ApexGrapple-CrosshairShape-TechCircle")
  @runtimeProperty("ModSettings.displayValues.TechHex", "ApexGrapple-CrosshairShape-TechHex")
  @runtimeProperty("ModSettings.displayValues.Launcher", "ApexGrapple-CrosshairShape-Launcher")
  @runtimeProperty("ModSettings.displayValues.MantisBlades", "ApexGrapple-CrosshairShape-MantisBlades")
  @runtimeProperty("ModSettings.displayValues.HeavyMachineGun", "ApexGrapple-CrosshairShape-HeavyMachineGun")
  @runtimeProperty("ModSettings.displayValues.Dot", "ApexGrapple-CrosshairShape-Dot")
  public let shape: ApexGrappleCrosshairShape = ApexGrappleCrosshairShape.Simple;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Crosshair")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-CrosshairColor")
  @runtimeProperty("ModSettings.description", "ApexGrapple-CrosshairColor-Description")
  @runtimeProperty("ModSettings.displayValues.Yellow", "ApexGrapple-CrosshairColor-Yellow")
  @runtimeProperty("ModSettings.displayValues.White", "ApexGrapple-CrosshairColor-White")
  @runtimeProperty("ModSettings.displayValues.Red", "ApexGrapple-CrosshairColor-Red")
  @runtimeProperty("ModSettings.displayValues.Green", "ApexGrapple-CrosshairColor-Green")
  @runtimeProperty("ModSettings.displayValues.Turquoise", "ApexGrapple-CrosshairColor-Turquoise")
  public let color: ApexGrappleCrosshairColor = ApexGrappleCrosshairColor.Yellow;

  // In per cent of the game's crosshairs: the game's dot is too small (Kevin, 9 November 2026).
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Crosshair")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-CrosshairSize")
  @runtimeProperty("ModSettings.description", "ApexGrapple-CrosshairSize-Description")
  @runtimeProperty("ModSettings.step", "10.0")
  @runtimeProperty("ModSettings.min", "50.0")
  @runtimeProperty("ModSettings.max", "200.0")
  public let size: Float = 100.0;
}

// The game's own theme colours (main_colors.inkstyle, 2.5), without their dark outline (Kevin: « sans les contours
// sombres »). Turquoise is the game's crosshair colour (Crosshair.mainColor = MainColors.Blue).
public func ApexGrappleCrosshairTint(color: ApexGrappleCrosshairColor) -> HDRColor {
  if Equals(color, ApexGrappleCrosshairColor.White) {
    return new HDRColor(1.0, 1.0, 1.0, 1.0);
  }
  if Equals(color, ApexGrappleCrosshairColor.Red) {
    return new HDRColor(1.1761, 0.3809, 0.3476, 1.0);
  }
  if Equals(color, ApexGrappleCrosshairColor.Green) {
    return new HDRColor(0.1137, 0.9294, 0.5137, 1.0);
  }
  if Equals(color, ApexGrappleCrosshairColor.Turquoise) {
    return new HDRColor(0.3686, 0.9647, 1.0, 1.0);
  }
  return new HDRColor(1.1192, 0.8441, 0.2565, 1.0);
}
