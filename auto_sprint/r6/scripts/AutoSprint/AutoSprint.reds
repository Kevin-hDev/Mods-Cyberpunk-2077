// Auto Sprint: V sprints on its own when moving forward.
// It only switches on the game's own sprint toggle; every rule of the game (aiming, shooting, angle, stamina)
// still decides whether V may sprint, and the mod waits for a reload (Reload.reds). Crouching and the slow walk
// toggle stop it, as they stop the game's toggle. Forward is the game's own angle limit, which Omni Sprint widens.
// Switched off in the settings, both wrappers hand over to the game untouched.

@addMethod(SprintDecisions)
private final const func AutoSprintWanted(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !scriptInterface.IsMoveInputConsiderable() {
    return false;
  }
  // A walk key press waits there until V stands; it must not be overtaken by a new sprint.
  if stateContext.GetBoolParameter(n"WalkToggled", true) || stateContext.GetBoolParameter(n"ToggleWalkInputRegistered", true) {
    return false;
  }
  if stateContext.IsStateActive(n"Locomotion", n"crouch") || stateContext.IsStateActive(n"Locomotion", n"crouchSprint") {
    return false;
  }
  if this.AutoSprintWaitsForReload(scriptInterface) {
    return false;
  }
  return true;
}

@wrapMethod(SprintDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !AutoSprintIsEnabled() {
    return wrappedMethod(stateContext, scriptInterface);
  }
  let wanted: Bool = this.AutoSprintWanted(stateContext, scriptInterface);
  if wanted {
    stateContext.SetConditionBoolParameter(n"SprintToggled", true, true);
  }
  let canEnter: Bool = wrappedMethod(stateContext, scriptInterface);
  // With no sprint key held, the game stops asking this question until a sprint key is pressed.
  // Keep it asking, or the automatic sprint would never start again after a stop.
  this.EnableOnEnterCondition(true);
  if canEnter && wanted {
    AutoSprintLog("sprint started");
  }
  return canEnter;
}

// The game reads the walk key only once V stands (StandEvents.OnTick), so during a sprint it did nothing
// until V stopped. Leaving the sprint as soon as the key is pressed lets the walk start while running.
@wrapMethod(SprintDecisions)
protected const func ToStand(stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if AutoSprintIsEnabled() && stateContext.GetBoolParameter(n"ToggleWalkInputRegistered", true) {
    stateContext.SetConditionBoolParameter(n"SprintToggled", false, true);
    stateContext.SetConditionBoolParameter(n"SprintHoldCanStartWithoutNewInput", false, true);
    return true;
  }
  return wrappedMethod(stateContext, scriptInterface);
}
