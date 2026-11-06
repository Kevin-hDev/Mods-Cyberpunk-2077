// V leaves our ladder by its "crouch" exit, which pushes V 1.5 m/s straight back from the wall (ladderCrouch in the
// locomotion tweak). Climbing on, the push is cancelled so V stays against the wall; letting go, it stays and takes V
// off the wall. Any other way off our ladder is the game's own, a jump for one: the climb ends there, the jump kept.
@wrapMethod(LadderJumpEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  if stateContext.GetConditionBool(n"wallClimbCancelPush") {
    stateContext.SetConditionBoolParameter(n"wallClimbCancelPush", false, true);
    let none: Vector4;
    this.AddImpulse(stateContext, none);
    return;
  }
  let climb: ref<WallClimbClimb> = WallClimbCurrent(scriptInterface);
  if IsDefined(climb) && climb.onWall && climb.grabbed {
    // The jump off the wall (Jump.reds): the ladder, a ground state, already gave the jumps back.
    climb.jumpOwed = false;
    WallClimbEnd(climb, stateContext, scriptInterface, "left our ladder by " + NameToString(this.GetClassName()));
  }
}
