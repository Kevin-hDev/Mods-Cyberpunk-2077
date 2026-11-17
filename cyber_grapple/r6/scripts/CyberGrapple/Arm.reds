// Made by fabrique/grapple.py from Apex Grapple's Arm.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// V's left arm during a grapple: the game's projectile launcher gesture, played by sending the animation graph the
// signals the launcher's own state machine sends (leftHandCyberwareTransitions.script); the gesture needs no launcher
// equipped, and one may be lent to the hand to show on it (Launcher.reds). Raised at the shot once V's right hand is
// empty (RightWeapon.reds), held through the flight, the pull and the hook's way back, then put back as the game leaves
// it: the rope starts in the hand, or at the lent launcher's barrel, until the hook is home. The grapple's phase
// (Hook.reds) is the one authority; the arm only follows it.
// The launcher's lowering signal (LeftHandCyberwareWaitForUnequip) is never sent: with it the camera dropped at once
// when V let go and came back up as the arm was put back; without it, seen in game, the camera stays still.
// Seen from outside (View.reds), no signal is sent, and the arm keeps its own pose: there, from the take-off on, the
// gesture and the left hand's item signals together hid V's left arm, seen in game; each alone, or none, did not.

public func CyberGrappleArmAtRest() -> Int32 {
  return 0;
}

public func CyberGrappleArmRaising() -> Int32 {
  return 1;
}

public func CyberGrappleArmHeld() -> Int32 {
  return 2;
}

// The pull is over and the arm stays up while the hook comes back to the hand.
public func CyberGrappleArmWaiting() -> Int32 {
  return 3;
}

// The values of AnimFeature_LeftHandCyberware.state the launcher's states send: at rest, equipping, charging.
public func CyberGrappleGestureRest() -> Int32 {
  return 0;
}

public func CyberGrappleGestureEquip() -> Int32 {
  return 1;
}

public func CyberGrappleGestureCharge() -> Int32 {
  return 2;
}

// The item type and state the launcher's equip state gives the left hand (SetLeftHandItemTypeAndState).
public func CyberGrappleLauncherItem() -> Int32 {
  return 2;
}

// No action duration, as the launcher sends at rest.
public func CyberGrappleNoDuration() -> Float {
  return -1.0;
}

// How long the gesture's raise and charge last: values that show the whole gesture, seen in game.
public func CyberGrappleArmHoldAfter() -> Float {
  return 0.12;
}

public func CyberGrappleArmRaiseDuration() -> Float {
  return 0.3;
}

public func CyberGrappleArmHoldDuration() -> Float {
  return 0.57;
}

// The arm waits at most as long as the hook takes to reel in this much rope, then is put back whatever happens, so that
// V's left hand is never left locked. Longer than any rope let go: the longest way back measured, 1.33 s at 50 m/s, is
// 66 m.
public func CyberGrappleLongestRopeBack() -> Float {
  return 250.0;
}

public class CyberGrappleArm extends IScriptable {
  public let stage: Int32;
  // The shot it serves, by the time it was fired.
  public let shotAt: Float;
  public let since: Float;
  public let state: Int32;
  public let charging: Bool;
  public let duration: Float;
  // The gesture's signals are up in the animation graph.
  public let sent: Bool;
  // One feature kept and filled again at each send, as the launcher's own states keep theirs (m_leftCWFeature,
  // leftHandCyberwareTransitions.script:24-42), rather than a new one each frame the arm is held (B14).
  public let feature: ref<AnimFeature_LeftHandCyberware>;
}

public func CyberGrappleArmSendGesture(arm: ref<CyberGrappleArm>, state: Int32, charging: Bool, duration: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !IsDefined(arm.feature) {
    arm.feature = new AnimFeature_LeftHandCyberware();
  }
  let feature: ref<AnimFeature_LeftHandCyberware> = arm.feature;
  feature.state = state;
  feature.actionDuration = duration;
  feature.isChargeAction = charging;
  scriptInterface.SetAnimationParameterFeature(n"LeftHandCyberware", feature, scriptInterface.executionOwner);
}

public func CyberGrappleArmSend(arm: ref<CyberGrappleArm>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  CyberGrappleArmSendGesture(arm, arm.state, arm.charging, arm.duration, scriptInterface);
}

// leftHandItemHandling, LeftHandItem and LeftHandAnimation, as the launcher's equip state sets them and its clean-up
// puts them back.
public func CyberGrappleArmHandSignals(up: Bool, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let handling: ref<AnimFeature_EquipUnequipItem> = new AnimFeature_EquipUnequipItem();
  handling.itemType = up ? CyberGrappleLauncherItem() : 0;
  handling.itemState = up ? CyberGrappleLauncherItem() : 0;
  scriptInterface.SetAnimationParameterFeature(n"leftHandItemHandling", handling, scriptInterface.executionOwner);
  let held: ref<AnimFeature_LeftHandItem> = new AnimFeature_LeftHandItem();
  held.itemInLeftHand = up;
  scriptInterface.SetAnimationParameterFeature(n"LeftHandItem", held, scriptInterface.executionOwner);
  let lock: ref<AnimFeature_LeftHandAnimation> = new AnimFeature_LeftHandAnimation();
  lock.lockLeftHandAnimation = up;
  scriptInterface.SetAnimationParameterFeature(n"LeftHandAnimation", lock, scriptInterface.executionOwner);
}

