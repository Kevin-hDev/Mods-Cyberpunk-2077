// Where the aim sends what the hook pulls to V ("Steer what is pulled with the aim", docs/apex-grapple/
// vehicules-et-personnes/conception.md), read every frame of the pull; the pushes that take the thing there are in
// YankDrive.reds. Kevin, 2 November 2026: "si je monte le viseur vers le haut, le personnage est ramené mais en
// hauteur [...] si je tourne vers la droite ça le tire vers la droite"; 13 November 2026: the aim from the bite to the
// end, and "je vise le bas -> projection vers le bas qui plaque au sol".
//
// The goal is the spot by V, moved by the aim against the line from the view to the bite: up as the aim is raised, to
// the side as it turns, and down onto the ground once it is lowered enough.

// Under this many degrees between the aim and the bite, nothing moves: an aim that drifts a little steers nothing.
public func ApexGrappleSteerDeadZone() -> Float {
  return 5.0;
}

// At this many degrees or more, the goal moves its farthest.
public func ApexGrappleSteerFull() -> Float {
  return 30.0;
}

// The farthest the goal moves, in metres: up, and to either side.
public func ApexGrappleSteerMostUp() -> Float {
  return 6.0;
}

public func ApexGrappleSteerMostSide() -> Float {
  return 8.0;
}

// Lowered this many degrees or more, the aim throws the thing against the ground: twice the dead zone, a slam kills.
public func ApexGrappleSteerSlamFrom() -> Float {
  return 10.0;
}

// Thrown against the ground, the thing has reached it this close to the point.
public func ApexGrappleSteerSlamNear() -> Float {
  return 1.0;
}

// Share of the farthest move for an angle: 0 within the dead zone, 1 at full and beyond, in proportion between.
public func ApexGrappleSteerShare(degrees: Float) -> Float {
  return ClampF((AbsF(degrees) - ApexGrappleSteerDeadZone()) / (ApexGrappleSteerFull() - ApexGrappleSteerDeadZone()), 0.0, 1.0);
}

public func ApexGrappleElevation(direction: Vector4) -> Float {
  let unit: Vector4 = Vector4.Normalize(direction);
  return Rad2Deg(AsinF(ClampF(unit.Z, -1.0, 1.0)));
}

// Degrees from `from` to `look` along the ground, to the right above zero. Looking back counts as square to the side.
public func ApexGrappleTurn(from: Vector4, right: Vector4, look: Vector4) -> Float {
  let across: Float = ClampF(Vector4.Dot(look, right), -1.0, 1.0);
  if Vector4.Dot(look, from) < 0.0 {
    return across >= 0.0 ? 90.0 : -90.0;
  }
  return Rad2Deg(AsinF(across));
}

// Sets the goal for where V looks now, against the line from the view to the bite.
public func ApexGrappleDriveAim(drive: ref<ApexGrappleDrive>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  drive.aims = false;
  drive.slams = false;
  drive.goal = drive.baseGoal;
  if !drive.steers {
    return;
  }
  let look: Vector4 = Transform.GetForward(scriptInterface.GetCameraWorldTransform());
  let from: Vector4 = ApexGrappleFlat(drive.aimFrom);
  let flatLook: Vector4 = ApexGrappleFlat(look);
  // No line along the ground to measure against: the bite or the look straight up or down.
  if Vector4.Length(from) <= ApexGrappleTiny() || Vector4.Length(flatLook) <= ApexGrappleTiny() {
    return;
  }
  from = Vector4.Normalize(from);
  // As the game turns a forward into its right (aiCustomAimingTasks.script:73).
  let right: Vector4 = Vector4.Normalize(Vector4.Cross(from, DefaultTransition.GetUpVector()));
  drive.raised = ApexGrappleElevation(look) - ApexGrappleElevation(drive.aimFrom);
  drive.turned = ApexGrappleTurn(from, right, Vector4.Normalize(flatLook));
  let up: Float = drive.raised > 0.0 ? ApexGrappleSteerShare(drive.raised) * ApexGrappleSteerMostUp() : 0.0;
  let side: Float = ApexGrappleSteerShare(drive.turned) * ApexGrappleSteerMostSide();
  if drive.turned < 0.0 {
    side = -side;
  }
  drive.slams = drive.raised <= -ApexGrappleSteerSlamFrom();
  drive.aims = drive.slams || up > 0.0 || AbsF(side) > 0.0;
  if !drive.aims {
    return;
  }
  drive.steered = true;
  drive.goal = drive.baseGoal + DefaultTransition.GetUpVector() * (drive.slams ? -drive.above : up) + right * side;
}
