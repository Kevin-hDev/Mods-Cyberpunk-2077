// The rope's movement (RopeMotion.reds) laid on its line in the game. Each span from one fixed point to the next (the
// rope's start, its bends, the hook) hangs as its own rope, nothing at its ends, so the rope stays round its bends. A
// span's bow is held up by what lies at its middle: one line of sight from the straight line to the bow's middle, cast
// against Static and Terrain as for the bends (one ray, RopeRay.reds), and the whole span shown less, so that its middle stays
// 2 cm off the surface. Without it a rope shot along the ground, or lying on a roof between two bends, would hang
// through it. Only the middle is looked at, while the rope hangs; the pull's straight rope costs nothing more.

// Below this, a bow is too small to look under: no ray.
public func ApexGrappleHangSmall() -> Float {
  return 0.02;
}

public class ApexGrappleRopeHangs extends IScriptable {
  // For the log, over one shot: frames with the rope hanging, rays cast, spans held up by a surface.
  public let frames: Int32;
  public let rays: Int32;
  public let held: Int32;
}

// The rope's places this frame, and for each span the place it ends at and whether it runs straight, so that the
// pieces of a straight span are turned and stretched once (PiecesDraw.reds, ApexGrappleLayRope).
public class ApexGrappleRopeLaid extends IScriptable {
  public let places: array<Vector4>;
  public let spanEnds: array<Int32>;
  public let straight: array<Bool>;
}

// A span shorter than half a piece is laid as one piece, hanging or not: its bow is at most 6 % of its line and its
// wave a quarter of that, so its curve is at most 1.24 times its line, and ApexGrappleRopePlaces keeps only its two
// ends. It is laid straight, with no bow worked out and no ray cast: the same places (audit of 10 November 2026, B1).
public func ApexGrappleOnePiece(distance: Float, piece: Float) -> Bool {
  return 2.0 * distance < piece;
}

// How much of a span's bow may show, from 0 to 1: its middle kept off what lies there.
public func ApexGrappleHeldShare(scriptInterface: ref<StateGameScriptInterface>, hangs: ref<ApexGrappleRopeHangs>, from: Vector4, to: Vector4, across: ApexGrappleAcross, slack: Float, shown: Float, table: ref<ApexGrappleHangTable>) -> Float {
  let offset: Vector4 = ApexGrappleHangOffsetAt(across, slack * shown, table, ApexGrappleHangMiddle());
  let reach: Float = Vector4.Length(offset);
  if reach < ApexGrappleHangSmall() {
    return 1.0;
  }
  let middle: Vector4 = from + (to - from) * 0.5;
  let clearance: Float = ApexGrappleBendClearance();
  let end: Vector4 = middle + offset * ((reach + clearance) / reach);
  hangs.rays = hangs.rays + 1;
  let room: Float = ApexGrappleHitDistance(ApexGrappleRopeRay(scriptInterface, middle, end), middle);
  if room < 0.0 {
    return 1.0;
  }
  hangs.held = hangs.held + 1;
  return ClampF((room - clearance) / reach, 0.0, 1.0);
}

// Where each piece lies along the rope's line, `shown` strong (RopeMotion.reds, ApexGrappleRopeSwing), written into
// `laid`. Each span hangs on its own and is laid on its own, the place it shares with the last one once, so that a
// bend is always between two pieces: one piece across a square corner would cut through it by up to a third of its
// length. The places go straight into `laid` rather than through a copy of the whole rope for each span (B12).
public func ApexGrappleHungPlaces(scriptInterface: ref<StateGameScriptInterface>, hangs: ref<ApexGrappleRopeHangs>, laid: ref<ApexGrappleRopeLaid>, table: ref<ApexGrappleHangTable>, line: array<Vector4>, shown: Float, clock: Float, piece: Float) -> Void {
  ArrayClear(laid.places);
  ArrayClear(laid.spanEnds);
  ArrayClear(laid.straight);
  let hanging: Bool = shown != 0.0;
  if hanging {
    hangs.frames = hangs.frames + 1;
    ApexGrappleHangTableAt(table, clock);
  }
  let i: Int32 = 1;
  while i < ArraySize(line) {
    let from: Vector4 = line[i - 1];
    let to: Vector4 = line[i];
    let distance: Float = Vector4.Distance(from, to);
    let across: ApexGrappleAcross;
    let slack: Float = 0.0;
    let held: Float = 0.0;
    if hanging && !ApexGrappleOnePiece(distance, piece) {
      across = ApexGrappleSpanAcross(from, to);
      slack = ApexGrappleHangSlack(distance);
      held = shown * ApexGrappleHeldShare(scriptInterface, hangs, from, to, across, slack, shown, table);
    }
    let curve: array<Vector4>;
    if held != 0.0 {
      curve = ApexGrappleRopeHang(from, to, across, slack, held, table);
    } else {
      ArrayPush(curve, from);
      ArrayPush(curve, to);
    }
    let more: array<Vector4> = ApexGrappleRopePlaces(curve, piece);
    let n: Int32 = ArraySize(laid.places) == 0 ? 0 : 1;
    while n < ArraySize(more) {
      ArrayPush(laid.places, more[n]);
      n = n + 1;
    }
    let end: Int32 = ArraySize(laid.places) - 1;
    ArrayPush(laid.spanEnds, end);
    ArrayPush(laid.straight, held == 0.0);
    i = i + 1;
  }
}

public func ApexGrappleRopeHangsText(hangs: ref<ApexGrappleRopeHangs>) -> String {
  if !IsDefined(hangs) || hangs.frames == 0 {
    return "rope never hung";
  }
  return "rope hung " + ToString(hangs.frames) + " frames, " + ToString(Cast<Float>(hangs.rays) / Cast<Float>(hangs.frames)) + " rays a frame, held up by a surface " + ToString(hangs.held) + " times";
}
