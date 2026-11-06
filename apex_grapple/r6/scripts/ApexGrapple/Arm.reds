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

public func ApexGrappleArmAtRest() -> Int32 {
  return 0;
}

public func ApexGrappleArmRaising() -> Int32 {
  return 1;
}

public func ApexGrappleArmHeld() -> Int32 {
  return 2;
}

// The pull is over and the arm stays up while the hook comes back to the hand.
public func ApexGrappleArmWaiting() -> Int32 {
  return 3;
}

// The values of AnimFeature_LeftHandCyberware.state the launcher's states send: at rest, equipping, charging.
public func ApexGrappleGestureRest() -> Int32 {
  return 0;
}

public func ApexGrappleGestureEquip() -> Int32 {
  return 1;
}

public func ApexGrappleGestureCharge() -> Int32 {
  return 2;
}

// The item type and state the launcher's equip state gives the left hand (SetLeftHandItemTypeAndState).
public func ApexGrappleLauncherItem() -> Int32 {
  return 2;
}

// No action duration, as the launcher sends at rest.
public func ApexGrappleNoDuration() -> Float {
  return -1.0;
}

// How long the gesture's raise and charge last: values that show the whole gesture, seen in game.
public func ApexGrappleArmHoldAfter() -> Float {
  return 0.12;
}

public func ApexGrappleArmRaiseDuration() -> Float {
  return 0.3;
}

public func ApexGrappleArmHoldDuration() -> Float {
  return 0.57;
}

// The arm waits at most as long as the hook takes to reel in this much rope, then is put back whatever happens, so that
// V's left hand is never left locked. Longer than any rope let go: the longest way back measured, 1.33 s at 50 m/s, is
// 66 m.
public func ApexGrappleLongestRopeBack() -> Float {
  return 250.0;
}

public class ApexGrappleArm extends IScriptable {
  public let stage: Int32;
  // The shot it serves, by the time it was fired.
  public let shotAt: Float;
  public let since: Float;
  public let state: Int32;
  public let charging: Bool;
  public let duration: Float;
  // The gesture's signals are up in the animation graph.
  public let sent: Bool;
}

public func ApexGrappleArmSendGesture(state: Int32, charging: Bool, duration: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let feature: ref<AnimFeature_LeftHandCyberware> = new AnimFeature_LeftHandCyberware();
  feature.state = state;
  feature.actionDuration = duration;
  feature.isChargeAction = charging;
  scriptInterface.SetAnimationParameterFeature(n"LeftHandCyberware", feature, scriptInterface.executionOwner);
}

public func ApexGrappleArmSend(arm: ref<ApexGrappleArm>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  ApexGrappleArmSendGesture(arm.state, arm.charging, arm.duration, scriptInterface);
}

// leftHandItemHandling, LeftHandItem and LeftHandAnimation, as the launcher's equip state sets them and its clean-up
// puts them back.
public func ApexGrappleArmHandSignals(up: Bool, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let handling: ref<AnimFeature_EquipUnequipItem> = new AnimFeature_EquipUnequipItem();
  handling.itemType = up ? ApexGrappleLauncherItem() : 0;
  handling.itemState = up ? ApexGrappleLauncherItem() : 0;
  scriptInterface.SetAnimationParameterFeature(n"leftHandItemHandling", handling, scriptInterface.executionOwner);
  let held: ref<AnimFeature_LeftHandItem> = new AnimFeature_LeftHandItem();
  held.itemInLeftHand = up;
  scriptInterface.SetAnimationParameterFeature(n"LeftHandItem", held, scriptInterface.executionOwner);
  let lock: ref<AnimFeature_LeftHandAnimation> = new AnimFeature_LeftHandAnimation();
  lock.lockLeftHandAnimation = up;
  scriptInterface.SetAnimationParameterFeature(n"LeftHandAnimation", lock, scriptInterface.executionOwner);
}

// Puts the gesture's signals up, from the arm's present step, or back at rest; true when it changed them.
public func ApexGrappleArmShow(arm: ref<ApexGrappleArm>, show: Bool, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if Equals(show, arm.sent) {
    return false;
  }
  arm.sent = show;
  if show {
    ApexGrappleArmHandSignals(true, scriptInterface);
    ApexGrappleArmSend(arm, scriptInterface);
    scriptInterface.PushAnimationEvent(n"LeftHandCyberwareReady");
  } else {
    ApexGrappleArmSendGesture(ApexGrappleGestureRest(), false, ApexGrappleNoDuration(), scriptInterface);
    ApexGrappleArmHandSignals(false, scriptInterface);
  }
  return true;
}

