// Made by fabrique/grapple.py from Apex Grapple's Sounds.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The grapple's sounds: one per moment, played on V when the grapple's phase (Hook.reds) reaches it. The shot, the
// hook biting, the pull starting (the same frame as the bite), the let-go (the hook starts back) and the hook home in
// the hand. The game's own sounds only, played by name as the game plays its own (GameObject.PlaySoundEvent,
// gameObject.script). A name the game does not know plays nothing: these five were each heard in game, chosen by ear
// among five of the game's sounds for each moment.

public func CyberGrappleShotSound() -> CName {
  return n"w_cyb_launcher_fire";
}

public func CyberGrappleBiteSound() -> CName {
  return n"w_melee_blade_impact_thrown";
}

public func CyberGrapplePullSound() -> CName {
  return n"w_cyb_whip_wire_charge_intro";
}

public func CyberGrappleLetGoSound() -> CName {
  return n"w_cyb_whip_wire_back";
}

public func CyberGrappleHomeSound() -> CName {
  return n"w_cyb_mantis_unequip";
}

public class CyberGrappleSounds extends IScriptable {
  // The shot heard, by the time it was fired.
  public let shotAt: Float;
  public let bitten: Bool;
  public let letGo: Bool;
  public let home: Bool;
}

public func CyberGrappleSoundPlay(name: CName, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  GameObject.PlaySoundEvent(scriptInterface.executionOwner, name);
}

public func CyberGrappleSoundsFrame(system: ref<CyberGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !IsDefined(system.sounds) {
    system.sounds = new CyberGrappleSounds();
  }
  let sounds: ref<CyberGrappleSounds> = system.sounds;
  if system.phase != CyberGrappleIdle() && sounds.shotAt != system.firedAt {
    sounds.shotAt = system.firedAt;
    sounds.bitten = false;
    sounds.letGo = false;
    sounds.home = false;
    CyberGrappleSoundPlay(CyberGrappleShotSound(), scriptInterface);
    return;
  }
  if system.phase == CyberGrapplePulling() && !sounds.bitten {
    sounds.bitten = true;
    CyberGrappleSoundPlay(CyberGrappleBiteSound(), scriptInterface);
    CyberGrappleSoundPlay(CyberGrapplePullSound(), scriptInterface);
    return;
  }
  if system.phase == CyberGrappleIdle() && sounds.shotAt > 0.0 && !sounds.letGo {
    sounds.letGo = true;
    CyberGrappleSoundPlay(CyberGrappleLetGoSound(), scriptInterface);
    return;
  }
  if sounds.letGo && !sounds.home && !CyberGrappleHookStillOut(system) {
    sounds.home = true;
    CyberGrappleSoundPlay(CyberGrappleHomeSound(), scriptInterface);
  }
}
