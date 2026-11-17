// Made by fabrique/grapple.py from Apex Grapple's Cost.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// What the mod did over each minute of game time, one line in the log (optimisation.md, section 9.2; Kevin's decision f
// of the audit of 10 November 2026): the grapple's frames a second, the frames the range indicator judged, the rays
// cast for the aim and for the rope, and the frames with the launcher lent. Counts only: the time an engine call takes
// cannot be read from a script. With its own bound per load, apart from the other lines (section 9.1).

public class CyberGrappleCost extends IScriptable {
  public let since: Float;
  public let frames: Int32;
  public let indicatorFrames: Int32;
  public let aimRays: Int32;
  public let ropeRays: Int32;
  public let loanFrames: Int32;
  public let lines: Int32;
}

public func CyberGrappleCostEvery() -> Float {
  return 60.0;
}

// Ten hours of play in one load.
public func CyberGrappleCostMostLines() -> Int32 {
  return 600;
}

// The rays of one look along the view (Aim.reds, CyberGrappleLook).
public func CyberGrappleLookRays() -> Int32 {
  return 6;
}

public func CyberGrappleCostOf(system: ref<CyberGrappleSystem>, now: Float) -> ref<CyberGrappleCost> {
  if !IsDefined(system.cost) {
    system.cost = new CyberGrappleCost();
    system.cost.since = now;
  }
  return system.cost;
}

// Each frame of the grapple (Frame.reds), before anything else.
public func CyberGrappleCostFrame(system: ref<CyberGrappleSystem>, now: Float) -> Void {
  let cost: ref<CyberGrappleCost> = CyberGrappleCostOf(system, now);
  let spent: Float = now - cost.since;
  if spent >= CyberGrappleCostEvery() {
    if cost.lines <= CyberGrappleCostMostLines() {
      cost.lines = CyberGrappleLogUpTo(cost.lines, CyberGrappleCostMostLines(), "cost", "cost over the last " + ToString(spent) + " s: " + ToString(Cast<Float>(cost.frames) / spent) + " grapple frames a second, range indicator judged " + ToString(cost.indicatorFrames) + " frames, rays cast " + ToString(cost.aimRays) + " for the aim and " + ToString(cost.ropeRays) + " for the rope, launcher lent " + ToString(cost.loanFrames) + " frames");
    }
    cost.since = now;
    cost.frames = 0;
    cost.indicatorFrames = 0;
    cost.aimRays = 0;
    cost.ropeRays = 0;
    cost.loanFrames = 0;
  }
  cost.frames = cost.frames + 1;
  if CyberGrappleLauncherOut(system) {
    cost.loanFrames = cost.loanFrames + 1;
  }
}
