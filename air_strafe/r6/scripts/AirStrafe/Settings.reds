// The player's settings, shown by Mod Settings in Options > Mods when it is installed.
// Without Mod Settings the fields keep the values written here: the mod stays on.
// Mod Settings updates the class's default values when a setting changes, so a new instance reads the
// current value; that is why the mod creates one at each read instead of keeping one.
public class AirStrafeSettings {
  @runtimeProperty("ModSettings.mod", "Air Strafe")
  @runtimeProperty("ModSettings.displayName", "AirStrafe-Enabled")
  @runtimeProperty("ModSettings.description", "AirStrafe-Enabled-Description")
  public let enabled: Bool = true;

  // The fastest the momentum turns toward the keys' direction, in degrees a second. Started at Borderlands 4's
  // value, about 1 400; Kevin after essai 1 (22 October 2026): "I think 900 would be better by default".
  @runtimeProperty("ModSettings.mod", "Air Strafe")
  @runtimeProperty("ModSettings.displayName", "AirStrafe-Steering")
  @runtimeProperty("ModSettings.description", "AirStrafe-Steering-Description")
  @runtimeProperty("ModSettings.step", "50.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "3000.0")
  public let steering: Float = 900.0;

  // Kevin, 22 October 2026: the back key swings the momentum behind at full speed, as an option; off, it only slows.
  @runtimeProperty("ModSettings.mod", "Air Strafe")
  @runtimeProperty("ModSettings.displayName", "AirStrafe-BackTurn")
  @runtimeProperty("ModSettings.description", "AirStrafe-BackTurn-Description")
  public let backTurn: Bool = true;

  // Kevin, 22 October 2026: a key to spam for the tap strafe, as an option. Off by default: a player who has not
  // asked for it would get sharper turns from a key he uses for something else.
  @runtimeProperty("ModSettings.mod", "Air Strafe")
  @runtimeProperty("ModSettings.displayName", "AirStrafe-TapStrafe")
  @runtimeProperty("ModSettings.description", "AirStrafe-TapStrafe-Description")
  public let tapStrafe: Bool = false;

  // W, Kevin's choice after essai 2 (22 October 2026). Not the mouse wheel: it switches weapons in this game, and
  // Codeware's key events never brought a single wheel notch (essai 2 log).
  @runtimeProperty("ModSettings.mod", "Air Strafe")
  @runtimeProperty("ModSettings.displayName", "AirStrafe-TapKey")
  @runtimeProperty("ModSettings.description", "AirStrafe-TapKey-Description")
  @runtimeProperty("ModSettings.dependency", "tapStrafe")
  public let tapKey: EInputKey = EInputKey.IK_W;

  // Its own rate, Kevin: "pour qu'il soit indépendant". Twice the air strafe's 900 for the sharper turns of Apex's
  // tap strafe: a quarter turn in a twentieth of a second. To judge in game.
  @runtimeProperty("ModSettings.mod", "Air Strafe")
  @runtimeProperty("ModSettings.displayName", "AirStrafe-TapSteering")
  @runtimeProperty("ModSettings.description", "AirStrafe-TapSteering-Description")
  @runtimeProperty("ModSettings.dependency", "tapStrafe")
  @runtimeProperty("ModSettings.step", "50.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "3000.0")
  public let tapSteering: Float = 1800.0;
}

public func AirStrafeIsEnabled() -> Bool {
  let settings: ref<AirStrafeSettings> = new AirStrafeSettings();
  return settings.enabled;
}

public func AirStrafeSteeringRate() -> Float {
  let settings: ref<AirStrafeSettings> = new AirStrafeSettings();
  return settings.steering;
}

public func AirStrafeBackTurns() -> Bool {
  let settings: ref<AirStrafeSettings> = new AirStrafeSettings();
  return settings.backTurn;
}

public func AirStrafeTapEnabled() -> Bool {
  let settings: ref<AirStrafeSettings> = new AirStrafeSettings();
  return settings.tapStrafe;
}

public func AirStrafeTapKey() -> EInputKey {
  let settings: ref<AirStrafeSettings> = new AirStrafeSettings();
  return settings.tapKey;
}

public func AirStrafeTapSteeringRate() -> Float {
  let settings: ref<AirStrafeSettings> = new AirStrafeSettings();
  return settings.tapSteering;
}
