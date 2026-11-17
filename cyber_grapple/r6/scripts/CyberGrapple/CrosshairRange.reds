// Made by fabrique/grapple.py from Apex Grapple's CrosshairRange.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The range indicator (docs/apex-grapple/portee/conception.md): while our crosshair shows with its indicator on, each
// frame of the grapple (Frame.reds, no clock of its own) asks the shot's rule (AimRule.reds) whether a press of
// profile 1's key would fire, and gives the crosshair its out of range colour when it would not. Profile 1 only
// (Kevin, 16 November 2026): until then the colour stayed in range while any profile would fire, and with profile 2 on
// a mouse button it told "in range" while his controller's key did not fire; following the last key pressed was
// refused, since a player would have to fire at random to learn how far the other key reaches. While the grapple is
// out (hook flying, pull, hook on its way back), a press fires no grapple: out of range, without rays (Kevin,
// 10 November 2026, after the audit; seen only with the arm implant set to None, the launcher hides the crosshair
// then). Left out: the places where the grapple is refused (CyberGrappleBlockedHere), or the crosshair would flash red
// at each vault, for a press no one makes. The implant's refusal is kept (CyberGrappleImplantRefusalNow). The
// pieces take a new colour only when it changes (CrosshairPieces.reds). With a menu open (inventory, crafting, map...)
// nothing is judged: the colour waits for the menu to close (A2).

public class CyberGrappleCrosshairRange extends IScriptable {
  // Our crosshair shows and the indicator is on: only then are rays cast. inMenu: a menu is open (Crosshair.reds).
  public let on: Bool;
  public let inMenu: Bool;
  public let system: wref<CyberGrappleSystem>;
  public let frame: wref<inkCanvas>;
  // The pieces a colour may be given to, listed at the first change of colour after each drawing (A15).
  public let pieces: array<wref<inkWidget>>;
  public let piecesListed: Bool;
  // Profile 1's settings, read again at each event of the crosshair and each change of the settings (Crosshair.reds,
  // SettingsCopy.reds).
  public let profile: ref<CyberGrappleSettings>;
  public let inRange: HDRColor;
  public let outOfRange: HDRColor;
  // The colour the pieces have now.
  public let tint: HDRColor;
  // What the log last told and when: the profile that would fire (0: none) and profile 1's reason.
  public let logged: Bool;
  public let loggedProfile: Int32;
  public let loggedReason: Int32;
  public let loggedAt: Float;
  // Lines written this load (CyberGrappleLogUpTo): the crosshair makes this object at each load (Crosshair.reds).
  public let lines: Int32;
}

// At most one line a second: the ASSERT channel writes each line to the file at once (Log.reds), and an aim on an edge
// changes its answer every frame. The next line always tells the state reached.
public func CyberGrappleCrosshairRangeLogGap() -> Float {
  return 1.0;
}

// Lines a load: Kevin's trial of 10 November 2026 wrote 115 in 7 minutes of play, all needed to read it.
public func CyberGrappleCrosshairRangeMostLines() -> Int32 {
  return 150;
}

// Reasons of the log beside the rule's own (CyberGrappleAimReason).
public func CyberGrappleRangeLauncherRequired() -> Int32 {
  return -1;
}

public func CyberGrappleRangeGrappleOut() -> Int32 {
  return -2;
}

// Where the crosshair is applied while it shows (Crosshair.reds). redrawn: the pieces were just drawn again, in the
// crosshair's colour; a change of the indicator's settings draws them again (CyberGrappleCrosshairSettingsText).
public func CyberGrappleCrosshairRangeStart(range: ref<CyberGrappleCrosshairRange>, frame: ref<inkCanvas>, settings: ref<CyberGrappleCrosshairSettings>, redrawn: Bool) -> Void {
  range.frame = frame;
  range.inRange = CyberGrappleCrosshairTint(settings.color);
  range.outOfRange = CyberGrappleCrosshairTint(settings.outOfRangeColor);
  if redrawn {
    range.tint = range.inRange;
    ArrayClear(range.pieces);
    range.piecesListed = false;
  }
  if !range.on {
    range.logged = false;
  }
  // The same colour both ways would show nothing: no rays for it.
  range.on = settings.rangeIndicator && !CyberGrappleSameColor(range.inRange, range.outOfRange);
  if range.on {
    CyberGrappleCrosshairRangeProfile(range);
  }
}

