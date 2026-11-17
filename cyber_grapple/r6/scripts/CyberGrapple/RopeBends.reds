// Made by fabrique/grapple.py from Apex Grapple's RopeBends.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The rope bends round the edges of what the hook can take, Static and Terrain surfaces as in Aim.reds, and runs
// straight again once nothing cuts the line: a rope running through walls and bridges looked wrong. Only how it looks:
// the pull still goes straight for the hook, since a rope pulling V toward the edge would change every trajectory.
// From the bite until the hook is home; during the hook's flight both ends move, and the aim's ray has just found the
// way clear.
// Each frame, first the bend nearest V goes while the line from the start to the point after it is clear; then, while
// the line from the start to the nearest point is blocked, a bend goes on the edge in between: the line swept from
// last frame's start, clear, to this one, blocked, round that point, halved until it just touches the edge. Simulated
// on boxes before the game (a roof, a bridge deck, two corners, a pole, V at 0.35 and 0.5 m a frame): the rope never
// ran through one. Shaking across an edge makes and undoes a bend each frame, where bent and straight look the same.

// A ray leaves out its first and last 10 cm: the edge a span rests on, and the surface the hook is planted in.
public func CyberGrappleBendMargin() -> Float {
  return 0.1;
}

// How far out of the corner a bend sits: the rope, 1.2 cm thick, clears it.
public func CyberGrappleBendClearance() -> Float {
  return 0.02;
}

// Closer than this to the start or to the point after it, a bend is refused: the rope runs straight there.
public func CyberGrappleBendNear() -> Float {
  return 0.2;
}

public func CyberGrappleMostBends() -> Int32 {
  return 8;
}

// New bends in one frame: at 50 m/s V can pass two edges between frames.
public func CyberGrappleBendTries() -> Int32 {
  return 3;
}

// Halvings of V's step to find an edge: 30 cm become 5 mm.
public func CyberGrappleEdgeSteps() -> Int32 {
  return 6;
}

public struct CyberGrappleRopeHit {
  let found: Bool;
  let at: Vector4;
  let normal: Vector4;
}

public class CyberGrappleRopeBends extends IScriptable {
  // Nearest the hook first, nearest V last.
  public let points: array<Vector4>;
  // The line from last frame's start to the nearest point was clear.
  public let clear: Bool;
  public let lastStart: Vector4;
  public let lastPivot: Vector4;
  // For the log, over one shot.
  public let most: Int32;
  public let made: Int32;
  public let guessed: Int32;
  public let undone: Int32;
  public let refused: Int32;
  public let rays: Int32;
  public let frames: Int32;
}

// The points the rope runs through, from its start to the hook.
public func CyberGrappleBendsFromStart(bends: ref<CyberGrappleRopeBends>) -> array<Vector4> {
  let line: array<Vector4>;
  if !IsDefined(bends) {
    return line;
  }
  let i: Int32 = ArraySize(bends.points) - 1;
  while i >= 0 {
    ArrayPush(line, bends.points[i]);
    i = i - 1;
  }
  return line;
}

public func CyberGrappleRopeHitOf(scriptInterface: ref<StateGameScriptInterface>, bends: ref<CyberGrappleRopeBends>, from: Vector4, to: Vector4) -> CyberGrappleRopeHit {
  let hit: CyberGrappleRopeHit;
  let margin: Float = CyberGrappleBendMargin();
  let span: Float = Vector4.Distance(from, to);
  if span <= 2.0 * margin + 0.05 {
    return hit;
  }
  let way: Vector4 = (to - from) * (1.0 / span);
  let a: Vector4 = from + way * margin;
  let b: Vector4 = to - way * margin;
  bends.rays = bends.rays + 1;
  let nearest: TraceResult = CyberGrappleRopeRay(scriptInterface, a, b);
  if !TraceResult.IsValid(nearest) {
    return hit;
  }
  let normal: Vector4 = Vector4.Vector3To4(nearest.normal);
  normal.W = 0.0;
  hit.found = true;
  hit.at = Vector4.Vector3To4(nearest.position);
  hit.normal = normal;
  return hit;
}

// Only whether the line is cut, as CyberGrappleRopeHitOf finds it, without working out where (audit of 10 November
// 2026, B4).
public func CyberGrappleRopeBlocked(scriptInterface: ref<StateGameScriptInterface>, bends: ref<CyberGrappleRopeBends>, from: Vector4, to: Vector4) -> Bool {
  let margin: Float = CyberGrappleBendMargin();
  let span: Float = Vector4.Distance(from, to);
  if span <= 2.0 * margin + 0.05 {
    return false;
  }
  let way: Vector4 = (to - from) * (1.0 / span);
  bends.rays = bends.rays + 1;
  return TraceResult.IsValid(CyberGrappleRopeRay(scriptInterface, from + way * margin, to - way * margin));
}

