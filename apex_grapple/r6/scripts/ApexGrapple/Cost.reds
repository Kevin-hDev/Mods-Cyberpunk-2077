// What the mod did over each minute of game time, one line in the log (optimisation.md, section 9.2; Kevin's decision f
// of the audit of 10 November 2026): the grapple's frames a second, the frames the range indicator judged, the rays
// cast for the aim and for the rope, and the frames with the launcher lent. Counts only: the time an engine call takes
// cannot be read from a script. With its own bound per load, apart from the other lines (section 9.1).

public class ApexGrappleCost extends IScriptable {
  public let since: Float;
  public let frames: Int32;
  public let indicatorFrames: Int32;
  public let aimRays: Int32;
  public let ropeRays: Int32;
  public let loanFrames: Int32;
  public let lines: Int32;
}

public func ApexGrappleCostEvery() -> Float {
  return 60.0;
}

// Ten hours of play in one load.
public func ApexGrappleCostMostLines() -> Int32 {
  return 600;
}

// The rays of one look along the view (Aim.reds, ApexGrappleLook).
public func ApexGrappleLookRays() -> Int32 {
  return 6;
}

public func ApexGrappleCostOf(system: ref<ApexGrappleSystem>, now: Float) -> ref<ApexGrappleCost> {
  if !IsDefined(system.cost) {
    system.cost = new ApexGrappleCost();
    system.cost.since = now;
  }
  return system.cost;
}

// Each frame of the grapple (Frame.reds), before anything else.
public func ApexGrappleCostFrame(system: ref<ApexGrappleSystem>, now: Float) -> Void {
  let cost: ref<ApexGrappleCost> = ApexGrappleCostOf(system, now);
  let spent: Float = now - cost.since;
  if spent >= ApexGrappleCostEvery() {
    if cost.lines <= ApexGrappleCostMostLines() {
      cost.lines = ApexGrappleLogUpTo(cost.lines, ApexGrappleCostMostLines(), "cost", "cost over the last " + ToString(spent) + " s: " + ToString(Cast<Float>(cost.frames) / spent) + " grapple frames a second, range indicator judged " + ToString(cost.indicatorFrames) + " frames, rays cast " + ToString(cost.aimRays) + " for the aim and " + ToString(cost.ropeRays) + " for the rope, launcher lent " + ToString(cost.loanFrames) + " frames");
    }
    cost.since = now;
    cost.frames = 0;
    cost.indicatorFrames = 0;
    cost.aimRays = 0;
    cost.ropeRays = 0;
    cost.loanFrames = 0;
  }
  cost.frames = cost.frames + 1;
  if ApexGrappleLauncherOut(system) {
    cost.loanFrames = cost.loanFrames + 1;
  }
}