// Puts the gesture's signals up, from the arm's present step, or back at rest; true when it changed them.
public func CyberGrappleArmShow(arm: ref<CyberGrappleArm>, show: Bool, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if Equals(show, arm.sent) {
    return false;
  }
  arm.sent = show;
  if show {
    CyberGrappleArmHandSignals(true, scriptInterface);
    CyberGrappleArmSend(arm, scriptInterface);
    scriptInterface.PushAnimationEvent(n"LeftHandCyberwareReady");
  } else {
    CyberGrappleArmSendGesture(arm, CyberGrappleGestureRest(), false, CyberGrappleNoDuration(), scriptInterface);
    CyberGrappleArmHandSignals(false, scriptInterface);
  }
  return true;
}

public func CyberGrappleArmTo(arm: ref<CyberGrappleArm>, stage: Int32, now: Float) -> Void {
  arm.stage = stage;
  arm.since = now;
}

public func CyberGrappleArmFrame(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !IsDefined(system.arm) {
    system.arm = new CyberGrappleArm();
  }
  let arm: ref<CyberGrappleArm> = system.arm;
  CyberGrappleLauncherLeftInSave(system, scriptInterface.executionOwner);
  if system.phase != CyberGrappleIdle() {
    if arm.stage == CyberGrappleArmAtRest() || arm.shotAt != system.firedAt {
      // The last shot's launcher goes before the weapon is put away: lent during a put-away, the game took it off with
      // the weapon and the arm never rose (1 November 2026).
      CyberGrappleLauncherTakeBack(system, now, scriptInterface.executionOwner, "a new shot");
      if CyberGrappleRightHandLetsArmRise(system, now, stateContext) {
        CyberGrappleArmRaise(arm, system, settings, now, scriptInterface);
      }
      return;
    }
    if arm.stage == CyberGrappleArmRaising() && now - arm.since >= CyberGrappleArmHoldAfter() {
      CyberGrappleArmHold(arm, now);
    }
  } else {
    if arm.stage == CyberGrappleArmRaising() || arm.stage == CyberGrappleArmHeld() {
      // A pull let go before the arm reached its charge pose waits in that pose all the same.
      if arm.stage == CyberGrappleArmRaising() {
        CyberGrappleArmHold(arm, now);
      }
      CyberGrappleArmTo(arm, CyberGrappleArmWaiting(), now);
    }
    if arm.stage == CyberGrappleArmWaiting() {
      let waited: Float = now - arm.since;
      let home: Bool = !CyberGrappleHookStillOut(system);
      if home || waited >= CyberGrappleLongestRopeBack() / CyberGrappleHookReturnSpeedOf(settings) {
        CyberGrappleArmRest(system, arm, now, scriptInterface);
        if !home {
          CyberGrappleLog("arm put back " + ToString(waited) + " s after the pull ended, the hook not home: too long");
        }
        return;
      }
    }
  }
  if arm.stage == CyberGrappleArmAtRest() {
    return;
  }
  // The view can change during a grapple, by the player or by a mod.
  let eyes: Float = CyberGrappleEyesNow(system, scriptInterface);
  if CyberGrappleArmShow(arm, CyberGrappleNearEyes(eyes, arm.sent), scriptInterface) {
    CyberGrappleLog("the arm's gesture " + (arm.sent ? "sent again, V seen from the eyes" : "taken down, V seen from outside") + ": camera " + ToString(eyes) + " m from the eyes");
  }
  CyberGrappleLauncherFrame(system, arm, now, scriptInterface.executionOwner);
  // The launcher's charge state sends its signal every frame: so does the arm held up.
  if arm.sent && (arm.stage == CyberGrappleArmHeld() || arm.stage == CyberGrappleArmWaiting()) {
    CyberGrappleArmSend(arm, scriptInterface);
  }
}

public func CyberGrappleArmHold(arm: ref<CyberGrappleArm>, now: Float) -> Void {
  CyberGrappleArmTo(arm, CyberGrappleArmHeld(), now);
  arm.state = CyberGrappleGestureCharge();
  arm.charging = true;
  arm.duration = CyberGrappleArmHoldDuration();
}

public func CyberGrappleArmRaise(arm: ref<CyberGrappleArm>, system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  arm.shotAt = system.firedAt;
  CyberGrappleArmTo(arm, CyberGrappleArmRaising(), now);
  arm.state = CyberGrappleGestureEquip();
  arm.charging = false;
  arm.duration = CyberGrappleArmRaiseDuration();
  let show: Bool = CyberGrappleNearEyes(CyberGrappleEyesNow(system, scriptInterface), arm.sent);
  // A new shot raises the arm again from the start.
  if show {
    arm.sent = false;
  }
  CyberGrappleArmShow(arm, show, scriptInterface);
  CyberGrappleImplantShow(system, arm, settings, now, scriptInterface.executionOwner);
}

public func CyberGrappleArmRest(system: ref<CyberGrappleSystem>, arm: ref<CyberGrappleArm>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  CyberGrappleArmTo(arm, CyberGrappleArmAtRest(), now);
  arm.state = CyberGrappleGestureRest();
  arm.charging = false;
  arm.duration = CyberGrappleNoDuration();
  CyberGrappleArmShow(arm, false, scriptInterface);
  CyberGrappleLauncherTakeBack(system, now, scriptInterface.executionOwner, "arm put back");
}
