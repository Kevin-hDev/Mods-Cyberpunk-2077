// Finding a step ahead of V: its face, its top, and room for V on it. Starting the step is in StepStart.reds, the
// climb itself in StepClimb.reds.

// Lower edges are left to the engine.
public func AutoSprintLowestStep() -> Float {
  return 0.06;
}

// A curb, not a wall. Trial of 21 October 2026: the curb measured 0.36 to 0.44 m in the steps that went up, but 0.52
// to 0.59 m in 31 of the 33 times V stood stuck against it, and a limit of 0.45 m kept V there for up to 6 s (Kevin).
// Anything higher than this still needs a jump; a low bench is now stepped onto as well. The menu texts
// (Localization.reds) and the Nexus description say 60 cm: change them with it.
public func AutoSprintHighestStep() -> Float {
  return 0.6;
}

// Heights above V's feet of the rays that look for a step's face, lowest first. In the trials of 21 and 22 October
// 2026, steps of 0.15 to 0.5 m started only once V touched the face 64 times in 70, steps above 0.5 m 1 time in 36.
// Trial of 22 October 2026 (essai 11): 17 faces were found by a higher ray, the lowest one meeting the sloped foot of
// a curb, about 22 degrees, and the steps started during the approach 57 times in 58.
public func AutoSprintFaceRays() -> array<Float> {
  return [AutoSprintLowestStep(), 0.15, 0.25];
}

// A face is steep, not ground, when its normal points this little upward or less: 60 degrees from flat or more.
public func AutoSprintSteepFace() -> Float {
  return 0.5;
}

// Distances behind the face of the probes that measure its top. V's feet pass over all of them, so the highest
// counts (trial of 21 October 2026: a single probe 15 cm behind sometimes read a greater height at the same place).
public func AutoSprintTopProbes() -> array<Float> {
  return [0.12, 0.25, 0.4];
}

// Height above V's feet where the probes of the top start: a wall gives back this full height.
public func AutoSprintProbeTop() -> Float {
  return 1.0;
}

// A top is walkable when its normal points this much upward or more: about 45 degrees from flat or less.
public func AutoSprintWalkableTop() -> Float {
  return 0.7;
}

// The height of walkable ground at a distance behind the face, above V's feet, or -1 where there is none.
@addMethod(LocomotionEventsTransition)
protected final func AutoSprintTopAt(scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, face: Vector4, normal: Vector4, behind: Float) -> Float {
  let up: Vector4 = DefaultTransition.GetUpVector();
  let probe: Vector4 = face - normal * behind;
  probe.Z = feet.Z;
  let top: TraceResult = scriptInterface.LocomotionRaycastTest(probe + up * AutoSprintProbeTop(), probe - up * 0.05);
  if !TraceResult.IsValid(top) || top.normal.Z < AutoSprintWalkableTop() {
    return -1.0;
  }
  return top.position.Z - feet.Z;
}

// A steep face in the direction the player pushes V. Gives a point of the face (with the height of its top in Z), its
// normal, flat and turned toward V, and the height V must clear: the highest of the top probes, or -1 without walkable
// ground there. What the rays saw comes back as text, for the log. False when the rays meet nothing, or only ground
// that rises: a slope, which the engine climbs.
@addMethod(LocomotionEventsTransition)
protected final func AutoSprintFindStep(scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, direction: Vector4, reach: Float, out face: Vector4, out normal: Vector4, out height: Float, out seen: String) -> Bool {
  let up: Vector4 = DefaultTransition.GetUpVector();
  let rays: array<Float> = AutoSprintFaceRays();
  let hit: TraceResult;
  let groundSlope: Float;
  let groundAt: Float;
  let found: Int32 = -1;
  let i: Int32 = 0;
  while i < ArraySize(rays) && found < 0 {
    let low: Vector4 = feet + up * rays[i];
    hit = scriptInterface.LocomotionRaycastTest(low, low + direction * reach);
    if !TraceResult.IsValid(hit) {
      return false;
    }
    if AbsF(hit.normal.Z) <= AutoSprintSteepFace() {
      found = i;
    } else {
      groundSlope = hit.normal.Z;
      groundAt = Vector4.Distance2D(feet, Vector4.Vector3To4(hit.position));
    }
    i += 1;
  }
  if found < 0 {
    return false;
  }
  face = Vector4.Vector3To4(hit.position);
  normal = Vector4.Vector3To4(hit.normal);
  normal.Z = 0.0;
  normal = Vector4.Normalize2D(normal);
  let probes: array<Float> = AutoSprintTopProbes();
  height = -1.0;
  seen = "probes";
  let j: Int32 = 0;
  while j < ArraySize(probes) {
    let top: Float = this.AutoSprintTopAt(scriptInterface, feet, face, normal, probes[j]);
    height = MaxF(height, top);
    seen += (j == 0 ? " " : " / ") + ToString(top);
    j += 1;
  }
  if found > 0 {
    seen += ", face seen by the ray at " + ToString(rays[found]) + " m, the one below met ground (normal.Z " + ToString(groundSlope) + ") " + ToString(groundAt) + " m ahead";
  }
  face.Z = feet.Z + height;
  return true;
}

// Room for V on the step, tested as the game tests a ledge before a climb: a ball of V's width just above the top.
@addMethod(LocomotionEventsTransition)
protected final func AutoSprintFitsOnStep(scriptInterface: ref<StateGameScriptInterface>, face: Vector4, normal: Vector4, radius: Float) -> Bool {
  let ball: Vector4;
  ball.X = radius;
  ball.Y = -1.0;
  ball.Z = -1.0;
  let position: Vector4 = face - normal * (radius + 0.05);
  position.Z = face.Z + radius + 0.05;
  let rotation: EulerAngles;
  let overlap: TraceResult;
  return !scriptInterface.LocomotionOverlapTest(ball, position, rotation, overlap);
}
