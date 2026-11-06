// Steps of a wall met while climbing sideways: the side of a rib or a pilaster that juts out no more than a lean
// (WallClimbMostOverhang), and the wall behind it. V shifts out and in, facing the wall still, as under an overhang
// (Overhang.reds). Taken as corners, the ribs of a facade turned the view a quarter turn and back at each one, and V
// stuck for seconds going round their edges in game: likely the arc round an edge so near the wall passes closer to
// it than V's capsule fits.

// Past the side of a step, where its front is looked for, in m: narrower ribs are taken as corners.
public func WallClimbStepLook() -> Float {
  return 0.1;
}

// `side`: the face across the way, met by the side ray (Corner.reds). True when it is a step, which V leans out round.
public func WallClimbStepOut(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, side: WallClimbWall, way: Vector4, now: Float) -> Bool {
  let jut: WallClimbWall = WallClimbJut(climb, scriptInterface, side.face + way * WallClimbStepLook());
  if !jut.found || AbsF(Vector4.Dot(jut.normal, way)) >= WallClimbLeastCornerTurn() {
    return false;
  }
  let front: Vector4 = jut.face;
  let depth: Float = Vector4.Dot(front - climb.wallPoint, climb.normal);
  climb.overhang = true;
  climb.overhangPoint = front;
  climb.overhangWay = way;
  climb.overhangSince = now;
  climb.overhangs = climb.overhangs + 1;
  WallClimbLog("step " + ToString(depth) + " m out from the wall, " + ToString(Vector4.Distance2D(feet, side.face)) + " m along: leaning out round it");
  return true;
}

// The lean round a step is over once the ray toward the wall meets the step's front, or V no longer goes its way.
public func WallClimbPastStep(climb: ref<WallClimbClimb>) -> Bool {
  return Vector4.Dot(climb.wallPoint - climb.overhangPoint, climb.normal) > -WallClimbLeastOverhang() || Vector4.Dot(WallClimbSideWay(climb), climb.overhangWay) <= 0.0;
}

// Called when the ray toward the wall lost it. True when a wall no more than a lean behind it takes over: the pull
// brings V in to it (Push.reds).
public func WallClimbStepIn(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, forward: Vector4, now: Float) -> Bool {
  if Vector4.IsZero(WallClimbSideWay(climb)) {
    return false;
  }
  let wall: WallClimbWall = WallClimbFindWall(scriptInterface, feet, climb.normal * -1.0, Vector4.Dot(feet - climb.wallPoint, climb.normal) + WallClimbMostOverhang(), forward);
  if !wall.found || Vector4.Dot(wall.normal, climb.normal) < WallClimbLeastSameWall() || wall.facing > WallClimbMostTurn() {
    return false;
  }
  let depth: Float = Vector4.Dot(climb.wallPoint - wall.face, climb.normal);
  climb.normal = wall.normal;
  climb.slant = wall.slant;
  climb.wallPoint = wall.face;
  climb.wallSeenAt = now;
  WallClimbLog("step in: the wall goes " + ToString(depth) + " m back");
  return true;
}