public func CyberGrappleCrosshairRangeStop(range: ref<CyberGrappleCrosshairRange>) -> Void {
  range.on = false;
}

public func CyberGrappleCrosshairRangeProfile(range: ref<CyberGrappleCrosshairRange>) -> Void {
  range.profile = null;
  let system: ref<CyberGrappleSystem> = range.system;
  if IsDefined(system) {
    range.profile = CyberGrappleProfileSettings(system, 1);
  }
}

// Each frame of the grapple (Frame.reds): profile 1 judged on the rays cast as far as its range.
public func CyberGrappleCrosshairRangeFrame(system: ref<CyberGrappleSystem>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let range: ref<CyberGrappleCrosshairRange> = system.crosshairRange;
  if !IsDefined(range) || !range.on || range.inMenu {
    return;
  }
  if system.phase != CyberGrappleIdle() || CyberGrappleHookStillOut(system) {
    CyberGrappleCrosshairRangeLog(range, 0, CyberGrappleRangeGrappleOut(), now);
    CyberGrappleCrosshairTintTo(range, range.outOfRange);
    return;
  }
  // Not read yet: no colour that could tell "in range" for a key not judged.
  let settings: ref<CyberGrappleSettings> = range.profile;
  if !IsDefined(settings) {
    CyberGrappleCrosshairTintTo(range, range.outOfRange);
    return;
  }
  if IsDefined(system.cost) {
    system.cost.indicatorFrames = system.cost.indicatorFrames + 1;
  }
  let sight: CyberGrappleSight;
  if system.sightKeptIn == system.frames && system.sightKeptLength == settings.range {
    sight = system.sightKept;
  } else {
    sight = CyberGrappleLookFor(system, scriptInterface, settings.range);
  }
  let fires: Bool = false;
  // Why it would not fire, for the log: the implant refuses the shot (Implant.reds).
  let reason: Int32 = CyberGrappleRangeLauncherRequired();
  if StrLen(CyberGrappleImplantRefusalNow(system, now, scriptInterface.executionOwner)) == 0 {
    let verdict: CyberGrappleVerdict = CyberGrappleVerdictOf(sight, settings);
    fires = verdict.fires;
    reason = EnumInt(verdict.reason);
  }
  CyberGrappleCrosshairRangeLog(range, fires ? 1 : 0, fires ? 0 : reason, now);
  CyberGrappleCrosshairTintTo(range, fires ? range.inRange : range.outOfRange);
}

public func CyberGrappleCrosshairTintTo(range: ref<CyberGrappleCrosshairRange>, color: HDRColor) -> Void {
  if CyberGrappleSameColor(color, range.tint) {
    return;
  }
  let frame: ref<inkCanvas> = range.frame;
  if IsDefined(frame) {
    if !range.piecesListed {
      CyberGrappleCrosshairListPieces(range, frame);
      range.piecesListed = true;
    }
    CyberGrappleCrosshairRecolor(range, range.tint, color);
  }
  range.tint = color;
}

public func CyberGrappleCrosshairRangeLog(range: ref<CyberGrappleCrosshairRange>, profile: Int32, reason: Int32, now: Float) -> Void {
  if range.logged && profile == range.loggedProfile && reason == range.loggedReason {
    return;
  }
  if range.logged && now - range.loggedAt < CyberGrappleCrosshairRangeLogGap() {
    return;
  }
  range.logged = true;
  range.loggedProfile = profile;
  range.loggedReason = reason;
  range.loggedAt = now;
  if range.lines > CyberGrappleCrosshairRangeMostLines() {
    return;
  }
  let text: String;
  if profile > 0 {
    text = "range indicator: in range, profile " + ToString(profile) + " would fire";
  } else {
    if reason == CyberGrappleRangeGrappleOut() {
      text = "range indicator: out of range, the grapple is still out";
    } else {
      let why: String = reason == CyberGrappleRangeLauncherRequired() ? "the implant refuses the shot (not worn, not in the Combat Gadget quickslot, or no charge left)" : NameToString(EnumValueToName(n"CyberGrappleAimReason", Cast<Int64>(reason)));
      text = "range indicator: out of range, profile 1: " + why;
    }
  }
  range.lines = CyberGrappleLogUpTo(range.lines, CyberGrappleCrosshairRangeMostLines(), "range indicator", text);
}
