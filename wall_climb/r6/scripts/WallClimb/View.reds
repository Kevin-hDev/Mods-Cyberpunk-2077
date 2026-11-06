// The view turns with V round a corner (Corner.reds), so the wall stays where the player sees it and the hands stay on
// screen. Only corners turn it: the ray toward the wall also follows the small bumps of a face, which would shake it.

// Degrees per second: a square corner in half a second. A quarter of a second was too quick in game.
public func WallClimbViewTurnRate() -> Float {
  return 180.0;
}

// Less than this many degrees of turn left, the view has caught up with the corner.
public func WallClimbViewTurnDone() -> Float {
  return 1.0;
}

// Round a corner, and while the view still turns from one, V goes along the wall no faster than the view turns.
public func WallClimbCornerSide(climb: ref<WallClimbClimb>, side: Float) -> Float {
  if !climb.rounding && AbsF(climb.viewTurnLeft) < WallClimbViewTurnDone() {
    return side;
  }
  let most: Float = Deg2Rad(WallClimbViewTurnRate()) * WallClimbHoldDistance();
  return ClampF(side, -most, most);
}

// Turns V by what is left of the corners' turn, at most the rate allows this frame. By the game's own way of turning
// V (an orientation without a slide, as when a knockdown turns V toward what hit it, scripts 2.5); the player keeps
// the camera. The orientation is the look turned round the vertical, its height kept: a level one brought the view
// back to shoulder height at every corner in game.
public func WallClimbTurnView(climb: ref<WallClimbClimb>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, timeDelta: Float) -> Void {
  if climb.viewTurnLeft == 0.0 {
    return;
  }
  let most: Float = WallClimbViewTurnRate() * timeDelta;
  let turn: Float = ClampF(climb.viewTurnLeft, -most, most);
  climb.viewTurnLeft = climb.viewTurnLeft - turn;
  let look: Vector4 = Transform.GetForward(scriptInterface.GetCameraWorldTransform());
  let facing: Vector4 = WallClimbTurned(look, turn);
  facing.Z = look.Z;
  let request: ref<AdjustTransformWithDurations> = new AdjustTransformWithDurations();
  request.SetPosition(new Vector4(0.0, 0.0, 0.0, 0.0));
  request.SetSlideDuration(-1.0);
  request.SetRotation(Quaternion.BuildFromDirectionVector(facing, DefaultTransition.GetUpVector()));
  request.SetRotationDuration(timeDelta);
  stateContext.SetTemporaryScriptableParameter(n"adjustTransform", request, true);
}

// Degrees between where the camera looks and the wall, seen from above: on our ladder V's body faces the wall,
// wherever the view turns.
public func WallClimbViewFromWall(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>) -> Float {
  return WallClimbDegreesFromWall(WallClimbFlat(Transform.GetForward(scriptInterface.GetCameraWorldTransform())), climb.normal);
}

// Degrees above the horizon the camera looks, for the corner lines of the log.
public func WallClimbViewPitch(scriptInterface: ref<StateGameScriptInterface>) -> Float {
  let look: Vector4 = Transform.GetForward(scriptInterface.GetCameraWorldTransform());
  return Rad2Deg(AsinF(ClampF(look.Z, -1.0, 1.0)));
}
