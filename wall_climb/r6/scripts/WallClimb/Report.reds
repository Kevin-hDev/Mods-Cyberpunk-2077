// What one climb does, in the log: its start with the settings, a few lines on the wall in its first second, the
// corners, stops and ledges, the end, the landing. A jump with forward held that writes no line at all found no wall
// within reach (Wall.reds).

// A line that repeats (a refusal, a ledge in reach) is written at most this often, in seconds.
public func WallClimbReportGap() -> Float {
  return 0.5;
}

// On the wall, a line this often during the first second of each climb: enough to read the climb's speed against the
// game's, without a line every quarter second of a long climb (63% of the mod's lines on 31 October 2026).
public func WallClimbClimbingReportGap() -> Float {
  return 0.25;
}

public func WallClimbClimbingReportSpan() -> Float {
  return 1.0;
}

// True when this kind of refusal was not written yet since V left the ground or last caught a wall, so a refusal that
// lasts writes once. At most one entry per kind, and there are five (Start.reds, Regrab.reds).
public func WallClimbRefusalIsNew(system: ref<WallClimbSystem>, kind: CName) -> Bool {
  if ArrayContains(system.refusalsLogged, kind) {
    return false;
  }
  ArrayPush(system.refusalsLogged, kind);
  return true;
}

public func WallClimbReportClimbing(climb: ref<WallClimbClimb>, scriptInterface: ref<StateGameScriptInterface>, state: CName, now: Float, feet: Vector4, stick: Vector4) -> Void {
  if now < climb.nextReport || now - climb.startedAt > WallClimbClimbingReportSpan() {
    return;
  }
  climb.nextReport = now + WallClimbClimbingReportGap();
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  let right: Vector4 = WallClimbAlongWall(climb.normal);
  WallClimbLog("on the wall at " + ToString(now - climb.startedAt) + " s in " + NameToString(state) + ": " + ToString(feet.Z - climb.startPosition.Z) + " m up, " + ToString(Vector4.Dot(feet - climb.startPosition, right)) + " m along, " + ToString(Vector4.Dot(feet - climb.wallPoint, climb.normal)) + " m from the wall; up speed " + ToString(velocity.Z) + " for " + ToString(climb.up) + " (" + ToString(climb.upLag) + " added for gravity), along " + ToString(Vector4.Dot(velocity, right)) + " for " + ToString(climb.side) + "; stick " + ToString(stick.X) + ", " + ToString(stick.Y) + "; facing the wall at " + ToString(WallClimbFacing(climb, scriptInterface)) + " deg" + (climb.rounding ? ", round a corner" : "") + "; hands " + ToString(ArraySize(climb.hands)) + ", weapon in hand " + ToString(IsDefined(ShootTransition.GetRightWeapon(scriptInterface)) || IsDefined(ShootTransition.GetLeftWeapon(scriptInterface))));
}

// All the settings on the climb's start line: a setting not written there could not be checked in the log.
public func WallClimbSettingsText(settings: ref<WallClimbSettings>) -> String {
  return "highest climb " + ToString(settings.maxHeight) + " m, climbing speed x" + ToString(settings.climbSpeed) + ", hold on " + ToString(settings.holdOn) + ", grab again " + ToString(settings.regrab) + ", ladder camera " + ToString(settings.ladderCamera) + ", no fall damage " + ToString(settings.softLanding) + ", fall effect " + ToString(settings.fallEffect);
}

public func WallClimbEndText(climb: ref<WallClimbClimb>) -> String {
  let right: Vector4 = WallClimbAlongWall(climb.normal);
  let climbed: Float = climb.endPosition.Z - climb.startPosition.Z;
  let time: Float = climb.endedAt - climb.startedAt;
  let hands: String = climb.handsPlaced ? ToString(climb.handSwaps) + " hand swaps, the first " + ToString(climb.firstHandsAt - climb.startedAt) + " s in" : "no hands on the wall";
  return "climb from " + NameToString(climb.fromState) + " ended, " + climb.endReason + ": " + ToString(climbed) + " m up and " + ToString(Vector4.Dot(climb.endPosition - climb.startPosition, right)) + " m along in " + ToString(time) + " s, " + ToString(climb.stops) + " stops and " + ToString(climb.resumes) + " restarts, " + ToString(climb.corners) + " corners, " + ToString(climb.overhangs) + " overhangs, " + hands;
}

public func WallClimbLandingText(climb: ref<WallClimbClimb>, state: CName, now: Float, feet: Vector4, impact: Float) -> String {
  return "landed in " + NameToString(state) + " " + ToString(now - climb.endedAt) + " s after leaving the wall, " + ToString(climb.endPosition.Z - feet.Z) + " m below where V left it, landing speed " + ToString(AbsF(impact)) + " m/s, hardest landing turned into a regular one " + ToString(climb.landingRewritten) + ", game ladders passed by " + ToString(climb.laddersPassed) + " frames, fall effect held back " + ToString(climb.fallEffectsHeldBack) + " times";
}
