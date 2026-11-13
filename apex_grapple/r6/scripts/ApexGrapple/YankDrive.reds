// What the hook pulls to V is thrown toward a goal the aim moves, from the bite until it gets there: the one way a
// person (Yank.reds) and a motorcycle (YankBike.reds) are moved. Kevin, 13 November 2026: "qu'on gere la traction du
// debut a la fin avec le viseur sans rien automatiser", "projeter dans une direction mais egalement la changer en cour
// de projection", and the same moves with or without damage. Before, the aim was read twice a pull (at the throw and
// halfway); the pull ended with a brake, or with damage a slam, whatever the aim (docs/apex-grapple/
// vehicules-et-personnes/conception.md).
//
// The moves: pushes toward the goal (YankSteer.reds) at the pull's full speed, each sized from the speed read, the
// next one given only once the last shows in that speed. A push every frame ran bodies away to 3,483 m/s in the first
// test, and a throw that showed late added to the next one: 1,012 m/s in the fourth. The pull ends when the thing
// gets to the goal. A first writing of 13 November slowed the thing down as it came and held it at the goal for a
// "traction time": Kevin, fourteenth trial, "on ne tire plus les gens dans certaines direction, on les deposes", "on
// voit les personne pendre au grapin".

public class ApexGrappleDrive {
  // By V, for an aim left alone, and how far that is above the ground; where the thing is thrown to now.
  public let baseGoal: Vector4;
  public let above: Float;
  public let goal: Vector4;
  // V's feet when the goals were last moved with V.
  public let feetAtGoal: Vector4;
  // From the view to the bite, at the bite: the line the aim is measured against.
  public let aimFrom: Vector4;
  // "Steer what is pulled with the aim" for this pull; the aim moves the goal now; it has done so at least once.
  public let steers: Bool;
  public let aims: Bool;
  public let steered: Bool;
  // The aim is lowered: the goal is on the ground, and the thing is thrown against it.
  public let slams: Bool;
  // The aim against the bite's line, in degrees, for the log.
  public let raised: Float;
  public let turned: Float;
  public let speed: Float;
  // The pushes begin (0 before), and the thing must have come by then with the aim left alone
  // (ApexGrappleDriveOverdue).
  public let beganAt: Float;
  public let comeBy: Float;
  // The pushes given, and the last one: when, how much, and the speed read then.
  public let pushes: Int32;
  public let pushedAt: Float;
  public let lastPush: Vector4;
  public let lastFrom: Vector4;
  public let toldAt: Float;
}

// No push sooner than this after the last one.
public func ApexGrappleDriveInterval() -> Float {
  return 0.05;
}

// A push this large or more must show in the speed read, by this share of itself, before the next one; after this long
// it is taken for lost.
public func ApexGrappleDriveShowsFrom() -> Float {
  return 4.0;
}

public func ApexGrappleDriveShown() -> Float {
  return 0.25;
}

public func ApexGrappleDriveShowLongest() -> Float {
  return 0.35;
}

// After the first, a push makes up this share of the gap between the speed wanted and the speed read, never more: a
// full share on a body that answers twice as hard would overshoot as much.
public func ApexGrappleDriveGain() -> Float {
  return 0.7;
}

// A smaller change of speed than this is not worth a push.
public func ApexGrappleDriveLeast() -> Float {
  return 1.0;
}

// The thing has this long after the time the way takes at the pull's speed; then it did not come.
public func ApexGrappleDriveLate() -> Float {
  return 1.0;
}

// This close to the goal, a thing going away from it at a quarter of the pull's speed or more has gone past it: a
// fast body crosses the goal between two frames.
public func ApexGrappleDrivePastNear() -> Float {
  return 3.0;
}

// Set at the bite. `baseGoal`: where the thing comes to with the aim left alone, `above` the ground.
public func ApexGrappleDriveSet(drive: ref<ApexGrappleDrive>, baseGoal: Vector4, above: Float, feet: Vector4, aimFrom: Vector4, steers: Bool, speed: Float) -> Void {
  drive.baseGoal = baseGoal;
  drive.above = above;
  drive.goal = baseGoal;
  drive.feetAtGoal = feet;
  drive.aimFrom = aimFrom;
  drive.steers = steers;
  drive.aims = false;
  drive.steered = false;
  drive.slams = false;
  drive.raised = 0.0;
  drive.turned = 0.0;
  drive.speed = speed;
  drive.beganAt = 0.0;
  drive.pushes = 0;
  drive.pushedAt = 0.0;
  drive.toldAt = 0.0;
}

public func ApexGrappleDriveBegin(drive: ref<ApexGrappleDrive>, place: Vector4, now: Float) -> Void {
  drive.beganAt = now;
  drive.comeBy = now + Vector4.Distance(place, drive.baseGoal) / drive.speed + ApexGrappleDriveLate();
}

// The goals move as V moves. Kevin, 13 November 2026: "Quand V bouge, il faut que le grapin qui atrappe suivent V donc
// que ca decale". Fixed at the bite, the goal left people 5 to 11 m from a V who had moved on (fifth height trial).
public func ApexGrappleDriveFollow(drive: ref<ApexGrappleDrive>, feet: Vector4) -> Void {
  let moved: Vector4 = feet - drive.feetAtGoal;
  drive.baseGoal = drive.baseGoal + moved;
  drive.goal = drive.goal + moved;
  drive.feetAtGoal = feet;
  // The way got that much longer, at most: the thing has the time to cover it too.
  drive.comeBy += Vector4.Length(moved) / drive.speed;
}

