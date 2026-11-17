// Made by fabrique/grapple.py from Apex Grapple's YankFrame.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Each frame of a person pulled to V (Yank.reds, YankDrive.reds) and its end, and why a pull of a person or a
// motorcycle is let go; the seconds after it in YankWatch.reds.

// The chest this close to the goal, along the ground: arrived.
public func CyberGrappleYankAtGoal() -> Float {
  return 1.0;
}

// Faster than this the physics ran away (the first test's pushes every frame reached 3,483 m/s), or the speed read is
// not the body's (fourth test: 1,012 m/s read, the brake worked out from it, the person ended 59 m away). Then the
// hook lets go.
public func CyberGrappleYankRunaway(yank: ref<CyberGrappleYank>) -> Float {
  return 2.0 * yank.drive.speed + 10.0;
}

// The chest this far above or below the goal has not reached it, however close along the ground: a person in a pit
// or under a balcony would be braked mid-climb.
public func CyberGrappleYankAtGoalHeight() -> Float {
  return 1.5;
}

// The chest's speed, from one frame to the next, half of it kept from the frames before: a single frame jolts.
public func CyberGrappleYankReadSpeed(yank: ref<CyberGrappleYank>, chest: Vector4, now: Float) -> Void {
  let step: Float = now - yank.lastAt;
  if step > CyberGrappleTiny() {
    yank.velocity = yank.velocity * 0.5 + (chest - yank.lastChest) / step * 0.5;
    yank.topSpeed = MaxF(yank.topSpeed, Vector4.Length(yank.velocity));
  }
  yank.lastChest = chest;
  yank.lastAt = now;
}

// Why a pull that brings a person or a motorcycle to V is let go; empty while it goes on.
@addMethod(LocomotionEventsTransition)
private final func CyberGrappleLetGoOfPulled(system: ref<CyberGrappleSystem>, key: CyberGrappleKey, settings: ref<CyberGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> String {
  let reason: String = this.CyberGrappleBlockedHere(system.stateName, stateContext, scriptInterface);
  if !settings.enabled {
    reason = "the mod was switched off";
  }
  if CyberGrappleLetGoByKey(settings.holdToKeepPulling, system.byHold, system.keyDown, system.releasedAt - system.pressedAt) {
    reason = "key released";
  }
  if key.pressed {
    reason = "a second press";
    CyberGrappleTakeKey(system, settings, now);
  }
  if scriptInterface.IsActionJustPressed(n"Jump") {
    reason = "jump";
  }
  return reason;
}

@addMethod(LocomotionEventsTransition)
private final func CyberGrappleYankFrame(system: ref<CyberGrappleSystem>, key: CyberGrappleKey, settings: ref<CyberGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let yank: ref<CyberGrappleYank> = system.yank;
  let person: ref<GameObject> = yank.person;
  let chest: Vector4 = system.anchor;
  let grab: ref<CyberGrappleGrab> = system.grab;
  let carried: String;
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  CyberGrappleYankReadSpeed(yank, chest, now);
  CyberGrappleDriveFollow(yank.drive, feet);
  let reason: String = this.CyberGrappleLetGoOfPulled(system, key, settings, now, stateContext, scriptInterface);
  if !IsDefined(person) {
    reason = "the person is gone";
  }
  if StrLen(reason) > 0 {
    this.CyberGrappleEndPull(system, reason, now, scriptInterface);
    return;
  }
  // A person brought standing for a grab (GrabCarry.reds): no push. A carry that failed has handed over to the
  // pushes below in this same frame.
  if IsDefined(grab) && grab.carried {
    carried = CyberGrappleGrabCarry(grab, yank, person, now, stateContext, scriptInterface);
    if StrLen(carried) > 0 {
      this.CyberGrappleEndPull(system, carried, now, scriptInterface);
      if Equals(carried, CyberGrappleGrabBrought()) {
        CyberGrappleGrabSend(grab, person, now, scriptInterface);
      }
      return;
    }
    if grab.carried {
      return;
    }
  }
  let drive: ref<CyberGrappleDrive> = yank.drive;
  if drive.beganAt <= 0.0 {
    if now - yank.startedAt < CyberGrappleYankThrowDelay() {
      return;
    }
    CyberGrappleDriveBegin(drive, chest, now);
  }
  let read: Float = Vector4.Length(yank.velocity);
  if read > CyberGrappleYankRunaway(yank) {
    this.CyberGrappleEndPull(system, "the body ran away at " + ToString(read) + " m/s", now, scriptInterface);
    return;
  }
  CyberGrappleDriveAim(drive, scriptInterface);
  let there: Int32 = CyberGrappleDriveArrived(drive, chest, yank.velocity, feet, CyberGrappleYankAtGoal(), CyberGrappleYankStop(), CyberGrappleYankAtGoalHeight());
  if there == 1 {
    CyberGrappleYankLand(yank, person, chest);
    this.CyberGrappleEndPull(system, "arrived", now, scriptInterface);
    return;
  }
  // Against the ground the lowered aim asked for: the ground stopped them, nothing more is done.
  if there == 2 {
    this.CyberGrappleEndPull(system, "thrown against the ground at " + ToString(read) + " m/s", now, scriptInterface);
    return;
  }
  if CyberGrappleDriveOverdue(drive, now) {
    this.CyberGrappleEndPull(system, "the person did not come: " + ToString(Vector4.Distance(chest, drive.goal)) + " m from the goal", now, scriptInterface);
    return;
  }
  let change: Vector4;
  if !CyberGrappleDriveDue(drive, yank.velocity, now) {
    return;
  }
  // From the first push on: of the 5 people not fallen at their first push in the fifteenth and sixteenth trials, 4
  // never fell.
  if yank.fallAsks < CyberGrappleYankMostFallAsks() && !CyberGrappleFallen(person) {
    CyberGrappleYankFallAgain(yank, person, scriptInterface.executionOwner);
  }
  if CyberGrappleDriveStep(drive, chest, yank.velocity, now, change) {
    CyberGrappleYankPush(person, chest, change);
    if CyberGrappleDriveTells(drive, now) {
      CyberGrappleLog("person pulled to V: " + CyberGrappleDrivePushText(drive, chest, read, change, now) + ", fallen " + ToString(CyberGrappleFallen(person)));
    }
  }
}

// A hook that lets go before the goal (second press, jump, key) does nothing to the person: they keep the speed they
// have, and fall or fly on with it.
public func CyberGrappleEndYank(system: ref<CyberGrappleSystem>, reason: String, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let yank: ref<CyberGrappleYank> = system.yank;
  let person: ref<GameObject> = yank.person;
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  if IsDefined(system.grab) && system.grab.carried {
    CyberGrappleGrabCarryEnd(system.grab, person, reason, now, scriptInterface);
  }
  CyberGrappleLog("person pulled to V ended: " + reason + " after " + ToString(now - yank.startedAt) + " s, from " + ToString(yank.startGap) + " m to " + ToString(Vector4.Length(CyberGrappleFlat(system.anchor - feet))) + " m from V and " + ToString(system.anchor.Z - feet.Z) + " m above V's feet, V moved " + ToString(Vector4.Distance(feet, yank.feetAtBite)) + " m since the bite, speed " + ToString(Vector4.Length(yank.velocity)) + " then, top speed " + ToString(yank.topSpeed) + ", " + CyberGrappleDriveEndText(yank.drive, now));
  CyberGrappleKeepSeen(scriptInterface.GetGame(), yank.personID, false, CyberGrappleYankSeenAfter());
  if IsDefined(person) {
    CyberGrappleYankWatchStart(yank, person, system.anchor, now);
  }
}
