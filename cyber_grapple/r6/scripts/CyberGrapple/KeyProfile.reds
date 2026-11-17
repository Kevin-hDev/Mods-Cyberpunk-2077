// Made by fabrique/grapple.py from Apex Grapple's KeyProfile.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Which profile's key the grapple reads. Between grapples, with no press under way, the first profile whose key was
// just pressed, from 1 up, reads it, and profile 1 when none was. During a press or a grapple that profile reads on
// alone: one grapple at a time, and the other profiles' presses are let go every frame, so that a press made during a
// grapple never fires once it ends.

public func CyberGrappleKeyFree(system: ref<CyberGrappleSystem>) -> Bool {
  return system.phase == CyberGrappleIdle() && !system.keyDown && !system.waitingForHold && !system.sharedDown;
}

// The settings of the profile whose key is read this frame: taken from the copy at each free frame (SettingsCopy.reds),
// then kept from the frame its key was pressed. own: the own keys' places this frame (CyberGrappleOwnKeysFor).
public func CyberGrappleKeySettingsNow(system: ref<CyberGrappleSystem>, own: array<CyberGrappleOwnKey>, scriptInterface: ref<StateGameScriptInterface>) -> ref<CyberGrappleSettings> {
  let free: Bool = CyberGrappleKeyFree(system);
  let base: ref<CyberGrappleSettings> = CyberGrappleProfileSettings(system, 1);
  if free {
    system.keyProfile = CyberGrapplePressedProfile(system, base, own, scriptInterface);
  }
  let i: Int32 = 0;
  while i < ArraySize(own) && i < ArraySize(system.ownPressesSeen) {
    if i + 1 != system.keyProfile {
      let state: CyberGrappleOwnKey = own[i];
      system.ownPressesSeen[i] = state.presses;
    }
    i += 1;
  }
  if free {
    system.keySettings = CyberGrappleProfileSettings(system, system.keyProfile);
  }
  if !IsDefined(system.keySettings) {
    system.keySettings = base;
  }
  // The master switch is no profile setting: kept live in the key's and the grapple's settings, as before profiles,
  // so that the mod switched off in the menu during a grapple ends it (Pulling.reds) and asks for no pieces. On the
  // copy's own objects this writes the value they already hold (ToSettings).
  system.keySettings.enabled = base.enabled;
  if IsDefined(system.settings) {
    system.settings.enabled = base.enabled;
  }
  return system.keySettings;
}

// Profile 1 first, on the game's gadget key or on its own key; then each own key, from profile 2 up.
public func CyberGrapplePressedProfile(system: ref<CyberGrappleSystem>, base: ref<CyberGrappleSettings>, own: array<CyberGrappleOwnKey>, scriptInterface: ref<StateGameScriptInterface>) -> Int32 {
  if !base.ownKey && CyberGrappleGadgetKeyNow(system, scriptInterface) {
    return 1;
  }
  let i: Int32 = 0;
  while i < ArraySize(own) && i < ArraySize(system.ownPressesSeen) {
    let state: CyberGrappleOwnKey = own[i];
    if state.held && state.presses != system.ownPressesSeen[i] {
      return i + 1;
    }
    i += 1;
  }
  return 1;
}
