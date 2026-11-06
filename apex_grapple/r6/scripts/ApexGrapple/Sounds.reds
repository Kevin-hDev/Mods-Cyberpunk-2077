// The grapple's sounds: one per moment, played on V when the grapple's phase (Hook.reds) reaches it. The shot, the
// hook biting, the pull starting (the same frame as the bite), the let-go (the hook starts back) and the hook home in
// the hand. The game's own sounds only, played by name as the game plays its own (GameObject.PlaySoundEvent,
// gameObject.script). A name the game does not know plays nothing: these five were each heard in game, chosen by ear
// among five of the game's sounds for each moment.

public func ApexGrappleShotSound() -> CName {
  return n"w_cyb_launcher_fire";
}

public func ApexGrappleBiteSound() -> CName {
  return n"w_melee_blade_impact_thrown";
}

public func ApexGrapplePullSound() -> CName {
  return n"w_cyb_whip_wire_charge_intro";
}

public func ApexGrappleLetGoSound() -> CName {
  return n"w_cyb_whip_wire_back";
}

public func ApexGrappleHomeSound() -> CName {
  return n"w_cyb_mantis_unequip";
}

public class ApexGrappleSounds extends IScriptable {
  // The shot heard, by the time it was fired.
  public let shotAt: Float;
  public let bitten: Bool;
  public let letGo: Bool;
  public let home: Bool;
}

public func ApexGrappleSoundPlay(name: CName, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  GameObject.PlaySoundEvent(scriptInterface.executionOwner, name);
}

public func ApexGrappleSoundsFrame(system: ref<ApexGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !IsDefined(system.sounds) {
    system.sounds = new ApexGrappleSounds();
  }
  let sounds: ref<ApexGrappleSounds> = system.sounds;
  if system.phase != ApexGrappleIdle() && sounds.shotAt != system.firedAt {
    sounds.shotAt = system.firedAt;
    sounds.bitten = false;
    sounds.letGo = false;
    sounds.home = false;
    ApexGrappleSoundPlay(ApexGrappleShotSound(), scriptInterface);
    return;
  }
  if system.phase == ApexGrapplePulling() && !sounds.bitten {
    sounds.bitten = true;
    ApexGrappleSoundPlay(ApexGrappleBiteSound(), scriptInterface);
    ApexGrappleSoundPlay(ApexGrapplePullSound(), scriptInterface);
    return;
  }
  if system.phase == ApexGrappleIdle() && sounds.shotAt > 0.0 && !sounds.letGo {
    sounds.letGo = true;
    ApexGrappleSoundPlay(ApexGrappleLetGoSound(), scriptInterface);
    return;
  }
  if sounds.letGo && !sounds.home && !ApexGrappleHookStillOut(system) {
    sounds.home = true;
    ApexGrappleSoundPlay(ApexGrappleHomeSound(), scriptInterface);
  }
}
