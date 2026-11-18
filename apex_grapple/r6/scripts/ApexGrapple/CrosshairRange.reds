// The range indicator (docs/apex-grapple/portee/conception.md): while our crosshair shows with its indicator on, each
// frame of the grapple (Frame.reds, no clock of its own) asks the shot's rule (AimRule.reds) whether a press of
// profile 1's key would fire, and gives the crosshair its out of range colour when it would not. Profile 1 only
// (Kevin, 16 November 2026): until then the colour stayed in range while any profile would fire, and with profile 2 on
// a mouse button it told "in range" while his controller's key did not fire; following the last key pressed was
// refused, since a player would have to fire at random to learn how far the other key reaches. While the grapple is
// out (hook flying, pull, hook on its way back), a press fires no grapple: out of range, without rays (Kevin,
// 10 November 2026, after the audit; seen only with the arm implant set to None, the launcher hides the crosshair
// then). Left out: the places where the grapple is refused (ApexGrappleBlockedHere), or the crosshair would flash red
// at each vault, for a press no one makes. The launcher profile 1 may ask for is kept (ApexGrappleImplantRefusal). The
// pieces take a new colour only when it changes (CrosshairPieces.reds). With a menu open (inventory, crafting, map...)
// nothing is judged: the colour waits for the menu to close (A2).

public class ApexGrappleCrosshairRange extends IScriptable {
  // Our crosshair shows and the indicator is on: only then are rays cast. inMenu: a menu is open (Crosshair.reds).
  public let on: Bool;
  public let inMenu: Bool;
  public let system: wref<ApexGrappleSystem>;
  public let frame: wref<inkCanvas>;
  // The pieces a colour may be given to, listed at the first change of colour after each drawing (A15).
  public let pieces: array<wref<inkWidget>>;
  public let piecesListed: Bool;
  // Profile 1's settings, read again at each event of the crosshair and each change of the settings (Crosshair.reds,
  // SettingsCopy.reds).
  public let profile: ref<ApexGrappleSettings>;
  public let inRange: HDRColor;
  public let outOfRange: HDRColor;
  // The colour the pieces have now.
  public let tint: HDRColor;
  // What the log last told and when: the profile that would fire (0: none) and profile 1's reason.
  public let logged: Bool;
  public let loggedProfile: Int32;
  public let loggedReason: Int32;
  public let loggedAt: Float;
  // Lines written this load (ApexGrappleLogUpTo): the crosshair makes this object at each load (Crosshair.reds).
  public let lines: Int32;
}

// At most one line a second: the ASSERT channel writes each line to the file at once (Log.reds), and an aim on an edge
// changes its answer every frame. The next line always tells the state reached.
public func ApexGrappleCrosshairRangeLogGap() -> Float {
  return 1.0;
}

// Lines a load: Kevin's trial of 10 November 2026 wrote 115 in 7 minutes of play, all needed to read it.
public func ApexGrappleCrosshairRangeMostLines() -> Int32 {
  return 150;
}

// Reasons of the log beside the rule's own (ApexGrappleAimReason).
public func ApexGrappleRangeLauncherRequired() -> Int32 {
  return -1;
}

public func ApexGrappleRangeGrappleOut() -> Int32 {
  return -2;
}

// Where the crosshair is applied while it shows (Crosshair.reds). redrawn: the pieces were just drawn again, in the
// crosshair's colour; a change of the indicator's settings draws them again (ApexGrappleCrosshairSettingsText).
public func ApexGrappleCrosshairRangeStart(range: ref<ApexGrappleCrosshairRange>, frame: ref<inkCanvas>, settings: ref<ApexGrappleCrosshairSettings>, redrawn: Bool) -> Void {
  range.frame = frame;
  range.inRange = ApexGrappleCrosshairTint(settings.color);
  range.outOfRange = ApexGrappleCrosshairTint(settings.outOfRangeColor);
  if redrawn {
    range.tint = range.inRange;
    ArrayClear(range.pieces);
    range.piecesListed = false;
  }
  if !range.on {
    range.logged = false;
  }
  // The same colour both ways would show nothing: no rays for it.
  range.on = settings.rangeIndicator && !ApexGrappleSameColor(range.inRange, range.outOfRange);
  if range.on {
    ApexGrappleCrosshairRangeProfile(range);
  }
}

