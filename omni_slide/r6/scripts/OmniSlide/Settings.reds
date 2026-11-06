// The player's settings, shown by Mod Settings in Options > Mods when it is installed.
// Without Mod Settings the fields keep the values written here: the mod stays on.
// Mod Settings updates the class's default values when a setting changes, so a new instance reads the
// current value (seen in game with Auto Sprint on 21 October 2026).
// The slider bounds written in the annotations are repeated in the functions below, which apply them.
public class OmniSlideSettings {
  @runtimeProperty("ModSettings.mod", "Omni Slide")
  @runtimeProperty("ModSettings.displayName", "OmniSlide-Enabled")
  @runtimeProperty("ModSettings.description", "OmniSlide-Enabled-Description")
  public let enabled: Bool = true;

  // No value under 1.0: the game's boost can only add speed, never take it away.
  @runtimeProperty("ModSettings.mod", "Omni Slide")
  @runtimeProperty("ModSettings.displayName", "OmniSlide-Speed")
  @runtimeProperty("ModSettings.description", "OmniSlide-Speed-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "5.0")
  public let slideSpeed: Float = 1.0;

  // At 1, a 12 degree descent keeps the speed (Slopes.reds).
  @runtimeProperty("ModSettings.mod", "Omni Slide")
  @runtimeProperty("ModSettings.displayName", "OmniSlide-Slopes")
  @runtimeProperty("ModSettings.description", "OmniSlide-Slopes-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "3.0")
  public let slopeStrength: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Omni Slide")
  @runtimeProperty("ModSettings.displayName", "OmniSlide-CrouchInAir")
  @runtimeProperty("ModSettings.description", "OmniSlide-CrouchInAir-Description")
  public let crouchInAir: Bool = true;
}

public func OmniSlideIsEnabled() -> Bool {
  let settings: ref<OmniSlideSettings> = new OmniSlideSettings();
  return settings.enabled;
}

public func OmniSlideSpeedFactor() -> Float {
  let settings: ref<OmniSlideSettings> = new OmniSlideSettings();
  return OmniSlideSliderValue(settings.slideSpeed, 1.0, 5.0);
}

public func OmniSlideSlopeStrength() -> Float {
  let settings: ref<OmniSlideSettings> = new OmniSlideSettings();
  return OmniSlideSliderValue(settings.slopeStrength, 0.0, 3.0);
}

public func OmniSlideKeepsCrouchInAir() -> Bool {
  let settings: ref<OmniSlideSettings> = new OmniSlideSettings();
  return settings.crouchInAir;
}

// A slider's value as the mod uses it. Mod Settings adds the step in floats without rounding, so a slider brought
// back to 1.0 can read a hair above it and the mod would take it for a faster slide; user.ini can also be edited by
// hand. Rounded to the step of 0.1 and kept within the slider's bounds.
public func OmniSlideSliderValue(value: Float, lowest: Float, highest: Float) -> Float {
  let tenths: Float = Cast<Float>(RoundF(value * OmniSlideSliderStepsPerUnit()));
  return ClampF(tenths / OmniSlideSliderStepsPerUnit(), lowest, highest);
}

public func OmniSlideSliderStepsPerUnit() -> Float {
  return 10.0;
}
