// Omni Sprint: the sprint works in every direction.
// The tweak file opens the game's angle limit, which the game reads only when a save loads (notes, enquête 1). While
// the switch is off, these wrappers apply the game's own limit themselves, so the switch acts at once.

// The game's limit, read in game 2.31 with the CET console (playerStateMachineLocomotion.sprint.enterAngleThreshold).
public func OmniSprintGameAngle() -> Float {
  return 55.0;
}

public func OmniSprintBeyondGameAngle(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  return scriptInterface.IsMoveInputConsiderable() && AbsF(scriptInterface.GetInputHeading()) > OmniSprintGameAngle();
}

// The angle comes first: within the game's limit, the settings need not be read.
public func OmniSprintBlocked(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  return OmniSprintBeyondGameAngle(scriptInterface) && !OmniSprintIsEnabled();
}

// What the game itself clears when its angle limit refuses or stops a sprint (SprintDecisions, scripts 2.31).
public func OmniSprintDropSprintRequest(const stateContext: ref<StateContext>) -> Void {
  stateContext.SetConditionBoolParameter(n"SprintToggled", false, true);
  stateContext.SetConditionBoolParameter(n"SprintHoldCanStartWithoutNewInput", false, true);
}

@wrapMethod(SprintDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if OmniSprintBlocked(scriptInterface) {
    if this.m_sprintPressed || this.m_toggleSprintPressed || stateContext.GetConditionBool(n"SprintToggled") {
      OmniSprintLogRefusal(stateContext, scriptInterface);
    }
    OmniSprintDropSprintRequest(stateContext);
    return false;
  }
  return wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(SprintDecisions)
protected const func ToStand(stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if OmniSprintBlocked(scriptInterface) {
    OmniSprintLog("switch off: sprint stopped, " + OmniSprintFacts(scriptInterface));
    OmniSprintDropSprintRequest(stateContext);
    return true;
  }
  let stops: Bool = wrappedMethod(stateContext, scriptInterface);
  if stops && OmniSprintBeyondGameAngle(scriptInterface) {
    OmniSprintLog("the game stopped a sprint beyond its own angle limit after " + ToString(this.GetInStateTime()) + " s, " + OmniSprintFacts(scriptInterface));
  }
  return stops;
}
