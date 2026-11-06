// Jumps after a climb, as in our Borderlands 4 mod (Kevin, 17 September 2026: the climb counts as touching the
// ground). The wall gives V its jumps back, as the ground does (LocomotionGroundEvents.OnEnter, scripts 2.5), and the
// first jump in the air after it, from the wall or in the fall, leaves the double jump for after it: in game the jump
// from the wall kept it, a jump in the fall after letting go did not (Kevin, 31 October 2026). The jump is the game's
// jump in the air (DoubleJumpEvents, with the double jump cyberware); the climb went on through it and swallowed it in
// game, so entering it ends the climb.

public func WallClimbRegainJumps(stateContext: ref<StateContext>) -> Void {
  stateContext.SetPermanentIntParameter(n"currentNumberOfJumps", 0, true);
  // A jump pressed before the climb (during an air dodge) would jump off the wall at once.
  stateContext.SetConditionBoolParameter(n"JumpPressed", false, true);
}

@wrapMethod(DoubleJumpEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let climb: ref<WallClimbClimb> = WallClimbCurrent(scriptInterface);
  if !IsDefined(climb) || climb.landed {
    return;
  }
  let falling: Bool = !climb.onWall;
  WallClimbEnd(climb, stateContext, scriptInterface, "jumped off the wall");
  let since: String = ToString(WallClimbGameTime(scriptInterface.executionOwner.GetGame()) - climb.endedAt) + " s after the climb ended (" + climb.endReason + ")";
  if climb.jumpOwed {
    climb.jumpOwed = false;
    // Counted as the game counts it, this jump left none for after it in game.
    WallClimbRegainJumps(stateContext);
    if falling {
      WallClimbLog("first jump in the air " + since + ": the double jump is kept");
    }
    return;
  }
  WallClimbLog("jump in the air " + since);
}

// After a climb and until V lands, V falls in the game's regular fall, not in its fall off an edge: against the wall
// the game read V as over an edge (UnsecureFootingFallDecisions, scripts 2.5), and no jump leaves that fall: 14 presses
// in it, none falling too fast, gave no jump after letting go at the highest climb in game (31 October 2026).
@wrapMethod(UnsecureFootingFallDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !wrappedMethod(stateContext, scriptInterface) {
    return false;
  }
  let climb: ref<WallClimbClimb> = WallClimbCurrent(scriptInterface);
  return !IsDefined(climb) || climb.landed;
}

// After a climb, every jump pressed in the air is written, with what the game's double jump needs: the state V is in,
// its fall no faster than the very hard landing's speed, and fewer jumps counted than allowed (DoubleJumpDecisions).
// A second press while the jump given back rises is kept for when the game allows the next jump, as the game keeps
// one made during an air dodge (DodgeAirEvents.OnUpdate, scripts 2.5). No jump counted in DoubleJumpEvents is only
// ever the jump given back: the game counts every other on entering. The first 0.05 s is the press that jumped.
// Called off the wall only (Climb.reds).
@addMethod(LocomotionAirEvents)
private final func WallClimbJumpPressed(climb: ref<WallClimbClimb>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if climb.landed || !scriptInterface.IsActionJustPressed(n"Jump") {
    return;
  }
  let jumps: Int32 = stateContext.GetIntParameter(n"currentNumberOfJumps", true);
  WallClimbLog("jump pressed in " + NameToString(this.GetClassName()) + " " + ToString(WallClimbGameTime(scriptInterface.executionOwner.GetGame()) - climb.endedAt) + " s after the climb ended, vertical speed " + ToString(this.GetVerticalSpeed(scriptInterface)) + " (too fast below " + ToString(stateContext.GetFloatParameter(n"VeryHardLandingFallingSpeed", true)) + "), jumps counted " + ToString(jumps));
  if IsDefined(this as DoubleJumpEvents) && this.GetInStateTime() > 0.05 && jumps == 0 {
    stateContext.SetConditionBoolParameter(n"JumpPressed", true, true);
  }
}
