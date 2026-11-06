// Handing a ledge to the game's own climb, with its mantle animations. From a fall, the game climbs only after a press
// of the jump key (ClimbDecisions.EnterCondition, scripts 2.5: the "JumpPressed" condition; a jump or an air dodge
// needs none). While our window is open, that condition is set for the climb's own test alone and put back at once,
// since the double jump reads it too and comes first in the jump state's exits. The climb also wants the stick within
// 30 degrees (its tweak value, in the log of its refusals in 2.5) and the camera not looking down too far: climbing
// diagonally, V goes on up until the stick is straight.

// The ledge is the game's: its climb only takes the ledge its own detection sees. Rays of ours that looked just
// behind the face took for the top a walkway behind a railing and crates behind a fence, and the climb then refused
// 16 hand-overs out of 29 in game. The detection also reports a ledge too high to climb, as not valid.
public func WallClimbGameLedge(scriptInterface: ref<StateGameScriptInterface>) -> ref<PlayerClimbInfo> {
  return scriptInterface.GetSpatialQueriesSystem().GetPlayerObstacleSystem().GetCurrentClimbInfo(scriptInterface.owner);
}

// True when the game's detection sees a ledge in front that its climb could take, before its other tests.
public func WallClimbLedgeInReach(info: ref<PlayerClimbInfo>) -> Bool {
  return IsDefined(info) && IsDefined(info.descResult) && info.climbValid;
}

public func WallClimbLedgeShortText(info: ref<PlayerClimbInfo>, feet: Vector4) -> String {
  if !IsDefined(info) || !IsDefined(info.descResult) {
    return "no ledge seen by the game";
  }
  let top: Vector4 = info.descResult.topPoint;
  return "game's ledge " + ToString(top.Z - feet.Z) + " m above the feet, climbable " + ToString(info.climbValid);
}

// Renewed at every air frame while the ledge is in reach: it only has to outlast a frame, two however long they last.
public func WallClimbAirLedgeWindow(timeDelta: Float) -> Float {
  return MaxF(0.1, 2.0 * timeDelta);
}

public func WallClimbOpenLedgeWindow(const stateContext: ref<StateContext>, now: Float, length: Float) -> Void {
  stateContext.SetConditionFloatParameter(n"wallClimbLedgeUntil", now + length, true);
}

public func WallClimbCloseLedgeWindow(const stateContext: ref<StateContext>) -> Void {
  if stateContext.GetConditionFloat(n"wallClimbLedgeUntil") > 0.0 {
    stateContext.SetConditionFloatParameter(n"wallClimbLedgeUntil", 0.0, true);
  }
}

@wrapMethod(ClimbDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let until: Float = stateContext.GetConditionFloat(n"wallClimbLedgeUntil");
  if until <= 0.0 {
    return wrappedMethod(stateContext, scriptInterface);
  }
  let now: Float = WallClimbGameTime(scriptInterface.executionOwner.GetGame());
  if now >= until {
    WallClimbCloseLedgeWindow(stateContext);
    return wrappedMethod(stateContext, scriptInterface);
  }
  let jumpPressed: Bool = stateContext.GetConditionBool(n"JumpPressed");
  stateContext.SetConditionBoolParameter(n"JumpPressed", true, true);
  let entered: Bool = wrappedMethod(stateContext, scriptInterface);
  stateContext.SetConditionBoolParameter(n"JumpPressed", jumpPressed, true);
  if entered {
    WallClimbCloseLedgeWindow(stateContext);
    WallClimbLog("the game's climb takes the ledge: " + this.WallClimbLedgeText(stateContext, scriptInterface));
  } else {
    if now >= stateContext.GetConditionFloat(n"wallClimbClimbReportAt") {
      stateContext.SetConditionFloatParameter(n"wallClimbClimbReportAt", now + WallClimbReportGap(), true);
      WallClimbLog("the game's climb refused the ledge: " + this.WallClimbLedgeText(stateContext, scriptInterface));
    }
  }
  return entered;
}

// What the game sees of the ledge, and its tests (scripts 2.5, ClimbDecisions.EnterCondition), with their values; the
// defaults are the scripts' own, used when the tweak data has none.
@addMethod(ClimbDecisions)
private final const func WallClimbLedgeText(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> String {
  let info: ref<PlayerClimbInfo> = WallClimbGameLedge(scriptInterface);
  if !IsDefined(info) || !IsDefined(info.descResult) {
    return "no ledge information";
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let top: Vector4 = info.descResult.topPoint;
  let behind: Vector4 = info.descResult.behindPoint;
  let text: String = "climb valid " + ToString(info.climbValid) + ", vault valid " + ToString(info.vaultValid) + ", ledge " + ToString(top.Z - feet.Z) + " m above the feet and " + ToString(Vector4.Distance2D(feet, top)) + " m away, behind it " + ToString(behind.Z - feet.Z) + " m, depth " + ToString(info.descResult.obstacleDepth) + ", top extent " + ToString(info.descResult.topExtent);
  if info.climbValid {
    text = text + ", room on top " + ToString(this.OverlapFitTest(scriptInterface, info)) + ", path clear " + ToString(this.TestClimbingPath(scriptInterface, info, feet)) + ", facing " + ToString(this.ForwardAngleTest(stateContext, scriptInterface, info));
  }
  return text + ", falling too fast " + ToString(this.IsCurrentFallSpeedTooFastToEnter(stateContext, scriptInterface)) + ", stick " + ToString(scriptInterface.GetInputHeading()) + " deg (within " + ToString(this.GetStaticFloatParameterDefault("inputAngleThreshold", -180.0)) + " needed), looking down too far " + ToString(this.IsCameraPitchAcceptable(stateContext, scriptInterface, this.GetStaticFloatParameterDefault("cameraPitchThreshold", -30.0))) + ", restricted " + ToString(this.IsVaultingClimbingRestricted(scriptInterface));
}
