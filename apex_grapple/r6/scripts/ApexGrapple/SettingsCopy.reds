// One copy of the settings for the whole mod, kept in the grapple's system (Hook.reds): made as the system attaches at
// each load, and again each time Mod Settings tells of a change, by one listener only, which then has the crosshair
// looked at again. Mod Settings writes the new values before it tells its listeners (its ModSettings.cpp, lines
// 505-511); with two listeners the order of their calls is not known, and the crosshair could have read the copy
// before it was made again. Each change makes new objects, never changes them in place: a grapple keeps the settings
// of its shot (Profiles.reds). Without Mod Settings the settings never change in game: the copy made at the load
// stands. Until the audit of 10 November 2026 (A1) a new ApexGrappleSettings was made at each frame instead.

public class ApexGrappleSettingsWatch extends IScriptable {
  public let system: wref<ApexGrappleSystem>;

  public cb func OnModSettingsChange() -> Void {
    let system: ref<ApexGrappleSystem> = this.system;
    if !IsDefined(system) {
      return;
    }
    ApexGrappleCopySettings(system);
    let host: ref<CrosshairGameControllerPersistentDot> = system.crosshairHost;
    if IsDefined(host) {
      host.ApexGrappleCrosshairRefresh();
    }
  }
}

@if(ModuleExists("ModSettingsModule"))
public func ApexGrappleSettingsWatchStart(watch: ref<ApexGrappleSettingsWatch>) -> Void {
  ModSettings.RegisterListenerToModifications(watch);
}

@if(ModuleExists("ModSettingsModule"))
public func ApexGrappleSettingsWatchStop(watch: ref<ApexGrappleSettingsWatch>) -> Void {
  if IsDefined(watch) {
    ModSettings.UnregisterListenerToModifications(watch);
  }
}

@if(!ModuleExists("ModSettingsModule"))
public func ApexGrappleSettingsWatchStart(watch: ref<ApexGrappleSettingsWatch>) -> Void {}

@if(!ModuleExists("ModSettingsModule"))
public func ApexGrappleSettingsWatchStop(watch: ref<ApexGrappleSettingsWatch>) -> Void {}

// The five profiles read from Mod Settings' values, profile 1 first: each profile's settings as the rest of the mod
// reads them (profiles 2 to 5 carry profile 1's master switch, ToSettings), whether it is on, and its own key, none for
// a profile that is off or for profile 1 on the quick melee key.
public func ApexGrappleCopySettings(system: ref<ApexGrappleSystem>) -> Void {
  let base: ref<ApexGrappleSettings> = new ApexGrappleSettings();
  let p2: ref<ApexGrappleProfile2> = new ApexGrappleProfile2();
  let p3: ref<ApexGrappleProfile3> = new ApexGrappleProfile3();
  let p4: ref<ApexGrappleProfile4> = new ApexGrappleProfile4();
  let p5: ref<ApexGrappleProfile5> = new ApexGrappleProfile5();
  let profiles: array<ref<ApexGrappleSettings>>;
  ArrayPush(profiles, base);
  ArrayPush(profiles, p2.ToSettings());
  ArrayPush(profiles, p3.ToSettings());
  ArrayPush(profiles, p4.ToSettings());
  ArrayPush(profiles, p5.ToSettings());
  let on: array<Bool>;
  ArrayPush(on, true);
  ArrayPush(on, p2.active);
  ArrayPush(on, p3.active);
  ArrayPush(on, p4.active);
  ArrayPush(on, p5.active);
  let keys: array<EInputKey>;
  ArrayPush(keys, base.ownKey ? base.key : EInputKey.IK_None);
  ArrayPush(keys, p2.OwnKey());
  ArrayPush(keys, p3.OwnKey());
  ArrayPush(keys, p4.OwnKey());
  ArrayPush(keys, p5.OwnKey());
  let any: Bool = false;
  for key in keys {
    if NotEquals(key, EInputKey.IK_None) {
      any = true;
    }
  }
  system.profiles = profiles;
  system.profilesOn = on;
  system.ownKeys = keys;
  system.anyOwnKey = any;
  system.settingsVersion = system.settingsVersion + 1;
}

// Profile `profile`'s settings in the copy, 1 to 5.
public func ApexGrappleProfileSettings(system: ref<ApexGrappleSystem>, profile: Int32) -> ref<ApexGrappleSettings> {
  if ArraySize(system.profiles) != ApexGrappleProfileCount() {
    ApexGrappleCopySettings(system);
  }
  return system.profiles[Clamp(profile, 1, ApexGrappleProfileCount()) - 1];
}

// The own keys' places this frame. With no own key set and no press or grapple under way, nothing could be pressed or
// held there: the listener is not asked (A1b). A press or a grapple under way reads on, whatever the menu says since.
public func ApexGrappleOwnKeysFor(system: ref<ApexGrappleSystem>, game: GameInstance) -> array<ApexGrappleOwnKey> {
  if !system.anyOwnKey && ApexGrappleKeyFree(system) {
    return ApexGrappleNoOwnKeys();
  }
  return ApexGrappleOwnKeysNow(game);
}
