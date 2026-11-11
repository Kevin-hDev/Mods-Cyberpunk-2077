// How our rope moves: Borderlands 4's rope_motion.py (swing and shape) ported in metres, at its way H. It hangs under
// the line while the hook flies out or comes back, a small wave running along it toward the hook; once the hook bites
// the bow swings back and forth and is calm in 0.4 s; it runs straight while pulling. Checked against Borderlands 4's
// own file on 48 shots in game, within 0.18 mm. How it is laid on the bent rope: RopeHang.reds.

// Way H: the bow's depth is 6 % of the span, 2 m at most, so that a 100 m shot does not hang 6 m.
public func ApexGrappleSlackShare() -> Float {
  return 0.06;
}

public func ApexGrappleSlackMost() -> Float {
  return 2.0;
}

// The wave: its height as a share of the bow's depth, how many waves the rope holds, how many pass a point each second.
public func ApexGrappleWaveShare() -> Float {
  return 0.25;
}

public func ApexGrappleWaveTurns() -> Float {
  return 1.5;
}

public func ApexGrappleWaveRate() -> Float {
  return 4.0;
}

// Once the hook bites: the swing dies out as exp(-t / 0.12 s), one swing every 0.2 s, brought to nothing at 0.4 s.
public func ApexGrappleSettle() -> Float {
  return 0.12;
}

public func ApexGrappleSwingTime() -> Float {
  return 0.2;
}

public func ApexGrappleSettled() -> Float {
  return 0.4;
}

// Points along a hanging span, both ends included: odd so that one lies in the middle. Borderlands 4 found 25 left
// sharp corners in the wave.
public func ApexGrappleHangPoints() -> Int32 {
  return 49;
}

// The point in the middle: its share of the way is 24 / 48, 0.5 exactly.
public func ApexGrappleHangMiddle() -> Int32 {
  return (ApexGrappleHangPoints() - 1) / 2;
}

// A whole turn in radians: the game's Pi() reads 3.14 in the decompiled scripts, too coarse to trust.
public func ApexGrappleTurn() -> Float {
  return 6.28318531;
}

public struct ApexGrappleAcross {
  let below: Vector4;
  let beside: Vector4;
  let hang: Float;
}

public func ApexGrappleCross(a: Vector4, b: Vector4) -> Vector4 {
  return new Vector4(a.Y * b.Z - a.Z * b.Y, a.Z * b.X - a.X * b.Z, a.X * b.Y - a.Y * b.X, 0.0);
}

// Across the rope: the way nearest straight down, the way beside it, and how much the first truly points down, from
// 1 on a level rope to 0 on one running straight up or down.
public func ApexGrappleAcrossOf(along: Vector4) -> ApexGrappleAcross {
  let across: ApexGrappleAcross;
  let lying: Vector4 = new Vector4(along.X * along.Z, along.Y * along.Z, along.Z * along.Z - 1.0, 0.0);
  across.hang = Vector4.Length(lying);
  if across.hang < ApexGrappleTiny() {
    lying = new Vector4(1.0, 0.0, 0.0, 0.0);
    across.hang = 0.0;
  }
  across.below = lying * (1.0 / Vector4.Length(lying));
  across.beside = ApexGrappleCross(along, across.below);
  return across;
}

// How much of the hanging shape shows: all of it while the hook flies out or comes back, a swing dying out once it
// bites, nothing while pulling. `since`: seconds since this phase began.
public func ApexGrappleRopeSwing(phase: Int32, since: Float) -> Float {
  if phase == ApexGrappleHookOut() || phase == ApexGrappleHookBack() {
    return 1.0;
  }
  if phase == ApexGrappleHookCaught() && since < ApexGrappleSettled() {
    return ExpF(-since / ApexGrappleSettle()) * CosF(ApexGrappleTurn() * since / ApexGrappleSwingTime()) * (1.0 - since / ApexGrappleSettled());
  }
  return 0.0;
}

// The bow's depth under a span of `distance` metres at full strength: times `shown`, the depth (negative: above the
// line, as the swing goes).
public func ApexGrappleHangSlack(distance: Float) -> Float {
  return MinF(ApexGrappleSlackShare() * distance, ApexGrappleSlackMost());
}

public func ApexGrappleSpanAcross(from: Vector4, to: Vector4) -> ApexGrappleAcross {
  return ApexGrappleAcrossOf(ApexGrappleToward(from, to));
}

// What a hanging span reads at each of its points, kept rather than worked out again for each point of each span: each
// point's share of the way and its envelope, the same at every frame, and the wave's sine for the clock it was made
// at, shared by every span of a frame. Made by the same operations as a point worked out alone, so the rope is the same
// to the last digit (audit of 10 November 2026, B2).
public class ApexGrappleHangTable extends IScriptable {
  public let parts: array<Float>;
  public let envelopes: array<Float>;
  public let waves: array<Float>;
  public let waveClock: Float;
  public let waveMade: Bool;
}

public func ApexGrappleHangTableAt(table: ref<ApexGrappleHangTable>, clock: Float) -> Void {
  let count: Int32 = ApexGrappleHangPoints();
  if ArraySize(table.parts) != count {
    ArrayClear(table.parts);
    ArrayClear(table.envelopes);
    let n: Int32 = 0;
    while n < count {
      let part: Float = Cast<Float>(n) / Cast<Float>(count - 1);
      ArrayPush(table.parts, part);
      ArrayPush(table.envelopes, SinF(0.5 * ApexGrappleTurn() * part));
      n = n + 1;
    }
    table.waveMade = false;
  }
  if table.waveMade && table.waveClock == clock {
    return;
  }
  ArrayResize(table.waves, count);
  let i: Int32 = 0;
  while i < count {
    table.waves[i] = SinF(ApexGrappleTurn() * (ApexGrappleWaveTurns() * table.parts[i] - ApexGrappleWaveRate() * clock));
    i = i + 1;
  }
  table.waveClock = clock;
  table.waveMade = true;
}

// How far the rope is off its straight line at point `n` of the table, the bow `depth` deep.
public func ApexGrappleHangOffsetAt(across: ApexGrappleAcross, depth: Float, table: ref<ApexGrappleHangTable>, n: Int32) -> Vector4 {
  let envelope: Float = table.envelopes[n];
  let wave: Float = ApexGrappleWaveShare() * depth * envelope * table.waves[n];
  return across.below * (depth * across.hang * envelope) + across.beside * wave;
}

// The rope's points from `from` to `to`: the bow under the line and the wave running along it toward `to`, both
// `shown` strong, nothing at either end. Its ends are `from` and `to` exactly, so that a bend stays where it is.
public func ApexGrappleRopeHang(from: Vector4, to: Vector4, across: ApexGrappleAcross, slack: Float, shown: Float, table: ref<ApexGrappleHangTable>) -> array<Vector4> {
  let points: array<Vector4>;
  let depth: Float = slack * shown;
  let bow: Float = depth * across.hang;
  let rise: Float = ApexGrappleWaveShare() * depth;
  let way: Vector4 = to - from;
  let count: Int32 = ApexGrappleHangPoints();
  ArrayPush(points, from);
  let n: Int32 = 1;
  while n < count - 1 {
    let envelope: Float = table.envelopes[n];
    ArrayPush(points, from + way * table.parts[n] + (across.below * (bow * envelope) + across.beside * (rise * envelope * table.waves[n])));
    n = n + 1;
  }
  ArrayPush(points, to);
  return points;
}
