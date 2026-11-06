// The game's choices about our ladder: why it refuses to put V on it, and when V leaves it.

// Downward speed under which V is not taken as moving down.
public func WallClimbDescentTolerance() -> Float {
  return 0.1;
}

// Moving down this close to our ladder's foot takes V off it to hang in the air: the foot is in the air, and the
// game's exit there stood V on nothing in an earlier version. Letting go there instead dropped V in game, with the
// stick held to the side. Higher up, a small move down is harmless (a stick springing back past its centre).
public func WallClimbFootClearance() -> Float {
  return 1.0;
}

// A ladder of the game's after a climb is judged on V's fall speed, as without the mod (Landing.reds).
@wrapMethod(LadderDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !wrappedMethod(stateContext, scriptInterface) {
    let ladder: ref<LadderDescription> = WallClimbOurLadder(stateContext);
    if IsDefined(ladder) {
      this.WallClimbExplainRefusal(stateContext, scriptInterface, ladder);
    }
    return false;
  }
  return !WallClimbPassesLadderBy(stateContext, scriptInterface, this.GetVerticalSpeed(scriptInterface));
}

// The tests of TestLadderMath and EnterCondition (scripts 2.5), read again with their values.
@addMethod(LadderDecisions)
private final const func WallClimbExplainRefusal(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>, ladder: ref<LadderDescription>) -> Void {
  let now: Float = WallClimbGameTime(scriptInterface.executionOwner.GetGame());
  if now < stateContext.GetConditionFloat(n"wallClimbRefusalReportAt") {
    return;
  }
  stateContext.SetConditionFloatParameter(n"wallClimbRefusalReportAt", now + WallClimbReportGap(), true);
  let forward: Vector4 = scriptInterface.GetOwnerForward();
  let middle: Vector4 = ladder.position + (ladder.up * (ladder.verticalStepBottom + ladder.topHeightFromPosition)) / 2.0;
  let toLadder: Vector4 = Vector4.Normalize2D(middle - DefaultTransition.GetPlayerPosition(scriptInterface));
  let angle: Float = Rad2Deg(AcosF(ClampF(Vector4.Dot(forward, toLadder), -1.0, 1.0)));
  WallClimbLog("the game refused our ladder: forward along its normal " + ToString(Vector4.Dot(ladder.normal, forward)) + " (must not be above 0), angle to it " + ToString(angle) + " (limit " + ToString(this.GetStaticFloatParameterDefault("enterAngleThreshold", 35.0)) + "), on the ground " + ToString(this.IsTouchingGround(scriptInterface)) + ", moving backwards " + ToString(this.IsPlayerMovingBackwards(stateContext, scriptInterface)) + ", landing type " + ToString(this.GetLandingType(stateContext)) + " (must be below 3), above its top " + ToString(this.IsPlayerAboveLadderTop(stateContext, scriptInterface)) + ", melee allows it " + ToString(MeleeTransition.MeleeUseExplorationCondition(stateContext, scriptInterface)) + ", no-ladder effect " + ToString(StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"NoLadder")));
}

// On our ladder V only holds on: the ladder's sprint and slide would move V along it, and its foot is in the air.
@wrapMethod(LadderSprintDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if IsDefined(WallClimbOurLadder(stateContext)) {
    return false;
  }
  return wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(LadderSlideDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if IsDefined(WallClimbOurLadder(stateContext)) {
    return false;
  }
  return wrappedMethod(stateContext, scriptInterface);
}

// V leaves our ladder by its "crouch" exit, which needs no key press: to climb on when the stick is on the wall again
// or to hang in the air (its push back cancelled, LeaveWall.reds), or to let go.
@wrapMethod(LadderDecisions)
protected final const func ToLadderCrouch(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if wrappedMethod(stateContext, scriptInterface) {
    return true;
  }
  let ladder: ref<LadderDescription> = WallClimbOurLadder(stateContext);
  if !IsDefined(ladder) {
    return false;
  }
  let climb: ref<WallClimbClimb> = WallClimbCurrent(scriptInterface);
  if !IsDefined(climb) || !climb.onWall {
    return true;
  }
  let now: Float = WallClimbGameTime(scriptInterface.executionOwner.GetGame());
  let keys: Vector4 = WallClimbMoveKeys(scriptInterface);
  let stick: Vector4 = WallClimbStickOnWall(keys);
  if !Vector4.IsZero(stick) && WallClimbCurrentSettings().enabled {
    stateContext.SetConditionBoolParameter(n"wallClimbCancelPush", true, true);
    WallClimbResume(climb, stateContext, scriptInterface, now, "from our ladder");
    return true;
  }
  let reason: String = this.WallClimbLetGoReason(climb, keys, scriptInterface);
  if StrLen(reason) > 0 {
    WallClimbEnd(climb, stateContext, scriptInterface, reason);
    return true;
  }
  // Never during the grab, which moved V down a little as its entry ended in an earlier version.
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  if now >= climb.grabEndsAt && this.GetVerticalSpeed(scriptInterface) < -WallClimbDescentTolerance() && feet.Z < ladder.position.Z + WallClimbFootClearance() {
    stateContext.SetConditionBoolParameter(n"wallClimbCancelPush", true, true);
    WallClimbHangInAir(climb, stateContext, "moving down our ladder, move keys " + ToString(keys.X) + ", " + ToString(keys.Y));
    return true;
  }
  return false;
}

// Why V lets go of our ladder now, or empty. A stick pushed under halfway is the game's to read: its ladder then
// carries V up, and stops at the highest climb here.
@addMethod(LadderDecisions)
private final const func WallClimbLetGoReason(climb: ref<WallClimbClimb>, keys: Vector4, const scriptInterface: ref<StateGameScriptInterface>) -> String {
  if !WallClimbCurrentSettings().enabled {
    return "the mod was switched off";
  }
  if WallClimbPushesBack(keys) {
    return "back pushed";
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  if feet.Z >= climb.letGoZ {
    return "highest climb reached";
  }
  return "";
}
