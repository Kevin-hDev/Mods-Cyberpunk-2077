// During a pull V flies, but the game keeps V in a ground state (stand, walk, sprint, slide): its fall starts only once
// V comes down faster than a landing speed (LocomotionAirDecisions.ShouldFall, scripts 2.31), and a pull goes up or
// level. In a ground state the game walks V with the move keys every frame (19 m/s with Auto Sprint's sprint: the keys
// steered the pulls), and other mods may write their own push there (Axle Slide in a slide). So as soon as V is off
// the ground during a pull, the game's fall may start; in the air the keys reach V only through the game's air
// control, which the pull's push overrides each frame (Push.reds). The slide has no way to the fall, only to its own
// short fall, an air state too (statemachine_locomotion.tweak, slide.transitionTo).

public func ApexGrappleLiftsOff(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  return IsDefined(system) && ApexGrappleMovesV(system);
}

@wrapMethod(FallDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if wrappedMethod(stateContext, scriptInterface) {
    return true;
  }
  // The ground first: V is on it most frames, and it is one read where the grapple's system is a search (B10).
  return !this.IsTouchingGround(scriptInterface) && ApexGrappleLiftsOff(scriptInterface);
}

@wrapMethod(SlideFallDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if wrappedMethod(stateContext, scriptInterface) {
    return true;
  }
  // The ground first: V is on it most frames, and it is one read where the grapple's system is a search (B10).
  return !this.IsTouchingGround(scriptInterface) && ApexGrappleLiftsOff(scriptInterface);
}

// So a pull rises in the fall, where the game is in its jump while V goes up. The animations follow the fall's
// animation event and the detailed state (FallEvents.OnEnter, scripts 2.5): in third person, seen in game, a rise
// from the ground played a fall picked for a floor close below, which ended and started again, in jerks, for the whole
// rise; a pull from a fall begun high up looked right. So while V rises, the animations are told what the game's jump
// tells them, and the fall once V comes down as fast as the game's own fall asks (FallDecisions.ShouldFall), or once
// V is high up. The state, and so the pull's physics, stay the fall's.
// The game's jump rises for well under a second, and its animation is a take-off: a rise of 2 to 2.75 s, seen in game,
// showed V walking in the air once the take-off was played.
public func ApexGrappleComingDown(stateContext: ref<StateContext>, verticalSpeed: Float) -> Bool {
  // Written by every air state's entry from the same height the game's fall reads (LocomotionAirEvents.OnEnter).
  return verticalSpeed < stateContext.GetFloatParameter(n"RegularLandingFallingSpeed", true);
}

// From this height a fall lasts 1.1 s or more at the game's 16 m/s², long enough for the long fall that a body seen
// in third person plays then; lower, a fall told while V still rises is picked for a landing about to come.
public func ApexGrappleLongFallHeight() -> Float {
  return 10.0;
}

// Nothing solid within ApexGrappleLongFallHeight() below V's feet, or nothing at all within the game's 100 m, by the
// game's own measure (Static, Terrain and PlayerBlocker, with a wide probe): two rays of our own, Static and Terrain
// only, met nothing within 10 m where the game measured the ground 4.08 m below V, seen in game.
public func ApexGrappleHighUp(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  return ApexGrappleHighAbove(DefaultTransition.GetDistanceToGround(scriptInterface));
}

public func ApexGrappleHighAbove(ground: Float) -> Bool {
  return ground < 0.0 || ground >= ApexGrappleLongFallHeight();
}

// The rise is told once per pull. A pull that lifts V off the ground enters the fall (EnterCondition, above), and the
// entry tells it. A pull begun while V already falls has no entry: its first frame going up tells it (OnUpdate), when
// the rope went up as the hook bit, so that a swing round an anchor below never takes off as a jump.
@addMethod(FallEvents)
private final func ApexGrappleShowRise(system: ref<ApexGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  system.riseShown = true;
  system.riseShownAt = ApexGrappleTime(scriptInterface.executionOwner.GetGame());
  scriptInterface.PushAnimationEvent(n"Jump");
  this.SetDetailedState(scriptInterface, gamePSMDetailedLocomotionStates.Jump);
}

@wrapMethod(FallEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !IsDefined(system) {
    return;
  }
  system.riseShown = false;
  if !ApexGrappleMovesV(system) {
    return;
  }
  // Told here either way: a pull that leaves the ground coming down stays a fall.
  system.riseFor = system.startedAt;
  if !ApexGrappleComingDown(stateContext, this.GetVerticalSpeed(scriptInterface)) {
    this.ApexGrappleShowRise(system, scriptInterface);
  }
}

// Each frame of the fall, the pull over or not.
@wrapMethod(FallEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !IsDefined(system) {
    return;
  }
  if !system.riseShown {
    if ApexGrappleMovesV(system) && system.riseFor != system.startedAt && system.anchor.Z > system.startPosition.Z && !ApexGrappleComingDown(stateContext, this.GetVerticalSpeed(scriptInterface)) {
      system.riseFor = system.startedAt;
      if !ApexGrappleHighUp(scriptInterface) {
        this.ApexGrappleShowRise(system, scriptInterface);
        ApexGrappleLog("rise shown as a jump in a fall begun before the pull, " + ToString(system.riseShownAt - system.startedAt) + " s into the pull");
      }
    }
    return;
  }
  let verticalSpeed: Float = this.GetVerticalSpeed(scriptInterface);
  let comingDown: Bool = ApexGrappleComingDown(stateContext, verticalSpeed);
  // The ground measured once, for the test and the log line both (B7a): it is a query of the world's geometry.
  let ground: Float = DefaultTransition.GetDistanceToGround(scriptInterface);
  if !comingDown && !ApexGrappleHighAbove(ground) {
    return;
  }
  system.riseShown = false;
  scriptInterface.PushAnimationEvent(n"Fall");
  this.SetDetailedState(scriptInterface, gamePSMDetailedLocomotionStates.Fall);
  let shownFor: Float = ApexGrappleTime(scriptInterface.executionOwner.GetGame()) - system.riseShownAt;
  let why: String = comingDown ? "coming down" : "high up";
  ApexGrappleLog("rise shown as a jump for " + ToString(shownFor) + " s, then the fall, " + why + ", at " + ToString(verticalSpeed) + " m/s, " + ToString(ground) + " m above the ground");
}

// A rise that ends before V comes down (on the ground, at a ledge) says so too.
@wrapMethod(LocomotionAirEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !IsDefined(this as FallEvents) || !IsDefined(system) || !system.riseShown {
    return;
  }
  system.riseShown = false;
  let shownFor: Float = ApexGrappleTime(scriptInterface.executionOwner.GetGame()) - system.riseShownAt;
  ApexGrappleLog("rise shown as a jump for " + ToString(shownFor) + " s, the fall left before V came down, on the ground " + ToString(scriptInterface.IsOnGround()));
}
