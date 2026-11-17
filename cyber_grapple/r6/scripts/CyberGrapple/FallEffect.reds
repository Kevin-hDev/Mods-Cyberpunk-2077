// Made by fabrique/grapple.py from Apex Grapple's FallEffect.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
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
  if Equals(effectName, n"falling") && CyberGrappleHoldsFallEffectBack(scriptInterface) {
    return;
  }
  wrappedMethod(scriptInterface, effectName, blackboard);
}

@wrapMethod(DefaultTransition)
protected final func StopEffect(scriptInterface: ref<StateGameScriptInterface>, effectName: CName) -> Void {
  if Equals(effectName, n"falling") {
    let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(scriptInterface.executionOwner.GetGame());
    if IsDefined(system) {
      system.fallEffectShown = false;
    }
  }
  wrappedMethod(scriptInterface, effectName);
}

public func CyberGrappleHoldsFallEffectBack(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !IsDefined(system) || !system.trajectory {
    return false;
  }
  if !CyberGrappleGrappleSettings(system).fallEffect || system.fallEffectShown {
    system.fallEffectsHeldBack = system.fallEffectsHeldBack + 1;
    return true;
  }
  system.fallEffectShown = true;
  return false;
}
