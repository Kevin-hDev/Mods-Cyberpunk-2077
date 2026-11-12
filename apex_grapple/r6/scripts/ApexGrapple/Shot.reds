// The key between grapples, the shot, the hook's flight and its bite.

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleIdleFrame(system: ref<ApexGrappleSystem>, key: ApexGrappleKey, settings: ref<ApexGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if system.trajectory || system.speedLimitToRestore {
    this.ApexGrappleGroundFrame(system, now, stateContext, scriptInterface);
  }
  if !settings.enabled {
    return;
  }
  if key.pressed {
    system.waitingForHold = key.holdMode;
    if key.sharedTap {
      this.ApexGrappleShoot(system, settings, now, false, system.pendingShot, scriptInterface);
    } else {
      if !key.holdMode {
        this.ApexGrappleTryFire(system, settings, now, false, stateContext, scriptInterface);
      }
    }
    return;
  }
  if !key.held {
    if system.waitingForHold {
      ApexGrappleLog("press of " + ToString(system.releasedAt - system.pressedAt) + " s, shorter than the hold time " + ToString(settings.holdTime) + " s: left to the quick melee");
    }
    system.waitingForHold = false;
    return;
  }
  if system.waitingForHold && now - system.pressedAt >= settings.holdTime {
    system.waitingForHold = false;
    this.ApexGrappleTryFire(system, settings, now, true, stateContext, scriptInterface);
  }
}

