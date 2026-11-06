// The player's settings, shown by Mod Settings in Options > Mods when it is installed. Without Mod Settings the fields
// keep the values written here: automatic sprint and step up on, both speeds at the game's.
// Mod Settings updates the class's default values when a setting changes, so a new instance reads the current value;
// that is why each read below creates one instead of keeping one.
public class AutoSprintSettings {
  @runtimeProperty("ModSettings.mod", "Auto Sprint")
  @runtimeProperty("ModSettings.displayName", "AutoSprint-Enabled")
  @runtimeProperty("ModSettings.description", "AutoSprint-Enabled-Description")
  public let enabled: Bool = true;

  // Step, min and max of both speed sliders: AutoSprintSpeedSetting below holds the same three numbers.
  @runtimeProperty("ModSettings.mod", "Auto Sprint")
  @runtimeProperty("ModSettings.displayName", "AutoSprint-Speed")
  @runtimeProperty("ModSettings.description", "AutoSprint-Speed-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.5")
  @runtimeProperty("ModSettings.max", "5.0")
  public let sprintSpeed: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Auto Sprint")
  @runtimeProperty("ModSettings.displayName", "AutoSprint-WalkSpeed")
  @runtimeProperty("ModSettings.description", "AutoSprint-WalkSpeed-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.5")
  @runtimeProperty("ModSettings.max", "5.0")
  public let walkSpeed: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Auto Sprint")
  @runtimeProperty("ModSettings.displayName", "AutoSprint-StepUp")
  @runtimeProperty("ModSettings.description", "AutoSprint-StepUp-Description")
  public let stepUp: Bool = true;
}

public func AutoSprintIsEnabled() -> Bool {
  let settings: ref<AutoSprintSettings> = new AutoSprintSettings();
  return settings.enabled;
}

public func AutoSprintStepsUp() -> Bool {
  let settings: ref<AutoSprintSettings> = new AutoSprintSettings();
  return settings.stepUp;
}

public func AutoSprintSpeedFactor() -> Float {
  let settings: ref<AutoSprintSettings> = new AutoSprintSettings();
  return AutoSprintSpeedSetting(settings.sprintSpeed);
}

public func AutoSprintWalkFactor() -> Float {
  let settings: ref<AutoSprintSettings> = new AutoSprintSettings();
  return AutoSprintSpeedSetting(settings.walkSpeed);
}

// A speed slider's value as the mod uses it. Mod Settings adds the step in floats without rounding (ChangeValue in its
// packed.reds), so a slider brought back to 1.0 can read a hair above it, and the mod would take it for a faster speed;
// user.ini can also be edited by hand. Rounded to the slider's step and kept within its bounds.
public func AutoSprintSpeedSetting(value: Float) -> Float {
  let tenths: Float = Cast<Float>(RoundF(value * AutoSprintSliderStepsPerUnit()));
  return ClampF(tenths / AutoSprintSliderStepsPerUnit(), AutoSprintSlowestSetting(), AutoSprintFastestSetting());
}

// A step of 0.1.
public func AutoSprintSliderStepsPerUnit() -> Float {
  return 10.0;
}

public func AutoSprintSlowestSetting() -> Float {
  return 0.5;
}

public func AutoSprintFastestSetting() -> Float {
  return 5.0;
}
