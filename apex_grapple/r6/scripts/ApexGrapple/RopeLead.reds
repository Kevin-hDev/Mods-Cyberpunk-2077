// How far the rope's start is moved on, to where the frame being drawn will show it: the hand and the camera the mod
// reads are where the last frame showed them (RopeStart.reds). Moved on by V's velocity alone, the start was drawn 1.3
// to 5.6 cm off the launcher's barrel on average at 33 to 45 m/s, and 5 to 11 cm while the view turned 6 to 8.5 degrees
// a frame (measured in game on 31 October, 22:24 and 22:32, 1,500 frames): the velocity the mod reads is not quite the
// one V moves with, and the hand turns with the view. The start's own move over the last frame, plus the change of V's
// velocity since, came out about twice as close on V's move, and carries the view's turn on from frame to frame.
// After a frame this guess missed by much (a landing, a climb), or when the start is read from another point (the fist,
// then the lent launcher's barrel 8 to 14 cm away, within the miss below), V's velocity alone leads, so that the jump is
// not carried on.

public class ApexGrappleRopeLead extends IScriptable {
  public let has: Bool;
  public let from: Int32;
  public let at: Vector4;
  public let step: Vector4;
  public let moving: Vector4;
  public let frame: Float;
  public let time: Float;
  // For the log, over one shot.
  public let led: Int32;
  public let afterMiss: Int32;
}

// The largest miss measured while the view turned fast was 11 cm; landings and climbs missed by 22 to 64 cm.
public func ApexGrappleRopeLeadMiss() -> Float {
  return 0.15;
}

// `here`: the start as the last frame showed it.
public func ApexGrappleRopeLeadStep(lead: ref<ApexGrappleRopeLead>, here: Vector4, from: Int32, moving: Vector4, now: Float, frame: Float) -> Vector4 {
  let step: Vector4 = ApexGrappleViewStep(moving, frame);
  let following: Bool = lead.has && lead.from == from && lead.frame > ApexGrappleTiny() && AbsF(now - lead.time - frame) < frame * 0.5;
  if following {
    let moved: Vector4 = here - lead.at;
    moved.W = 0.0;
    if Vector4.Length(moved - lead.step) <= ApexGrappleRopeLeadMiss() {
      step = moved * (frame / lead.frame) + (moving - lead.moving) * frame;
      step.W = 0.0;
      lead.led += 1;
    } else {
      lead.afterMiss += 1;
    }
  }
  lead.has = true;
  lead.from = from;
  lead.at = here;
  lead.step = step;
  lead.moving = moving;
  lead.frame = frame;
  lead.time = now;
  return step;
}

public func ApexGrappleRopeLeadText(lead: ref<ApexGrappleRopeLead>) -> String {
  return "the rope's start led by its own last move on " + ToString(lead.led) + " frames, by V's velocity alone after a miss on " + ToString(lead.afterMiss);
}
