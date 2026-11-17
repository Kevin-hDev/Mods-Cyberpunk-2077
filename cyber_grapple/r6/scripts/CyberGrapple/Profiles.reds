// Made by fabrique/grapple.py from Apex Grapple's Profiles.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// How the mod reads its settings. Five profiles: profile 1 is CyberGrappleSettings (Settings.reds), profiles 2 to 5 are
// made from it (Profile2.reds to Profile5.reds), all read into one copy (SettingsCopy.reds). The rest of the mod reads
// one CyberGrappleSettings: the profile whose key is read (KeyProfile.reds), or the one that fired the grapple.

public func CyberGrappleProfileCount() -> Int32 {
  return 1;
}

// The grapple's settings: those of the profile that fired the last grapple, as they were at its shot, through its
// landing; before any shot this load, the fallback, or profile 1's.
public func CyberGrappleGrappleSettings(system: ref<CyberGrappleSystem>, opt fallback: ref<CyberGrappleSettings>) -> ref<CyberGrappleSettings> {
  if IsDefined(system.settings) {
    return system.settings;
  }
  if IsDefined(fallback) {
    return fallback;
  }
  return CyberGrappleProfileSettings(system, 1);
}

// The hook's speed as used, flight and way back alike: a settings file edited by hand to 0 would keep the hook out for
// good, and every shot after it refused.
public func CyberGrappleHookSpeedOf(settings: ref<CyberGrappleSettings>) -> Float {
  return MaxF(settings.hookSpeed, 1.0);
}

public func CyberGrappleHookReturnSpeedOf(settings: ref<CyberGrappleSettings>) -> Float {
  return CyberGrappleHookSpeedOf(settings) * MaxF(settings.hookReturn, 1.0);
}

// The speed people are pulled to V at ("Speed of what is pulled to V"): the time a pull may take is worked out from
// it, and a settings file edited by hand to 0 would divide by it.
public func CyberGrapplePulledSpeedOf(settings: ref<CyberGrappleSettings>) -> Float {
  return MaxF(settings.pulledSpeed, 1.0);
}

public func CyberGrappleKeyName(key: EInputKey) -> String {
  return NameToString(EnumValueToName(n"EInputKey", Cast<Int64>(EnumInt(key))));
}

// For the log: profile 1, each other profile that is on, and the keys two profiles share (the lower number fires).
public func CyberGrappleProfilesText(system: ref<CyberGrappleSystem>) -> String {
  let keys: array<EInputKey> = system.ownKeys;
  let text: String = "profile 1: " + CyberGrappleSettingsText(CyberGrappleProfileSettings(system, 1));
  let p: Int32 = 2;
  while p <= CyberGrappleProfileCount() {
    if NotEquals(keys[p - 1], EInputKey.IK_None) {
      text = text + "; profile " + ToString(p) + ": " + CyberGrappleSettingsText(CyberGrappleProfileSettings(system, p));
    }
    p += 1;
  }
  // Each shared key once, from the lowest profile that has it, the one that fires.
  let i: Int32 = 0;
  while i < ArraySize(keys) {
    if NotEquals(keys[i], EInputKey.IK_None) && CyberGrappleFirstWithKey(keys, i) {
      let j: Int32 = i + 1;
      while j < ArraySize(keys) {
        if Equals(keys[i], keys[j]) {
          text = text + "; profiles " + ToString(i + 1) + " and " + ToString(j + 1) + " share the key " + CyberGrappleKeyName(keys[i]) + ": profile " + ToString(i + 1) + " fires";
        }
        j += 1;
      }
    }
    i += 1;
  }
  return text;
}

// No profile before place i has the key at place i.
public func CyberGrappleFirstWithKey(keys: array<EInputKey>, i: Int32) -> Bool {
  let k: Int32 = 0;
  while k < i {
    if Equals(keys[k], keys[i]) {
      return false;
    }
    k += 1;
  }
  return true;
}

// What the game runs, for the log: a default changed in the sources is not what a player's saved settings hold.
public func CyberGrappleSettingsText(s: ref<CyberGrappleSettings>) -> String {
  return "enabled " + ToString(s.enabled) + ", implant " + CyberGrappleImplantName(s.implant) + ", launcher " + (s.requireLauncher ? "required" : "not required") + ", key " + (s.ownKey ? CyberGrappleKeyName(s.key) : "gadget key") + ", hold keyboard " + ToString(s.keyboardHold) + " controller " + ToString(s.controllerHold) + " " + ToString(s.holdTime) + " s, range " + ToString(s.range) + ", hook " + ToString(s.hookSpeed) + " back x" + ToString(s.hookReturn) + ", pull " + ToString(s.pullStrength) + " cap " + ToString(s.pullSpeedCap) + ", steering " + ToString(s.steerStrength) + ", carry " + ToString(s.ropeCarry) + " %, take-off " + ToString(s.takeOffLift) + " for " + ToString(s.takeOffTime) + " s, hold to keep pulling " + ToString(s.holdToKeepPulling) + ", arrival " + ToString(s.arrivalDistance) + ", let go past the anchor " + ToString(s.letGoPastAnchor) + ", longest " + ToString(s.longestPull) + ", let go on landing " + ToString(s.letGoOnLanding) + ", preserve jump " + ToString(s.preserveJump) + ", double jump back " + ToString(s.regainDoubleJump) + ", targets " + ToString(s.hookTargets) + " pull people " + ToString(s.pullPeople) + " at " + ToString(s.pulledSpeed) + " damage " + ToString(s.pullDamage) + " slam " + ToString(s.pullSlam) + " steer " + ToString(s.steerPeople) + ", motorcycles " + ToString(s.pullBikes) + ", grab " + ToString(s.grabPeople) + " at " + ToString(s.grabSpeed) + ", punch wins " + ToString(s.punchWins) + " within " + ToString(s.punchRange) + ", soft landing " + ToString(s.softLanding) + ", fall effect " + ToString(s.fallEffect) + ", dynamic FOV " + ToString(s.dynamicFov) + " +" + ToString(s.fovWidening) + " in " + ToString(s.fovTransition) + " s";
}