public func ApexGrappleCrosshairRangeStop(range: ref<ApexGrappleCrosshairRange>) -> Void {
  range.on = false;
}

public func ApexGrappleCrosshairRangeProfile(range: ref<ApexGrappleCrosshairRange>) -> Void {
  range.profile = null;
  let system: ref<ApexGrappleSystem> = range.system;
  if IsDefined(system) {
    range.profile = ApexGrappleProfileSettings(system, 1);
  }
}

// Each frame of the grapple (Frame.reds): profile 1 judged on the rays cast as far as its range.
public func ApexGrappleCrosshairRangeFrame(system: ref<ApexGrappleSystem>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let range: ref<ApexGrappleCrosshairRange> = system.crosshairRange;
  if !IsDefined(range) || !range.on || range.inMenu {
    return;
  }
  if system.phase != ApexGrappleIdle() || ApexGrappleHookStillOut(system) {
    ApexGrappleCrosshairRangeLog(range, 0, ApexGrappleRangeGrappleOut(), now);
    ApexGrappleCrosshairTintTo(range, range.outOfRange);
    return;
  }
  // Not read yet: no colour that could tell "in range" for a key not judged.
  let settings: ref<ApexGrappleSettings> = range.profile;
  if !IsDefined(settings) {
    ApexGrappleCrosshairTintTo(range, range.outOfRange);
    return;
  }
  if IsDefined(system.cost) {
    system.cost.indicatorFrames = system.cost.indicatorFrames + 1;
  }
  let sight: ApexGrappleSight;
  if system.sightKeptIn == system.frames && system.sightKeptLength == settings.range {
    sight = system.sightKept;
  } else {
    sight = ApexGrappleLookFor(system, scriptInterface, settings.range);
  }
  let fires: Bool = false;
  // Why it would not fire, for the log: profile 1 may ask for the launcher while V has none.
  let reason: Int32 = ApexGrappleRangeLauncherRequired();
  if !settings.requireLauncher || ApexGrappleHasLauncher(scriptInterface.executionOwner) {
    let verdict: ApexGrappleVerdict = ApexGrappleVerdictOf(sight, settings);
    fires = verdict.fires;
    reason = EnumInt(verdict.reason);
  }
  ApexGrappleCrosshairRangeLog(range, fires ? 1 : 0, fires ? 0 : reason, now);
  ApexGrappleCrosshairTintTo(range, fires ? range.inRange : range.outOfRange);
}

public func ApexGrappleCrosshairTintTo(range: ref<ApexGrappleCrosshairRange>, color: HDRColor) -> Void {
  if ApexGrappleSameColor(color, range.tint) {
    return;
  }
  let frame: ref<inkCanvas> = range.frame;
  if IsDefined(frame) {
    if !range.piecesListed {
      ApexGrappleCrosshairListPieces(range, frame);
      range.piecesListed = true;
    }
    ApexGrappleCrosshairRecolor(range, range.tint, color);
  }
  range.tint = color;
}

public func ApexGrappleCrosshairRangeLog(range: ref<ApexGrappleCrosshairRange>, profile: Int32, reason: Int32, now: Float) -> Void {
  if range.logged && profile == range.loggedProfile && reason == range.loggedReason {
    return;
  }
  if range.logged && now - range.loggedAt < ApexGrappleCrosshairRangeLogGap() {
    return;
  }
  range.logged = true;
  range.loggedProfile = profile;
  range.loggedReason = reason;
  range.loggedAt = now;
  if range.lines > ApexGrappleCrosshairRangeMostLines() {
    return;
  }
  let text: String;
  if profile > 0 {
    text = "range indicator: in range, profile " + ToString(profile) + " would fire";
  } else {
    if reason == ApexGrappleRangeGrappleOut() {
      text = "range indicator: out of range, the grapple is still out";
    } else {
      let why: String = reason == ApexGrappleRangeLauncherRequired() ? "the projectile launcher is required" : NameToString(EnumValueToName(n"ApexGrappleAimReason", Cast<Int64>(reason)));
      text = "range indicator: out of range, profile 1: " + why;
    }
  }
  range.lines = ApexGrappleLogUpTo(range.lines, ApexGrappleCrosshairRangeMostLines(), "range indicator", text);
}
