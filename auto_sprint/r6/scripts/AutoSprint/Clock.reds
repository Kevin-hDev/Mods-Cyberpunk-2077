// The game's time in seconds, shared by the step up and the hit report. A loaded save can bring it back: each user
// checks for a time that goes back.
public func AutoSprintNow(scriptInterface: ref<StateGameScriptInterface>) -> Float {
  return EngineTime.ToFloat(GameInstance.GetSimTime(scriptInterface.GetGame()));
}
