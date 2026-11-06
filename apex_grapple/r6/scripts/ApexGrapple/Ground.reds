// The grapple's flight ends once V has stood a while on the ground: the soft landing, the hidden fall effect and the
// ladder rule stop covering V, and the game's speed hold comes back as it was before the pull.

// How long V must stay on the ground before a grapple's landing counts as over. A pull that ends against a wall high
// up touches it for a moment, read as ground: ended there, the soft landing let a 20 m fall kill V.
public func ApexGrappleSettleTime() -> Float {
  return 0.5;
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleGroundFrame(system: ref<ApexGrappleSystem>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  // A ladder holds V as the ground does: a shot from one that never took V off it (hook called off, a person pulled
  // to V) would otherwise leave the soft landing on for V's next fall from there, whatever its height.
  if !scriptInterface.IsOnGround() && !ApexGrappleOnLadder(stateContext) {
    system.onGroundBefore = false;
    return;
  }
  if !system.onGroundBefore {
    system.onGroundBefore = true;
    system.groundSince = now;
  }
  if now - system.groundSince >= ApexGrappleSettleTime() {
    this.ApexGrappleBackOnGround(system, stateContext);
  }
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleBackOnGround(system: ref<ApexGrappleSystem>, stateContext: ref<StateContext>) -> Void {
  if system.trajectory {
    system.trajectory = false;
    ApexGrappleLog("on the ground after a grapple: fastest fall " + ToString(AbsF(system.fastestFall)) + " m/s, hardest landing turned into a regular one " + ToString(system.landingRewritten) + ", ladder entries refused " + ToString(system.ladderRefusals) + ", fall effect held back " + ToString(system.fallEffectsHeldBack) + " times, state " + NameToString(this.GetStateName()));
  }
  system.fallEffectsHeldBack = 0;
  system.landingRewritten = 0;
  system.fastestFall = 0.0;
  system.ladderRefusals = 0;
  system.gameLanding = 0;
  if system.speedLimitToRestore {
    system.speedLimitToRestore = false;
    stateContext.SetPermanentBoolParameter(n"TemporarySpeedLimitIgnore", system.speedLimitBefore, true);
  }
}
