// Every locomotion state's entry: air, ground, climb, swimming and braindance states reach
// LocomotionEventsTransition.OnEnter through their parents (scripts 2.5). Takedown states do not, but for the fall
// while holding someone (GrappleFallEvents, an air state), nor do ladderSprint and ladderSlide; a climb a takedown
// interrupts ends at the first locomotion state after it. Our ladder's entry is Hold.reds' own; a ladder of the game's
// is ground, which gives the jumps back (LocomotionGroundEvents.OnEnter).
@wrapMethod(LocomotionEventsTransition)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  if IsDefined(this as LadderEvents) && IsDefined(WallClimbOurLadder(stateContext)) {
    return;
  }
  let inAir: Bool = IsDefined(this as LocomotionAirEvents);
  let system: ref<WallClimbSystem> = WallClimbSystemOf(scriptInterface);
  if !IsDefined(system) {
    return;
  }
  if IsDefined(system.climb) {
    if inAir {
      WallClimbBackInAir(system, scriptInterface);
    } else {
      WallClimbOnGround(system.climb, stateContext, scriptInterface, this.GetClassName());
    }
  }
  if !inAir {
    WallClimbOffFooting(system, stateContext);
  }
}

// Out of the air, a climb ends: on the ground, at the game's climb over a ledge, on a ladder of the game's, in water.
// The first such state is written as the landing.
public func WallClimbOnGround(climb: ref<WallClimbClimb>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, state: CName) -> Void {
  WallClimbEnd(climb, stateContext, scriptInterface, "into " + NameToString(state));
  if climb.landed {
    return;
  }
  let now: Float = WallClimbGameTime(scriptInterface.executionOwner.GetGame());
  climb.landed = true;
  // The ground gives the jumps back itself.
  climb.jumpOwed = false;
  climb.landedAt = now;
  // The game's vertical speed at the last frame in the air (LocomotionAirEvents.OnUpdate, scripts 2.5).
  let impact: Float = stateContext.GetFloatParameter(n"ImpactSpeed", true);
  WallClimbLog(WallClimbLandingText(climb, state, now, DefaultTransition.GetPlayerPosition(scriptInterface), impact));
}

// Back in the air after a landing: the climb is over once V had stood on the ground long enough (Landing.reds). A
// shorter touch keeps it, and the next landing is written again.
public func WallClimbBackInAir(system: ref<WallClimbSystem>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let climb: ref<WallClimbClimb> = system.climb;
  if !climb.landed {
    return;
  }
  if WallClimbGameTime(scriptInterface.executionOwner.GetGame()) - climb.landedAt >= WallClimbSettleTime() {
    system.climb = null;
    return;
  }
  climb.landed = false;
}

// Back on the ground or in water: a new climb is allowed, and our ladder still offered is taken back, or walking into
// a wall would put V on it. The water's own ladder state reads the same description
// (SwimmingLadderDecisions.TestParameters), so it must not reach it either.
public func WallClimbOffFooting(system: ref<WallClimbSystem>, stateContext: ref<StateContext>) -> Void {
  WallClimbWithdraw(stateContext);
  WallClimbCloseLedgeWindow(stateContext);
  if stateContext.GetBoolParameter(n"wallClimbUsed", true) {
    stateContext.SetPermanentBoolParameter(n"wallClimbUsed", false, true);
  }
  if stateContext.GetConditionBool(n"wallClimbCancelPush") {
    stateContext.SetConditionBoolParameter(n"wallClimbCancelPush", false, true);
  }
  ArrayClear(system.refusalsLogged);
}
