// Directions and turns on the ground plane. In the game's world X points east, Y north and Z up, so the right of a
// direction (x, y) is (y, -x), checked against the game's GetWorldRight in game (Axle Slide, 22 October 2026).
// Turns to the right count positive.

public func AirStrafeFlat(v: Vector4) -> Vector4 {
  return new Vector4(v.X, v.Y, 0.0, 0.0);
}

public func AirStrafeRightOf(v: Vector4) -> Vector4 {
  return new Vector4(v.Y, -v.X, 0.0, 0.0);
}

public func AirStrafeTurnRight(v: Vector4, degrees: Float) -> Vector4 {
  let angle: Float = Deg2Rad(degrees);
  let right: Vector4 = AirStrafeRightOf(v);
  return new Vector4(v.X * CosF(angle) + right.X * SinF(angle), v.Y * CosF(angle) + right.Y * SinF(angle), 0.0, 0.0);
}

// The turn from a to b in degrees, right positive; 0 when either is too short to have a direction.
public func AirStrafeTurnBetween(a: Vector4, b: Vector4) -> Float {
  let lengths: Float = Vector4.Length2D(a) * Vector4.Length2D(b);
  if lengths < 0.0001 {
    return 0.0;
  }
  let angle: Float = Rad2Deg(AcosF(ClampF((a.X * b.X + a.Y * b.Y) / lengths, -1.0, 1.0)));
  if Vector4.Dot2D(AirStrafeRightOf(a), b) < 0.0 {
    return -angle;
  }
  return angle;
}