// The thing did not come: later than the way to the spot by V takes (ApexGrappleDriveBegin), what V walked since
// (ApexGrappleDriveFollow), and the way from that spot to where the aim sends it now. Worked out at the bite alone,
// the time would run out mid-flight at a low speed: at 10 m/s, 20 m away, V backing off at 6 m/s needs 5 s where 3
// were given, and a goal 8 m to the side takes 0.8 s of the second to spare (worked out at the audit of 13 November
// 2026, not seen in game).
public func ApexGrappleDriveOverdue(drive: ref<ApexGrappleDrive>, now: Float) -> Bool {
  return now > drive.comeBy + Vector4.Distance(drive.goal, drive.baseGoal) / drive.speed;
}

// Whether a push may be given now: not too soon after the last, and the last one showing in the speed read.
public func ApexGrappleDriveDue(drive: ref<ApexGrappleDrive>, velocity: Vector4, now: Float) -> Bool {
  if drive.pushes == 0 {
    return true;
  }
  let since: Float = now - drive.pushedAt;
  if since < ApexGrappleDriveInterval() {
    return false;
  }
  let size: Float = Vector4.Length(drive.lastPush);
  return size < ApexGrappleDriveShowsFrom() || since >= ApexGrappleDriveShowLongest() || Vector4.Length(velocity - drive.lastFrom) >= ApexGrappleDriveShown() * size;
}

// The push toward the goal from `place` at the speed read `velocity`, to the pull's full speed; false when none is
// worth giving.
public func ApexGrappleDriveStep(drive: ref<ApexGrappleDrive>, place: Vector4, velocity: Vector4, now: Float, out change: Vector4) -> Bool {
  let toGoal: Vector4 = drive.goal - place;
  let far: Float = Vector4.Length(toGoal);
  if far <= ApexGrappleTiny() {
    return false;
  }
  // The first push whole, as the throw it replaces; the next ones a share of the gap only.
  let share: Float = drive.pushes == 0 ? 1.0 : ApexGrappleDriveGain();
  change = ApexGrappleClamp((toGoal / far * drive.speed - velocity) * share, drive.speed);
  if Vector4.Length(change) < ApexGrappleDriveLeast() {
    return false;
  }
  drive.pushes += 1;
  drive.pushedAt = now;
  drive.lastPush = change;
  drive.lastFrom = velocity;
  return true;
}

// 0: not there yet. 1: at the goal. 2: against the ground the lowered aim threw it at. `near`: this close to the goal
// along the ground and within `height` of its height; `stop`: with the aim left alone, or this close to V.
public func ApexGrappleDriveArrived(drive: ref<ApexGrappleDrive>, place: Vector4, velocity: Vector4, feet: Vector4, near: Float, stop: Float, height: Float) -> Int32 {
  let toGoal: Vector4 = drive.goal - place;
  let far: Float = Vector4.Length(toGoal);
  if drive.slams {
    return far <= ApexGrappleSteerSlamNear() ? 2 : 0;
  }
  if far <= ApexGrappleDrivePastNear() && Vector4.Dot(toGoal, velocity) < 0.0 && Vector4.Length(velocity) >= 0.25 * drive.speed {
    return 1;
  }
  if AbsF(toGoal.Z) > height {
    return 0;
  }
  if Vector4.Length(ApexGrappleFlat(toGoal)) <= near || (!drive.aims && Vector4.Length(ApexGrappleFlat(place - feet)) <= stop) {
    return 1;
  }
  return 0;
}

public func ApexGrappleClamp(change: Vector4, most: Float) -> Vector4 {
  let size: Float = Vector4.Length(change);
  return size > most ? change / size * most : change;
}

// Whether this push is written to the log: the first four, then one every quarter of a second.
public func ApexGrappleDriveTells(drive: ref<ApexGrappleDrive>, now: Float) -> Bool {
  if drive.pushes > 4 && now - drive.toldAt < 0.25 {
    return false;
  }
  drive.toldAt = now;
  return true;
}

// For the log, one push: where the thing is against the goal, and what the aim does.
public func ApexGrappleDrivePushText(drive: ref<ApexGrappleDrive>, place: Vector4, read: Float, change: Vector4, now: Float) -> String {
  let aim: String = drive.aims ? (drive.slams ? "on the ground" : "moved") : "left alone";
  return "push " + ToString(drive.pushes) + " at " + ToString(now - drive.beganAt) + " s: " + ToString(Vector4.Distance(place, drive.goal)) + " m from the goal, speed read " + ToString(read) + ", push " + ToString(Vector4.Length(change)) + " m/s, aim " + ToString(drive.raised) + " degrees up and " + ToString(drive.turned) + " to the right, goal " + aim + ", " + ToString(drive.goal.Z - drive.baseGoal.Z) + " m above the spot by V and " + ToString(Vector4.Length(ApexGrappleFlat(drive.goal - drive.baseGoal))) + " m to its side";
}

// For the log, the pull's end.
public func ApexGrappleDriveEndText(drive: ref<ApexGrappleDrive>, now: Float) -> String {
  return ToString(drive.pushes) + " pushes in " + ToString(drive.beganAt > 0.0 ? now - drive.beganAt : 0.0) + " s, steered " + ToString(drive.steered);
}
