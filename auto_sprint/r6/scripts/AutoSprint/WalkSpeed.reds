// Walk speed: V's pace when moving without sprinting, the "stand" state (3.5 m/s in the game), as a multiplier on the
// MaxSpeed stat (SpeedModifiers.reds). The sprint speed works with the automatic sprint off; a player without it moves
// mostly at this pace, and wants to set it as well (Kevin, 22 October 2026).
//
// The slow walk (G) keeps the game's speed: it stays in "stand" with the crouch stat group (MaxSpeed 1.5 in TweakDB
// 2.31), under the 2.5 m/s over which the game lets enemies hear V's steps (StandEvents.OnTick,
// footstepStimuliSpeedThreshold). Faster, it would give V away.

@addMethod(LocomotionEventsTransition)
protected final func AutoSprintWantedWalkFactor(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Float {
  if Equals(this.GetStateName(), n"stand") && !stateContext.GetBoolParameter(n"WalkToggled", true) && !AutoSprintSceneSetsPace(scriptInterface) {
    return AutoSprintWalkFactor();
  }
  return 1.0;
}

@addMethod(LocomotionEventsTransition)
protected final func AutoSprintSetWalkFactor(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, factor: Float) -> Void {
  if AutoSprintSetSpeedFactor(stateContext, scriptInterface, n"AutoSprintWalkModifier", factor) {
    AutoSprintLog("walk speed x" + ToString(factor) + " in state " + NameToString(this.GetStateName()) + ", MaxSpeed now " + ToString(AutoSprintMaxSpeed(scriptInterface)));
  }
}

// On entering a state, and every frame after in the states that call the common update, "stand" among them: the slow
// walk toggles inside "stand", and a new setting from the menu counts at once.
@wrapMethod(LocomotionEventsTransition)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  this.AutoSprintSetWalkFactor(stateContext, scriptInterface, this.AutoSprintWantedWalkFactor(stateContext, scriptInterface));
}

@wrapMethod(LocomotionEventsTransition)
public func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  this.AutoSprintSetWalkFactor(stateContext, scriptInterface, this.AutoSprintWantedWalkFactor(stateContext, scriptInterface));
}

// Leaving "stand" for a state that would not call the two above (a vehicle, a scene) must not carry the multiplier.
@wrapMethod(LocomotionEventsTransition)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  this.AutoSprintSetWalkFactor(stateContext, scriptInterface, 1.0);
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(LocomotionEventsTransition)
public func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  this.AutoSprintSetWalkFactor(stateContext, scriptInterface, 1.0);
  wrappedMethod(stateContext, scriptInterface);
}
