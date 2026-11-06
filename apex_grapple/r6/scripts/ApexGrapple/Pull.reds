// The grapple's model: what one frame adds to V's velocity while the hook holds. Numbers in, numbers out, from Apex
// Grapple in Borderlands 4 (pull.py), itself measured in Titanfall 2. Two accelerations: toward the anchor, constant
// whatever the length of the rope, until a speed; toward where V looks, which bends the path. The rope carries a share
// of V's weight: at all of it, V flies straight where V aimed.
//
// Borderlands 4 steered with the move stick turned by the camera. Here, as in Apex Legends, the crosshair alone steers
// the pull, up and down included, and the move keys do nothing until the rope is let go.
//
// Once V has passed the anchor, nothing pulls V back. A rope that took off whatever carried V away from the anchor
// acted only once V was past it, so it could only pull V back: with the steering at 120 it braked V from 35 to
// 9.5 m/s and swung V up round the point. The circles come from the view, the pull helping while the anchor is beside
// V.

// A frame longer than this is a hitch, not a frame: taken whole, it would fire V out of the level.
public func ApexGrappleLongestFrame() -> Float {
  return 0.1;
}

// Below this a direction means nothing, and normalising it would explode.
public func ApexGrappleTiny() -> Float {
  return 0.000001;
}

// The fall state's gravity in TweakDB (playerStateMachineLocomotion.fall.downwardsGravity), for a state without its own.
public func ApexGrappleFallGravity() -> Float {
  return -16.0;
}

// Accelerates along a unit direction until the speed that way reaches the cap. The last frame before the cap adds
// only what is left, so the cap holds at any frame rate.
public func ApexGrapplePushToward(velocity: Vector4, direction: Vector4, acceleration: Float, cap: Float, frame: Float) -> Vector4 {
  let room: Float = cap - Vector4.Dot(velocity, direction);
  if room <= 0.0 {
    return velocity;
  }
  return velocity + direction * MinF(acceleration * frame, room);
}

// How far V is past the anchor along V's motion, in metres: below zero the anchor is still ahead, at zero it is square
// beside V.
public func ApexGrapplePastAnchor(velocity: Vector4, position: Vector4, anchor: Vector4) -> Float {
  let speed: Float = Vector4.Length(velocity);
  if speed <= ApexGrappleTiny() {
    return 0.0;
  }
  return Vector4.Dot(position - anchor, velocity * (1.0 / speed));
}

// The velocity to write this frame. `look`: where the view points, in world axes. `pullCap`: what the pull may reach
// along the rope (Shot.reds, ApexGrappleAttach). `gravity`: the state's fall gravity, positive, in m/s². `pulls`: false
// once V has passed the anchor (Pulling.reds).
public func ApexGrappleStep(velocity: Vector4, position: Vector4, anchor: Vector4, look: Vector4, settings: ref<ApexGrappleSettings>, pullCap: Float, gravity: Float, frame: Float, pulls: Bool) -> Vector4 {
  let step: Float = ClampF(frame, 0.0, ApexGrappleLongestFrame());
  if step <= 0.0 {
    return velocity;
  }
  let result: Vector4 = velocity;
  let falling: Float = gravity * (1.0 - ClampF(settings.ropeCarry / 100.0, 0.0, 1.0));
  if falling > 0.0 {
    result.Z = result.Z - falling * step;
  }
  let toAnchor: Vector4 = anchor - position;
  if pulls && Vector4.Length(toAnchor) > ApexGrappleTiny() {
    result = ApexGrapplePushToward(result, Vector4.Normalize(toAnchor), settings.pullStrength, pullCap, step);
  }
  return ApexGrappleSteer(result, look, settings.steerStrength, step);
}

// The part of the view across V's motion turns the motion toward it: as hard as the steering strength when V looks
// square across, fading as the motion lines up with the view. Only the way turns, the speed is left to the pull: added
// as it is, the push across made V faster at every turn, and faster the longer the frames (up to 5 m/s more each
// second in game, three times that at 30 frames a second). Borderlands 4 pushed toward the stick only while the speed
// that way stayed under a cap: at 25 m/s that acted only when V looked more than 66 degrees away from the motion, and
// a player looking 10 to 50 degrees away saw the aim change nothing.
public func ApexGrappleSteer(velocity: Vector4, look: Vector4, strength: Float, step: Float) -> Vector4 {
  let speed: Float = Vector4.Length(velocity);
  if speed <= ApexGrappleTiny() || Vector4.Length(look) <= ApexGrappleTiny() {
    return velocity;
  }
  let motion: Vector4 = velocity * (1.0 / speed);
  let view: Vector4 = Vector4.Normalize(look);
  let across: Vector4 = view - motion * Vector4.Dot(view, motion);
  let turned: Vector4 = velocity + across * (strength * step);
  let turnedSpeed: Float = Vector4.Length(turned);
  if turnedSpeed <= ApexGrappleTiny() {
    return velocity;
  }
  return turned * (speed / turnedSpeed);
}
