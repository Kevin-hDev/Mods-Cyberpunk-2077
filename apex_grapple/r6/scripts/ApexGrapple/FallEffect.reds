// The game darkens a long fall: the air states start the effect "falling" once V comes down faster than a hard
// landing, and stop it as V leaves the air (LocomotionAirEvents.OnUpdate and OnExit, scripts 2.31). It is hidden during
// a grapple's flight unless the option puts it back; falls on foot keep it. That this effect is the darkening players
// see: deduced from the scripts, the only effect they start by fall speed.
//
// The game starts it when the landing type turns hard. The soft landing (Landing.reds) writes the type back to regular
// each frame, so the game asked for the effect again every frame of a fast descent: with the option on, it is let
// through once per air state, as the game does alone. The wraps reach every state machine, but only locomotion starts
// this effect.

@wrapMethod(DefaultTransition)
protected final func StartEffect(scriptInterface: ref<StateGameScriptInterface>, effectName: CName, opt blackboard: ref<worldEffectBlackboard>) -> Void {
  if Equals(effectName, n"falling") && ApexGrappleHoldsFallEffectBack(scriptInterface) {
    return;
  }
  wrappedMethod(scriptInterface, effectName, blackboard);
}

@wrapMethod(DefaultTransition)
protected final func StopEffect(scriptInterface: ref<StateGameScriptInterface>, effectName: CName) -> Void {
  if Equals(effectName, n"falling") {
    let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
    if IsDefined(system) {
      system.fallEffectShown = false;
    }
  }
  wrappedMethod(scriptInterface, effectName);
}

public func ApexGrappleHoldsFallEffectBack(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !IsDefined(system) || !system.trajectory {
    return false;
  }
  if !ApexGrappleGrappleSettings(system).fallEffect || system.fallEffectShown {
    system.fallEffectsHeldBack = system.fallEffectsHeldBack + 1;
    return true;
  }
  system.fallEffectShown = true;
  return false;
}
