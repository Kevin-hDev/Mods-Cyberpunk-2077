// A person pulled to V steered with the aim ("Steer pulled people with the aim", docs/apex-grapple/
// vehicules-et-personnes/conception.md). Kevin, 2 November 2026: "si je monte le viseur vers le haut, le personnage est
// ramené mais en hauteur [...] si je tourne vers la droite ça le tire vers la droite". The flight lasts 0.1 to 0.6 s
// (fourth test), too short to steer frame by frame as V's pull is, and a push every frame ran the bodies away in the
// first test: the aim is read at the throw and at the correction, and moves the goal.

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

// Shares of the aim's move tried in turn, down to none: the moved goal must pass the checks the straight one passed.
public func ApexGrappleSteerTry(step: Int32) -> Float {
  if step == 0 {
    return 1.0;
  }
  if step == 1 {
    return 0.75;
  }
  if step == 2 {
    return 0.5;
  }
  return 0.25;
}

// A moved goal the person can reach: ground where the AI can stand under it, as for the straight one (YankWhy.reds).
// The audit of 2 November 2026 found the moved goal never checked: steered throws came 74 % of the time, straight ones
// 91 % (fifth test). Something in the way does not count, for the straight goal neither (Kevin, 9 November 2026).
public func ApexGrappleSteerFits(yank: ref<ApexGrappleYank>, goal: Vector4, side: Float, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if AbsF(side) <= ApexGrappleTiny() {
    return true;
  }
  let up: Vector4 = DefaultTransition.GetUpVector();
  let ground: Vector4 = goal - up * (goal.Z - yank.baseGoal.Z + ApexGrappleYankChestUp());
  let snapped: Vector4;
  return GameInstance.GetAINavigationSystem(scriptInterface.GetGame()).IsPointOnNavmesh(yank.person, ground, new Vector4(0.5, 0.5, 1.0, 1.0), snapped);
}

// Moves the goal for where V looks now, against the line from the view to the bite: up as the aim is raised, to the
// side as it turns. Lowered, it steers nothing: the ground is there.
public func ApexGrappleYankSteer(yank: ref<ApexGrappleYank>, chest: Vector4, when: String, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let look: Vector4 = Transform.GetForward(scriptInterface.GetCameraWorldTransform());
  let from: Vector4 = ApexGrappleFlat(yank.aimFrom);
  let flatLook: Vector4 = ApexGrappleFlat(look);
  if !yank.steers || Vector4.Length(from) <= ApexGrappleTiny() || Vector4.Length(flatLook) <= ApexGrappleTiny() {
    return;
  }
  from = Vector4.Normalize(from);
  // As the game turns a forward into its right (aiCustomAimingTasks.script:73).
  let right: Vector4 = Vector4.Normalize(Vector4.Cross(from, DefaultTransition.GetUpVector()));
  let raised: Float = ApexGrappleElevation(look) - ApexGrappleElevation(yank.aimFrom);
  let turned: Float = ApexGrappleTurn(from, right, Vector4.Normalize(flatLook));
  let up: Float = raised > 0.0 ? ApexGrappleSteerShare(raised) * ApexGrappleSteerMostUp() : 0.0;
  let side: Float = ApexGrappleSteerShare(turned) * ApexGrappleSteerMostSide();
  if turned < 0.0 {
    side = -side;
  }
  let share: Float = 0.0;
  let goal: Vector4 = yank.baseGoal;
  if up > 0.0 || AbsF(side) > 0.0 {
    let step: Int32 = 0;
    while step < 4 && share <= 0.0 {
      let tried: Vector4 = yank.baseGoal + DefaultTransition.GetUpVector() * (up * ApexGrappleSteerTry(step)) + right * (side * ApexGrappleSteerTry(step));
      if ApexGrappleSteerFits(yank, tried, side * ApexGrappleSteerTry(step), scriptInterface) {
        share = ApexGrappleSteerTry(step);
        goal = tried;
      }
      step += 1;
    }
  }
  yank.goal = goal;
  let toGoal: Vector4 = ApexGrappleFlat(yank.goal - chest);
  if Vector4.Length(toGoal) > ApexGrappleTiny() {
    yank.line = Vector4.Normalize(toGoal);
  }
  ApexGrappleLog("person pulled to V: aim " + ToString(raised) + " degrees up and " + ToString(turned) + " to the right " + when + ", goal " + ToString(up * share) + " m higher and " + ToString(side * share) + " m to the right (" + ToString(share * 100.0) + " % of the aim's move fits)");
}
