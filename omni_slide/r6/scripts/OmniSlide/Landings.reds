// Hard landings with no real fall: the game judges a landing only by V's vertical speed in the air
// (LocomotionAirEvents.OnUpdate). With the speed hold lifted (SpeedLimit.reds), V moves far faster than the game
// expects, and a curb taken at speed can read as a hard landing: "landing 2 turned into 1: vertical speed -12.675149,
// real fall 0.234780 m, horizontal speed 33.575096" (Auto Sprint, log of 21 October 2026). While the slide speed is
// above the game's, a hard, very hard or death landing stands only if V really came down from that high since
// leaving the ground; otherwise it becomes what the real height gives. Real falls keep the game's damage.
// Auto Sprint carries the same guard for the sprint: with both installed, the first to act leaves nothing for the other.

public func OmniSlideIsHardLanding(landing: Int32) -> Bool {
  return landing == EnumInt(LandingType.Hard) || landing == EnumInt(LandingType.VeryHard) || landing == EnumInt(LandingType.Death);
}

// What the game writes on the PlayerStateMachine.Fall blackboard for each landing (LocomotionAirEvents.OnUpdate).
public func OmniSlideFallSignal(landing: Int32) -> Int32 {
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
protected final const func OmniSlideLandingForHeight(height: Float) -> Int32 {
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
protected final const func OmniSlideFallFacts(velocity: Vector4, fallen: Float) -> String {
  return "vertical speed " + ToString(velocity.Z) + ", real fall " + ToString(fallen) + " m, horizontal speed " + ToString(Vector4.Length2D(velocity)) + ", state " + NameToString(this.GetStateName());
}

// Whether this state guards landings, decided as it starts so that no frame reads the settings; a setting changed in
// the menu counts from the next state.
@addField(LocomotionEventsTransition)
public let omniSlideGuardsLandings: Bool;

@wrapMethod(LocomotionEventsTransition)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  this.omniSlideGuardsLandings = OmniSlideSpeedFactor() > 1.0;
}

// V's highest point since the ground: a bump lifts V while the state is still the slide. Followed in the states that
// call the common update; those that do not (outils/boucle_commune.py: a ledge climb, a superhero landing, low
// gravity, a braindance, breaking free of a grab) are no slide that a bump could lift.
@wrapMethod(LocomotionEventsTransition)
public func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  if !this.omniSlideGuardsLandings {
    return;
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  if scriptInterface.IsOnGround() {
    stateContext.SetPermanentFloatParameter(n"OmniSlidePeak", feet.Z, true);
    stateContext.SetPermanentIntParameter(n"OmniSlideLandingLogged", 0, true);
    return;
  }
  let peak: StateResultFloat = stateContext.GetPermanentFloatParameter(n"OmniSlidePeak");
  if !peak.valid || feet.Z > peak.value {
    stateContext.SetPermanentFloatParameter(n"OmniSlidePeak", feet.Z, true);
  }
}

@wrapMethod(LocomotionAirEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  if !this.omniSlideGuardsLandings || this.IsTouchingGround(scriptInterface) {
    return;
  }
  let landing: Int32 = stateContext.GetIntParameter(n"LandingType", true);
  let peak: StateResultFloat = stateContext.GetPermanentFloatParameter(n"OmniSlidePeak");
  if !OmniSlideIsHardLanding(landing) || !peak.valid {
    return;
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  let fallen: Float = MaxF(peak.value - feet.Z, 0.0);
  let allowed: Int32 = this.OmniSlideLandingForHeight(fallen);
  // One line each time the game's verdict changes during a fall, not one per frame.
  let logged: Bool = stateContext.GetIntParameter(n"OmniSlideLandingLogged", true) == landing;
  stateContext.SetPermanentIntParameter(n"OmniSlideLandingLogged", landing, true);
  if allowed >= landing {
    if !logged {
      OmniSlideLog("landing " + ToString(landing) + " ahead, as in the game: " + this.OmniSlideFallFacts(velocity, fallen));
    }
    return;
  }
  stateContext.SetPermanentIntParameter(n"LandingType", allowed, true);
  this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Fall, OmniSlideFallSignal(allowed));
  if !logged {
    OmniSlideLog("landing " + ToString(landing) + " turned into " + ToString(allowed) + ": " + this.OmniSlideFallFacts(velocity, fallen));
  }
}
