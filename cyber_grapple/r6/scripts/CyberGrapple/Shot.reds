// Made by fabrique/grapple.py from Apex Grapple's Shot.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The key between grapples, the shot, the hook's flight and its bite.

@addMethod(LocomotionEventsTransition)
private final func CyberGrappleIdleFrame(system: ref<CyberGrappleSystem>, key: CyberGrappleKey, settings: ref<CyberGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if system.trajectory || system.speedLimitToRestore {
    this.CyberGrappleGroundFrame(system, now, stateContext, scriptInterface);
  }
  if !settings.enabled {
    return;
  }
  if key.pressed {
    system.waitingForHold = key.holdMode;
    if key.sharedTap {
      this.CyberGrappleShoot(system, settings, now, false, system.pendingShot, scriptInterface);
    } else {
      if !key.holdMode {
        this.CyberGrappleTryFire(system, settings, now, false, stateContext, scriptInterface);
      }
    }
    return;
  }
  if !key.held {
    if system.waitingForHold {
      CyberGrappleLog("press of " + ToString(system.releasedAt - system.pressedAt) + " s, shorter than the hold time " + ToString(settings.holdTime) + " s: left to the game");
    }
    system.waitingForHold = false;
    return;
  }
  if system.waitingForHold && now - system.pressedAt >= settings.holdTime {
    system.waitingForHold = false;
    this.CyberGrappleTryFire(system, settings, now, true, stateContext, scriptInterface);
  }
}

// What a shot would do here and now: fire at aim, or why not, for the log. takesKey: the press is the grapple's even
// without a shot (the last hook is not back yet), so the game's quick melee must not strike.
public struct CyberGrappleShotCheck {
  let fires: Bool;
  let takesKey: Bool;
  let why: String;
  let aim: CyberGrappleAim;
}

