// One climb at a time, from its start to the end of the fall that follows, kept by a game system so that every state
// it goes through (the air states, our ladder, the landing) reads the same one. A new climb gets a new object, so
// nothing carries over from the last one. A system attaches again at each load, so a climb never survives a load.

public class WallClimbSystem extends ScriptableSystem {
  public let climb: ref<WallClimbClimb>;
  // Report.reds: the kinds of refusal written since V left the ground or last caught a wall, one entry per kind.
  public let refusalsLogged: array<CName>;
}

public class WallClimbClimb {
  public let fromState: CName;
  public let startedAt: Float;
  public let startPosition: Vector4;
  public let letGoZ: Float;
  // The wall, renewed at each frame a ray meets it. The normal is flat and points from the wall toward V; the slant
  // is the height of the surface's own normal, above zero when the wall leans back (Push.reds).
  public let normal: Vector4;
  public let slant: Float;
  public let wallPoint: Vector4;
  public let wallSeenAt: Float;
  // Frames in a row without the wall, so that a single long frame does not end the climb (Climb.reds).
  public let framesLost: Int32;
  // Corner.reds and View.reds: round an outside corner the wall is the edge, from one face's normal to the next.
  public let rounding: Bool;
  public let edge: Vector4;
  public let cornerFrom: Vector4;
  public let cornerTo: Vector4;
  public let roundingSince: Float;
  public let viewTurnLeft: Float;
  // Overhang.reds and Step.reds: leaning out under something that juts out above V, or round a step to the side.
  public let overhang: Bool;
  public let overhangPoint: Vector4;
  // Zero above V; the way along the wall to a step.
  public let overhangWay: Vector4;
  public let overhangSince: Float;
  // Climbing, or stopped on the wall with "Hold on when stopping": waiting for our ladder, then on it until the game's
  // grab is over (Hold.reds).
  public let onWall: Bool;
  public let stopping: Bool;
  public let stoppedAt: Float;
  public let grabbed: Bool;
  public let grabEndsAt: Float;
  // The last frame with the stick on the wall, the frames since, and the speeds it asked for, kept through a read that
  // drops.
  public let stickAt: Float;
  public let stickFramesLost: Int32;
  public let up: Float;
  public let side: Float;
  // Push.reds: the speed up asked for at the last push, and what the frames fell short of it.
  public let pushed: Bool;
  public let upAsked: Float;
  public let upLag: Float;
  // Jump.reds: the first jump in the air after the climb is given back, until V lands.
  public let jumpOwed: Bool;
  // Hands.reds and Weapon.reds.
  public let hands: array<ref<IKTargetAddEvent>>;
  public let nextHands: Float;
  public let leftHigh: Bool;
  public let holstered: Bool;
  // Landing.reds and FallEffect.reds, as long as this object: until V has stood a while on the ground (NewState.reds).
  public let landed: Bool;
  public let landedAt: Float;
  public let landingRewritten: Int32;
  public let laddersPassed: Int32;
  public let fallEffectShown: Bool;
  public let fallEffectsHeldBack: Int32;
  // The end of the climb: the report, the regrab wait (Regrab.reds) and the lines of the jumps after it.
  public let endReason: String;
  public let endedAt: Float;
  public let endPosition: Vector4;
  // Report.reds.
  public let nextReport: Float;
  public let stops: Int32;
  public let resumes: Int32;
  public let corners: Int32;
  public let overhangs: Int32;
  public let handSwaps: Int32;
  public let handsPlaced: Bool;
  public let firstHandsAt: Float;
}

public func WallClimbSystemOf(scriptInterface: ref<StateGameScriptInterface>) -> ref<WallClimbSystem> {
  return scriptInterface.GetScriptableSystem(n"WallClimbSystem") as WallClimbSystem;
}

public func WallClimbCurrent(scriptInterface: ref<StateGameScriptInterface>) -> ref<WallClimbClimb> {
  let system: ref<WallClimbSystem> = WallClimbSystemOf(scriptInterface);
  if !IsDefined(system) {
    return null;
  }
  return system.climb;
}

public func WallClimbBegin(state: CName, now: Float, feet: Vector4, wall: WallClimbWall, highest: Float) -> ref<WallClimbClimb> {
  let climb: ref<WallClimbClimb> = new WallClimbClimb();
  climb.fromState = state;
  climb.startedAt = now;
  climb.startPosition = feet;
  climb.letGoZ = feet.Z + highest;
  climb.normal = wall.normal;
  climb.slant = wall.slant;
  climb.wallPoint = wall.face;
  climb.wallSeenAt = now;
  climb.onWall = true;
  climb.stickAt = now;
  climb.jumpOwed = true;
  return climb;
}

// Ends the climb wherever it is: in the air, on our ladder, or at the next state. V's motion is the caller's.
public func WallClimbEnd(climb: ref<WallClimbClimb>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, reason: String) -> Void {
  if !climb.onWall {
    return;
  }
  climb.onWall = false;
  climb.stopping = false;
  climb.grabbed = false;
  climb.endReason = reason;
  climb.endedAt = WallClimbGameTime(scriptInterface.executionOwner.GetGame());
  climb.endPosition = DefaultTransition.GetPlayerPosition(scriptInterface);
  WallClimbWithdraw(stateContext);
  WallClimbRemoveHands(climb, scriptInterface);
  WallClimbRedraw(stateContext, climb);
  WallClimbLog(WallClimbEndText(climb));
}