// What a shot would do here and now: fire at aim, or why not, for the log. takesKey: the press is the grapple's even
// without a shot (the last hook is not back yet), so the game's quick melee must not strike.
public struct ApexGrappleShotCheck {
  let fires: Bool;
  let takesKey: Bool;
  let why: String;
  let aim: ApexGrappleAim;
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleCheckShot(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> ApexGrappleShotCheck {
  let check: ApexGrappleShotCheck;
  if ApexGrappleHookStillOut(system) {
    check.takesKey = true;
    check.why = "refused: the last hook is not back yet";
    return check;
  }
  let implant: String = ApexGrappleImplantRefusal(settings, scriptInterface.executionOwner);
  if StrLen(implant) > 0 {
    check.why = implant;
    return check;
  }
  let blocked: String = this.ApexGrappleBlockedHere(system.stateName, stateContext, scriptInterface);
  if StrLen(blocked) > 0 {
    check.why = "refused: " + blocked;
    return check;
  }
  check.aim = ApexGrappleAimNow(system, scriptInterface, settings);
  if !check.aim.found {
    check.why = "left to the game: " + check.aim.seen;
    return check;
  }
  check.fires = true;
  check.takesKey = true;
  return check;
}

// A press of the scanner's button, the quick melee key or an own key (Key.reds): the shot a tap would fire is decided
// now, and the quick melee held back from now if the press is the grapple's and the button strikes it, since the game
// strikes it at the same release as our shot, in an order between the two not known. During a grapple, a tap calls it
// off: held back too.
@addMethod(LocomotionEventsTransition)
private final func ApexGrappleSharedPress(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let none: ApexGrappleShotCheck;
  none.why = "refused: pressed during the last grapple";
  system.pendingShot = none;
  if !settings.enabled {
    return;
  }
  if system.phase == ApexGrappleIdle() {
    system.pendingShot = this.ApexGrappleCheckShot(system, settings, stateContext, scriptInterface);
    if !system.pendingShot.takesKey {
      return;
    }
  }
  if system.keyIsQuickMelee {
    system.holdBackUntil = now + ApexGrappleUntilRelease();
    system.holdBacks = system.holdBacks + 1;
  }
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleTryFire(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, now: Float, byHold: Bool, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  this.ApexGrappleShoot(system, settings, now, byHold, this.ApexGrappleCheckShot(system, settings, stateContext, scriptInterface), scriptInterface);
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleShoot(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, now: Float, byHold: Bool, check: ApexGrappleShotCheck, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  system.shots = system.shots + 1;
  if check.takesKey {
    ApexGrappleTakeKey(system, settings, now);
  }
  if !check.fires {
    ApexGrappleLog("shot " + ToString(system.shots) + " " + check.why);
    return;
  }
  let aim: ApexGrappleAim = check.aim;
  ApexGrappleLogSettingsIfChanged(system);
  // The grapple keeps its profile's settings as they are now, through its landing (Profiles.reds).
  system.profile = system.keyProfile;
  system.settings = settings;
  system.phase = ApexGrappleFlying();
  system.anchor = aim.anchor;
  ApexGrappleTakeTarget(system, settings, aim);
  // The game's grab key counts from the shot to the bite (GrabKey.reds).
  ApexGrappleGrabKeyRead(system, scriptInterface);
  system.firedAt = now;
  system.landsAt = now + aim.distance / ApexGrappleHookSpeedOf(settings);
  system.byHold = byHold;
  // The grapple has V's fall in hand from the shot, not from the bite: V once died of a 15 m fall with the hook still
  // 1.2 s from its point. A fall already darkening the screen becomes a grapple's flight.
  system.trajectory = true;
  if !settings.fallEffect {
    this.StopEffect(scriptInterface, n"falling");
  }
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  ApexGrappleLog("shot " + ToString(system.shots) + " fired" + (byHold ? " by a hold" : "") + ", profile " + ToString(system.profile) + ": " + aim.seen + ApexGrappleTargetText(system) + ", lands in " + ToString(system.landsAt - now) + " s, state " + NameToString(this.GetStateName()) + ", speed " + ToString(Vector4.Length(velocity)) + ", on the ground " + ToString(scriptInterface.IsOnGround()) + ", camera " + ToString(ApexGrappleCameraFromEyes(scriptInterface)) + " m from the eyes");
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleFlyingFrame(system: ref<ApexGrappleSystem>, key: ApexGrappleKey, settings: ref<ApexGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let reason: String = this.ApexGrappleBlockedHere(system.stateName, stateContext, scriptInterface);
  if !settings.enabled {
    reason = "the mod was switched off";
  }
  if key.pressed {
    reason = "a second press";
    ApexGrappleTakeKey(system, settings, now);
  }
  if StrLen(reason) > 0 {
    system.phase = ApexGrappleIdle();
    ApexGrappleLog("hook cancelled after " + ToString(now - system.firedAt) + " s: " + reason);
    return;
  }
  ApexGrappleGrabKeyRead(system, scriptInterface);
  if now >= system.landsAt {
    this.ApexGrappleAttach(system, settings, now, stateContext, scriptInterface);
  }
}

// The hook bites. The speed V already carries toward the anchor adds to the pull's cap: that is what chains one grapple
// into the next (Borderlands 4). Speed carried away from it does not lower the cap: a shot behind a running V pulls as
// hard as any, where Borderlands 4's cap dropped to a few metres a second. The game's speed hold is lifted for the
// pull, and put back as it was once V is on the ground again: the momentum is kept after the pull.
@addMethod(LocomotionEventsTransition)
private final func ApexGrappleAttach(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  // A person comes to V: pulled ("Pull people to V"), or brought for the game's grab, its key seen (Grab.reds).
  if (system.comesToV || system.grabKeySeen) && ApexGrappleStartYank(system, settings, now, ApexGrappleOnLadder(stateContext), scriptInterface) {
    return;
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let middle: Vector4 = feet + DefaultTransition.GetUpVector() * ApexGrappleMiddleHeight();
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  let rope: Vector4 = system.anchor - middle;
  let gap: Float = Vector4.Length(rope);
  let carried: Float = 0.0;
  let tilt: Float = 0.0;
  if gap > ApexGrappleTiny() {
    carried = Vector4.Dot(velocity, rope / gap);
    tilt = 90.0 - Rad2Deg(AcosF(ClampF(rope.Z / gap, -1.0, 1.0)));
  }
  system.phase = ApexGrapplePulling();
  system.startedAt = now;
  system.startPosition = middle;
  system.lastPosition = middle;
  system.closest = gap;
  system.lastRope = rope;
  system.turned = 0.0;
  system.cameToward = false;
  system.near = ApexGrappleArrivalForShot(settings.arrivalDistance, gap);
  system.pullCap = MaxF(carried, 0.0) + settings.pullSpeedCap;
  system.velocity = velocity;
  system.topSpeed = Vector4.Length(velocity);
  system.stretchTime = 0.0;
  system.stretchAsked = 0.0;
  system.stretchWent = 0.0;
  system.pushesWrittenBack = 0;
  system.ladderLeft = false;
  system.fromLadder = ApexGrappleOnLadder(stateContext);
  if !system.speedLimitToRestore {
    let before: StateResultBool = stateContext.GetPermanentBoolParameter(n"TemporarySpeedLimitIgnore");
    system.speedLimitBefore = before.valid && before.value;
    system.speedLimitToRestore = true;
  }
  stateContext.SetPermanentBoolParameter(n"TemporarySpeedLimitIgnore", true, true);
  let jumps: String = ApexGrappleGiveDoubleJumpBack(settings, stateContext);
  ApexGrappleLog("hook set after " + ToString(now - system.firedAt) + " s: " + ToString(gap) + " m to the anchor, rope " + ToString(tilt) + " deg above flat, speed " + ToString(Vector4.Length(velocity)) + " (" + ToString(carried) + " along the rope), arrival " + ToString(system.near) + " m, on the ground " + ToString(scriptInterface.IsOnGround()) + ", state " + NameToString(this.GetStateName()) + jumps);
}
