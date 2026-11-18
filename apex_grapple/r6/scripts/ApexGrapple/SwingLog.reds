// What the log tells of "Stay hooked" (Swing.reds): the speed the rope took while paying out and the speed lost at
// its end, kept apart, and the hardest slowing of one frame, the number to read when a player tells of a wall in the
// air (audit of 17 November 2026, R6: what acts in the same frame adds up). All three count speed V lost against its
// speed before the frame's gravity: until 18 November 2026 they also counted the share that only carries V's weight,
// 16 m/s2 too many for a V hanging still. The lines of each stage are written where the stage changes
// (SwingFrame.reds).

public func ApexGrappleSwingCount(system: ref<ApexGrappleSystem>, took: Float, held: Float, taut: Bool, timeDelta: Float) -> Void {
  let step: Float = ClampF(timeDelta, 0.0, ApexGrappleLongestFrame());
  system.swingPaidTook = system.swingPaidTook + took;
  system.swingRopeTook = system.swingRopeTook + held;
  if step > 0.0 {
    system.swingHardest = MaxF(system.swingHardest, (took + held) / step);
  }
  if taut {
    system.swingTaut = system.swingTaut + 1;
  }
}

public func ApexGrappleSwingStageText(stage: Int32) -> String {
  if stage == ApexGrappleSwingFlies() {
    return "V's own flight";
  }
  if stage == ApexGrappleSwingPaysOut() {
    return "the rope paying out";
  }
  return "the rope coming back in";
}

// The part of the pull's last line about the kept rope, empty without one. Where V ends is told against the anchor's
// plumb line, with whether anything stands between V and the anchor: V at rest off that line is held there by
// something (Kevin's trial of 18 November 2026: under a slab, and on an edge).
public func ApexGrappleSwingText(system: ref<ApexGrappleSystem>, middle: Vector4, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> String {
  if !system.swinging {
    return "";
  }
  let aside: Vector4 = middle - system.anchor;
  aside.Z = 0.0;
  let ends: String = ", ends " + ToString(Vector4.Length(aside)) + " m off the anchor's plumb line and " + ToString(system.anchor.Z - middle.Z) + " m under it, way to the anchor clear " + ToString(ApexGrappleRopeClear(system, scriptInterface, middle, system.anchor));
  return ends + ", rope kept " + ToString(now - system.swingStartedAt) + " s since V was " + ToString(system.swingKeptAt) + " m from the anchor, ended in " + ApexGrappleSwingStageText(system.swingStage) + ", rope " + ToString(system.ropeLength) + " m to hang on " + ToString(system.swingHangs) + " m, frames at its end " + ToString(system.swingTaut) + ", " + ToString(system.swingPaidTook) + " m/s taken while paying out, rope's end " + ToString(system.swingRopeTook) + " m/s, hardest slowing " + ToString(system.swingHardest) + " m/s2, farthest " + ToString(system.swingFarthest) + " m, the game's velocity taken " + ToString(system.swingAdopted) + " times, pushes written back while swinging " + ToString(system.pushesWrittenBack - system.swingPushesBefore) + ", ground touched " + ToString(system.swingGroundTouches) + " times, " + ToString(system.swingGroundFrames) + " frames on it, " + ToString(system.swingEdgeFrames) + " of them on an unsecure edge";
}
