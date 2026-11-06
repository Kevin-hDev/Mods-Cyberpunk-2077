// Directions round a wall, seen from above: the climb works with flat directions, and with the wall's normal flat and
// pointing from the wall toward V.

public func WallClimbFlat(v: Vector4) -> Vector4 {
  let flat: Vector4 = v;
  flat.Z = 0.0;
  return Vector4.Normalize2D(flat);
}

// To the right along the wall, as seen facing it.
public func WallClimbAlongWall(normal: Vector4) -> Vector4 {
  return Vector4.Normalize2D(Vector4.Cross(DefaultTransition.GetUpVector(), normal));
}

// Degrees between a flat direction and facing the wall straight on.
public func WallClimbDegreesFromWall(direction: Vector4, normal: Vector4) -> Float {
  return Rad2Deg(AcosF(ClampF(-Vector4.Dot(direction, normal), -1.0, 1.0)));
}

// Degrees from one flat direction to another, positive counterclockwise seen from above, the way WallClimbTurned turns.
public func WallClimbYawBetween(from: Vector4, to: Vector4) -> Float {
  let angle: Float = Rad2Deg(AcosF(ClampF(Vector4.Dot(from, to), -1.0, 1.0)));
  return from.X * to.Y - from.Y * to.X < 0.0 ? -angle : angle;
}

public func WallClimbTurned(direction: Vector4, degrees: Float) -> Vector4 {
  let cosine: Float = CosF(Deg2Rad(degrees));
  let sine: Float = SinF(Deg2Rad(degrees));
  return new Vector4(direction.X * cosine - direction.Y * sine, direction.X * sine + direction.Y * cosine, 0.0, 0.0);
}
