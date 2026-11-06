// Where our hook is at each frame of a shot: Borderlands 4's look_timing.py, ported. It leaves the rope's start whole,
// point first, and flies at the hook's speed so that its point reaches the aimed point, sunk in, at the very instant
// the pull starts. Caught, it stays planted, turned as it was then. The point is the grapple's anchor (system.anchor),
// read each frame and never copied: a vehicle or a person moves it (Target.reds), and until 2 November 2026 the drawn
// hook kept the point of the bite and hung in the air as they moved on (Kevin). Let go, whatever the cause, it comes back to the
// start at its return speed (ApexGrappleHookReturnSpeedOf), base first, from wherever it was, and the shot is over when
// it gets there: the rope never vanishes at once.
// One change from Borderlands 4: on its way back the rope shortens at the return speed whatever V does, where
// Borderlands 4 flew the hook at that speed through the world. V let go past the anchor at up to 48 m/s, and a hook at
// 50 m/s took up to 2.8 s to catch up, the rope trailing behind V. And the rope it reels in may bend (RopeBends.reds):
// the hook comes back along it.

public func ApexGrappleHookOut() -> Int32 {
  return 0;
}

public func ApexGrappleHookCaught() -> Int32 {
  return 1;
}

public func ApexGrappleHookBack() -> Int32 {
  return 2;
}

public class ApexGrappleHookShot extends IScriptable {
  public let firedAt: Float;
  public let flight: Float;
  public let length: Float;
  public let sunk: Float;
  public let backSpeed: Float;
  public let caught: Bool;
  public let caughtAt: Float;
  public let plantedWay: Vector4;
  public let released: Bool;
  public let releasedAt: Float;
  public let releasedFrom: Vector4;
  public let releasedLength: Float;

  public static func Create(firedAt: Float, flight: Float, length: Float, sunk: Float, backSpeed: Float) -> ref<ApexGrappleHookShot> {
    let shot: ref<ApexGrappleHookShot> = new ApexGrappleHookShot();
    shot.firedAt = firedAt;
    shot.flight = flight;
    shot.length = length;
    shot.sunk = sunk;
    shot.backSpeed = backSpeed;
    return shot;
  }
}

// On the way back, `base` and `way` are not set: the hook is `left` metres along the rope from its start, and the
// rope's line, bends and all, is drawn in PiecesDraw.reds.
public struct ApexGrappleHookPose {
  let there: Bool;
  let base: Vector4;
  let way: Vector4;
  let left: Float;
  let phase: Int32;
  let since: Float;
}

public func ApexGrappleToward(from: Vector4, to: Vector4) -> Vector4 {
  let span: Vector4 = to - from;
  let distance: Float = Vector4.Length(span);
  if distance <= ApexGrappleTiny() {
    return new Vector4(1.0, 0.0, 0.0, 0.0);
  }
  return span * (1.0 / distance);
}

// Its base, once its point, coming along `way`, is `sunk` past the anchor.
public func ApexGrapplePlantedBase(shot: ref<ApexGrappleHookShot>, anchor: Vector4, way: Vector4) -> Vector4 {
  return anchor + way * (shot.sunk - shot.length);
}

public func ApexGrappleHookWhere(shot: ref<ApexGrappleHookShot>, start: Vector4, anchor: Vector4, now: Float) -> ApexGrappleHookPose {
  let pose: ApexGrappleHookPose;
  pose.there = true;
  if shot.released {
    let left: Float = shot.releasedLength - shot.backSpeed * (now - shot.releasedAt);
    if left <= 0.0 {
      pose.there = false;
      return pose;
    }
    pose.left = left;
    pose.phase = ApexGrappleHookBack();
    pose.since = now - shot.releasedAt;
    return pose;
  }
  if shot.caught {
    pose.base = ApexGrapplePlantedBase(shot, anchor, shot.plantedWay);
    pose.way = shot.plantedWay;
    pose.phase = ApexGrappleHookCaught();
    pose.since = now - shot.caughtAt;
    return pose;
  }
  let way: Vector4 = ApexGrappleToward(start, anchor);
  let end: Vector4 = ApexGrapplePlantedBase(shot, anchor, way);
  let share: Float = ClampF((now - shot.firedAt) / MaxF(shot.flight, 0.001), 0.0, 1.0);
  pose.base = start + (end - start) * share;
  pose.way = way;
  pose.phase = ApexGrappleHookOut();
  pose.since = now - shot.firedAt;
  return pose;
}

public func ApexGrappleHookCatch(shot: ref<ApexGrappleHookShot>, start: Vector4, anchor: Vector4, now: Float) -> Void {
  if shot.caught || shot.released {
    return;
  }
  shot.caught = true;
  shot.caughtAt = now;
  shot.plantedWay = ApexGrappleToward(start, anchor);
}

// `through`: the rope's bends, from its start to the hook.
public func ApexGrappleHookRelease(shot: ref<ApexGrappleHookShot>, start: Vector4, anchor: Vector4, through: array<Vector4>, now: Float) -> Void {
  if shot.released {
    return;
  }
  let pose: ApexGrappleHookPose = ApexGrappleHookWhere(shot, start, anchor, now);
  shot.releasedFrom = pose.there ? pose.base : start;
  shot.releasedLength = ApexGrappleRopeLength(ApexGrappleRopeLine(start, through, shot.releasedFrom));
  shot.releasedAt = now;
  shot.released = true;
}
