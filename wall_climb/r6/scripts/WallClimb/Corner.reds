// Going round the corners of a wall while climbing sideways. A wall that turns toward V (an inside corner) is met by
// a ray along the way V moves, and the climb takes the new wall at once. A wall that turns away (an outside corner)
// is lost by the ray toward it: a ray from just behind the face finds the next face, and V goes round the edge where
// the two faces meet, on an arc the push keeps (Push.reds). Gentle bends need neither: the ray toward the wall follows
// them frame by frame (Climb.reds). Each corner turns the view with V (View.reds).

// Slower than this along the wall, in m/s, V is climbing past an edge, not going round it.
public func WallClimbCornerSideSpeed() -> Float {
  return 1.0;
}

// An inside corner is taken when the next wall is this close to V's centre, before the capsule meets it.
public func WallClimbInsideReach() -> Float {
  return WallClimbCapsuleRadius() + 0.3;
}

// The sine of 30 degrees: a face turned less than that from the wall is a bend, which the ray toward the wall follows.
public func WallClimbLeastCornerTurn() -> Float {
  return 0.5;
}

// The cosine of 60 degrees: a face the ray toward the wall meets turned further than that is another face, the side
// of a pipe or, just past an edge, the face V left, grazed by the ray. Followed, it would turn the wall back and V
// would go round the same edge again.
public func WallClimbLeastSameWall() -> Float {
  return 0.5;
}

// How far behind a face its rays look, in m. The next face of an outside corner is looked for this far behind the
// face V leaves: shallow enough to find the end of a wall 10 cm thick; a thinner panel lets V go at its end. It is
// also the margin past the face of the ray toward the wall (Wall.reds), of the overhang's ray (Overhang.reds) and of
// the ray toward an edge (here).
public func WallClimbBehindFace() -> Float {
  return 0.1;
}

// How far that ray looks back, and the farthest an edge may be from V.
public func WallClimbEdgeSearch() -> Float {
  return 1.0;
}

// The climb's wall turns with a corner, and the view with it.
// An overhang is read against the wall it juts out from: a corner ends the lean.
public func WallClimbCornerTurn(climb: ref<WallClimbClimb>, normal: Vector4) -> Void {
  climb.viewTurnLeft = climb.viewTurnLeft + WallClimbYawBetween(climb.normal, normal);
  climb.normal = normal;
  climb.overhang = false;
}

// The way V moves along the wall, or zero when V is too slow to take a corner.
public func WallClimbSideWay(climb: ref<WallClimbClimb>) -> Vector4 {
  let none: Vector4;
  if AbsF(climb.side) < WallClimbCornerSideSpeed() {
    return none;
  }
  return WallClimbAlongWall(climb.normal) * (climb.side > 0.0 ? 1.0 : -1.0);
}

// Not while leaning out: the side ray would meet again the step V leans out round.
public func WallClimbTakeInsideCorner(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, now: Float) -> Void {
  let way: Vector4 = WallClimbSideWay(climb);
  if Vector4.IsZero(way) || climb.overhang {
    return;
  }
  let next: WallClimbWall = WallClimbWallAt(scriptInterface, feet, WallClimbChestHeight(), way, WallClimbInsideReach(), way);
  if !next.found || Vector4.Dot(next.normal, way) > -WallClimbLeastCornerTurn() || WallClimbStepOut(climb, scriptInterface, feet, next, way, now) {
    return;
  }
  let turn: Float = WallClimbYawBetween(climb.normal, next.normal);
  WallClimbCornerTurn(climb, next.normal);
  climb.slant = next.slant;
  climb.wallPoint = next.face;
  climb.wallSeenAt = now;
  climb.corners = climb.corners + 1;
  WallClimbLog("inside corner: the wall turns " + ToString(turn) + " deg, " + ToString(Vector4.Distance2D(feet, next.face)) + " m away, view pitch " + ToString(WallClimbViewPitch(scriptInterface)) + " deg");
}