@addMethod(LocomotionEventsTransition)
private final func CyberGrappleCheckShot(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> CyberGrappleShotCheck {
  let check: CyberGrappleShotCheck;
  if CyberGrappleHookStillOut(system) {
    check.takesKey = true;
    check.why = "refused: the last hook is not back yet";
    return check;
  }
  let implant: String = CyberGrappleImplantRefusal(settings, scriptInterface.executionOwner);
  if StrLen(implant) > 0 {
    check.why = implant;
    return check;
  }
  let blocked: String = this.CyberGrappleBlockedHere(system.stateName, stateContext, scriptInterface);
  if StrLen(blocked) > 0 {
    check.why = "refused: " + blocked;
    return check;
  }
  check.aim = CyberGrappleAimNow(system, scriptInterface, settings);
  if !check.aim.found {
    check.why = "left to the game: " + check.aim.seen;
    return check;
  }
  check.fires = true;
  check.takesKey = true;
  return check;
}

// A press of an own key on the scanner's button (Key.reds): the shot a tap would fire is decided
// now, and the quick melee held back from now if the press is the grapple's and the button strikes it, since the game
// strikes it at the same release as our shot, in an order between the two not known. During a grapple, a tap calls it
// off: held back too.
@addMethod(LocomotionEventsTransition)
private final func CyberGrappleSharedPress(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let none: CyberGrappleShotCheck;
  none.why = "refused: pressed during the last grapple";
  system.pendingShot = none;
  if !settings.enabled {
    return;
  }
  if system.phase == CyberGrappleIdle() {
    system.pendingShot = this.CyberGrappleCheckShot(system, settings, stateContext, scriptInterface);
    if !system.pendingShot.takesKey {
      return;
    }
  }
  if system.keyIsQuickMelee {
    system.holdBackUntil = now + CyberGrappleUntilRelease();
    system.holdBacks = system.holdBacks + 1;
  }
}

@addMethod(LocomotionEventsTransition)
private final func CyberGrappleTryFire(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, now: Float, byHold: Bool, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  this.CyberGrappleShoot(system, settings, now, byHold, this.CyberGrappleCheckShot(system, settings, stateContext, scriptInterface), scriptInterface);
}

@addMethod(LocomotionEventsTransition)
private final func CyberGrappleShoot(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, now: Float, byHold: Bool, check: CyberGrappleShotCheck, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  system.shots = system.shots + 1;
  if check.takesKey {
    CyberGrappleTakeKey(system, settings, now);
  }
  if !check.fires {
    CyberGrappleLog("shot " + ToString(system.shots) + " " + check.why);
    CyberGrappleRefusedSound(system, settings, now, scriptInterface);
    return;
  }
  let aim: CyberGrappleAim = check.aim;
  CyberGrappleLogSettingsIfChanged(system);
  // The grapple keeps its profile's settings as they are now, through its landing (Profiles.reds).
  system.profile = system.keyProfile;
  system.settings = settings;
  system.phase = CyberGrappleFlying();
  system.anchor = aim.anchor;
  CyberGrappleTakeTarget(system, settings, aim);
  // The game's grab key counts from the shot to the bite (GrabKey.reds).
  CyberGrappleGrabKeyRead(system, scriptInterface);
  system.firedAt = now;
  CyberGrappleChargeSpent(system, now);
  system.landsAt = now + aim.distance / CyberGrappleHookSpeedOf(settings);
  system.byHold = byHold;
  // The grapple has V's fall in hand from the shot, not from the bite: V once died of a 15 m fall with the hook still
  // 1.2 s from its point. A fall already darkening the screen becomes a grapple's flight.
  system.trajectory = true;
  if !settings.fallEffect {
    this.StopEffect(scriptInterface, n"falling");
  }
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  CyberGrappleLog("shot " + ToString(system.shots) + " fired" + (byHold ? " by a hold" : "") + ", profile " + ToString(system.profile) + ": " + aim.seen + CyberGrappleTargetText(system) + ", lands in " + ToString(system.landsAt - now) + " s, state " + NameToString(this.GetStateName()) + ", speed " + ToString(Vector4.Length(velocity)) + ", on the ground " + ToString(scriptInterface.IsOnGround()) + ", camera " + ToString(CyberGrappleCameraFromEyes(scriptInterface)) + " m from the eyes");
}

@addMethod(LocomotionEventsTransition)
private final func CyberGrappleFlyingFrame(system: ref<CyberGrappleSystem>, key: CyberGrappleKey, settings: ref<CyberGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let reason: String = this.CyberGrappleBlockedHere(system.stateName, stateContext, scriptInterface);
  if !settings.enabled {
    reason = "the mod was switched off";
  }
  if key.pressed {
    reason = "a second press";
    CyberGrappleTakeKey(system, settings, now);
  }
  if StrLen(reason) > 0 {
    system.phase = CyberGrappleIdle();
    CyberGrappleLog("hook cancelled after " + ToString(now - system.firedAt) + " s: " + reason);
    return;
  }
  CyberGrappleGrabKeyRead(system, scriptInterface);
  if now >= system.landsAt {
    this.CyberGrappleAttach(system, settings, now, stateContext, scriptInterface);
  }
}

// The hook bites. The speed V already carries toward the anchor adds to the pull's cap: that is what chains one grapple
// into the next (Borderlands 4). Speed carried away from it does not lower the cap: a shot behind a running V pulls as
// hard as any, where Borderlands 4's cap dropped to a few metres a second. The game's speed hold is lifted for the
// pull, and put back as it was once V is on the ground again: the momentum is kept after the pull.
@addMethod(LocomotionEventsTransition)
private final func CyberGrappleAttach(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  // A person comes to V: pulled ("Pull people to V"), or brought for the game's grab, its key seen (Grab.reds).
  if (system.comesToV || system.grabKeySeen) && CyberGrappleStartYank(system, settings, now, CyberGrappleOnLadder(stateContext), scriptInterface) {
    return;
  }
  if system.bikeComes && CyberGrappleStartBikePull(system, settings, now, scriptInterface) {
    return;
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let middle: Vector4 = feet + DefaultTransition.GetUpVector() * CyberGrappleMiddleHeight();
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  let rope: Vector4 = system.anchor - middle;
  let gap: Float = Vector4.Length(rope);
  let carried: Float = 0.0;
  let tilt: Float = 0.0;
  if gap > CyberGrappleTiny() {
    carried = Vector4.Dot(velocity, rope / gap);
    tilt = 90.0 - Rad2Deg(AcosF(ClampF(rope.Z / gap, -1.0, 1.0)));
  }
  system.phase = CyberGrapplePulling();
  system.startedAt = now;
  system.startPosition = middle;
  system.lastPosition = middle;
  system.closest = gap;
  system.lastRope = rope;
  system.turned = 0.0;
  system.cameToward = false;
  system.near = CyberGrappleArrivalForShot(settings.arrivalDistance, gap);
  system.pullCap = MaxF(carried, 0.0) + settings.pullSpeedCap;
  system.velocity = velocity;
  system.topSpeed = Vector4.Length(velocity);
  system.stretchTime = 0.0;
  system.stretchAsked = 0.0;
  system.stretchWent = 0.0;
  system.pushesWrittenBack = 0;
  system.ladderLeft = false;
  system.fromLadder = CyberGrappleOnLadder(stateContext);
  if !system.speedLimitToRestore {
    let before: StateResultBool = stateContext.GetPermanentBoolParameter(n"TemporarySpeedLimitIgnore");
    system.speedLimitBefore = before.valid && before.value;
    system.speedLimitToRestore = true;
  }
  stateContext.SetPermanentBoolParameter(n"TemporarySpeedLimitIgnore", true, true);
  let jumps: String = CyberGrappleGiveDoubleJumpBack(settings, stateContext);
  CyberGrappleLog("hook set after " + ToString(now - system.firedAt) + " s: " + ToString(gap) + " m to the anchor, rope " + ToString(tilt) + " deg above flat, speed " + ToString(Vector4.Length(velocity)) + " (" + ToString(carried) + " along the rope), arrival " + ToString(system.near) + " m, on the ground " + ToString(scriptInterface.IsOnGround()) + ", state " + NameToString(this.GetStateName()) + jumps);
}
