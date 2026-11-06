// Deaths with no fall: the game judges a landing only by V's vertical speed in the air (LocomotionAirEvents.OnUpdate);
// a death landing from 25.3 m/s down, the speed of a 20 m fall (fall.deathLanding). On 21 October 2026, V died
// brushing a pole while sprinting at 5 times the game's speed; the log of that minute was lost in a crash, so the
// cause is not proven. At 39 m/s, a knock can turn part of the run into a plunge with no real fall. While the sprint
// or the walk is faster than the game's, a hard, very hard or death landing stands only if V really came down from
// that high since leaving the ground; otherwise it becomes what the real height gives. Real falls keep the game's
// damage.

public func AutoSprintIsHardLanding(landing: Int32) -> Bool {
  return landing == EnumInt(LandingType.Hard) || landing == EnumInt(LandingType.VeryHard) || landing == EnumInt(LandingType.Death);
}

// What the game writes on the PlayerStateMachine.Fall blackboard for each landing (LocomotionAirEvents.OnUpdate).
public func AutoSprintFallSignal(landing: Int32) -> Int32 {
  if landing == EnumInt(LandingType.Death) {
    return EnumInt(gamePSMFallStates.DeathFall);
  }
  if landing == EnumInt(LandingType.VeryHard) {
    return EnumInt(gamePSMFallStates.VeryFastFall);
  }
  if landing == EnumInt(LandingType.Hard) {
    return EnumInt(gamePSMFallStates.FastFall);
  }
  return EnumInt(gamePSMFallStates.RegularFall);
}

// The landing that the height V really came down from gives, with the state's own heights (5, 10 and 20 m).
@addMethod(LocomotionAirEvents)
protected final const func AutoSprintLandingForHeight(height: Float) -> Int32 {
  if height >= this.GetStaticFloatParameterDefault("deathLanding", 20.0) {
    return EnumInt(LandingType.Death);
  }
  if height >= this.GetStaticFloatParameterDefault("veryHardLandingHeight", 10.0) {
    return EnumInt(LandingType.VeryHard);
  }
  if height >= this.GetStaticFloatParameterDefault("hardLandingHeight", 5.0) {
    return EnumInt(LandingType.Hard);
  }
  return EnumInt(LandingType.Regular);
}

@addMethod(LocomotionAirEvents)
protected final const func AutoSprintFallFacts(velocity: Vector4, fallen: Float) -> String {
  return "vertical speed " + ToString(velocity.Z) + ", real fall " + ToString(fallen) + " m, horizontal speed " + ToString(Vector4.Length2D(velocity)) + ", state " + NameToString(this.GetStateName());
}

// V's highest point since the ground: a step or a knock lifts V while the state is still the sprint. Followed in the
// states that call the common update; those that do not (outils/boucle_commune.py: a ledge climb, a superhero
// landing, low gravity, a braindance, breaking free of a grab) are no run that a knock could lift.
@wrapMethod(LocomotionEventsTransition)
public func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  if scriptInterface.IsOnGround() {
    stateContext.SetPermanentFloatParameter(n"AutoSprintPeak", feet.Z, true);
    stateContext.SetPermanentIntParameter(n"AutoSprintLandingLogged", 0, true);
    return;
  }
  let peak: StateResultFloat = stateContext.GetPermanentFloatParameter(n"AutoSprintPeak");
  if !peak.valid || feet.Z > peak.value {
    stateContext.SetPermanentFloatParameter(n"AutoSprintPeak", feet.Z, true);
  }
}

@wrapMethod(LocomotionAirEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  if AutoSprintFastestFactor() <= 1.0 || this.IsTouchingGround(scriptInterface) {
    return;
  }
  let landing: Int32 = stateContext.GetIntParameter(n"LandingType", true);
  let peak: StateResultFloat = stateContext.GetPermanentFloatParameter(n"AutoSprintPeak");
  if !AutoSprintIsHardLanding(landing) || !peak.valid {
    return;
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  let fallen: Float = MaxF(peak.value - feet.Z, 0.0);
  let allowed: Int32 = this.AutoSprintLandingForHeight(fallen);
  // One line each time the game's verdict changes during a fall, not one per frame.
  let logged: Bool = stateContext.GetIntParameter(n"AutoSprintLandingLogged", true) == landing;
  stateContext.SetPermanentIntParameter(n"AutoSprintLandingLogged", landing, true);
  if allowed >= landing {
    if !logged {
      AutoSprintLog("landing " + ToString(landing) + " ahead, as in the game: " + this.AutoSprintFallFacts(velocity, fallen));
    }
    return;
  }
  stateContext.SetPermanentIntParameter(n"LandingType", allowed, true);
  this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Fall, AutoSprintFallSignal(allowed));
  if !logged {
    AutoSprintLog("landing " + ToString(landing) + " turned into " + ToString(allowed) + ": " + this.AutoSprintFallFacts(velocity, fallen));
  }
}