// Called while the ray toward the wall finds nothing: V starts going round an edge if one is there.
public func WallClimbFindEdge(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, now: Float) -> Void {
  let way: Vector4 = WallClimbSideWay(climb);
  if Vector4.IsZero(way) {
    return;
  }
  let chest: Vector4 = feet + DefaultTransition.GetUpVector() * WallClimbChestHeight();
  let behind: Vector4 = chest - climb.normal * (Vector4.Dot(feet - climb.wallPoint, climb.normal) + WallClimbBehindFace());
  let trace: TraceResult = scriptInterface.LocomotionRaycastTest(behind, behind - way * WallClimbEdgeSearch());
  if !TraceResult.IsValid(trace) || AbsF(trace.normal.Z) > WallClimbMostSlant() {
    return;
  }
  let next: Vector4 = WallClimbFlat(Vector4.Vector3To4(trace.normal));
  if Vector4.Dot(next, way) < WallClimbLeastCornerTurn() {
    return;
  }
  // Where the face V leaves meets the next one, seen from above; the test above keeps the division away from zero.
  let along: Vector4 = WallClimbAlongWall(climb.normal);
  let edge: Vector4 = climb.wallPoint + along * (Vector4.Dot(Vector4.Vector3To4(trace.position) - climb.wallPoint, next) / Vector4.Dot(along, next));
  edge.Z = feet.Z;
  if Vector4.Distance2D(feet, edge) > WallClimbEdgeSearch() {
    return;
  }
  climb.rounding = true;
  climb.cornerFrom = climb.normal;
  climb.cornerTo = next;
  climb.edge = edge;
  climb.roundingSince = now;
  climb.corners = climb.corners + 1;
  WallClimbLog("outside corner: the wall turns " + ToString(WallClimbYawBetween(climb.normal, next)) + " deg round an edge " + ToString(Vector4.Distance2D(feet, edge)) + " m away, view pitch " + ToString(WallClimbViewPitch(scriptInterface)) + " deg");
  WallClimbRound(climb, scriptInterface, feet, now);
}

// One frame round the edge, where the wall is the edge itself, facing V. Done when V faces the next face, or back
// on the one it left when the stick turns back.
public func WallClimbRound(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, now: Float) -> Void {
  let around: Vector4 = WallClimbFlat(feet - climb.edge);
  let done: Float = WallClimbYawBetween(climb.cornerFrom, around) / WallClimbYawBetween(climb.cornerFrom, climb.cornerTo);
  if done >= 1.0 {
    WallClimbCornerTurn(climb, climb.cornerTo);
    climb.rounding = false;
    WallClimbLog("round the corner in " + ToString(now - climb.roundingSince) + " s, facing the wall at " + ToString(WallClimbFacing(climb, scriptInterface)) + " deg with " + ToString(climb.viewTurnLeft) + " deg of view turn to go, view pitch " + ToString(WallClimbViewPitch(scriptInterface)) + " deg");
  } else {
    if done <= 0.0 {
      WallClimbCornerTurn(climb, climb.cornerFrom);
      climb.rounding = false;
      WallClimbLog("back from the corner after " + ToString(now - climb.roundingSince) + " s");
    } else {
      WallClimbCornerTurn(climb, around);
    }
  }
  climb.wallPoint = climb.edge;
  // The edge goes on: a ray toward it at chest height meets one of its faces. Past its top, V lets go (Climb.reds).
  let chest: Vector4 = feet + DefaultTransition.GetUpVector() * WallClimbChestHeight();
  let edgeAtChest: Vector4 = climb.edge;
  edgeAtChest.Z = chest.Z;
  let toEdge: Vector4 = edgeAtChest - chest;
  if TraceResult.IsValid(scriptInterface.LocomotionRaycastTest(chest, chest + Vector4.Normalize(toEdge) * (Vector4.Length(toEdge) + WallClimbBehindFace()))) {
    climb.wallSeenAt = now;
  }
}

// Degrees between V's forward and the wall, as the view stands now.
public func WallClimbFacing(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>) -> Float {
  return WallClimbDegreesFromWall(WallClimbFlat(scriptInterface.GetOwnerForward()), climb.normal);
}
