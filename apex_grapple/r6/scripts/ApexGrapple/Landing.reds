// No damage on the landing of a grapple, as in Apex Legends: from the shot, the hook's flight included, until V has
// stood on the ground (Ground.reds), a hard, very hard or death landing becomes a regular one. The damage comes only
// from the very hard and death landing states (locomotionTransitions.script), which the game reaches two ways:
// - every air state judges the landing by V's vertical speed in LocomotionAirEvents.OnUpdate and writes LandingType;
//   the mod writes it back, with the Fall blackboard signal (Auto Sprint's lever for its landings). In game, a death
//   landing at 25 m/s after 4.9 s of free fall left V at full health;
// - the fall of a ground slam in the air (superheroFall) goes to the death landing by height alone, whatever
//   LandingType says. Until 30 October 2026, a slam from a grapple's height killed V (Kevin).

// The game's LandingType values: Regular 1, Hard 2, VeryHard 3, Superhero 4, Death 5.
public func ApexGrappleRegularLanding() -> Int32 {
  return 1;
}

public func ApexGrappleDeathLanding() -> Int32 {
  return 5;
}

// The Fall blackboard's RegularFall (gamePSMFallStates).
public func ApexGrappleRegularFall() -> Int32 {
  return 1;
}

public func ApexGrappleIsHardLanding(landing: Int32) -> Bool {
  return landing == 2 || landing == 3 || landing == ApexGrappleDeathLanding();
}

public func ApexGrappleSoftLandingCovers(system: ref<ApexGrappleSystem>) -> Bool {
  if !IsDefined(system) || !system.trajectory {
    return false;
  }
  return ApexGrappleGrappleSettings(system).softLanding;
}

@wrapMethod(LocomotionAirEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !ApexGrappleSoftLandingCovers(system) {
    return;
  }
  let landing: Int32 = stateContext.GetIntParameter(n"LandingType", true);
  system.gameLanding = landing;
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  system.fastestFall = MinF(system.fastestFall, velocity.Z);
  if !ApexGrappleIsHardLanding(landing) {
    return;
  }
  stateContext.SetPermanentIntParameter(n"LandingType", ApexGrappleRegularLanding(), true);
  this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Fall, ApexGrappleRegularFall());
  system.landingRewritten = Max(system.landingRewritten, landing);
}

// The slam's fall dies when V lands more than deathLanding (20 m, statemachine_locomotion.tweak read in 2.31) below the
// height kept as the slam begins (AirHoverEvents.SetDeathFallHeight, scripts 2.5). Refused, the next way out is the
// game's superhero landing, its blow on the enemies around included.
@wrapMethod(SuperheroFallDecisions)
protected const func ToDeathLand(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !wrappedMethod(stateContext, scriptInterface) {
    return false;
  }
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !ApexGrappleSoftLandingCovers(system) {
    return true;
  }
  system.landingRewritten = ApexGrappleDeathLanding();
  ApexGrappleLog("ground slam: death landing turned into the superhero landing");
  return false;
}
