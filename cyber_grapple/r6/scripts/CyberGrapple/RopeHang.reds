// Made by fabrique/grapple.py from Apex Grapple's RopeHang.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The rope's movement (RopeMotion.reds) laid on its line in the game. Each span from one fixed point to the next (the
// rope's start, its bends, the hook) hangs as its own rope, nothing at its ends, so the rope stays round its bends. A
// span's bow is held up by what lies at its middle: one line of sight from the straight line to the bow's middle, cast
// against Static and Terrain as for the bends (one ray, RopeRay.reds), and the whole span shown less, so that its middle stays
// 2 cm off the surface. Without it a rope shot along the ground, or lying on a roof between two bends, would hang
// through it. Only the middle is looked at, while the rope hangs; the pull's straight rope costs nothing more.

// Below this, a bow is too small to look under: no ray.
public func CyberGrappleHangSmall() -> Float {
  return 0.02;
}

public class CyberGrappleRopeHangs extends IScriptable {
  // For the log, over one shot: frames with the rope hanging, rays cast, spans held up by a surface.
  public let frames: Int32;
  public let rays: Int32;
  public let held: Int32;
}

// The rope's places this frame, and for each span the place it ends at, whether it runs straight, so that the pieces
// of a straight span are turned and stretched once, and whether it is laid with short pieces (PiecesDraw.reds,
// CyberGrappleLayRope).
public class CyberGrappleRopeLaid extends IScriptable {
  public let places: array<Vector4>;
  public let spanEnds: array<Int32>;
  public let straight: array<Bool>;
  public let shortSpan: array<Bool>;
}

// A span shorter than half a piece is laid straight, hanging or not: its bow is at most 6 % of its line and its wave a
// quarter of that, so its curve is at most 1.24 times its line. No bow is worked out and no ray cast (audit of 10
// November 2026, B1). Named when such a span took one long piece: it now takes short pieces, one turn of the twist each
// (RopeStock.reds), while they last; past them, one long piece squashed to it, as before them.
public func CyberGrappleOnePiece(distance: Float, piece: Float) -> Bool {
  return 2.0 * distance < piece;
}

// How much of a span's bow may show, from 0 to 1: its middle kept off what lies there.
public func CyberGrappleHeldShare(scriptInterface: ref<StateGameScriptInterface>, hangs: ref<CyberGrappleRopeHangs>, from: Vector4, to: Vector4, across: CyberGrappleAcross, slack: Float, shown: Float, table: ref<CyberGrappleHangTable>) -> Float {
  let offset: Vector4 = CyberGrappleHangOffsetAt(across, slack * shown, table, CyberGrappleHangMiddle());
  let reach: Float = Vector4.Length(offset);
  if reach < CyberGrappleHangSmall() {
    return 1.0;
  }
  let middle: Vector4 = from + (to - from) * 0.5;
  let clearance: Float = CyberGrappleBendClearance();
  let end: Vector4 = middle + offset * ((reach + clearance) / reach);
  hangs.rays = hangs.rays + 1;
  let room: Float = CyberGrappleHitDistance(CyberGrappleRopeRay(scriptInterface, middle, end), middle);
  if room < 0.0 {
    return 1.0;
  }
  hangs.held = hangs.held + 1;
  return ClampF((room - clearance) / reach, 0.0, 1.0);
}

// Where each piece lies along the rope's line, `shown` strong (RopeMotion.reds, CyberGrappleRopeSwing), written into
// `laid`. Each span hangs on its own and is laid on its own, the place it shares with the last one once, so that a
// bend is always between two pieces: one piece across a square corner would cut through it by up to a third of its
// length. The places go straight into `laid` rather than through a copy of the whole rope for each span (B12).
public func CyberGrappleHungPlaces(scriptInterface: ref<StateGameScriptInterface>, hangs: ref<CyberGrappleRopeHangs>, laid: ref<CyberGrappleRopeLaid>, table: ref<CyberGrappleHangTable>, line: array<Vector4>, shown: Float, clock: Float, piece: Float, shortPiece: Float, shortPieces: Int32) -> Void {
  ArrayClear(laid.places);
  ArrayClear(laid.spanEnds);
  ArrayClear(laid.straight);
  ArrayClear(laid.shortSpan);
  let shortsLeft: Int32 = shortPieces;
  let hanging: Bool = shown != 0.0;
  if hanging {
    hangs.frames = hangs.frames + 1;
    CyberGrappleHangTableAt(table, clock);
  }
  let i: Int32 = 1;
  while i < ArraySize(line) {
    let from: Vector4 = line[i - 1];
    let to: Vector4 = line[i];
    let distance: Float = Vector4.Distance(from, to);
    let across: CyberGrappleAcross;
    let slack: Float = 0.0;
    let held: Float = 0.0;
    let short: Bool = false;
    if CyberGrappleOnePiece(distance, piece) {
      let shorts: Int32 = shortPiece > 0.0 ? CyberGrappleRopePiecesOver(distance, shortPiece) : shortsLeft + 1;
      short = shorts <= shortsLeft;
      if short {
        shortsLeft = shortsLeft - shorts;
      }
    } else {
      if hanging {
        across = CyberGrappleSpanAcross(from, to);
        slack = CyberGrappleHangSlack(distance);
        held = shown * CyberGrappleHeldShare(scriptInterface, hangs, from, to, across, slack, shown, table);
      }
    }
    let curve: array<Vector4>;
    if held != 0.0 {
      curve = CyberGrappleRopeHang(from, to, across, slack, held, table);
    } else {
      ArrayPush(curve, from);
      ArrayPush(curve, to);
    }
    let more: array<Vector4> = CyberGrappleRopePlaces(curve, short ? shortPiece : piece);
    let n: Int32 = ArraySize(laid.places) == 0 ? 0 : 1;
    while n < ArraySize(more) {
      ArrayPush(laid.places, more[n]);
      n = n + 1;
    }
    let end: Int32 = ArraySize(laid.places) - 1;
    ArrayPush(laid.spanEnds, end);
    ArrayPush(laid.straight, held == 0.0);
    ArrayPush(laid.shortSpan, short);
    i = i + 1;
  }
}

public func CyberGrappleRopeHangsText(hangs: ref<CyberGrappleRopeHangs>) -> String {
  if !IsDefined(hangs) || hangs.frames == 0 {
    return "rope never hung";
  }
  return "rope hung " + ToString(hangs.frames) + " frames, " + ToString(Cast<Float>(hangs.rays) / Cast<Float>(hangs.frames)) + " rays a frame, held up by a surface " + ToString(hangs.held) + " times";
}
