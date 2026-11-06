// "No fall damage after a climb": from the start of a climb until V has stood a while on the ground, a hard, very hard
// or death landing becomes a regular one. The same lever as our grapple's soft landing, measured there in game (a
// death landing at 25 m/s left V at full health). The damage comes only from the very hard and death landing states
// (locomotionTransitions.script), which the game reaches two ways:
// - every air state judges the landing by V's vertical speed in LocomotionAirEvents.OnUpdate and writes LandingType;
//   the mod writes it back after it (Climb.reds calls this), with the Fall blackboard signal;
// - the fall of a ground slam in the air (superheroFall) goes to the death landing by height alone.

// How long V must stay on the ground before the climb's landing counts as over: a touch on the way down, read as
// ground, must not end the cover before the real landing.
public func WallClimbSettleTime() -> Float {
  return 0.5;
}

public func WallClimbIsHardLanding(landing: Int32) -> Bool {
  return landing == EnumInt(LandingType.Hard) || landing == EnumInt(LandingType.VeryHard) || landing == EnumInt(LandingType.Death);
}

@addMethod(LocomotionAirEvents)
private final func WallClimbSoftenLanding(climb: ref<WallClimbClimb>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let landing: Int32 = stateContext.GetIntParameter(n"LandingType", true);
  if !WallClimbIsHardLanding(landing) {
    return;
  }
  stateContext.SetPermanentIntParameter(n"LandingType", EnumInt(LandingType.Regular), true);
  this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Fall, EnumInt(gamePSMFallStates.RegularFall));
  climb.landingRewritten = Max(climb.landingRewritten, landing);
}

// The game takes V onto a ladder from a fall only when the landing would be less than very hard (TestLadderMath, scripts
// 2.5), and the soft landing tells it every landing is regular. So after a climb a ladder of the game's is judged on
// V's fall speed as the game judges the landing (VeryHardLandingFallingSpeed, LocomotionAirEvents.OnUpdate), as
// without the mod: a fast fall passes it by. Without this, our grapple's soft landing stopped V dead on a ladder at up
// to 38 m/s in game; not seen with the climb. On the ground V's speed is far above that limit.
public func WallClimbPassesLadderBy(const stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, verticalSpeed: Float) -> Bool {
  let climb: ref<WallClimbClimb> = WallClimbCurrent(scriptInterface);
  if !IsDefined(climb) || verticalSpeed > stateContext.GetFloatParameter(n"VeryHardLandingFallingSpeed", true) || IsDefined(WallClimbOurLadder(stateContext)) {
    return false;
  }
  climb.laddersPassed = climb.laddersPassed + 1;
  return true;
}

// The slam's fall dies when V lands more than deathLanding below the height kept as the slam begins
// (AirHoverEvents.SetDeathFallHeight, scripts 2.5). Refused, the next way out is the game's superhero landing.
@wrapMethod(SuperheroFallDecisions)
protected const func ToDeathLand(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !wrappedMethod(stateContext, scriptInterface) {
    return false;
  }
  let climb: ref<WallClimbClimb> = WallClimbCurrent(scriptInterface);
  if !IsDefined(climb) || !WallClimbCurrentSettings().softLanding {
    return true;
  }
  climb.landingRewritten = EnumInt(LandingType.Death);
  WallClimbLog("ground slam after a climb: death landing turned into the superhero landing");
  return false;
}
