// A key, or a stick pushed more than halfway, counts; below that nothing counts.
public func WallClimbHalfPush() -> Float {
  return 0.5;
}

// A key, stick or ray read can drop for a frame; this is too short to be seen.
public func WallClimbReleaseGrace() -> Float {
  return 0.15;
}

// The climb goes within this many degrees of straight up; its side part takes V along the wall, so the keys forward
// and left or right climb diagonally, and left or right alone along the wall without rising (Kevin, 31 October 2026:
// 180 degrees in all, 160 before). The stick a little under flat climbs sideways too: players hold it flat along a
// wall, and V stopping there made almost all the stops of sideways climbs in game.
public func WallClimbMostStickAngle() -> Float {
  return 90.0;
}

public func WallClimbPushesForward(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  return scriptInterface.GetActionValue(n"MoveY") > WallClimbHalfPush();
}

// The move keys or stick, read once a frame: X to the right, Y forward.
public func WallClimbMoveKeys(scriptInterface: ref<StateGameScriptInterface>) -> Vector4 {
  return new Vector4(scriptInterface.GetActionValue(n"MoveX"), scriptInterface.GetActionValue(n"MoveY"), 0.0, 0.0);
}

// Back, and more back than to the side: a stick held to the side that sags under it climbs on (WallClimbStickOnWall).
public func WallClimbPushesBack(keys: Vector4) -> Bool {
  return -keys.Y > WallClimbHalfPush() && -keys.Y > AbsF(keys.X);
}

// The stick on the wall, of length 1: X to the right along the wall, Y up. Zero when it is not pushed on the wall, or
// more back than to the side. The camera plays no part: looking around does not change the way V climbs.
public func WallClimbStickOnWall(keys: Vector4) -> Vector4 {
  let none: Vector4;
  let push: Float = SqrtF(keys.X * keys.X + keys.Y * keys.Y);
  if push <= WallClimbHalfPush() || keys.Y < -AbsF(keys.X) {
    return none;
  }
  let angle: Float = Deg2Rad(MinF(Rad2Deg(AcosF(ClampF(keys.Y / push, -1.0, 1.0))), WallClimbMostStickAngle()));
  // Not below zero: the cosine of 90 degrees comes out a hair under it.
  return new Vector4((keys.X < 0.0 ? -1.0 : 1.0) * SinF(angle), MaxF(CosF(angle), 0.0), 0.0, 0.0);
}
