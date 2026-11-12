// Each frame of a person pulled to V (Yank.reds, YankFlight.reds) and its end; the seconds after it in YankWatch.reds.

// The chest this close to the goal, along the ground: arrived.
public func ApexGrappleYankAtGoal() -> Float {
  return 1.0;
}

// Later than the arrival planned by this much: the person did not come.
public func ApexGrappleYankLate() -> Float {
  return 0.6;
}

// Faster than this the physics ran away (the first test's pushes every frame reached 3,483 m/s), or the speed read is
// not the body's (fourth test: 1,012 m/s read, the brake worked out from it, the person ended 59 m away). Then no push.
public func ApexGrappleYankRunaway(yank: ref<ApexGrappleYank>) -> Float {
  return 2.0 * ApexGrappleYankMeant(yank) + 10.0;
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

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleYankFrame(system: ref<ApexGrappleSystem>, key: ApexGrappleKey, settings: ref<ApexGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let yank: ref<ApexGrappleYank> = system.yank;
  let person: ref<GameObject> = yank.person;
  let chest: Vector4 = system.anchor;
  let grab: ref<ApexGrappleGrab> = system.grab;
  let carried: String;
  ApexGrappleYankReadSpeed(yank, chest, now);
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
  if !IsDefined(person) {
    reason = "the person is gone";
  }
  if StrLen(reason) > 0 {
    this.ApexGrappleEndPull(system, reason, now, scriptInterface);
    return;
  }
  // A person brought standing for a grab (GrabCarry.reds): no throw. A carry that failed has handed over to the
  // throw below in this same frame.
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
  if yank.thrownAt <= 0.0 {
    if now - yank.startedAt >= ApexGrappleYankThrowDelay() {
      ApexGrappleYankThrow(yank, person, chest, now, scriptInterface);
    }
    return;
  }
  if Vector4.Length(yank.velocity) > ApexGrappleYankRunaway(yank) {
    yank.pushesOver = true;
    this.ApexGrappleEndPull(system, "the body ran away at " + ToString(Vector4.Length(yank.velocity)) + " m/s", now, scriptInterface);
    return;
  }
  let toGoal: Vector4 = ApexGrappleFlat(yank.goal - chest);
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  // Arrived, or past the goal along the throw's line, or by V: a fast body may cross the goal between two frames.
  if (Vector4.Length(toGoal) <= ApexGrappleYankAtGoal() && AbsF(chest.Z - yank.goal.Z) <= ApexGrappleYankAtGoalHeight()) || Vector4.Dot(toGoal, yank.line) <= 0.0 || Vector4.Length(ApexGrappleFlat(chest - feet)) <= ApexGrappleYankStop() {
    ApexGrappleYankLand(yank, person, chest);
    this.ApexGrappleEndPull(system, "arrived", now, scriptInterface);
    return;
  }
  if now > yank.arriveAt + ApexGrappleYankLate() {
    this.ApexGrappleEndPull(system, "the person did not come: " + ToString(Vector4.Length(toGoal)) + " m from the goal", now, scriptInterface);
    return;
  }
  if !yank.corrected && now >= (yank.thrownAt + yank.arriveAt) / 2.0 {
    ApexGrappleYankCorrect(yank, person, chest, now, scriptInterface);
  }
}

public func ApexGrappleEndYank(system: ref<ApexGrappleSystem>, reason: String, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let yank: ref<ApexGrappleYank> = system.yank;
  let person: ref<GameObject> = yank.person;
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let flight: Float = yank.thrownAt > 0.0 ? now - yank.thrownAt : 0.0;
  // Let go in flight (second press, jump, key, out of range...): braked as at the goal, not left flying past V.
  if IsDefined(person) && yank.thrownAt > 0.0 && !yank.pushesOver {
    ApexGrappleYankLand(yank, person, system.anchor);
  }
  if IsDefined(system.grab) && system.grab.carried {
    ApexGrappleGrabCarryEnd(system.grab, person, reason, now, scriptInterface);
  }
  ApexGrappleLog("person pulled to V ended: " + reason + " after " + ToString(now - yank.startedAt) + " s (" + ToString(flight) + " s of flight), from " + ToString(yank.startGap) + " m to " + ToString(Vector4.Length(ApexGrappleFlat(system.anchor - feet))) + " m from V, top speed " + ToString(yank.topSpeed) + ", correction " + (yank.skipped ? "skipped" : (yank.corrected ? "pushed" : "none")));
  ApexGrappleKeepSeen(scriptInterface.GetGame(), yank.personID, false, ApexGrappleYankSeenAfter());
  if IsDefined(person) {
    ApexGrappleYankWatchStart(yank, person, system.anchor, now);
  }
}
