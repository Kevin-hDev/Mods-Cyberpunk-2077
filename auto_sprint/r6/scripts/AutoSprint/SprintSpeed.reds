// Sprint speed: while V sprints, a multiplier on the MaxSpeed stat (SpeedModifiers.reds). Read at the start of each
// sprint, so a new value counts from the next sprint. The crouched sprint is not a sprint state (CrouchSprintEvents
// derives from CrouchEvents) and keeps the game's speed, as the menu says (Kevin, 25 October 2026).

// When the log gives V's real speed in a sprint, in seconds: the stat alone does not show the engine's hold on speed.
public func AutoSprintSpeedReportAfter() -> Float {
  return 1.0;
}

@addField(SprintEvents)
public let autoSprintSpeedLogged: Bool;

@wrapMethod(SprintEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  this.autoSprintSpeedLogged = false;
  let factor: Float = AutoSprintSceneSetsPace(scriptInterface) ? 1.0 : AutoSprintSpeedFactor();
  AutoSprintSetSpeedFactor(stateContext, scriptInterface, n"AutoSprintSprintModifier", factor);
  if factor != 1.0 {
    AutoSprintLog("sprint speed x" + ToString(factor) + ", MaxSpeed now " + ToString(AutoSprintMaxSpeed(scriptInterface)));
  }
}

@wrapMethod(SprintEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  if !this.autoSprintSpeedLogged && this.GetInStateTime() >= AutoSprintSpeedReportAfter() {
    this.autoSprintSpeedLogged = true;
    AutoSprintLog("after " + ToString(AutoSprintSpeedReportAfter()) + " s of sprint, speed " + ToString(Vector4.Length2D(DefaultTransition.GetLinearVelocity(scriptInterface))) + ", limit lifted " + ToString(stateContext.GetBoolParameter(n"TemporarySpeedLimitIgnore", true)));
  }
}

// Every way out of the sprint goes through OnExit (jumps call it too) or OnForcedExit.
@wrapMethod(SprintEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  AutoSprintSetSpeedFactor(stateContext, scriptInterface, n"AutoSprintSprintModifier", 1.0);
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(SprintEvents)
public func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  AutoSprintSetSpeedFactor(stateContext, scriptInterface, n"AutoSprintSprintModifier", 1.0);
  wrappedMethod(stateContext, scriptInterface);
}
