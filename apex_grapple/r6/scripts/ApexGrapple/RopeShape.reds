// Where each piece of our rope lies along its points, from the rope's start to the hook's base: as many pieces as fit
// best, each running straight from one place to the next, spread evenly along the points, at least one (Borderlands
// 4, rope_motion.laid, ported). Every piece is then stretched alike to fill its span (PiecesDraw.reds). The line runs
// through the rope's start, its bends (RopeBends.reds) and the hook's base; each span between them hangs on its own
// (RopeHang.reds).

// The rope's line: its start, the points it runs through in order, its end.
public func ApexGrappleRopeLine(start: Vector4, through: array<Vector4>, end: Vector4) -> array<Vector4> {
  let line: array<Vector4>;
  ArrayPush(line, start);
  for point in through {
    ArrayPush(line, point);
  }
  ArrayPush(line, end);
  return line;
}

public func ApexGrappleRopeLength(points: array<Vector4>) -> Float {
  let total: Float = 0.0;
  let i: Int32 = 1;
  while i < ArraySize(points) {
    total = total + Vector4.Distance(points[i - 1], points[i]);
    i = i + 1;
  }
  return total;
}

// Room for a hanging rope's sag over its line: 69 m of line took 144 pieces, 1.14 times its length (2 November 2026).
public func ApexGrappleRopeSagRoom() -> Float {
  return 1.25;
}

// Our pieces reach about 105 m of line at their own length: a longer rope (range up to 150 m) stretches each piece alike
// rather than being cut short where the pieces run out.
public func ApexGrappleRopePieceFor(line: array<Vector4>, pieces: Int32) -> Float {
  if pieces <= 0 {
    return ApexGrappleRopePieceLength();
  }
  return MaxF(ApexGrappleRopePieceLength(), ApexGrappleRopeLength(line) * ApexGrappleRopeSagRoom() / Cast<Float>(pieces));
}

// The first `length` metres of the line from its start, or all of it: the rope as the hook reels it in.
public func ApexGrappleRopeCut(points: array<Vector4>, length: Float) -> array<Vector4> {
  let cut: array<Vector4>;
  if ArraySize(points) == 0 {
    return cut;
  }
  ArrayPush(cut, points[0]);
  let left: Float = MaxF(length, 0.0);
  let i: Int32 = 1;
  while i < ArraySize(points) {
    let span: Float = Vector4.Distance(points[i - 1], points[i]);
    if span >= left {
      let share: Float = span > 0.0 ? left / span : 0.0;
      ArrayPush(cut, points[i - 1] + (points[i] - points[i - 1]) * share);
      return cut;
    }
    ArrayPush(cut, points[i]);
    left = left - span;
    i = i + 1;
  }
  return cut;
}

// One span's places added to the rope's, the point they share once. The pieces are laid span by span, so that a bend
// is always between two pieces: one piece across a square corner would cut through it by up to a third of its length.
public func ApexGrappleAddPlaces(places: array<Vector4>, more: array<Vector4>) -> array<Vector4> {
  let all: array<Vector4> = places;
  let n: Int32 = ArraySize(all) == 0 ? 0 : 1;
  while n < ArraySize(more) {
    ArrayPush(all, more[n]);
    n = n + 1;
  }
  return all;
}

public func ApexGrappleRopePlaces(points: array<Vector4>, piece: Float) -> array<Vector4> {
  let places: array<Vector4>;
  let count: Int32 = ArraySize(points);
  if count < 2 || piece <= 0.0 {
    return places;
  }
  let lengths: array<Float>;
  let total: Float = 0.0;
  let i: Int32 = 0;
  while i < count - 1 {
    let one: Float = Vector4.Distance(points[i], points[i + 1]);
    ArrayPush(lengths, one);
    total = total + one;
    i = i + 1;
  }
  let pieces: Int32 = Max(1, RoundF(total / piece));
  ArrayPush(places, points[0]);
  let segment: Int32 = 0;
  let walked: Float = 0.0;
  let n: Int32 = 1;
  while n < pieces {
    let mark: Float = total * Cast<Float>(n) / Cast<Float>(pieces);
    while segment < ArraySize(lengths) - 1 && walked + lengths[segment] < mark {
      walked = walked + lengths[segment];
      segment = segment + 1;
    }
    let share: Float = 0.0;
    if lengths[segment] > 0.0 {
      share = (mark - walked) / lengths[segment];
    }
    ArrayPush(places, points[segment] + (points[segment + 1] - points[segment]) * share);
    n = n + 1;
  }
  ArrayPush(places, points[count - 1]);
  return places;
}
