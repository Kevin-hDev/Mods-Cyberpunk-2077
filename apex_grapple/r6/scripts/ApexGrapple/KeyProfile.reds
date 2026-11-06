// Which profile's key the grapple reads. Between grapples, with no press under way, the first profile whose key was
// just pressed, from 1 up, reads it, and profile 1 when none was. During a press or a grapple that profile reads on
// alone: one grapple at a time, and the other profiles' presses are let go every frame, so that a press made during a
// grapple never fires once it ends.

public func ApexGrappleKeyFree(system: ref<ApexGrappleSystem>) -> Bool {
  return system.phase == ApexGrappleIdle() && !system.keyDown && !system.waitingForHold && !system.sharedDown;
}

// The settings of the profile whose key is read this frame: read fresh at each free frame, as before profiles, then
// kept from the frame its key was pressed. own: the own keys' places this frame (ApexGrappleOwnKeysNow). One
// ApexGrappleSettings made per frame, as before profiles.
public func ApexGrappleKeySettingsNow(system: ref<ApexGrappleSystem>, own: array<ApexGrappleOwnKey>, scriptInterface: ref<StateGameScriptInterface>) -> ref<ApexGrappleSettings> {
  let free: Bool = ApexGrappleKeyFree(system);
  let base: ref<ApexGrappleSettings> = new ApexGrappleSettings();
  if free {
    system.keyProfile = ApexGrapplePressedProfile(system, base, own, scriptInterface);
  }
  let i: Int32 = 0;
  while i < ArraySize(own) && i < ArraySize(system.ownPressesSeen) {
    if i + 1 != system.keyProfile {
      let state: ApexGrappleOwnKey = own[i];
      system.ownPressesSeen[i] = state.presses;
    }
    i += 1;
  }
  if free {
    system.keySettings = ApexGrappleSettingsOf(system.keyProfile, base);
  }
  if !IsDefined(system.keySettings) {
    system.keySettings = base;
  }
  // The master switch is no profile setting: kept live in the key's and the grapple's settings, as before profiles,
  // so that the mod switched off in the menu during a grapple ends it (Pulling.reds) and asks for no pieces.
  system.keySettings.enabled = base.enabled;
  if IsDefined(system.settings) {
    system.settings.enabled = base.enabled;
  }
  return system.keySettings;
}

// Profile 1 first, on the quick melee key or on its own key; then each own key, from profile 2 up.
public func ApexGrapplePressedProfile(system: ref<ApexGrappleSystem>, base: ref<ApexGrappleSettings>, own: array<ApexGrappleOwnKey>, scriptInterface: ref<StateGameScriptInterface>) -> Int32 {
  if !base.ownKey && scriptInterface.IsActionJustPressed(n"QuickMelee") {
    return 1;
  }
  let i: Int32 = 0;
  while i < ArraySize(own) && i < ArraySize(system.ownPressesSeen) {
    let state: ApexGrappleOwnKey = own[i];
    if state.held && state.presses != system.ownPressesSeen[i] {
      return i + 1;
    }
    i += 1;
  }
  return 1;
}
