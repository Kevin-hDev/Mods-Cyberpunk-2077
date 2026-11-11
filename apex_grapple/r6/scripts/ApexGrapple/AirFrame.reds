// The grapple's work at each frame in the air, after the state's own: one wrap rather than three, the system looked for
// once (audit of 10 November 2026, B9). In the order the three wraps ran, by their files' order: the double jump watched
// (Jump.reds), the soft landing (Landing.reds), the pull's push written back (Push.reds). The file stays in the mod's
// folder, so that the wrap keeps its place among other mods' wraps of the same frame, after Air Strafe's: the order of
// wraps by file path is supposed, seen only through the pushes written back (Push.reds).
@wrapMethod(LocomotionAirEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !IsDefined(system) {
    return;
  }
  this.ApexGrappleWatchDoubleJump(system, scriptInterface);
  this.ApexGrappleSoftenLanding(system, stateContext, scriptInterface);
  ApexGrapplePushBack(system, stateContext, scriptInterface);
}
