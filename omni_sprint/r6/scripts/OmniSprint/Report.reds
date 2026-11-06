// What the log says about sprints, so that a test can be read afterwards: the direction and speed of each sprint once
// V runs at full speed, and the sprints the switch refuses.

// Long enough after the start for V to run at full speed, in seconds.
public func OmniSprintReportAfter() -> Float {
  return 1.0;
}

// A refused sprint is asked for again at every frame: one line at most per this many seconds.
public func OmniSprintRefusalReportEvery() -> Float {
  return 2.0;
}

// The heading the game compares with its angle limit (0 is forward, 180 backwards, the sign gives the side), and the
// speed it compares with its minimum sprint speed.
public func OmniSprintFacts(const scriptInterface: ref<StateGameScriptInterface>) -> String {
  return "input " + ToString(RoundF(scriptInterface.GetInputHeading())) + " degrees, speed " + ToString(scriptInterface.GetOwnerStateVectorParameterFloat(physicsStateValue.LinearSpeed));
}

public func OmniSprintLogRefusal(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let now: Float = EngineTime.ToFloat(GameInstance.GetSimTime(scriptInterface.GetGame()));
  let next: Float = stateContext.GetConditionFloat(n"OmniSprintRefusalReportAt");
  // A loaded save can bring the time back: a next report further ahead than one period is not waited for.
  if now < next && next - now <= OmniSprintRefusalReportEvery() {
    return;
  }
  stateContext.SetConditionFloatParameter(n"OmniSprintRefusalReportAt", now + OmniSprintRefusalReportEvery(), true);
  OmniSprintLog("switch off: sprint refused, " + OmniSprintFacts(scriptInterface));
}

@addField(SprintEvents)
public let omniSprintReported: Bool;

@wrapMethod(SprintEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  this.omniSprintReported = false;
}

@wrapMethod(SprintEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  if !this.omniSprintReported && this.GetInStateTime() >= OmniSprintReportAfter() {
    this.omniSprintReported = true;
    OmniSprintLog("after " + ToString(OmniSprintReportAfter()) + " s of sprint, " + OmniSprintFacts(scriptInterface));
  }
}