public func ApexGrappleArmTo(arm: ref<ApexGrappleArm>, stage: Int32, now: Float) -> Void {
  arm.stage = stage;
  arm.since = now;
}

public func ApexGrappleArmFrame(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !IsDefined(system.arm) {
    system.arm = new ApexGrappleArm();
  }
  let arm: ref<ApexGrappleArm> = system.arm;
  ApexGrappleLauncherLeftInSave(system, scriptInterface.executionOwner);
  if system.phase != ApexGrappleIdle() {
    if arm.stage == ApexGrappleArmAtRest() || arm.shotAt != system.firedAt {
      // The last shot's launcher goes before the weapon is put away: lent during a put-away, the game took it off with
      // the weapon and the arm never rose (1 November 2026).
      ApexGrappleLauncherTakeBack(system, now, scriptInterface.executionOwner, "a new shot");
      if ApexGrappleRightHandLetsArmRise(system, now, stateContext) {
        ApexGrappleArmRaise(arm, system, settings, now, scriptInterface);
      }
      return;
    }
    if arm.stage == ApexGrappleArmRaising() && now - arm.since >= ApexGrappleArmHoldAfter() {
      ApexGrappleArmHold(arm, now);
    }
  } else {
    if arm.stage == ApexGrappleArmRaising() || arm.stage == ApexGrappleArmHeld() {
      // A pull let go before the arm reached its charge pose waits in that pose all the same.
      if arm.stage == ApexGrappleArmRaising() {
        ApexGrappleArmHold(arm, now);
      }
      ApexGrappleArmTo(arm, ApexGrappleArmWaiting(), now);
    }
    if arm.stage == ApexGrappleArmWaiting() {
      let waited: Float = now - arm.since;
      let home: Bool = !ApexGrappleHookStillOut(system);
      if home || waited >= ApexGrappleLongestRopeBack() / ApexGrappleHookReturnSpeedOf(settings) {
        ApexGrappleArmRest(system, arm, now, scriptInterface);
        if !home {
          ApexGrappleLog("arm put back " + ToString(waited) + " s after the pull ended, the hook not home: too long");
        }
        return;
      }
    }
  }
  if arm.stage == ApexGrappleArmAtRest() {
    return;
  }
  // The view can change during a grapple, by the player or by a mod.
  let eyes: Float = ApexGrappleCameraFromEyes(scriptInterface);
  if ApexGrappleArmShow(arm, ApexGrappleNearEyes(eyes, arm.sent), scriptInterface) {
    ApexGrappleLog("the arm's gesture " + (arm.sent ? "sent again, V seen from the eyes" : "taken down, V seen from outside") + ": camera " + ToString(eyes) + " m from the eyes");
  }
  ApexGrappleLauncherFrame(system, arm, now, scriptInterface.executionOwner);
  // The launcher's charge state sends its signal every frame: so does the arm held up.
  if arm.sent && (arm.stage == ApexGrappleArmHeld() || arm.stage == ApexGrappleArmWaiting()) {
    ApexGrappleArmSend(arm, scriptInterface);
  }
}

public func ApexGrappleArmHold(arm: ref<ApexGrappleArm>, now: Float) -> Void {
  ApexGrappleArmTo(arm, ApexGrappleArmHeld(), now);
  arm.state = ApexGrappleGestureCharge();
  arm.charging = true;
  arm.duration = ApexGrappleArmHoldDuration();
}

public func ApexGrappleArmRaise(arm: ref<ApexGrappleArm>, system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  arm.shotAt = system.firedAt;
  ApexGrappleArmTo(arm, ApexGrappleArmRaising(), now);
  arm.state = ApexGrappleGestureEquip();
  arm.charging = false;
  arm.duration = ApexGrappleArmRaiseDuration();
  let show: Bool = ApexGrappleNearEyes(ApexGrappleCameraFromEyes(scriptInterface), arm.sent);
  // A new shot raises the arm again from the start.
  if show {
    arm.sent = false;
  }
  ApexGrappleArmShow(arm, show, scriptInterface);
  ApexGrappleImplantShow(system, arm, settings, now, scriptInterface.executionOwner);
}

public func ApexGrappleArmRest(system: ref<ApexGrappleSystem>, arm: ref<ApexGrappleArm>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  ApexGrappleArmTo(arm, ApexGrappleArmAtRest(), now);
  arm.state = ApexGrappleGestureRest();
  arm.charging = false;
  arm.duration = ApexGrappleNoDuration();
  ApexGrappleArmShow(arm, false, scriptInterface);
  ApexGrappleLauncherTakeBack(system, now, scriptInterface.executionOwner, "arm put back");
}
