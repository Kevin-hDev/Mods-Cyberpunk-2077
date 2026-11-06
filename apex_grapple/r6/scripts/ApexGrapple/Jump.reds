// A jump during a pull lets go and spends no jump (Borderlands 4's "Preserve jump when detaching"). The game starts a
// double jump in DoubleJumpDecisions.EnterCondition when Jump is pressed in the air (scripts 2.31); while a pull holds,
// or just after a jump let go of one, the mod answers no, so the count of jumps is untouched. Pulling.reds sees the
// same press and ends the pull, whichever runs first; its line says "jump".

// Long enough for the decision to see the press of the frame that let go.
public func ApexGrappleJumpWindow() -> Float {
  return 0.2;
}

@wrapMethod(DoubleJumpDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let wants: Bool = wrappedMethod(stateContext, scriptInterface);
  if !wants {
    return false;
  }
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !IsDefined(system) {
    return true;
  }
  if !ApexGrappleGrappleSettings(system).preserveJump {
    return true;
  }
  let now: Float = ApexGrappleTime(scriptInterface.executionOwner.GetGame());
  return !ApexGrappleMovesV(system) && now - system.jumpLetGoAt >= ApexGrappleJumpWindow();
}

// The double jump given back as the hook bites (option, docs/apex-grapple/double-saut/conception.md). The game allows
// a double jump while currentNumberOfJumps is under numberOfMultiJumps (1), and only the ground sets it back to 0
// (DoubleJumpDecisions, LocomotionGroundEvents.OnEnter, scripts 2.5). Returns the part of the "hook set" line.
public func ApexGrappleGiveDoubleJumpBack(settings: ref<ApexGrappleSettings>, stateContext: ref<StateContext>) -> String {
  let jumps: Int32 = stateContext.GetIntParameter(n"currentNumberOfJumps", true);
  if !settings.regainDoubleJump {
    return ", jumps counted " + ToString(jumps);
  }
  stateContext.SetPermanentIntParameter(n"currentNumberOfJumps", 0, true);
  return ", jumps counted " + ToString(jumps) + ", set back to 0: double jump back";
}

// Each double jump from the shot until V has stood on the ground, for the option's test in game. Its first moments are
// watched too: on 2 November 2026 the game entered a double jump after each pull, yet Kevin saw none in the air.
@wrapMethod(DoubleJumpEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let jumps: Int32 = stateContext.GetIntParameter(n"currentNumberOfJumps", true);
  let before: Float = this.GetVerticalSpeed(scriptInterface);
  wrappedMethod(stateContext, scriptInterface);
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !IsDefined(system) || !system.trajectory {
    return;
  }
  let now: Float = ApexGrappleTime(scriptInterface.executionOwner.GetGame());
  system.doubleJumpWatched = true;
  system.doubleJumpAt = now;
  system.doubleJumpBefore = before;
  system.doubleJumpTop = before;
  let when: String = system.phase == ApexGrappleFlying() ? "while the hook flies" : (system.phase == ApexGrapplePulling() ? "during the pull" : "after the pull");
  ApexGrappleLog("double jump " + when + ", " + ToString(now - system.firedAt) + " s after the shot, jumps counted before it " + ToString(jumps) + ", vertical speed " + ToString(before));
}

// How long a double jump is watched, in seconds: the game's jump lifts V at once, then its gravity slows the rise.
public func ApexGrappleDoubleJumpWatch() -> Float {
  return 0.3;
}

// The double jump's highest vertical speed over its first moments, against the speed it began with: higher means it
// pushed V up. A double jump that lands before the end of its watch writes no line.
@wrapMethod(LocomotionAirEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !IsDefined(system) || !system.doubleJumpWatched {
    return;
  }
  let since: Float = ApexGrappleTime(scriptInterface.executionOwner.GetGame()) - system.doubleJumpAt;
  if since > ApexGrappleDoubleJumpWatch() + 0.2 {
    system.doubleJumpWatched = false;
    return;
  }
  let speed: Float = this.GetVerticalSpeed(scriptInterface);
  system.doubleJumpTop = MaxF(system.doubleJumpTop, speed);
  if since < ApexGrappleDoubleJumpWatch() {
    return;
  }
  system.doubleJumpWatched = false;
  ApexGrappleLog("double jump after " + ToString(since) + " s: highest vertical speed " + ToString(system.doubleJumpTop) + ", " + ToString(system.doubleJumpBefore) + " as it began, " + ToString(speed) + " now, state " + NameToString(this.GetStateName()));
}
