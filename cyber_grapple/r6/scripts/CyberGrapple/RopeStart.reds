// Made by fabrique/grapple.py from Apex Grapple's RopeStart.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Where the rope starts: the middle of V's left fist (Wrist.reds), or the lent launcher's barrel (LauncherRope.reds). A
// fixed point bottom left of the view stays for when the hand cannot be read, said once a load.

// The start and the point it was read from: from one frame to the next, a change of that point is a jump, not a move
// (RopeLead.reds).
public struct CyberGrappleRopeStartRead {
  let at: Vector4;
  let from: Int32;
}

public func CyberGrappleRopeFromFixedPoint() -> Int32 {
  return 0;
}

public func CyberGrappleRopeFromFist() -> Int32 {
  return 1;
}

public func CyberGrappleRopeFromWrist() -> Int32 {
  return 2;
}

public func CyberGrappleRopeFromBarrel() -> Int32 {
  return 3;
}

public func CyberGrappleRopeStartFrom(at: Vector4, from: Int32) -> CyberGrappleRopeStartRead {
  let read: CyberGrappleRopeStartRead;
  read.at = at;
  read.from = from;
  return read;
}

public func CyberGrappleRopeStartAcross() -> Float {
  return 0.32;
}

public func CyberGrappleRopeStartDown() -> Float {
  return 0.75;
}

public func CyberGrappleRopeStartDepth() -> Float {
  return 0.7;
}

// On foot the game's field of view is horizontal.
public func CyberGrappleRopeStart(view: Transform, fov: Float, aspect: Float) -> Vector4 {
  let depth: Float = CyberGrappleRopeStartDepth();
  let halfWide: Float = TanF(Deg2Rad(MaxF(fov, 1.0)) * 0.5) * depth;
  let halfHigh: Float = halfWide / MaxF(aspect, 0.1);
  let across: Float = (CyberGrappleRopeStartAcross() * 2.0 - 1.0) * halfWide;
  let up: Float = (1.0 - CyberGrappleRopeStartDown() * 2.0) * halfHigh;
  let at: Vector4 = Transform.GetPosition(view) + Transform.GetForward(view) * depth + Transform.GetRight(view) * across + Transform.GetUp(view) * up;
  at.W = 1.0;
  return at;
}

// V's step this frame. The camera and the hand the mod reads are where they were before V's move this frame (measured
// in game on 22 shots out of 22), so the rope's start is moved on (RopeLead.reds): left a step behind, 27 to 43 cm at
// 30 to 48 m/s, the rope trembled during pulls. This step alone leads on a shot's first frame and after a miss.
public func CyberGrappleViewStep(velocity: Vector4, frame: Float) -> Vector4 {
  let step: Vector4 = velocity * frame;
  step.W = 0.0;
  return step;
}

// The velocity V moves with this frame. During a pull the mod has already written this frame's push when the rope is
// drawn (Pulling.reds) and V moves with it, while the game's velocity is still the one before it: stepped on with the
// game's, the rope's start was off by the push times the frame (on Kevin's captures 64 and 65 the rope jumped about
// 11 cm in a frame, the launcher still).
public func CyberGrappleMovingWith(system: ref<CyberGrappleSystem>, now: Float, game: Vector4) -> Vector4 {
  if system.phase == CyberGrapplePulling() && system.pushAt == now {
    return system.velocity;
  }
  return game;
}

// The rope's start as the last frame showed it; RopeLead.reds moves it on. While the launcher is lent its barrel is
// read first, and the hand only when the wrist under it cannot be: read first, the hand was read for nothing (B13). The
// barrel is read from the wrist joint, so wherever it is found the hand would have been too: the start is the same.
public func CyberGrappleRopeStartNow(system: ref<CyberGrappleSystem>, view: Transform, scriptInterface: ref<StateGameScriptInterface>) -> CyberGrappleRopeStartRead {
  let lent: Bool = CyberGrappleLauncherOut(system) && CyberGrappleHandSlotsFound(system, scriptInterface);
  if lent {
    let barrel: CyberGrappleWristRead = CyberGrappleLauncherBarrelStart(system, view);
    if barrel.found {
      return CyberGrappleRopeStartFrom(barrel.at, CyberGrappleRopeFromBarrel());
    }
  }
  let read: CyberGrappleWristRead = CyberGrappleLeftHand(system, scriptInterface);
  if !read.found {
    if !system.handMissSaid {
      system.handMissSaid = true;
      CyberGrappleLog("the left hand could not be read: the rope starts from the fixed point bottom left");
    }
    let cameras: ref<CameraSystem> = GameInstance.GetCameraSystem(scriptInterface.executionOwner.GetGame());
    return CyberGrappleRopeStartFrom(CyberGrappleRopeStart(view, cameras.GetActiveCameraFOV(), cameras.GetAspectRatio()), CyberGrappleRopeFromFixedPoint());
  }
  if lent && !system.loan.wristMissSaid {
    system.loan.wristMissSaid = true;
    CyberGrappleLog("the wrist could not be read: the rope starts from the fist under the launcher");
  }
  // The step to the fist's middle was measured from WeaponLeft; the wrist joint gets none.
  if read.inHand {
    return CyberGrappleRopeStartFrom(CyberGrappleFistMiddle(view, read.at), CyberGrappleRopeFromFist());
  }
  return CyberGrappleRopeStartFrom(read.at, CyberGrappleRopeFromWrist());
}
