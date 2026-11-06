// The game darkens a long fall: the air states start the effect "falling" once V comes down faster than a hard
// landing, and stop it as V leaves the air (LocomotionAirEvents.OnUpdate and OnExit, scripts 2.5). It is hidden from
// the start of a climb until V has stood on the ground (Landing.reds), unless the option puts it back; falls on foot
// keep it. That this effect is the darkening players see: deduced from the scripts, the only effect they start by
// fall speed.
//
// The game starts it when the landing type turns hard. The soft landing writes the type back to regular each frame,
// so the game asks for the effect again every frame of a fast descent: with the option on, it is let through once per
// air state, as the game does alone. The wraps reach every state machine, but only locomotion starts this effect.

@wrapMethod(DefaultTransition)
protected final func StartEffect(scriptInterface: ref<StateGameScriptInterface>, effectName: CName, opt blackboard: ref<worldEffectBlackboard>) -> Void {
  if Equals(effectName, n"falling") && WallClimbHoldsFallEffectBack(scriptInterface) {
    return;
  }
  wrappedMethod(scriptInterface, effectName, blackboard);
}

@wrapMethod(DefaultTransition)
protected final func StopEffect(scriptInterface: ref<StateGameScriptInterface>, effectName: CName) -> Void {
  if Equals(effectName, n"falling") {
    let climb: ref<WallClimbClimb> = WallClimbCurrent(scriptInterface);
    if IsDefined(climb) {
      climb.fallEffectShown = false;
    }
  }
  wrappedMethod(scriptInterface, effectName);
}

public func WallClimbHoldsFallEffectBack(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let climb: ref<WallClimbClimb> = WallClimbCurrent(scriptInterface);
  if !IsDefined(climb) {
    return false;
  }
  if !WallClimbCurrentSettings().fallEffect || climb.fallEffectShown {
    climb.fallEffectsHeldBack = climb.fallEffectsHeldBack + 1;
    return true;
  }
  climb.fallEffectShown = true;
  return false;
}
