// Each frame of "Stay hooked" (Swing.reds). The phase stays the pull's, so the arm, the drawn rope, the sounds, the
// soft landing and the push written back at the end of a frame in the air go on as during a pull. During V's own
// flight the mod writes nothing to V's velocity: the game flies V, with its own control in the air, as after a pull
// that ended; only the game's speed hold stays lifted, as during the pull. Once the rope holds, the mod owns V's
// velocity again, the lever the pull measured (Pulling.reds): gravity, the rope, then push = wanted - game. From
// there neither the view nor the keys steer: in the simulation of 17 November 2026 the view, turning V's motion
// toward it, held V up in the air.

// Under this speed, V in the game's unsecure footing fall stands on the edge that started it (on a ledge in Kevin's
// trial of 18 November 2026, 0 to 2.4 m/s). The game keeps that fall state through a whole flight: counted as the
// ground at any speed, it let go of V in the air at 11 to 39 m/s, seven times in trials 4 and 5.
public func ApexGrappleOnEdgeSpeed() -> Float {
  return 4.0;
}

// `hangs`: the length V hangs on in the end, the pull's arrival distance. After a blow farther than that, V's own
// distance: reeled in, V would be dragged against what stopped V (Pulling.reds).
@addMethod(LocomotionEventsTransition)
private final func ApexGrappleSwingStart(system: ref<ApexGrappleSystem>, why: String, velocity: Vector4, middle: Vector4, hangs: Float, now: Float) -> Void {
  let gap: Float = Vector4.Distance(middle, system.anchor);
  system.velocity = velocity;
  system.swinging = true;
  system.swingStage = ApexGrappleSwingFlies();
  system.ropeLength = gap;
  system.swingHangs = hangs;
  system.swingKeptAt = gap;
  system.swingStartedAt = now;
  system.swingHeldAt = now;
  system.swingTaut = 0;
  system.swingAdopted = 0;
  system.swingPaidTook = 0.0;
  system.swingRopeTook = 0.0;
  system.swingHardest = 0.0;
  system.swingFarthest = gap;
  system.swingPushesBefore = system.pushesWrittenBack;
  system.swingGroundSince = -1.0;
  system.swingGroundTouches = 0;
  system.swingGroundFrames = 0;
  system.swingEdgeFrames = 0;
  ApexGrappleLog("rope kept: " + why + " after " + ToString(now - system.startedAt) + " s, " + ToString(gap) + " m from the anchor and " + ToString(system.anchor.Z - middle.Z) + " m under it, speed " + ToString(Vector4.Length(velocity)) + ", V flies on, to hang on " + ToString(hangs) + " m");
}

// V's own flight is over: the rope begins to hold, from the velocity the game gave that flight.
public func ApexGrappleSwingHolds(system: ref<ApexGrappleSystem>, middle: Vector4, gap: Float, now: Float) -> Void {
  system.swingStage = ApexGrappleSwingPaysOut();
  system.swingHeldAt = now;
  system.stretchTime = 0.0;
  system.stretchAsked = 0.0;
  system.stretchWent = 0.0;
  ApexGrappleLog("rope holds: V neither rises nor comes at the anchor " + ToString(now - system.swingStartedAt) + " s after the rope was kept, " + ToString(gap) + " m from the anchor and " + ToString(system.anchor.Z - middle.Z) + " m under it, speed " + ToString(Vector4.Length(system.velocity)));
}

// V no longer goes away: the rope takes V's distance and comes back in from there. Nearer than the length V hangs
// on, the rope is slack down to that length.
public func ApexGrappleSwingTurns(system: ref<ApexGrappleSystem>, gap: Float, now: Float) -> Void {
  system.swingStage = ApexGrappleSwingComesBack();
  system.ropeLength = gap;
  ApexGrappleLog("rope comes back in: V no longer goes away " + ToString(now - system.swingHeldAt) + " s after the rope began to hold, " + ToString(gap) + " m from the anchor, to hang on " + ToString(system.swingHangs) + " m, " + ToString(system.swingPaidTook) + " m/s taken while paying out, hardest slowing " + ToString(system.swingHardest) + " m/s2, speed now " + ToString(Vector4.Length(system.velocity)));
}

