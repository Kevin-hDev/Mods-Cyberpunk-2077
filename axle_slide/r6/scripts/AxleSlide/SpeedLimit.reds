// Past 15 m/s. The engine holds V's speed at 15 (log of 21 October 2026: slides boosted toward 30 and 45 all ran at
// 15). The game lifts that hold for a dash with the TemporarySpeedLimitIgnore parameter, and puts it back when a
// dash or a sprint ends. While the speed boost is on, the locomotion states lift it again as they start, so a boosted
// slide keeps its speed, and so does the jump that may follow it. A few skip the common start (ladder slide and
// sprint, takedowns): nothing pushes V there, and the hold stays as the state before left it.
//
// Except the states of a hit (a car, a blast, a heavy blow), which push V away: with the hold lifted there, a car met
// head-on threw V back at about the speed V ran at (Kevin, 21 October 2026). Those keep the game's hold. The same
// rule, seen in game, runs in our other mods that lift this hold. Falls and landings keep the hold lifted, so that a
// jump keeps its speed; Landings.reds guards them instead.
public func AxleSlideIsHitReaction(state: CName) -> Bool {
  return Equals(state, n"knockdown") || Equals(state, n"vehicleKnockdown") || Equals(state, n"forcedKnockdown") || Equals(state, n"stunned") || Equals(state, n"felled");
}

// Whether this state lifts the hold, decided as it starts; Landings.reds guards landings exactly then.
@addField(LocomotionEventsTransition)
public let axleSlideLiftsLimit: Bool;

@wrapMethod(LocomotionEventsTransition)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let state: CName = this.GetStateName();
  if AxleSlideIsHitReaction(state) {
    this.axleSlideLiftsLimit = false;
    stateContext.SetPermanentBoolParameter(n"TemporarySpeedLimitIgnore", false, true);
    AxleSlideLog("hit: " + NameToString(state) + " at speed " + ToString(Vector4.Length2D(DefaultTransition.GetLinearVelocity(scriptInterface))) + ", the game's speed hold is back");
    return;
  }
  let settings: ref<AxleSlideSettings> = AxleSlideCurrentSettings();
  this.axleSlideLiftsLimit = settings.enabled && settings.speedBoost > 0.0;
  if this.axleSlideLiftsLimit {
    stateContext.SetPermanentBoolParameter(n"TemporarySpeedLimitIgnore", true, true);
  }
}
