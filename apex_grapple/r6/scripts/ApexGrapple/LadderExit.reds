// A grapple fired from a ladder: the game's own, or one a mod puts V on to hang against a wall. The hook flies with V
// still on it; once it bites, V leaves the ladder by its crouch exit, which needs no key, and the pull goes on in the
// air (docs/apex-grapple/echelle/conception.md).

// Longer than this on the ladder once the hook has bitten, the game is keeping V there: the grapple lets go. The exit
// comes at the next decision; a pull held frozen longer would set off all at once.
public func ApexGrappleLadderExitWait() -> Float {
  return 0.3;
}

// On the ladder itself, its sprint or its slide. Its two exits, ladderCrouch and ladderJump, are air states
// (LadderJumpEvents extends LocomotionAirEvents), where the game's IsInLadderState still counts V on the ladder.
public func ApexGrappleOnLadder(const stateContext: ref<StateContext>) -> Bool {
  let state: CName = stateContext.GetStateMachineCurrentState(n"Locomotion");
  return Equals(state, n"ladder") || Equals(state, n"ladderSprint") || Equals(state, n"ladderSlide");
}

// Before the other mods' tests: one of them could keep V on its ladder, or start a move of its own, in the frame the
// pull needs V off it.
@wrapMethod(LadderDecisions)
protected final const func ToLadderCrouch(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if IsDefined(system) && ApexGrappleMovesV(system) {
    if !system.ladderLeft {
      system.ladderLeft = true;
      ApexGrappleLog("the pull takes V off the ladder (" + NameToString(stateContext.GetStateMachineCurrentState(n"Locomotion")) + ")");
    }
    return true;
  }
  return wrappedMethod(stateContext, scriptInterface);
}

// A pull frame while V is still on the ladder: nothing moves V until the exit. A pull that caught a ladder on its way
// ends there, as in 1.0.6.
@addMethod(LocomotionEventsTransition)
private final func ApexGrappleLadderWait(system: ref<ApexGrappleSystem>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !system.fromLadder {
    this.ApexGrappleEndPull(system, "V caught a ladder during the pull", now, scriptInterface);
    return;
  }
  if now - system.startedAt > ApexGrappleLadderExitWait() {
    this.ApexGrappleEndPull(system, "the game kept V on the ladder", now, scriptInterface);
  }
}
