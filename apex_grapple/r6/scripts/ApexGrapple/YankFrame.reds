// Each frame of a person pulled to V (Yank.reds, YankDrive.reds) and its end, and why a pull of a person or a
// motorcycle is let go; the seconds after it in YankWatch.reds.

// The chest this close to the goal, along the ground: arrived.
public func ApexGrappleYankAtGoal() -> Float {
  return 1.0;
}

// Faster than this the physics ran away (the first test's pushes every frame reached 3,483 m/s), or the speed read is
// not the body's (fourth test: 1,012 m/s read, the brake worked out from it, the person ended 59 m away). Then the
// hook lets go.
public func ApexGrappleYankRunaway(yank: ref<ApexGrappleYank>) -> Float {
  return 2.0 * yank.drive.speed + 10.0;
}

// The chest this far above or below the goal has not reached it, however close along the ground: a person in a pit
// or under a balcony would be braked mid-climb.
public func ApexGrappleYankAtGoalHeight() -> Float {
  return 1.5;
}

// The chest's speed, from one frame to the next, half of it kept from the frames before: a single frame jolts.
public func ApexGrappleYankReadSpeed(yank: ref<ApexGrappleYank>, chest: Vector4, now: Float) -> Void {
  let step: Float = now - yank.lastAt;
  if step > ApexGrappleTiny() {
    yank.velocity = yank.velocity * 0.5 + (chest - yank.lastChest) / step * 0.5;
    yank.topSpeed = MaxF(yank.topSpeed, Vector4.Length(yank.velocity));
  }
  yank.lastChest = chest;
  yank.lastAt = now;
}

// Why a pull that brings a person or a motorcycle to V is let go; empty while it goes on.
@addMethod(LocomotionEventsTransition)
private final func ApexGrappleLetGoOfPulled(system: ref<ApexGrappleSystem>, key: ApexGrappleKey, settings: ref<ApexGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> String {
  let reason: String = this.ApexGrappleBlockedHere(system.stateName, stateContext, scriptInterface);
  if !settings.enabled {
    reason = "the mod was switched off";
  }
  if ApexGrappleLetGoByKey(settings.holdToKeepPulling, system.byHold, system.keyDown, system.releasedAt - system.pressedAt) {
    reason = "key released";
  }
  if key.pressed {
    reason = "a second press";
    ApexGrappleTakeKey(system, settings, now);
  }
  if scriptInterface.IsActionJustPressed(n"Jump") {
    reason = "jump";
  }
  return reason;
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleYankFrame(system: ref<ApexGrappleSystem>, key: ApexGrappleKey, settings: ref<ApexGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let yank: ref<ApexGrappleYank> = system.yank;
  let person: ref<GameObject> = yank.person;
  let chest: Vector4 = system.anchor;
  let grab: ref<ApexGrappleGrab> = system.grab;
  let carried: String;
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  ApexGrappleYankReadSpeed(yank, chest, now);
  ApexGrappleDriveFollow(yank.drive, feet);
  let reason: String = this.ApexGrappleLetGoOfPulled(system, key, settings, now, stateContext, scriptInterface);
  if !IsDefined(person) {
    reason = "the person is gone";
  }
  if StrLen(reason) > 0 {
    this.ApexGrappleEndPull(system, reason, now, scriptInterface);
    return;
  }
  // A person brought standing for a grab (GrabCarry.reds): no push. A carry that failed has handed over to the
  // pushes below in this same frame.
  if IsDefined(grab) && grab.carried {
    carried = ApexGrappleGrabCarry(grab, yank, person, now, stateContext, scriptInterface);
    if StrLen(carried) > 0 {
      this.ApexGrappleEndPull(system, carried, now, scriptInterface);
      if Equals(carried, ApexGrappleGrabBrought()) {
        ApexGrappleGrabSend(grab, person, now, scriptInterface);
      }
      return;
    }
    if grab.carried {
      return;
    }
  }
  let drive: ref<ApexGrappleDrive> = yank.drive;
  if drive.beganAt <= 0.0 {
    if now - yank.startedAt < ApexGrappleYankThrowDelay() {
      return;
    }
    ApexGrappleDriveBegin(drive, chest, now);
  }
  let read: Float = Vector4.Length(yank.velocity);
  if read > ApexGrappleYankRunaway(yank) {
    this.ApexGrappleEndPull(system, "the body ran away at " + ToString(read) + " m/s", now, scriptInterface);
    return;
  }
  ApexGrappleDriveAim(drive, scriptInterface);
  let there: Int32 = ApexGrappleDriveArrived(drive, chest, yank.velocity, feet, ApexGrappleYankAtGoal(), ApexGrappleYankStop(), ApexGrappleYankAtGoalHeight());
  if there == 1 {
    ApexGrappleYankLand(yank, person, chest);
    this.ApexGrappleEndPull(system, "arrived", now, scriptInterface);
    return;
  }
  // Against the ground the lowered aim asked for: the ground stopped them, nothing more is done.
  if there == 2 {
    this.ApexGrappleEndPull(system, "thrown against the ground at " + ToString(read) + " m/s", now, scriptInterface);
    return;
  }
  if ApexGrappleDriveOverdue(drive, now) {
    this.ApexGrappleEndPull(system, "the person did not come: " + ToString(Vector4.Distance(chest, drive.goal)) + " m from the goal", now, scriptInterface);
    return;
  }
  let change: Vector4;
  if !ApexGrappleDriveDue(drive, yank.velocity, now) {
    return;
  }
  // From the first push on: of the 5 people not fallen at their first push in the fifteenth and sixteenth trials, 4
  // never fell.
  if yank.fallAsks < ApexGrappleYankMostFallAsks() && !ApexGrappleFallen(person) {
    ApexGrappleYankFallAgain(yank, person, scriptInterface.executionOwner);
  }
  if ApexGrappleDriveStep(drive, chest, yank.velocity, now, change) {
    ApexGrappleYankPush(person, chest, change);
    if ApexGrappleDriveTells(drive, now) {
      ApexGrappleLog("person pulled to V: " + ApexGrappleDrivePushText(drive, chest, read, change, now) + ", fallen " + ToString(ApexGrappleFallen(person)));
    }
  }
}

// A hook that lets go before the goal (second press, jump, key) does nothing to the person: they keep the speed they
// have, and fall or fly on with it.
public func ApexGrappleEndYank(system: ref<ApexGrappleSystem>, reason: String, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let yank: ref<ApexGrappleYank> = system.yank;
  let person: ref<GameObject> = yank.person;
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  if IsDefined(system.grab) && system.grab.carried {
    ApexGrappleGrabCarryEnd(system.grab, person, reason, now, scriptInterface);
  }
  ApexGrappleLog("person pulled to V ended: " + reason + " after " + ToString(now - yank.startedAt) + " s, from " + ToString(yank.startGap) + " m to " + ToString(Vector4.Length(ApexGrappleFlat(system.anchor - feet))) + " m from V and " + ToString(system.anchor.Z - feet.Z) + " m above V's feet, V moved " + ToString(Vector4.Distance(feet, yank.feetAtBite)) + " m since the bite, speed " + ToString(Vector4.Length(yank.velocity)) + " then, top speed " + ToString(yank.topSpeed) + ", " + ApexGrappleDriveEndText(yank.drive, now));
  ApexGrappleKeepSeen(scriptInterface.GetGame(), yank.personID, false, ApexGrappleYankSeenAfter());
  if IsDefined(person) {
    ApexGrappleYankWatchStart(yank, person, system.anchor, now);
  }
}
