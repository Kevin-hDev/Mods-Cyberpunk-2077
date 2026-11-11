// Where the rope leaves the lent launcher (Launcher.reds): its start at the barrel's mouth, and its way out along the
// barrel.
// The start: the bone the rope otherwise starts from (WeaponLeft, RopeStart.reds) sits in V's fist, hidden under the
// launcher, 8 to 10 cm right of the barrel. The barrel sits on the forearm by the wrist, so the rope starts from the
// wrist joint (slot LeftHand) plus a step in the camera's frame. The step: on capture 63 (a pull, 2000 x 1253 px) Kevin
// circled the barrel's mouth at 632, 824 px; with the game's vertical field of view of 51 degrees a pixel there is
// 1/1313 of the depth, and at the wrist's depth (0.372 m, arm held, 19 readings within 1 cm) the mouth is 2 cm right of
// and 4 cm above the wrist; the rope's end was then drawn 15 px from there. The launcher settles there about 0.5 s after
// the shot; while the arm rises it comes up late and lower.
// The way out: run straight from the barrel to the hook, the rope left the barrel askew once the hook was off to a side
// of the screen (Kevin, 31 October 2026). Seen from the eyes, the line starts with a curve: out along the barrel, which
// aims at the middle of the view, then round toward the line's next point, in a few short spans laid with their own
// pieces as the bends' are (RopeShape.reds). 12 cm legs left a smooth hook in front of the barrel, a U-turn once V passed
// the anchor, and lost the rope's twisted strands (a 55 cm piece squashed to a few centimetres); 4 cm legs, as a taut
// rope bends at the barrel's lip, keep the squashed part small.

public func ApexGrappleLauncherBarrelRight() -> Float {
  return 0.02;
}

public func ApexGrappleLauncherBarrelUp() -> Float {
  return 0.04;
}

// Each of the curve's two legs, at most a third of the way to the line's next point.
public func ApexGrappleLauncherExitLength() -> Float {
  return 0.04;
}

// The points along the curve, its end included.
public func ApexGrappleLauncherExitSteps() -> Int32 {
  return 3;
}

public func ApexGrappleLauncherWrist(system: ref<ApexGrappleSystem>) -> ApexGrappleWristRead {
  let read: ApexGrappleWristRead;
  let place: WorldTransform;
  if !IsDefined(system.handSlots) || !system.handSlots.GetSlotTransform(n"LeftHand", place) {
    return read;
  }
  let at: Vector4 = WorldPosition.ToVector4(WorldTransform.GetWorldPosition(place));
  at.W = 1.0;
  read.found = true;
  read.at = at;
  return read;
}

// Called by the rope's start (RopeStart.reds) while the launcher is lent: the barrel's mouth, or nothing when the
// wrist cannot be read.
public func ApexGrappleLauncherBarrelStart(system: ref<ApexGrappleSystem>, view: Transform) -> ApexGrappleWristRead {
  let read: ApexGrappleWristRead;
  let wrist: ApexGrappleWristRead = ApexGrappleLauncherWrist(system);
  if !wrist.found {
    return read;
  }
  let at: Vector4 = wrist.at + Transform.GetRight(view) * ApexGrappleLauncherBarrelRight() + Transform.GetUp(view) * ApexGrappleLauncherBarrelUp();
  at.W = 1.0;
  read.found = true;
  read.at = at;
  return read;
}

public func ApexGrappleLauncherExitPoint(from: Vector4, bend: Vector4, to: Vector4, share: Float) -> Vector4 {
  let rest: Float = 1.0 - share;
  let at: Vector4 = from * (rest * rest) + bend * (2.0 * rest * share) + to * (share * share);
  at.W = 1.0;
  return at;
}

// Before the line is cut on the hook's way back (PiecesDraw.reds), so that the hook comes home along the curve.
public func ApexGrappleLauncherExit(system: ref<ApexGrappleSystem>, view: Transform, line: array<Vector4>) -> array<Vector4> {
  if ArraySize(line) < 2 || !ApexGrappleLauncherOut(system) || !IsDefined(system.arm) || !system.arm.sent {
    return line;
  }
  let from: Vector4 = line[0];
  let leg: Float = MinF(ApexGrappleLauncherExitLength(), Vector4.Distance(from, line[1]) / 3.0);
  if leg <= ApexGrappleTiny() {
    return line;
  }
  let forward: Vector4 = Transform.GetForward(view);
  let bend: Vector4 = from + forward * leg;
  bend.W = 1.0;
  let to: Vector4 = bend + ApexGrappleToward(bend, line[1]) * leg;
  to.W = 1.0;
  let curved: array<Vector4>;
  ArrayPush(curved, from);
  let steps: Int32 = ApexGrappleLauncherExitSteps();
  let i: Int32 = 1;
  while i <= steps {
    ArrayPush(curved, ApexGrappleLauncherExitPoint(from, bend, to, Cast<Float>(i) / Cast<Float>(steps)));
    i += 1;
  }
  let n: Int32 = 1;
  while n < ArraySize(line) {
    ArrayPush(curved, line[n]);
    n += 1;
  }
  return curved;
}
