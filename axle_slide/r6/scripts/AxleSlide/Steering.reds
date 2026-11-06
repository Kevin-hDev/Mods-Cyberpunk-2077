// Steering: the slide follows the move keys as walking does. The keys give a direction seen from the view (forward:
// where V looks; back: behind the view, a backward slide), and every frame the slide turns toward it, at most at the
// steering setting's rate, keeping its speed. Turning the view with forward held turns the slide; going round the
// keys, or round the stick, draws a circle. With no key held the slide goes straight on. The view is never turned.
//
// The lever, seen in game on 22 October 2026: a sideways push every frame, the turned velocity minus the current
// one, read again each frame, turned slides by the angle asked without slowing them. Turning V's body did not turn
// the slide.

// Under this, a stick is at rest: no direction is asked.
public func AxleSlideStickRest() -> Float {
  return 0.2;
}

// Looking nearly straight up or down, the view gives no direction on the ground.
public func AxleSlideFlatViewLeast() -> Float {
  return 0.01;
}

// Slower than this, in m/s, a slide is not steered.
public func AxleSlideSteerLeastSpeed() -> Float {
  return 1.0;
}

// The largest push in one frame, in m/s. A turn by an angle a at speed v pushes 2 v sin(a / 2): a frame that would
// push more turns less, so a fast slide, or a low frame rate, still turns, only slower. At 350 degrees a second, a
// 30 m/s slide pushes about 3 m/s a frame at 60 frames a second.
public func AxleSlideMaxPush() -> Float {
  return 6.0;
}

// The largest turn in one frame, in degrees, at this speed.
public func AxleSlideMaxStep(speed: Float) -> Float {
  let half: Float = AxleSlideMaxPush() / (2.0 * speed);
  if half >= 1.0 {
    return 180.0;
  }
  return 2.0 * Rad2Deg(AsinF(half));
}

@addField(SlideEvents)
public let axleSlideAsked: Float;

@addField(SlideEvents)
public let axleSlideTurned: Float;

@addField(SlideEvents)
public let axleSlideLastVelocity: Vector4;

@addField(SlideEvents)
public let axleSlidePushesCut: Int32;

// The direction the keys ask for, on the ground, seen from the view; zero when no key is held. The view is brought
// back to length 1 once flat, so looking up or down does not slow the turn.
public func AxleSlideKeyDirection(scriptInterface: ref<StateGameScriptInterface>) -> Vector4 {
  let side: Float = scriptInterface.GetActionValue(n"MoveX");
  let ahead: Float = scriptInterface.GetActionValue(n"MoveY");
  if SqrtF(side * side + ahead * ahead) < AxleSlideStickRest() {
    return new Vector4(0.0, 0.0, 0.0, 0.0);
  }
  let flat: Vector4 = AxleSlideFlat(Transform.GetForward(scriptInterface.GetCameraWorldTransform()));
  let length: Float = Vector4.Length2D(flat);
  if length < AxleSlideFlatViewLeast() {
    return new Vector4(0.0, 0.0, 0.0, 0.0);
  }
  let view: Vector4 = new Vector4(flat.X / length, flat.Y / length, 0.0, 0.0);
  let right: Vector4 = AxleSlideRightOf(view);
  return new Vector4(view.X * ahead + right.X * side, view.Y * ahead + right.Y * side, 0.0, 0.0);
}

@addMethod(SlideEvents)
private final func AxleSlideStartSteering(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  this.axleSlideAsked = 0.0;
  this.axleSlideTurned = 0.0;
  this.axleSlidePushesCut = 0;
  this.axleSlideLastVelocity = AxleSlideFlat(DefaultTransition.GetLinearVelocity(scriptInterface));
}

@addMethod(SlideEvents)
private final func AxleSlideSteer(timeDelta: Float, rate: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let velocity: Vector4 = AxleSlideFlat(DefaultTransition.GetLinearVelocity(scriptInterface));
  this.axleSlideTurned = this.axleSlideTurned + AxleSlideTurnBetween(this.axleSlideLastVelocity, velocity);
  this.axleSlideLastVelocity = velocity;
  let speed: Float = Vector4.Length2D(velocity);
  if speed < AxleSlideSteerLeastSpeed() {
    return;
  }
  let wanted: Vector4 = AxleSlideKeyDirection(scriptInterface);
  let strength: Float = Vector4.Length2D(wanted);
  if strength < 0.001 {
    return;
  }
  let limit: Float = rate * timeDelta * MinF(strength, 1.0);
  let step: Float = ClampF(AxleSlideTurnBetween(velocity, wanted), -limit, limit);
  let most: Float = AxleSlideMaxStep(speed);
  if AbsF(step) > most {
    step = ClampF(step, -most, most);
    this.axleSlidePushesCut = this.axleSlidePushesCut + 1;
  }
  if AbsF(step) < 0.01 {
    return;
  }
  stateContext.SetTemporaryVectorParameter(n"impulse", AxleSlideTurnRight(velocity, step) - velocity, true);
  this.axleSlideAsked = this.axleSlideAsked + step;
}
