// V's hands on the wall during the climb, one above the other, swapping places again and again: hand over hand. The
// game has no animation of climbing a wall; its ledge climb places the hands with the arm IK (the game bends the arm so
// the hand reaches a point: ClimbEvents.CreateIKConstraint, scripts 2.5), and so does this. Only a free hand reaches:
// the weapon is put away first (Weapon.reds).

// Time between two swaps at the normal speed; these three times shrink as the speed setting grows, so the hands keep
// up with V.
public func WallClimbHandSwapTime() -> Float {
  return 0.3;
}

// How long a hand takes to reach its new point, and to let go of the old one.
public func WallClimbHandReach() -> Float {
  return 0.12;
}

public func WallClimbHandRelease() -> Float {
  return 0.15;
}

public func WallClimbSwapHands(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>, now: Float, pace: Float) -> Void {
  if now < climb.nextHands {
    return;
  }
  let leftFree: Bool = !IsDefined(ShootTransition.GetLeftWeapon(scriptInterface));
  let rightFree: Bool = !IsDefined(ShootTransition.GetRightWeapon(scriptInterface));
  if !leftFree && !rightFree {
    return;
  }
  climb.nextHands = now + WallClimbHandSwapTime() / pace;
  climb.leftHigh = !climb.leftHigh;
  // The old points blend into the new ones (the release and reach times).
  WallClimbRemoveHands(climb, scriptInterface);
  let aim: Vector4 = WallClimbHandsAim(climb, scriptInterface);
  if leftFree {
    WallClimbPlaceHand(climb, scriptInterface, aim, true, climb.leftHigh, pace);
  }
  if rightFree {
    WallClimbPlaceHand(climb, scriptInterface, aim, false, !climb.leftHigh, pace);
  }
  climb.handSwaps = climb.handSwaps + 1;
  if !climb.handsPlaced {
    climb.handsPlaced = true;
    climb.firstHandsAt = now;
  }
}

// Where the hands go round the eyes, set by eye in game: under the eyes when the look runs along the wall, at the point
// looked at between these distances along the look, and between these heights below and above the eyes, in m.
public func WallClimbHandsBelowEyes() -> Float {
  return 0.1;
}

public func WallClimbNearestHands() -> Float {
  return 0.25;
}

public func WallClimbFarthestHands() -> Float {
  return 1.5;
}

public func WallClimbHandsLowest() -> Float {
  return 0.35;
}

public func WallClimbHandsHighest() -> Float {
  return 0.4;
}

// Under this, the look runs almost along the wall: the cosine of its angle with the way into the wall.
public func WallClimbLeastLookAtWall() -> Float {
  return 0.2;
}

// Between the hands: the point of the wall the camera looks at, kept within arm's reach of the eyes, so the hands are
// on screen in first person.
public func WallClimbHandsAim(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>) -> Vector4 {
  let up: Vector4 = DefaultTransition.GetUpVector();
  let intoWall: Vector4 = climb.normal * -1.0;
  let camera: Transform = scriptInterface.GetCameraWorldTransform();
  let eyes: Vector4 = Transform.GetPosition(camera);
  let look: Vector4 = Transform.GetForward(camera);
  let aim: Vector4 = eyes - up * WallClimbHandsBelowEyes();
  let towardWall: Float = Vector4.Dot(look, intoWall);
  if towardWall > WallClimbLeastLookAtWall() {
    aim = eyes + look * ClampF(Vector4.Dot(climb.wallPoint - eyes, intoWall) / towardWall, WallClimbNearestHands(), WallClimbFarthestHands());
  }
  aim.Z = ClampF(aim.Z, eyes.Z - WallClimbHandsLowest(), eyes.Z + WallClimbHandsHighest());
  // Onto the wall, the palms 4 cm off it.
  return aim - climb.normal * (Vector4.Dot(aim - climb.wallPoint, climb.normal) - 0.04);
}

// The high hand 10 cm above the aim and the low one 15 cm below, each 20 cm to its side. The point is set relative
// to V, so it rises with V: a point fixed on the wall would be 1.5 m below the hand by the next swap.
public func WallClimbPlaceHand(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>, aim: Vector4, isLeft: Bool, isHigh: Bool, pace: Float) -> Void {
  let up: Vector4 = DefaultTransition.GetUpVector();
  let right: Vector4 = WallClimbAlongWall(climb.normal);
  let target: Vector4 = aim + up * (isHigh ? 0.1 : -0.15) + right * (isLeft ? -0.2 : 0.2);
  // The hand's orientation as the game's ledge climb builds it from the edge under the hand; the game's edges run
  // opposite ways for the two hands, and its reference up is reversed for the right one.
  let edge: Vector4 = right * (isLeft ? 0.2 : -0.2);
  let referenceUp: Vector4 = up * (isLeft ? 1.0 : -1.0);
  let handNormal: Vector4 = Vector4.Normalize(Vector4.Cross(edge, referenceUp));
  // The palm tilted up against the wall, set by eye in game.
  handNormal.Z = 0.3;
  handNormal = Vector4.Normalize(handNormal);
  let orientation: Matrix = Matrix.BuildFromDirectionVector(handNormal, edge);
  let owner: ref<GameObject> = scriptInterface.owner;
  let ownerTransform: Transform = WorldTransform._ToXForm(owner.GetWorldTransform());
  let reach: ref<IKTargetAddEvent> = new IKTargetAddEvent();
  reach.targetPositionProvider = IPositionProvider.CreateEntityPositionProvider(owner, Cast<Vector3>(Transform.TransformPoint(Transform.GetInverse(ownerTransform), target)));
  reach.orientationProvider = IOrientationProvider.CreateEntityOrientationProvider(null, n"None", owner, Quaternion.Conjugate(Transform.GetOrientation(ownerTransform)) * Matrix.ToQuat(orientation));
  reach.request.transitionIn = WallClimbHandReach() / pace;
  reach.request.transitionOut = WallClimbHandRelease() / pace;
  // The game's ledge climb gives its hands this priority.
  reach.request.priority = -100;
  reach.bodyPart = isLeft ? n"ikLeftArm" : n"ikRightArm";
  owner.QueueEvent(reach);
  ArrayPush(climb.hands, reach);
}

// At most two: each swap takes the last ones off before placing new ones.
public func WallClimbRemoveHands(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  for reach in climb.hands {
    IKTargetRemoveEvent.QueueRemoveIkTargetRemoveEvent(scriptInterface.owner, reach);
  }
  ArrayClear(climb.hands);
}
