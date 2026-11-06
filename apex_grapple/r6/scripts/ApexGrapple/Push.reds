// The pull's push, written again at the very end of each frame in the air. The game reads the push parameter once the
// frame's scripts are done, so the last write wins. Another mod may write it later in the frame than the grapple: Air
// Strafe turns the momentum with the move keys in its own wrap of LocomotionAirEvents.OnUpdate, after this frame's pull
// (Pulling.reds runs inside the state's super.OnUpdate), and during a pull the move keys must do nothing. The end of
// each pull logs how many pushes were written back: with Air Strafe on, 11 to 238 a pull in game, so this wrap runs
// after Air Strafe's and wins; with it off, none.
@wrapMethod(LocomotionAirEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !IsDefined(system) || !ApexGrappleMovesV(system) {
    return;
  }
  if system.pushAt != ApexGrappleTime(scriptInterface.executionOwner.GetGame()) {
    return;
  }
  let found: StateResultVector = stateContext.GetTemporaryVectorParameter(n"impulse");
  if found.valid && Vector4.Distance(found.value, system.push) < ApexGrapplePushTolerance() {
    return;
  }
  stateContext.SetTemporaryVectorParameter(n"impulse", system.push, true);
  system.pushesWrittenBack = system.pushesWrittenBack + 1;
}

// Closer than this, in m/s, the push found is the grapple's own.
public func ApexGrapplePushTolerance() -> Float {
  return 0.001;
}
