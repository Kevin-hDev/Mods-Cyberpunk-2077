// Finding the wall in front of V in the air.

// The game's capsule for V, in m: V's size against walls and overhangs.
public func WallClimbCapsuleRadius() -> Float {
  return 0.4;
}

public func WallClimbCapsuleHeight() -> Float {
  return 1.8;
}

// From V's centre: the capsule's radius plus half a metre.
public func WallClimbReach() -> Float {
  return WallClimbCapsuleRadius() + 0.5;
}

// Chest height on V's capsule.
public func WallClimbChestHeight() -> Float {
  return 1.2;
}

// How far V may face away from the wall and still start a climb: the limit of the game's own ladder entry
// (enterAngleThreshold, 45 in the log of every refusal of our ladder in 2.5), kept from this mod's earlier versions,
// which climbed by a ladder.
public func WallClimbMostFacing() -> Float {
  return 45.0;
}

// A face whose normal rises more than this is a slope, not a wall: about 20 degrees off vertical.
public func WallClimbMostSlant() -> Float {
  return 0.35;
}

public struct WallClimbWall {
  // Something within reach, upright or not.
  let hit: Bool;
  // Upright: a wall V can catch.
  let found: Bool;
  // Where the ray met it.
  let face: Vector4;
  // Flat, pointing from the wall toward V.
  let normal: Vector4;
  // The surface normal's height: above zero, the wall leans back.
  let slant: Float;
  // Degrees between V's forward and the wall.
  let facing: Float;
}

// Waist height: the wall is still there when the chest has passed a window or the top.
public func WallClimbWaistHeight() -> Float {
  return 0.5;
}

// The ray toward the wall during a climb reaches its plane wherever V stands off it, a lean's width at most beyond
// WallClimbReach: leaning out (Overhang.reds, Step.reds), or just stepped in to a wall further back, V is farther.
// Short of it, a wall stepped in to was lost and taken again at every frame until V was pulled in, in game.
public func WallClimbFollowReach(climb: ref<WallClimbClimb>, feet: Vector4) -> Float {
  return ClampF(Vector4.Dot(feet - climb.wallPoint, climb.normal) + WallClimbBehindFace(), WallClimbReach(), WallClimbReach() + WallClimbMostOverhang());
}

// A ray toward the wall at chest height, then at the waist. `toward` is V's forward before a climb, and the way to
// the wall during one, so that looking around does not lose it; `forward` measures how far V faces away.
public func WallClimbFindWall(scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, toward: Vector4, reach: Float, forward: Vector4) -> WallClimbWall {
  let chest: WallClimbWall = WallClimbWallAt(scriptInterface, feet, WallClimbChestHeight(), toward, reach, forward);
  if chest.found {
    return chest;
  }
  let waist: WallClimbWall = WallClimbWallAt(scriptInterface, feet, WallClimbWaistHeight(), toward, reach, forward);
  if waist.found {
    return waist;
  }
  return chest;
}

public func WallClimbWallAt(scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, height: Float, toward: Vector4, reach: Float, forward: Vector4) -> WallClimbWall {
  let wall: WallClimbWall;
  let start: Vector4 = feet + DefaultTransition.GetUpVector() * height;
  let trace: TraceResult = scriptInterface.LocomotionRaycastTest(start, start + toward * reach);
  if !TraceResult.IsValid(trace) {
    return wall;
  }
  wall.hit = true;
  wall.face = Vector4.Vector3To4(trace.position);
  wall.slant = trace.normal.Z;
  if AbsF(wall.slant) > WallClimbMostSlant() {
    return wall;
  }
  wall.found = true;
  wall.normal = WallClimbFlat(Vector4.Vector3To4(trace.normal));
  wall.facing = WallClimbDegreesFromWall(forward, wall.normal);
  return wall;
}

// Built only for a line about to be written.
public func WallClimbWallText(wall: WallClimbWall, feet: Vector4) -> String {
  if !wall.hit {
    return "no wall within " + ToString(WallClimbReach()) + " m at chest or waist height";
  }
  if !wall.found {
    return "surface ahead not upright (normal.Z " + ToString(wall.slant) + ")";
  }
  return "wall " + ToString(Vector4.Distance2D(feet, wall.face)) + " m ahead, facing " + ToString(wall.facing) + " deg";
}
