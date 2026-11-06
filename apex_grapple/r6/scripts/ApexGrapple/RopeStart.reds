// Where the rope starts: the middle of V's left fist (Wrist.reds), or the lent launcher's barrel (LauncherRope.reds). A
// fixed point bottom left of the view stays for when the hand cannot be read, said once a load.

// The start and the point it was read from: from one frame to the next, a change of that point is a jump, not a move
// (RopeLead.reds).
public struct ApexGrappleRopeStartRead {
  let at: Vector4;
  let from: Int32;
}

public func ApexGrappleRopeFromFixedPoint() -> Int32 {
  return 0;
}

public func ApexGrappleRopeFromFist() -> Int32 {
  return 1;
}

public func ApexGrappleRopeFromWrist() -> Int32 {
  return 2;
}

public func ApexGrappleRopeFromBarrel() -> Int32 {
  return 3;
}

public func ApexGrappleRopeStartFrom(at: Vector4, from: Int32) -> ApexGrappleRopeStartRead {
  let read: ApexGrappleRopeStartRead;
  read.at = at;
  read.from = from;
  return read;
}

public func ApexGrappleRopeStartAcross() -> Float {
  return 0.32;
}

public func ApexGrappleRopeStartDown() -> Float {
  return 0.75;
}

public func ApexGrappleRopeStartDepth() -> Float {
  return 0.7;
}

// On foot the game's field of view is horizontal.
public func ApexGrappleRopeStart(view: Transform, fov: Float, aspect: Float) -> Vector4 {
  let depth: Float = ApexGrappleRopeStartDepth();
  let halfWide: Float = TanF(Deg2Rad(MaxF(fov, 1.0)) * 0.5) * depth;
  let halfHigh: Float = halfWide / MaxF(aspect, 0.1);
  let across: Float = (ApexGrappleRopeStartAcross() * 2.0 - 1.0) * halfWide;
  let up: Float = (1.0 - ApexGrappleRopeStartDown() * 2.0) * halfHigh;
  let at: Vector4 = Transform.GetPosition(view) + Transform.GetForward(view) * depth + Transform.GetRight(view) * across + Transform.GetUp(view) * up;
  at.W = 1.0;
  return at;
}

// V's step this frame. The camera and the hand the mod reads are where they were before V's move this frame (measured
// in game on 22 shots out of 22), so the rope's start is moved on (RopeLead.reds): left a step behind, 27 to 43 cm at
// 30 to 48 m/s, the rope trembled during pulls. This step alone leads on a shot's first frame and after a miss.
public func ApexGrappleViewStep(velocity: Vector4, frame: Float) -> Vector4 {
  let step: Vector4 = velocity * frame;
  step.W = 0.0;
  return step;
}

// The velocity V moves with this frame. During a pull the mod has already written this frame's push when the rope is
// drawn (Pulling.reds) and V moves with it, while the game's velocity is still the one before it: stepped on with the
// game's, the rope's start was off by the push times the frame (on Kevin's captures 64 and 65 the rope jumped about
// 11 cm in a frame, the launcher still).
public func ApexGrappleMovingWith(system: ref<ApexGrappleSystem>, now: Float, game: Vector4) -> Vector4 {
  if system.phase == ApexGrapplePulling() && system.pushAt == now {
    return system.velocity;
  }
  return game;
}

// The rope's start as the last frame showed it; RopeLead.reds moves it on.
public func ApexGrappleRopeStartNow(system: ref<ApexGrappleSystem>, view: Transform, scriptInterface: ref<StateGameScriptInterface>) -> ApexGrappleRopeStartRead {
  let read: ApexGrappleWristRead = ApexGrappleLeftHand(system, scriptInterface);
  if !read.found {
    if !system.handMissSaid {
      system.handMissSaid = true;
      ApexGrappleLog("the left hand could not be read: the rope starts from the fixed point bottom left");
    }
    let cameras: ref<CameraSystem> = GameInstance.GetCameraSystem(scriptInterface.executionOwner.GetGame());
    return ApexGrappleRopeStartFrom(ApexGrappleRopeStart(view, cameras.GetActiveCameraFOV(), cameras.GetAspectRatio()), ApexGrappleRopeFromFixedPoint());
  }
  let barrel: ApexGrappleWristRead = ApexGrappleLauncherBarrelStart(system, view);
  if barrel.found {
    return ApexGrappleRopeStartFrom(barrel.at, ApexGrappleRopeFromBarrel());
  }
  // The step to the fist's middle was measured from WeaponLeft; the wrist joint gets none.
  if read.inHand {
    return ApexGrappleRopeStartFrom(ApexGrappleFistMiddle(view, read.at), ApexGrappleRopeFromFist());
  }
  return ApexGrappleRopeStartFrom(read.at, ApexGrappleRopeFromWrist());
}
