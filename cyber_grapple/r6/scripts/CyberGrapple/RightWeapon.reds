// Made by fabrique/grapple.py from Apex Grapple's RightWeapon.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The weapon in V's right hand during a grapple. The shot sets the flag the game's launcher gesture sets when a weapon
// is out (leftHandCyberwareTransitions.script, 2.31 and 2.5): the upper body's state machine then puts the weapon away
// (upperBodyTransitions.script), and draws it again once the flag is gone. The flag goes when the pull ends, and only if
// the mod set it. With nothing in the right hand nothing is done: the flag would be set and taken off for nothing.
// Always, with no setting: kept in hand, the weapon went away all the same (the game never shows its launcher gesture
// with a weapon in hand; deduced), and a menu setting that does nothing has no place there.
// With something in the right hand at the shot, the arm (Arm.reds) waits until the weapon is put away, as the game's
// grenade throw waits before its own left-hand gesture (combatGadgetTransitions.script, CheckEquipDurationCondition).
// Raised earlier, it never rose: on 1 November from 01:02, implant out, the right hand was "equipped" at the shot, read
// empty one frame later while the upper body went into temporaryUnequip, and 7 shots of 8 left the arm down; the one
// that waited 0.35 s raised it, as did all 8 shots with empty hands (journal of 2026-11-01-etat-main-droite). The game
// reads the hand empty at once during a temporary unequip (UnequipCycleDecisions, equipment.script), while the weapon's
// put-away animation still plays for the time it gave it.

public class CyberGrappleRightWeapon extends IScriptable {
  public let shotAt: Float;
  public let flagSet: Bool;
  // The shot whose arm had to wait for the hand.
  public let waitedFor: Float;
}

// The arm rises at the latest this long after the shot, so that a weapon the game keeps in hand never leaves a grapple
// without its arm. Longer than a put-away time plus its margin (not measured: written in the log at each wait).
public func CyberGrappleRightHandLongestWait() -> Float {
  return 1.5;
}

// What the game's grenade throw adds to the put-away time before its gesture.
public func CyberGrappleRightHandPutAwayMargin() -> Float {
  return 0.2;
}

// The put-away time the game gave the right-hand weapon's animation (GetWeaponUnEquipDuration, equipment.script).
public func CyberGrappleRightHandPutAwayTime(stateContext: ref<StateContext>) -> Float {
  return stateContext.GetFloatParameter(n"rhUnequipDuration", true);
}

public func CyberGrappleRightHandItem(scriptInterface: ref<StateGameScriptInterface>) -> ref<ItemObject> {
  return scriptInterface.GetTransactionSystem().GetItemInSlot(scriptInterface.executionOwner, t"AttachmentSlots.WeaponRight");
}

// Read as the game's IsRightHandInUnequippedState reads it (defaultTransition.script), its waiting state included: the
// hand is empty there too.
public func CyberGrappleRightHandEmpty(state: CName) -> Bool {
  return Equals(state, n"None") || Equals(state, n"unequipped") || Equals(state, n"unequippedWaitingForExternalFactors");
}

public func CyberGrappleRightHandState(stateContext: ref<StateContext>) -> CName {
  let machine: StateMachineIdentifier;
  machine.definitionName = n"Equipment";
  machine.referenceName = n"RightHand";
  return stateContext.GetStateMachineCurrentStateWithIdentifier(machine);
}

public func CyberGrappleRightHandLetsArmRise(system: ref<CyberGrappleSystem>, now: Float, stateContext: ref<StateContext>) -> Bool {
  if !IsDefined(system.weapon) {
    system.weapon = new CyberGrappleRightWeapon();
  }
  let waited: Float = now - system.firedAt;
  let waiting: Bool = system.weapon.waitedFor == system.firedAt;
  let state: CName = CyberGrappleRightHandState(stateContext);
  let empty: Bool = CyberGrappleRightHandEmpty(state);
  // Empty at the shot: nothing to put away.
  if !waiting && empty {
    return true;
  }
  if !waiting {
    system.weapon.waitedFor = system.firedAt;
    CyberGrappleLog("arm waits for V's right hand, in state " + NameToString(state));
    return false;
  }
  let putAway: Float = CyberGrappleRightHandPutAwayTime(stateContext);
  if empty && waited >= putAway + CyberGrappleRightHandPutAwayMargin() {
    CyberGrappleLog("arm raised " + ToString(waited) + " s after the shot, V's right hand empty and its weapon put away in " + ToString(putAway) + " s");
    return true;
  }
  if waited >= CyberGrappleRightHandLongestWait() {
    CyberGrappleLog("arm raised " + ToString(waited) + " s after the shot, too long: V's right hand in state " + NameToString(state) + ", put-away time " + ToString(putAway) + " s");
    return true;
  }
  return false;
}

public func CyberGrappleRightWeaponFrame(system: ref<CyberGrappleSystem>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !IsDefined(system.weapon) {
    system.weapon = new CyberGrappleRightWeapon();
  }
  let weapon: ref<CyberGrappleRightWeapon> = system.weapon;
  if system.phase != CyberGrappleIdle() && weapon.shotAt != system.firedAt {
    weapon.shotAt = system.firedAt;
    if IsDefined(CyberGrappleRightHandItem(scriptInterface)) {
      stateContext.SetPermanentBoolParameter(n"forceTempUnequipWeapon", true, true);
      weapon.flagSet = true;
    }
    return;
  }
  if system.phase == CyberGrappleIdle() && weapon.flagSet {
    stateContext.RemovePermanentBoolParameter(n"forceTempUnequipWeapon");
    weapon.flagSet = false;
  }
}
