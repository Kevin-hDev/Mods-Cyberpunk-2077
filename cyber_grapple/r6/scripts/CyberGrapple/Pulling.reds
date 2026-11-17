// Made by fabrique/grapple.py from Apex Grapple's Pulling.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Each frame of a pull, in Borderlands 4's order (traction.py): the take-off, the stride since the last frame, the
// check that nothing solid stops V, the model, the push, then the ends. The push is the velocity wanted minus the one
// the game has, written as the state's impulse each frame (the lever of Air Strafe and Axle Slide); it acts once: in
// game the game's vertical speed followed the wanted one a frame of gravity behind, never beyond. V's velocity stays the
// mod's own from frame to frame, so the move keys, which reach V only through the game's own control, do nothing
// during a pull; the view steers it (Pull.reds).

// The angle between two directions, in degrees, for the log.
public func CyberGrappleAngle(a: Vector4, b: Vector4) -> Float {
  let lengths: Float = Vector4.Length(a) * Vector4.Length(b);
  if lengths <= CyberGrappleTiny() {
    return 0.0;
  }
  return Rad2Deg(AcosF(ClampF(Vector4.Dot(a, b) / lengths, -1.0, 1.0)));
}

@addMethod(LocomotionEventsTransition)
private final func CyberGrapplePullFrame(system: ref<CyberGrappleSystem>, key: CyberGrappleKey, settings: ref<CyberGrappleSettings>, now: Float, timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if system.comesToV {
    this.CyberGrappleYankFrame(system, key, settings, now, stateContext, scriptInterface);
    return;
  }
  if system.bikeComes {
    this.CyberGrappleBikeFrame(system, key, settings, now, stateContext, scriptInterface);
    return;
  }
  if CyberGrappleOnLadder(stateContext) {
    this.CyberGrappleLadderWait(system, now, scriptInterface);
    return;
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let middle: Vector4 = feet + DefaultTransition.GetUpVector() * CyberGrappleMiddleHeight();
  let stride: Float = Vector4.Distance(middle, system.lastPosition);
  system.lastPosition = middle;
  let game: Vector4 = CyberGrappleVelocityNow(system, scriptInterface);
  let held: Float = now - system.startedAt;
  let onGround: Bool = scriptInterface.IsOnGround();
  let takingOff: Bool = CyberGrappleTakingOff(held, settings.takeOffTime);
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
    system.jumpLetGoAt = now;
  }
  if StrLen(reason) == 0 && this.CyberGrappleStuck(system, game, takingOff, timeDelta) {
    reason = "hit something";
  }
  if StrLen(reason) > 0 {
    this.CyberGrappleEndPull(system, reason, now, scriptInterface);
    return;
  }
  // Again each frame while on the floor: the game walks V as soon as a floor is under V.
  let wanted: Vector4 = system.velocity;
  if takingOff && onGround && wanted.Z < settings.takeOffLift {
    wanted.Z = settings.takeOffLift;
  }
  let gravity: Float = AbsF(this.GetStaticFloatParameterDefault("downwardsGravity", CyberGrappleFallGravity()));
  let look: Vector4 = Transform.GetForward(CyberGrappleViewNow(system, scriptInterface));
  if Vector4.Dot(wanted, system.anchor - middle) > 0.0 {
    system.cameToward = true;
  }
  let pulls: Bool = !system.cameToward || CyberGrapplePastAnchor(wanted, middle, system.anchor) <= 0.0;
  wanted = CyberGrappleStep(wanted, middle, system.anchor, look, settings, system.pullCap, gravity, timeDelta, pulls);
  system.velocity = wanted;
  system.topSpeed = MaxF(system.topSpeed, Vector4.Length(wanted));
  // Again each frame: the game puts its speed hold back when a sprint or a dash ends (locomotionTransitions.script).
  stateContext.SetPermanentBoolParameter(n"TemporarySpeedLimitIgnore", true, true);
  system.push = wanted - game;
  system.pushAt = now;
  stateContext.SetTemporaryVectorParameter(n"impulse", system.push, true);
  let toAnchor: Vector4 = system.anchor - middle;
  let gap: Float = Vector4.Length(toAnchor);
  system.closest = MinF(system.closest, gap);
  system.turned = system.turned + CyberGrappleAngle(system.lastRope, toAnchor);
  system.lastRope = toAnchor;
  if CyberGrappleArrived(gap, system.near, stride) {
    reason = "arrived";
  } else {
    if CyberGrapplePassedBy(system.cameToward, CyberGrapplePastAnchor(wanted, middle, system.anchor), settings.letGoPastAnchor) {
      reason = "past the anchor";
    } else {
      if CyberGrappleOutOfTime(held, settings.longestPull) {
        reason = "longest pull";
      } else {
        if settings.letGoOnLanding && onGround && !takingOff {
          reason = "landed";
        }
      }
    }
  }
  if StrLen(reason) > 0 {
    this.CyberGrappleEndPull(system, reason, now, scriptInterface);
  }
}

