// The rope's movement (RopeMotion.reds) laid on its line in the game. Each span from one fixed point to the next (the
// rope's start, its bends, the hook) hangs as its own rope, nothing at its ends, so the rope stays round its bends. A
// span's bow is held up by what lies at its middle: one line of sight from the straight line to the bow's middle, cast
// against Static and then Terrain as for the bends (two rays), and the whole span shown less, so that its middle stays
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

// How much of a span's bow may show, from 0 to 1: its middle kept off what lies there.
public func ApexGrappleHeldShare(scriptInterface: ref<StateGameScriptInterface>, hangs: ref<ApexGrappleRopeHangs>, from: Vector4, to: Vector4, shown: Float, clock: Float) -> Float {
  let depth: Float = ApexGrappleHangDepth(Vector4.Distance(from, to), shown);
  let offset: Vector4 = ApexGrappleHangOffset(ApexGrappleSpanAcross(from, to), depth, 0.5, clock);
  let reach: Float = Vector4.Length(offset);
  if reach < ApexGrappleHangSmall() {
    return 1.0;
  }
  let middle: Vector4 = from + (to - from) * 0.5;
  let clearance: Float = ApexGrappleBendClearance();
  let end: Vector4 = middle + offset * ((reach + clearance) / reach);
  hangs.rays = hangs.rays + 2;
  let statics: TraceResult = scriptInterface.RaycastWithASingleGroup(middle, end, n"Static");
  let terrain: TraceResult = scriptInterface.RaycastWithASingleGroup(middle, end, n"Terrain");
  let room: Float = ApexGrappleHitDistance(ApexGrappleNearest(statics, terrain, middle), middle);
  if room < 0.0 {
    return 1.0;
  }
  hangs.held = hangs.held + 1;
  return ClampF((room - clearance) / reach, 0.0, 1.0);
}

// Where each piece lies along the rope's line, `shown` strong (RopeMotion.reds, ApexGrappleRopeSwing), each span
// hanging on its own and laid on its own (RopeShape.reds, ApexGrappleAddPlaces).
public func ApexGrappleHungPlaces(scriptInterface: ref<StateGameScriptInterface>, hangs: ref<ApexGrappleRopeHangs>, line: array<Vector4>, shown: Float, clock: Float, piece: Float) -> array<Vector4> {
  let places: array<Vector4>;
  let hanging: Bool = shown != 0.0;
  if hanging {
    hangs.frames = hangs.frames + 1;
  }
  let i: Int32 = 1;
  while i < ArraySize(line) {
    let from: Vector4 = line[i - 1];
    let to: Vector4 = line[i];
    let held: Float = 0.0;
    if hanging {
      held = shown * ApexGrappleHeldShare(scriptInterface, hangs, from, to, shown, clock);
    }
    let curve: array<Vector4>;
    if held != 0.0 {
      curve = ApexGrappleRopeHang(from, to, held, clock);
    } else {
      ArrayPush(curve, from);
      ArrayPush(curve, to);
    }
    places = ApexGrappleAddPlaces(places, ApexGrappleRopePlaces(curve, piece));
    i = i + 1;
  }
  return places;
}

public func ApexGrappleRopeHangsText(hangs: ref<ApexGrappleRopeHangs>) -> String {
  if !IsDefined(hangs) || hangs.frames == 0 {
    return "rope never hung";
  }
  return "rope hung " + ToString(hangs.frames) + " frames, " + ToString(Cast<Float>(hangs.rays) / Cast<Float>(hangs.frames)) + " rays a frame, held up by a surface " + ToString(hangs.held) + " times";
}
