// Past 15 m/s. Two limits hold V there: the MaxSpeed stat's own cap, raised by r6/tweaks/AutoSprint/speed_cap.yaml,
// and a hold of the engine on V's speed (log of 21 October 2026: MaxSpeed read 23.6, V still ran at 15). The game
// lifts that hold for a dash with the TemporarySpeedLimitIgnore parameter, and puts it back when a dash or a sprint
// ends. While the sprint or walk speed is above the game's, every locomotion state lifts it again as it starts, so the
// speed also carries into the jump or the slide that follows a sprint.
//
// Except the states of a hit (a car, a blast, a heavy blow), which push V away: with the hold lifted there, a car met
// head-on threw V back at about sprint speed (Kevin, 21 October 2026). Those keep the game's hold, at any sprint speed.
public func AutoSprintIsHitReaction(state: CName) -> Bool {
  return Equals(state, n"knockdown") || Equals(state, n"vehicleKnockdown") || Equals(state, n"forcedKnockdown") || Equals(state, n"stunned") || Equals(state, n"felled");
}

@wrapMethod(LocomotionEventsTransition)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let state: CName = this.GetStateName();
  if AutoSprintIsHitReaction(state) {
    stateContext.SetPermanentBoolParameter(n"TemporarySpeedLimitIgnore", false, true);
    stateContext.SetPermanentFloatParameter(n"AutoSprintHitTime", AutoSprintNow(scriptInterface), true);
    AutoSprintLog("hit: " + NameToString(state) + " at speed " + ToString(Vector4.Length2D(DefaultTransition.GetLinearVelocity(scriptInterface))) + ", the game's speed hold is back");
    return;
  }
  if AutoSprintFastestFactor() > 1.0 {
    stateContext.SetPermanentBoolParameter(n"TemporarySpeedLimitIgnore", true, true);
  }
}

// V's speed this long into a hit, in seconds, once the push has acted: the log shows how far the hit throws V.
public func AutoSprintHitReportAfter() -> Float {
  return 0.3;
}

@wrapMethod(LocomotionEventsTransition)
public func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  let hit: StateResultFloat = stateContext.GetPermanentFloatParameter(n"AutoSprintHitTime");
  if !hit.valid || hit.value < 0.0 {
    return;
  }
  let now: Float = AutoSprintNow(scriptInterface);
  if now >= hit.value && now - hit.value < AutoSprintHitReportAfter() {
    return;
  }
  stateContext.SetPermanentFloatParameter(n"AutoSprintHitTime", -1.0, true);
  AutoSprintLog(ToString(AutoSprintHitReportAfter()) + " s into the hit: speed " + ToString(Vector4.Length2D(DefaultTransition.GetLinearVelocity(scriptInterface))) + ", state " + NameToString(this.GetStateName()));
}
