// Made by fabrique/grapple.py from Apex Grapple's Push.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The pull's push, written again at the very end of each frame in the air (AirFrame.reds). The game reads the push
// parameter once the frame's scripts are done, so the last write wins. Another mod may write it later in the frame than
// the grapple: Air Strafe turns the momentum with the move keys in its own wrap of LocomotionAirEvents.OnUpdate, after
// this frame's pull (Pulling.reds runs inside the state's super.OnUpdate), and during a pull the move keys must do
// nothing. The end of each pull logs how many pushes were written back: with Air Strafe on, 11 to 238 a pull in game,
// so the grapple's wrap runs after Air Strafe's and wins; with it off, none.
public func CyberGrapplePushBack(system: ref<CyberGrappleSystem>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !CyberGrappleMovesV(system) {
    return;
  }
  if system.pushAt != CyberGrappleTime(scriptInterface.executionOwner.GetGame()) {
    return;
  }
  let found: StateResultVector = stateContext.GetTemporaryVectorParameter(n"impulse");
  if found.valid && Vector4.Distance(found.value, system.push) < CyberGrapplePushTolerance() {
    return;
  }
  stateContext.SetTemporaryVectorParameter(n"impulse", system.push, true);
  system.pushesWrittenBack = system.pushesWrittenBack + 1;
}

// Closer than this, in m/s, the push found is the grapple's own.
public func CyberGrapplePushTolerance() -> Float {
  return 0.001;
}
