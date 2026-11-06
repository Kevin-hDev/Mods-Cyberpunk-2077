// Something above V that juts out from the wall (a band along a facade, a sill) would stop V's head under it. Rays
// toward the wall above the head see it coming; V leans out from the wall until its head clears it (Push.reds), and
// once V's chest is level with it, the ray toward the wall takes its face as the wall (Climb.reds). Deeper than
// WallClimbMostOverhang it is a balcony or a roof: V stays under it, as before.

// Just above the capsule.
public func WallClimbHeadHeight() -> Float {
  return WallClimbCapsuleHeight() + 0.1;
}

// The second ray looks this many seconds of climbing higher, so that V has the time to lean out.
public func WallClimbOverhangLook() -> Float {
  return 0.2;
}

// A face above less than this nearer than the wall, in m, is the wall itself, which V presses against.
public func WallClimbLeastOverhang() -> Float {
  return 0.05;
}

// Leaning out this far, the ray toward the wall still reaches it (WallClimbFollowReach).
public func WallClimbMostOverhang() -> Float {
  return 0.6;
}

// The capsule's radius and a margin: a face above nearer than this to V's centre would stop V's head.
public func WallClimbHeadClearance() -> Float {
  return WallClimbCapsuleRadius() + 0.05;
}

public func WallClimbWatchOverhang(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, now: Float) -> Void {
  if climb.overhang {
    let above: Bool = Vector4.IsZero(climb.overhangWay);
    if (above ? feet.Z + WallClimbChestHeight() >= climb.overhangPoint.Z : WallClimbPastStep(climb)) {
      climb.overhang = false;
      WallClimbLog("past the " + (above ? "overhang" : "step") + " in " + ToString(now - climb.overhangSince) + " s, " + ToString(Vector4.Dot(feet - climb.overhangPoint, climb.normal)) + " m from its face");
    }
    return;
  }
  if climb.up <= 0.0 {
    return;
  }
  let wallDistance: Float = Vector4.Dot(feet - climb.wallPoint, climb.normal);
  WallClimbLookAbove(climb, scriptInterface, feet, WallClimbHeadHeight(), wallDistance, now);
  if !climb.overhang {
    WallClimbLookAbove(climb, scriptInterface, feet, WallClimbHeadHeight() + climb.up * WallClimbOverhangLook(), wallDistance, now);
  }
}

// A face jutting out from the wall by WallClimbLeastOverhang to WallClimbMostOverhang at `at`, wherever V stands: the
// ray starts just beyond a lean's reach and goes toward the wall. From V's centre it started inside anything deeper
// than V stood, and took V's own distance for the depth: V leaned half a metre out under a roof and stuck there in
// game. A deeper face starts this ray inside it too, which finds nothing that fits.
public func WallClimbJut(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>, at: Vector4) -> WallClimbWall {
  let jut: WallClimbWall;
  let out: Float = WallClimbMostOverhang() + WallClimbLeastOverhang();
  let start: Vector4 = at + climb.normal * (out - Vector4.Dot(at - climb.wallPoint, climb.normal));
  let trace: TraceResult = scriptInterface.LocomotionRaycastTest(start, start - climb.normal * (out + WallClimbBehindFace()));
  if !TraceResult.IsValid(trace) {
    return jut;
  }
  let face: Vector4 = Vector4.Vector3To4(trace.position);
  let depth: Float = Vector4.Dot(face - climb.wallPoint, climb.normal);
  if depth < WallClimbLeastOverhang() || depth > WallClimbMostOverhang() {
    return jut;
  }
  jut.found = true;
  jut.face = face;
  jut.normal = WallClimbFlat(Vector4.Vector3To4(trace.normal));
  return jut;
}

public func WallClimbLookAbove(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, height: Float, wallDistance: Float, now: Float) -> Void {
  let jut: WallClimbWall = WallClimbJut(climb, scriptInterface, feet + DefaultTransition.GetUpVector() * height);
  let depth: Float = Vector4.Dot(jut.face - climb.wallPoint, climb.normal);
  if !jut.found || wallDistance - depth >= WallClimbHeadClearance() {
    return;
  }
  let face: Vector4 = jut.face;
  let none: Vector4;
  climb.overhang = true;
  climb.overhangPoint = face;
  climb.overhangWay = none;
  climb.overhangSince = now;
  climb.overhangs = climb.overhangs + 1;
  WallClimbLog("overhang " + ToString(depth) + " m out from the wall, " + ToString(face.Z - feet.Z) + " m above the feet: leaning out");
}

// What V still has to lean out: how much nearer to the overhang's face it is than WallClimbHoldDistance.
public func WallClimbLeanLeft(climb: ref<WallClimbClimb>, feet: Vector4) -> Float {
  return WallClimbHoldDistance() - Vector4.Dot(feet - climb.overhangPoint, climb.normal);
}
