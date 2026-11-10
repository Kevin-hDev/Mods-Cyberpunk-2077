// The range indicator (docs/apex-grapple/portee/conception.md): while our crosshair shows with its indicator on, each
// frame of the grapple (Frame.reds, no clock of its own) asks the shot's rule (AimRule.reds) whether a press would
// fire, for each profile that can fire, profile 1 first, and gives the crosshair its out of range colour when none
// would. The rays are cast once, as far as the longest of those profiles' ranges. While the grapple is out (hook
// flying, pull, hook on its way back), a press fires no grapple: out of range, without rays (Kevin, 10 November 2026,
// after the audit; seen only with the arm implant set to None, the launcher hides the crosshair then). Left out: the
// places where the grapple is refused (ApexGrappleBlockedHere), or the crosshair would flash red at each vault, for a
// press no one makes. The launcher a profile asks for is kept (ApexGrappleImplantRefusal). The pieces take a new
// colour only when it changes (CrosshairPieces.reds).

public class ApexGrappleCrosshairRange extends IScriptable {
  // Our crosshair shows and the indicator is on: only then are rays cast.
  public let on: Bool;
  public let frame: wref<inkCanvas>;
  // The profiles that can fire and their numbers, read again at each event of the crosshair and each change of the
  // settings (Crosshair.reds, CrosshairWatch.reds), and the longest of their ranges.
  public let profiles: array<ref<ApexGrappleSettings>>;
  public let numbers: array<Int32>;
  public let longest: Float;
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
  }
  if !range.on {
    range.logged = false;
  }
  // The same colour both ways would show nothing: no rays for it.
  range.on = settings.rangeIndicator && !ApexGrappleSameColor(range.inRange, range.outOfRange);
  if range.on {
    ApexGrappleCrosshairRangeProfiles(range);
  }
}

public func ApexGrappleCrosshairRangeStop(range: ref<ApexGrappleCrosshairRange>) -> Void {
  range.on = false;
}

// Profile 1 always; the others while on and given a key (ApexGrappleOwnKeys gives none otherwise) that no lower profile
// has, since the lowest fires (ApexGrappleFirstWithKey), and only while own keys are heard (Codeware).
public func ApexGrappleCrosshairRangeProfiles(range: ref<ApexGrappleCrosshairRange>) -> Void {
  ArrayClear(range.profiles);
  ArrayClear(range.numbers);
  range.longest = 0.0;
  let base: ref<ApexGrappleSettings> = new ApexGrappleSettings();
  let keys: array<EInputKey> = ApexGrappleOwnKeys();
  let heard: Bool = ApexGrappleOwnKeysHeard();
  let p: Int32 = 1;
  while p <= ApexGrappleProfileCount() {
    if p == 1 || (heard && NotEquals(keys[p - 1], EInputKey.IK_None) && ApexGrappleFirstWithKey(keys, p - 1)) {
      let settings: ref<ApexGrappleSettings> = ApexGrappleSettingsOf(p, base);
      ArrayPush(range.profiles, settings);
      ArrayPush(range.numbers, p);
      range.longest = MaxF(range.longest, settings.range);
    }
    p += 1;
  }
}

// Each frame of the grapple (Frame.reds): the profiles are judged in order until one would fire.
public func ApexGrappleCrosshairRangeFrame(system: ref<ApexGrappleSystem>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let range: ref<ApexGrappleCrosshairRange> = system.crosshairRange;
  if !IsDefined(range) || !range.on {
    return;
  }
  if system.phase != ApexGrappleIdle() || ApexGrappleHookStillOut(system) {
    ApexGrappleCrosshairRangeLog(range, 0, ApexGrappleRangeGrappleOut(), now);
    ApexGrappleCrosshairTintTo(range, range.outOfRange);
    return;
  }
  let sight: ApexGrappleSight = ApexGrappleLook(scriptInterface, range.longest);
  let player: ref<GameObject> = scriptInterface.executionOwner;
  let firing: Int32 = 0;
  // Profile 1's reason when none would fire, for the log; it may ask for the launcher while V has none.
  let reason: Int32 = ApexGrappleRangeLauncherRequired();
  let i: Int32 = 0;
  while i < ArraySize(range.profiles) && firing == 0 {
    let settings: ref<ApexGrappleSettings> = range.profiles[i];
    if StrLen(ApexGrappleImplantRefusal(settings, player)) == 0 {
      let verdict: ApexGrappleVerdict = ApexGrappleVerdictOf(sight, settings);
      if verdict.fires {
        firing = range.numbers[i];
      } else {
        if i == 0 {
          reason = EnumInt(verdict.reason);
        }
      }
    }
    i += 1;
  }
  ApexGrappleCrosshairRangeLog(range, firing, firing > 0 ? 0 : reason, now);
  ApexGrappleCrosshairTintTo(range, firing > 0 ? range.inRange : range.outOfRange);
}

public func ApexGrappleCrosshairTintTo(range: ref<ApexGrappleCrosshairRange>, color: HDRColor) -> Void {
  if ApexGrappleSameColor(color, range.tint) {
    return;
  }
  let frame: ref<inkCanvas> = range.frame;
  if IsDefined(frame) {
    ApexGrappleCrosshairRecolor(frame, range.tint, color);
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
