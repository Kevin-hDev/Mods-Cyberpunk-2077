// Steering in the air: the momentum follows the move keys as walking does. The keys give a direction seen from the
// view, and every frame the momentum turns toward it, at most at the steering setting's rate, keeping its speed.
// Holding forward and turning the view quickly swings the momentum at once: Apex's tap strafe. With no key held the
// momentum goes straight on.
//
// The lever is Axle Slide's: a sideways push every frame, the turned velocity minus the current one, read again each
// frame. In the air too it turns the momentum by the angle asked without slowing it (essai 1, 22 October 2026:
// 190 degrees asked, 193 turned, 12.6 m/s kept).

// Under this, a stick is at rest: no direction is asked.
public func AirStrafeStickRest() -> Float {
  return 0.2;
}

// A push above this, in m/s in a single frame, is not a turn: refused and logged. At 1 400 degrees a second and
// 30 frames a second, a jump at 18 m/s (the game's air limit) asks about 14 m/s.
public func AirStrafeMaxPush() -> Float {
  return 20.0;
}

// A longer frame turns no more than this one would: a hitch must not swing the momentum in one go.
public func AirStrafeLongestFrame() -> Float {
  return 1.0 / 30.0;
}

// With the back turn off, the back key slows V by this much each second, in m/s: the game's own air acceleration
// (air stat group, Acceleration 5). Whether the game slows V by itself is unknown: in essai 1 (22 October 2026) the
// mod still turned V around with the option off, so the slowing is the mod's, sure to happen whatever the game does.
public func AirStrafeBackBraking() -> Float {
  return 5.0;
}

// What the keys ask for this frame: a direction seen from the view, how fast to turn toward it, and how hard the
// back key brakes (0 to 1). With the back turn off, the back key gives no direction, only braking: going back is
// never a turn then, and back with a side key steers to that side only.
//
// The air strafe and the tap strafe key are two switches that work alone or together (Kevin, 22 October 2026):
// - air strafe: side and back keys steer; forward steers too, toward the view, unless the tap strafe key is on;
// - tap strafe key on: forward no longer swings the momentum after the view, so a jump with forward held goes
//   straight, as in Apex where turning the view alone never tap strafes; only the chosen key, spammed or held,
//   swings it, at its own rate.
public struct AirStrafeKeys {
  public let direction: Vector4;
  public let rate: Float;
  public let braking: Float;
}

public func AirStrafeReadKeys(scriptInterface: ref<StateGameScriptInterface>) -> AirStrafeKeys {
  let keys: AirStrafeKeys;
  let side: Float = 0.0;
  let ahead: Float = 0.0;
  keys.rate = AirStrafeSteeringRate();
  if AirStrafeIsEnabled() {
    side = scriptInterface.GetActionValue(n"MoveX");
    ahead = scriptInterface.GetActionValue(n"MoveY");
    if AirStrafeTapEnabled() {
      ahead = MinF(ahead, 0.0);
    }
  }
  if AirStrafeTapEnabled() && AirStrafeTapHeld(scriptInterface.executionOwner.GetGame()) {
    ahead = 1.0;
    keys.rate = AirStrafeTapSteeringRate();
  }
  if !AirStrafeBackTurns() && ahead < 0.0 {
    keys.braking = MinF(-ahead, 1.0);
    ahead = 0.0;
  }
  if SqrtF(side * side + ahead * ahead) < AirStrafeStickRest() {
    keys.direction = new Vector4(0.0, 0.0, 0.0, 0.0);
    return keys;
  }
  let view: Vector4 = AirStrafeFlat(Transform.GetForward(scriptInterface.GetCameraWorldTransform()));
  let right: Vector4 = AirStrafeRightOf(view);
  keys.direction = new Vector4(view.X * ahead + right.X * side, view.Y * ahead + right.Y * side, 0.0, 0.0);
  return keys;
}

@addMethod(LocomotionAirEvents)
private final func AirStrafeSteer(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let velocity: Vector4 = AirStrafeFlat(DefaultTransition.GetLinearVelocity(scriptInterface));
  let speed: Float = Vector4.Length2D(velocity);
  this.airStrafeTurned += AirStrafeTurnBetween(this.airStrafeLastVelocity, velocity);
  this.airStrafeLastVelocity = velocity;
  let keys: AirStrafeKeys = AirStrafeReadKeys(scriptInterface);
  let steering: Float = MinF(Vector4.Length2D(keys.direction), 1.0);
  if steering < 0.001 && keys.braking < AirStrafeStickRest() {
    return;
  }
  let now: Float = this.GetInStateTime();
  let report: Bool = now >= this.airStrafeNextReport;
  if report {
    this.airStrafeNextReport = now + 0.5;
  }
  if speed < 1.0 {
    if report {
      AirStrafeLog("keys held at " + ToString(now) + " s, too slow to steer: speed " + ToString(speed));
    }
    return;
  }
  let frame: Float = MinF(timeDelta, AirStrafeLongestFrame());
  let push: Vector4 = new Vector4(0.0, 0.0, 0.0, 0.0);
  let step: Float = 0.0;
  if steering >= 0.001 {
    let limit: Float = keys.rate * frame * steering;
    step = ClampF(AirStrafeTurnBetween(velocity, keys.direction), -limit, limit);
    if AbsF(step) >= 0.01 {
      push = AirStrafeTurnRight(velocity, step) - velocity;
    }
  }
  let slowed: Float = 0.0;
  if keys.braking >= AirStrafeStickRest() {
    slowed = MinF(AirStrafeBackBraking() * frame * keys.braking, speed - 1.0);
    push = push - Vector4.Normalize2D(velocity) * slowed;
  }
  if Vector4.Length2D(push) > AirStrafeMaxPush() {
    if now - this.airStrafePushRefusedAt >= 1.0 {
      this.airStrafePushRefusedAt = now;
      AirStrafeLog("push of " + ToString(Vector4.Length2D(push)) + " m/s refused, above " + ToString(AirStrafeMaxPush()) + ", speed " + ToString(speed));
    }
    return;
  }
  if Vector4.Length2D(push) > 0.0 {
    stateContext.SetTemporaryVectorParameter(n"impulse", push, true);
    this.airStrafeAsked += step;
    this.airStrafeSlowed += slowed;
  }
  if report {
    AirStrafeLog("steering at " + ToString(now) + " s: asked " + ToString(this.airStrafeAsked) + ", turned " + ToString(this.airStrafeTurned) + ", still off by " + ToString(AirStrafeTurnBetween(velocity, keys.direction)) + ", slowed " + ToString(this.airStrafeSlowed) + ", speed " + ToString(speed) + ", rate " + ToString(keys.rate) + ", back turn " + ToString(AirStrafeBackTurns()));
  }
}
