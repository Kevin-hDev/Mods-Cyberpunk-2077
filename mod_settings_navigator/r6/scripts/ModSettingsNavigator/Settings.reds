// The mod's own page in Mod Settings. Mod Settings updates the class's default values when a setting changes, so the
// mod creates a new instance at each read instead of keeping one.
// Both are on by default: Kevin asked for both features, 10 November 2026. Off gives Mod Settings as it is.
public class ModSettingsNavigatorSettings {
  @runtimeProperty("ModSettings.mod", "Mod Settings Navigator")
  @runtimeProperty("ModSettings.displayName", "ModSettingsNavigator-Sections")
  @runtimeProperty("ModSettings.description", "ModSettingsNavigator-Sections-Description")
  public let collapsibleSections: Bool = true;

  @runtimeProperty("ModSettings.mod", "Mod Settings Navigator")
  @runtimeProperty("ModSettings.displayName", "ModSettingsNavigator-Position")
  @runtimeProperty("ModSettings.description", "ModSettingsNavigator-Position-Description")
  public let rememberPosition: Bool = true;
}