public func CyberGrappleClosestOn(a: Vector4, b: Vector4, p: Vector4) -> Vector4 {
  let span: Vector4 = b - a;
  let squared: Float = Vector4.Dot(span, span);
  if squared <= CyberGrappleTiny() {
    return a;
  }
  return a + span * ClampF(Vector4.Dot(p - a, span) / squared, 0.0, 1.0);
}

// The edge between a clear line (from `clear` to `pivot`) and a blocked one (from `blocked` to `pivot`): the last
// clear line found, moved out of the corner, away from where the first blocked line met the surface.
public func CyberGrappleRopeEdge(scriptInterface: ref<StateGameScriptInterface>, bends: ref<CyberGrappleRopeBends>, clear: Vector4, blocked: Vector4, pivot: Vector4, met: CyberGrappleRopeHit) -> Vector4 {
  let low: Float = 0.0;
  let high: Float = 1.0;
  let best: CyberGrappleRopeHit = met;
  let i: Int32 = 0;
  while i < CyberGrappleEdgeSteps() {
    let middle: Float = (low + high) * 0.5;
    let hit: CyberGrappleRopeHit = CyberGrappleRopeHitOf(scriptInterface, bends, clear + (blocked - clear) * middle, pivot);
    if hit.found {
      high = middle;
      best = hit;
    } else {
      low = middle;
    }
    i = i + 1;
  }
  let near: Vector4 = CyberGrappleClosestOn(clear + (blocked - clear) * low, pivot, best.at);
  let out: Vector4 = near - best.at;
  out.W = 0.0;
  if Vector4.Length(out) < 0.001 {
    out = best.normal;
  }
  let corner: Vector4 = near + Vector4.Normalize(out) * CyberGrappleBendClearance();
  corner.W = 1.0;
  return corner;
}

// One frame of the rope from `start` to `end`, the hook's base where it was planted.
public func CyberGrappleBendRope(scriptInterface: ref<StateGameScriptInterface>, bends: ref<CyberGrappleRopeBends>, start: Vector4, end: Vector4) -> Void {
  bends.frames = bends.frames + 1;
  let undoneNow: Bool = false;
  while ArraySize(bends.points) > 0 {
    let count: Int32 = ArraySize(bends.points);
    let next: Vector4 = count >= 2 ? bends.points[count - 2] : end;
    let blocked: Bool = CyberGrappleRopeBlocked(scriptInterface, bends, start, next);
    if blocked {
      break;
    }
    ArrayResize(bends.points, count - 1);
    bends.undone = bends.undone + 1;
    undoneNow = true;
  }
  let tries: Int32 = 0;
  let going: Bool = true;
  while going {
    let count: Int32 = ArraySize(bends.points);
    let pivot: Vector4 = count > 0 ? bends.points[count - 1] : end;
    // Just after a bend went, the line to the point it leaves was found clear by the last test above, from the same
    // start: it is not cast again (P8).
    let hit: CyberGrappleRopeHit;
    if !undoneNow {
      hit = CyberGrappleRopeHitOf(scriptInterface, bends, start, pivot);
    }
    undoneNow = false;
    if !hit.found {
      bends.clear = true;
      bends.lastStart = start;
      bends.lastPivot = pivot;
      going = false;
    } else {
      if count >= CyberGrappleMostBends() || tries >= CyberGrappleBendTries() {
        bends.refused = bends.refused + 1;
        bends.clear = false;
        going = false;
      } else {
        let corner: Vector4;
        if bends.clear && Vector4.Distance(bends.lastPivot, pivot) < 0.001 {
          corner = CyberGrappleRopeEdge(scriptInterface, bends, bends.lastStart, start, pivot, hit);
        } else {
          corner = hit.at + hit.normal * CyberGrappleBendClearance();
          corner.W = 1.0;
          bends.guessed = bends.guessed + 1;
        }
        if Vector4.Distance(corner, pivot) < CyberGrappleBendNear() || Vector4.Distance(corner, start) < CyberGrappleBendNear() {
          bends.refused = bends.refused + 1;
          bends.clear = false;
          going = false;
        } else {
          ArrayPush(bends.points, corner);
          bends.made = bends.made + 1;
          tries = tries + 1;
        }
      }
    }
  }
  bends.most = Max(bends.most, ArraySize(bends.points));
}

public func CyberGrappleRopeBendsText(bends: ref<CyberGrappleRopeBends>) -> String {
  if !IsDefined(bends) || bends.frames == 0 {
    return "rope never bent: no bite";
  }
  return "rope bends at most " + ToString(bends.most) + ", made " + ToString(bends.made) + " (" + ToString(bends.guessed) + " without a clear frame before), undone " + ToString(bends.undone) + ", refused " + ToString(bends.refused) + ", " + ToString(Cast<Float>(bends.rays) / Cast<Float>(bends.frames)) + " rays a frame over " + ToString(bends.frames) + " frames";
}