// Over each stretch of the pull after the take-off, the distance the pull asked for against the one V went at the
// game's speed (Release.reds). The take-off is left out: a pull from the floor may catch an edge for a moment.
@addMethod(LocomotionEventsTransition)
private final func CyberGrappleStuck(system: ref<CyberGrappleSystem>, game: Vector4, takingOff: Bool, timeDelta: Float) -> Bool {
  if takingOff {
    system.stretchTime = 0.0;
    system.stretchAsked = 0.0;
    system.stretchWent = 0.0;
    return false;
  }
  let step: Float = ClampF(timeDelta, 0.0, CyberGrappleLongestFrame());
  system.stretchTime = system.stretchTime + step;
  system.stretchAsked = system.stretchAsked + Vector4.Length(system.velocity) * step;
  system.stretchWent = system.stretchWent + Vector4.Length(game) * step;
  if system.stretchTime < CyberGrappleStretchTime() {
    return false;
  }
  let stuck: Bool = CyberGrappleBlocked(system.stretchAsked, system.stretchWent);
  system.stretchTime = 0.0;
  system.stretchAsked = 0.0;
  system.stretchWent = 0.0;
  return stuck;
}

// The speed acquired is kept as it is: no braking (Borderlands 4). A pull ending in the air leaves the landing to come
// softened (Landing.reds) and the speed hold lifted until the ground (Ground.reds).
@addMethod(LocomotionEventsTransition)
private final func CyberGrappleEndPull(system: ref<CyberGrappleSystem>, reason: String, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  system.phase = CyberGrappleIdle();
  if system.comesToV {
    CyberGrappleEndYank(system, reason, now, scriptInterface);
    return;
  }
  if system.bikeComes {
    CyberGrappleEndBike(system, reason, now, scriptInterface);
    return;
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let middle: Vector4 = feet + DefaultTransition.GetUpVector() * CyberGrappleMiddleHeight();
  let onGround: Bool = scriptInterface.IsOnGround();
  // The grapple's flight goes on until V has stood on the ground a while, even if V is on it now: a pull that ends
  // "landed" may stand on a ledge or a wall's foot, high up.
  system.onGroundBefore = false;
  CyberGrappleLog("pull ended: " + reason + " after " + ToString(now - system.startedAt) + " s, " + ToString(Vector4.Distance(middle, system.startPosition)) + " m travelled, top speed " + ToString(system.topSpeed) + ", speed now " + ToString(Vector4.Length(DefaultTransition.GetLinearVelocity(scriptInterface))) + ", " + ToString(Vector4.Distance(middle, system.anchor)) + " m from the anchor (closest " + ToString(system.closest) + "), turned " + ToString(system.turned) + " deg round it, pushes written back " + ToString(system.pushesWrittenBack) + ", on the ground " + ToString(onGround) + ", state " + NameToString(this.GetStateName()));
}
