// The player's settings, shown by Mod Settings in Options > Mods when it is installed.
// Without Mod Settings the field keeps the value written here: the mod stays on.
// Mod Settings updates the class's default values when a setting changes, so a new instance reads the
// current value (seen in game with Auto Sprint on 21 October 2026).
public class OmniSprintSettings {
  @runtimeProperty("ModSettings.mod", "Omni Sprint")
  @runtimeProperty("ModSettings.displayName", "OmniSprint-Enabled")
  @runtimeProperty("ModSettings.description", "OmniSprint-Enabled-Description")
  public let enabled: Bool = true;
}

public func OmniSprintIsEnabled() -> Bool {
  let settings: ref<OmniSprintSettings> = new OmniSprintSettings();
  return settings.enabled;
}
