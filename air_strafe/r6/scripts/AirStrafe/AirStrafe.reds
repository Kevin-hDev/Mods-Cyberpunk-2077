// Air Strafe: in the air, the move keys steer V's momentum as walking does, without losing speed (air strafe), and
// a quick turn of the view with forward held swings it at once (tap strafe), as in Apex Legends. The start, every
// frame and the end of each air state are wired here; the steering lives in Steering.reds.
//
// Every air state of the game derives from LocomotionAirEvents and goes through its OnEnter, OnUpdate and OnExit
// (scripts 2.31: each override calls the parent). The states that move V their own way keep the game's control.

@addField(LocomotionAirEvents)
public let airStrafeAsked: Float;

@addField(LocomotionAirEvents)
public let airStrafeTurned: Float;

@addField(LocomotionAirEvents)
public let airStrafeLastVelocity: Vector4;

@addField(LocomotionAirEvents)
public let airStrafeNextReport: Float;

@addField(LocomotionAirEvents)
public let airStrafePushRefusedAt: Float;

@addField(LocomotionAirEvents)
public let airStrafeStartSpeed: Float;

// Speed taken off by the back key with the back turn off, in m/s.
@addField(LocomotionAirEvents)
public let airStrafeSlowed: Float;

// Thrusters, hovering, the air dash, the superhero fall and the body slam steer or aim V themselves.
@addMethod(LocomotionAirEvents)
private final func AirStrafeSteersHere() -> Bool {
  return !IsDefined(this as AirThrustersEvents) && !IsDefined(this as AirHoverEvents) && !IsDefined(this as DodgeAirEvents) && !IsDefined(this as SuperheroFallEvents) && !IsDefined(this as BodySlamJumpEvents);
}

@wrapMethod(LocomotionAirEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  this.airStrafeAsked = 0.0;
  this.airStrafeTurned = 0.0;
  this.airStrafeSlowed = 0.0;
  this.airStrafeLastVelocity = AirStrafeFlat(DefaultTransition.GetLinearVelocity(scriptInterface));
  this.airStrafeStartSpeed = Vector4.Length2D(this.airStrafeLastVelocity);
  this.airStrafeNextReport = 0.0;
  this.airStrafePushRefusedAt = -10.0;
  if this.AirStrafeSteersHere() {
    AirStrafeLog(NameToString(this.GetClassName()) + " start, speed " + ToString(this.airStrafeStartSpeed) + ", switch " + ToString(AirStrafeIsEnabled()));
  }
}

@wrapMethod(LocomotionAirEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  if (AirStrafeIsEnabled() || AirStrafeTapEnabled()) && this.AirStrafeSteersHere() && !this.IsTouchingGround(scriptInterface) {
    this.AirStrafeSteer(timeDelta, stateContext, scriptInterface);
  }
}

@wrapMethod(LocomotionAirEvents)
public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if this.AirStrafeSteersHere() {
    AirStrafeLog(NameToString(this.GetClassName()) + " end after " + ToString(this.GetInStateTime()) + " s, speed " + ToString(this.airStrafeStartSpeed) + " -> " + ToString(Vector4.Length2D(DefaultTransition.GetLinearVelocity(scriptInterface))) + ", steering asked " + ToString(this.airStrafeAsked) + ", turned " + ToString(this.airStrafeTurned) + ", slowed " + ToString(this.airStrafeSlowed));
  }
  wrappedMethod(stateContext, scriptInterface);
}
