// The player's settings, shown by Mod Settings in Options > Mods when it is installed.
// Without Mod Settings the fields keep the values written here: the mod stays on.
// Mod Settings updates the class's default values when a setting changes, so a new instance reads the
// current value; that is why the mod creates one at each read instead of keeping one.
// Defaults and bounds are Borderlands 4's Axle slide, validated by Kevin on 17 September 2026. The sliders' steps,
// 1 and 5 from 0, land on whole numbers: no rounding needed.
public class AxleSlideSettings {
  @runtimeProperty("ModSettings.mod", "Axle Slide")
  @runtimeProperty("ModSettings.displayName", "AxleSlide-Enabled")
  @runtimeProperty("ModSettings.description", "AxleSlide-Enabled-Description")
  public let enabled: Bool = true;

  // 350 is the turn rate Kevin settled on in Borderlands 4, after 220, 1000, 500 and 400; here it caps the turn
  // toward the keys' direction.
  @runtimeProperty("ModSettings.mod", "Axle Slide")
  @runtimeProperty("ModSettings.displayName", "AxleSlide-Steering")
  @runtimeProperty("ModSettings.description", "AxleSlide-Steering-Description")
  @runtimeProperty("ModSettings.step", "5.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1000.0")
  public let steering: Float = 350.0;

  // Up to 50 only to compare: Kevin wanted it "around 25 % but no more".
  @runtimeProperty("ModSettings.mod", "Axle Slide")
  @runtimeProperty("ModSettings.displayName", "AxleSlide-SpeedBoost")
  @runtimeProperty("ModSettings.description", "AxleSlide-SpeedBoost-Description")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "50.0")
  public let speedBoost: Float = 25.0;

  @runtimeProperty("ModSettings.mod", "Axle Slide")
  @runtimeProperty("ModSettings.displayName", "AxleSlide-FlatBoost")
  @runtimeProperty("ModSettings.description", "AxleSlide-FlatBoost-Description")
  @runtimeProperty("ModSettings.step", "5.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "200.0")
  public let flatBoost: Float = 50.0;

  @runtimeProperty("ModSettings.mod", "Axle Slide")
  @runtimeProperty("ModSettings.displayName", "AxleSlide-SlopeBoost")
  @runtimeProperty("ModSettings.description", "AxleSlide-SlopeBoost-Description")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "50.0")
  public let slopeBoost: Float = 25.0;
}

// One instance per read: each caller takes what it needs from it.
public func AxleSlideCurrentSettings() -> ref<AxleSlideSettings> {
  return new AxleSlideSettings();
}
