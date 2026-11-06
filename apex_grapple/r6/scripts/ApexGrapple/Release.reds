// When a pull ends. Numbers in, answers out, from Apex Grapple in Borderlands 4 (release.py); each rule exists because
// a simpler one failed there:
// - the arrival sphere grows with V's stride: at top speed a fixed sphere was stepped clean over, and V swung back and
//   forth through the anchor for seconds;
// - the ground means nothing during the take-off: a pull from the floor has V standing for its first frames;
// - going far slower than the pull asks means something solid is in the way: the mod owns the velocity during a pull,
//   and without this it would hold V pressed into a wall;
// - past the anchor: Borderlands 4 let go as soon as V moved away after coming near it, which cut every swing round
//   it. Here the rope lets go a set distance after V has passed the anchor, so that a wide arc made with the view goes
//   on. Measured along V's motion, so a circle round the anchor, which keeps it beside V, never ends; only once V has
//   come toward the anchor, since a hook shot behind a running V first pulls V back to it.

public func ApexGrappleStrideShare() -> Float {
  return 1.2;
}

public func ApexGrappleShortArrivalShare() -> Float {
  return 0.5;
}

// The blocked rule is judged over this much time, not one frame. Over one frame, as in Borderlands 4, it depended on
// the frame rate: at 10 ms a frame it needed 38 m/s, so V stayed pressed into walls, and a hitch let go of V still
// flying freely (in game, three such let-gos out of five).
public func ApexGrappleStretchTime() -> Float {
  return 0.1;
}

// Below this asked over a stretch, V is nearly still and the comparison means nothing.
public func ApexGrappleBlockedFloor() -> Float {
  return 0.4;
}

public func ApexGrappleBlockedShare() -> Float {
  return 0.4;
}

// A press shorter than this is a tap: it pulls all the way, even with "Hold to keep pulling" on. Close hooks land
// before a normal tap ends, so the press length decides, not the hook's flight.
public func ApexGrappleTapTime() -> Float {
  return 0.2;
}

// Close shots travel before arriving; long shots keep the arrival distance set.
public func ApexGrappleArrivalForShot(near: Float, startingGap: Float) -> Float {
  return MinF(near, startingGap * ApexGrappleShortArrivalShare());
}

public func ApexGrappleArrived(gap: Float, near: Float, stride: Float) -> Bool {
  return gap <= MaxF(near, stride * ApexGrappleStrideShare());
}

public func ApexGrapplePassedBy(cameToward: Bool, past: Float, letGoPast: Float) -> Bool {
  return cameToward && past >= letGoPast;
}

// A limit of zero is no limit: swinging round an anchor takes far longer than flying at it.
public func ApexGrappleOutOfTime(held: Float, longest: Float) -> Bool {
  return longest > 0.0 && held >= longest;
}

// `asked` and `went`: the distance the pull asked for over a stretch, and the one V's speed in the game gave. The
// game's speed, not V's stride: pressed into a wall it drops at once (in game, 2.3 m/s for 18.7 asked), while a
// hitch leaves it whole and only the stride falls short.
public func ApexGrappleBlocked(asked: Float, went: Float) -> Bool {
  return asked > ApexGrappleBlockedFloor() && went < asked * ApexGrappleBlockedShare();
}

public func ApexGrappleTakingOff(held: Float, grace: Float) -> Bool {
  return held < grace;
}

// "Hold to keep pulling": the key is up and its last press was not a tap. A grapple fired by a hold pulls all the way:
// letting go of a held key to start the pull would otherwise end it at once.
public func ApexGrappleLetGoByKey(keepPulling: Bool, byHold: Bool, keyDown: Bool, pressedFor: Float) -> Bool {
  return keepPulling && !byHold && !keyDown && pressedFor >= ApexGrappleTapTime();
}