// On the ground the game walks V and the rope lets go once V has stood there a while (Ground.reds: a wall high up is
// read as ground for a moment), whatever "Let go on landing" says: that setting is the pull's, and nobody walks with a
// rope on the arm (Kevin, 17 November 2026: "arriver au sol la corde doit toujours lacher"). The rope keeps its length
// there. Paid out to V at each touch, it let V slide down a wall to the ground, most likely by such moments (Kevin,
// 18 November 2026: "V bute contre le plafon il touche le bord du mur verticale et ensuite descend jusqu'au sol"; the
// rope ended 17.6 m long instead of 8). The touches are counted for the log.
@addMethod(LocomotionEventsTransition)
private final func ApexGrappleSwingLanded(system: ref<ApexGrappleSystem>, game: Vector4, onEdge: Bool, now: Float) -> Bool {
  if system.swingGroundSince < 0.0 {
    system.swingGroundSince = now;
    system.swingGroundTouches = system.swingGroundTouches + 1;
  }
  system.swingGroundFrames = system.swingGroundFrames + 1;
  if onEdge {
    system.swingEdgeFrames = system.swingEdgeFrames + 1;
  }
  system.velocity = game;
  return now - system.swingGroundSince >= ApexGrappleSettleTime();
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleSwingFrame(system: ref<ApexGrappleSystem>, key: ApexGrappleKey, settings: ref<ApexGrappleSettings>, now: Float, timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let reason: String = this.ApexGrappleLetGoWhy(system, key, settings, now, stateContext, scriptInterface);
  if ApexGrappleOnLadder(stateContext) {
    reason = "V took a ladder";
  }
  let middle: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface) + DefaultTransition.GetUpVector() * ApexGrappleMiddleHeight();
  let game: Vector4 = ApexGrappleVelocityNow(system, scriptInterface);
  let toAnchor: Vector4 = system.anchor - middle;
  let gap: Float = Vector4.Length(toAnchor);
  // For the pull's last line, as during the pull (Pulling.reds).
  system.closest = MinF(system.closest, gap);
  system.turned = system.turned + ApexGrappleAngle(system.lastRope, toAnchor);
  system.lastRope = toAnchor;
  system.swingFarthest = MaxF(system.swingFarthest, gap);
  // An edge the game calls unsecure footing carries V as the ground does, though the game says V falls: held on one
  // by the rope, V stood 25 s beside the anchor (Kevin's trial of 18 November 2026).
  let onEdge: Bool = IsDefined(this as UnsecureFootingFallEvents) && Vector4.Length(game) < ApexGrappleOnEdgeSpeed();
  let onGround: Bool = scriptInterface.IsOnGround() || onEdge;
  if StrLen(reason) == 0 && onGround && this.ApexGrappleSwingLanded(system, game, onEdge, now) {
    reason = "landed";
  }
  if StrLen(reason) > 0 {
    this.ApexGrappleEndPull(system, reason, now, scriptInterface);
    return;
  }
  if onGround {
    return;
  }
  system.swingGroundSince = -1.0;
  // Again each frame, as during the pull: the game puts its speed hold back when a sprint or a dash ends
  // (locomotionTransitions.script). Ground.reds gives it back once V has stood on the ground.
  stateContext.SetPermanentBoolParameter(n"TemporarySpeedLimitIgnore", true, true);
  if system.swingStage == ApexGrappleSwingFlies() {
    system.velocity = game;
    system.ropeLength = gap;
    // V's own flight lasts while V rises, and until V goes away from the anchor: held while still coming at it, V
    // flew through the anchor's place and was caught hard a rope's length beyond (two arrivals level with the
    // anchor, replayed off the game on 18 November 2026: 69 and 75 m/s² in a frame).
    if game.Z > 0.0 || Vector4.Dot(game, toAnchor) >= 0.0 {
      return;
    }
    ApexGrappleSwingHolds(system, middle, gap, now);
  }
  // Against a wall or a ceiling, V goes on from the game's velocity instead of being pressed into it (Release.reds),
  // and the rope stays: in the air only the player lets go (Kevin, 18 November 2026: "si le joueur ne clic pas sur la
  // touche pour lacher, que le grapin ne lache pas"). A ray to the anchor let go of 12 ropes out of 39 in his trial,
  // taking the anchor's own building for an obstacle.
  if this.ApexGrappleStuck(system, game, false, timeDelta) {
    system.velocity = game;
    system.swingAdopted = system.swingAdopted + 1;
  }
  let gravity: Float = AbsF(this.GetStaticFloatParameterDefault("downwardsGravity", ApexGrappleFallGravity()));
  let took: Float = 0.0;
  let held: Float = 0.0;
  let taut: Bool = false;
  // Only the rope paying out says V no longer goes away.
  let away: Bool = true;
  let wanted: Vector4;
  if system.swingStage == ApexGrappleSwingPaysOut() {
    wanted = ApexGrappleSwingPayOut(system.velocity, middle, system.anchor, gravity, ApexGrappleSwingSoft(), timeDelta, took, away);
    system.ropeLength = gap;
  } else {
    let step: Float = ClampF(timeDelta, 0.0, ApexGrappleLongestFrame());
    system.ropeLength = MaxF(system.swingHangs, system.ropeLength - ApexGrappleSwingComesIn() * step);
    wanted = ApexGrappleSwingStep(system.velocity, middle, system.anchor, system.ropeLength, gravity, settings.pullStrength, timeDelta, held, taut);
  }
  ApexGrappleSwingCount(system, took, held, taut, timeDelta);
  system.velocity = wanted;
  system.topSpeed = MaxF(system.topSpeed, Vector4.Length(wanted));
  system.push = wanted - game;
  system.pushAt = now;
  stateContext.SetTemporaryVectorParameter(n"impulse", system.push, true);
  if !away {
    ApexGrappleSwingTurns(system, gap, now);
  }
}
