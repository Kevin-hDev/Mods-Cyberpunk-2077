// The player's settings, shown by Mod Settings in Options > Mods when it is installed.
// Without Mod Settings the fields keep the values written here: the mod stays on.
// Mod Settings updates the class's default values when a setting changes, so a new object reads the current values;
// that is why the mod creates one where it needs them instead of keeping one.
public class WallClimbSettings {
  @runtimeProperty("ModSettings.mod", "Wall Climb")
  @runtimeProperty("ModSettings.displayName", "WallClimb-Enabled")
  @runtimeProperty("ModSettings.description", "WallClimb-Enabled-Description")
  public let enabled: Bool = true;

  // 4 m by default (Kevin, 31 October 2026); 3.6 m before, twice V's height as in our Borderlands 4 mod. In metres,
  // so the player reads a height. Up to 30 m: the climb of Revenant in Apex Legends goes to about 26.5 m.
  @runtimeProperty("ModSettings.mod", "Wall Climb")
  @runtimeProperty("ModSettings.displayName", "WallClimb-MaxHeight")
  @runtimeProperty("ModSettings.description", "WallClimb-MaxHeight-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "30.0")
  public let maxHeight: Float = 4.0;

  // A multiple of WallClimbClimbSpeed, so the player reads how many times faster V climbs.
  @runtimeProperty("ModSettings.mod", "Wall Climb")
  @runtimeProperty("ModSettings.displayName", "WallClimb-ClimbSpeed")
  @runtimeProperty("ModSettings.description", "WallClimb-ClimbSpeed-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "3.0")
  public let climbSpeed: Float = 1.0;

  // Off by default: V stopping on a wall lets go and falls, the normal case; on, V holds on as on a ladder (Hold.reds).
  @runtimeProperty("ModSettings.mod", "Wall Climb")
  @runtimeProperty("ModSettings.displayName", "WallClimb-HoldOn")
  @runtimeProperty("ModSettings.description", "WallClimb-HoldOn-Description")
  public let holdOn: Bool = false;

  // On by default, as in our Borderlands 4 mod: V grabs a wall again in the fall after a climb (Regrab.reds).
  @runtimeProperty("ModSettings.mod", "Wall Climb")
  @runtimeProperty("ModSettings.displayName", "WallClimb-Regrab")
  @runtimeProperty("ModSettings.description", "WallClimb-Regrab-Description")
  public let regrab: Bool = true;

  // Off by default: the game's ladder camera brought the view back level when V held on (LadderCamera.reds).
  @runtimeProperty("ModSettings.mod", "Wall Climb")
  @runtimeProperty("ModSettings.displayName", "WallClimb-LadderCamera")
  @runtimeProperty("ModSettings.description", "WallClimb-LadderCamera-Description")
  public let ladderCamera: Bool = false;

  // No damage on the landing after a climb (Landing.reds), on by default as in our grapple.
  @runtimeProperty("ModSettings.mod", "Wall Climb")
  @runtimeProperty("ModSettings.displayName", "WallClimb-SoftLanding")
  @runtimeProperty("ModSettings.description", "WallClimb-SoftLanding-Description")
  public let softLanding: Bool = true;

  // Off by default as in our grapple: the darkening of a long fall is hidden after a climb (FallEffect.reds).
  @runtimeProperty("ModSettings.mod", "Wall Climb")
  @runtimeProperty("ModSettings.displayName", "WallClimb-FallEffect")
  @runtimeProperty("ModSettings.description", "WallClimb-FallEffect-Description")
  public let fallEffect: Bool = false;
}

public func WallClimbCurrentSettings() -> ref<WallClimbSettings> {
  return new WallClimbSettings();
}
