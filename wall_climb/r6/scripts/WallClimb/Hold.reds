// "Hold on when stopping": when the stick leaves the wall, our ladder (Ladder.reds) is offered where V stopped, and
// the game's own entry onto a ladder brings V into the ladder pose while the hands let go of the wall. Pushing on the
// wall again takes V off the ladder by its crouch exit, without the exit's push back (Decisions.reds, LeaveWall.reds),
// and the climb goes on in the air. The ladder because the game has no pose for hanging on a wall, and its ladder
// pose was the one of this mod's earlier versions.

// Time the game gets to put V on our ladder; V hangs where it stopped meanwhile, and after it in the air, off the
// ladder: the game refuses a ladder V looks away from by more than 45 degrees, and letting go there dropped V in game.
public func WallClimbHoldWait() -> Float {
  return 0.5;
}

@addMethod(LocomotionAirEvents)
private final func WallClimbStop(climb: ref<WallClimbClimb>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, now: Float) -> Void {
  if !climb.stopping {
    climb.stopping = true;
    climb.stoppedAt = now;
    climb.stops = climb.stops + 1;
    // V hangs still: the speeds kept through a read that drops are no longer asked for, nor do they take corners.
    climb.up = 0.0;
    climb.side = 0.0;
    let ladder: ref<LadderDescription> = WallClimbLadderAt(climb.wallPoint, climb.normal, feet, climb.letGoZ);
    stateContext.SetPermanentScriptableParameter(n"wallClimbLadder", ladder, true);
    stateContext.SetConditionScriptableParameter(n"usingLadder", ladder, true);
    WallClimbLog("stopping on the wall, our ladder offered: " + ToString(feet.Z - climb.startPosition.Z) + " m above the start, " + ToString(Vector4.Distance2D(feet, climb.wallPoint)) + " m from the wall, vertical speed " + ToString(this.GetVerticalSpeed(scriptInterface)) + ", state " + NameToString(this.GetClassName()) + ", move keys " + ToString(scriptInterface.GetActionValue(n"MoveX")) + ", " + ToString(scriptInterface.GetActionValue(n"MoveY")));
  } else {
    if now - climb.stoppedAt > WallClimbHoldWait() && IsDefined(WallClimbOurLadder(stateContext)) {
      WallClimbHangInAir(climb, stateContext, "the game did not put V on our ladder within " + ToString(WallClimbHoldWait()) + " s");
    }
  }
  WallClimbPush(climb, stateContext, scriptInterface, feet, 0.0, 0.0, 0.0);
}

// V holds on in the air where it is, our ladder taken back. Written once: the ladder is gone after the first call.
public func WallClimbHangInAir(climb: ref<WallClimbClimb>, const stateContext: ref<StateContext>, why: String) -> Void {
  if WallClimbWithdraw(stateContext) {
    climb.grabbed = false;
    WallClimbLog("hanging on in the air: " + why);
  }
}

// Back to climbing, from our ladder or before the game took it.
public func WallClimbResume(climb: ref<WallClimbClimb>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, now: Float, from: String) -> Void {
  climb.stopping = false;
  climb.grabbed = false;
  climb.resumes = climb.resumes + 1;
  climb.stickAt = now;
  WallClimbWithdraw(stateContext);
  WallClimbLog("climbing again " + from + ", " + ToString(now - climb.stoppedAt) + " s after stopping, view " + ToString(WallClimbViewFromWall(climb, scriptInterface)) + " deg from the wall");
}

// V entering "ladder" on our ladder, at the end of a stop. A ladder of the game's is ground to the climb
// (NewState.reds). ladderSprint and ladderSlide are refused on our ladder (Decisions.reds).
@wrapMethod(LadderEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let climb: ref<WallClimbClimb> = WallClimbCurrent(scriptInterface);
  if !IsDefined(climb) || !climb.onWall || !climb.stopping || climb.grabbed || !IsDefined(WallClimbOurLadder(stateContext)) {
    return;
  }
  let now: Float = WallClimbGameTime(scriptInterface.executionOwner.GetGame());
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  climb.grabbed = true;
  climb.grabEndsAt = now + WallClimbGrabTime();
  // The game faces V to our ladder, which faces the wall: a turn still left would turn V away from it once climbing
  // again ("facing the wall at 0 deg" on the first line after every stop in game).
  climb.viewTurnLeft = 0.0;
  WallClimbRemoveHands(climb, scriptInterface);
  WallClimbLog("on our ladder " + ToString(now - climb.stoppedAt) + " s after stopping, " + ToString(feet.Z - climb.startPosition.Z) + " m above the start");
}
