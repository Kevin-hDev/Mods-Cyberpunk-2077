// V's voice lines (Kevin, 18 November 2026): Get over here as a person really starts coming to V, and one of the
// execution lines when V kills or knocks out the person the grapple brought and grabbed (the knock-out added by Kevin,
// 19 November 2026). Audioware plays them, from the manifest of r6/audioware/CyberGrapple (voices.yml); VoicePlay.reds
// alone reaches it. Asked from the start of a person's pull (CyberGrappleAttach in Shot.reds, a line patched in by
// fabrique/grapple_spec.py) and from the game's execution (VoiceKill.reds): once each, nothing here runs each frame.
// How often each occasion has its line, how the execution lines are said, and in which voice, are the player's choices
// in the menu (MENU_ADDED in fabrique/grapple_spec.py). The lines themselves, and what each says, are in
// VoiceTable.reds; the voice, the menu's or V's own, is decided in VoiceGender.reds.

// How V says the execution lines. The menu's list is made from this enum (fabrique/grapple_settings.py), and Mod
// Settings keeps the player's choice under a member's name: a member is never renamed.
enum CyberGrappleVoiceKillStyle {
  Normal = 0,
  Whisper = 1,
  Both = 2
}

public func CyberGrappleVoiceMostLines() -> Int32 {
  return 30;
}

// One of the takes of Get over here in V's voice, never the same twice in a row (Kevin, 19 November 2026).
public func CyberGrappleVoicePullLine(last: CName, female: Bool) -> CName {
  let table: array<CyberGrappleVoiceLine> = CyberGrappleVoiceTable();
  let lines: array<CName> = CyberGrappleVoiceLinesOf(table, CyberGrappleVoicePhrase.GetOverHere, female, true, false);
  return CyberGrappleVoiceOtherThan(lines, last);
}

// The occasions in a bag. Kevin, 18 November 2026: at 50 %, six executions out of seven without a line, each drawn
// apart, read as a fault. The chance of the slider now comes true over every series of this many occasions.
public func CyberGrappleVoiceBagSize() -> Int32 {
  return 10;
}

// Whether V speaks at this occasion, from the bag of its kind kept on the system: a pull's (pull), else an
// execution's. The bag holds a series of occasions and, among them, the lines the slider asks, said in an order left to
// the draw. It is filled again once empty, and when the slider no longer gives the chance it was filled for: at the
// first occasion of a load, whose fields are at nothing, and after the player moved the slider. The chance over the
// percent one occasion stands for, 10 for a bag of ten, gives the lines in the bag.
public func CyberGrappleVoiceBagDraw(system: ref<CyberGrappleSystem>, occasion: String, pull: Bool, chance: Float) -> Bool {
  let left: Int32 = pull ? system.voicePullLeft : system.voiceKillLeft;
  let says: Int32 = pull ? system.voicePullSays : system.voiceKillSays;
  let filledFor: Float = pull ? system.voicePullFor : system.voiceKillFor;
  if left <= 0 || filledFor != chance {
    let size: Int32 = CyberGrappleVoiceBagSize();
    left = size;
    says = Clamp(RoundF(chance / (100.0 / Cast<Float>(size))), 0, size);
    filledFor = chance;
  }
  let speaks: Bool = RandRange(0, left) < says;
  left -= 1;
  if speaks {
    says -= 1;
  }
  if pull {
    system.voicePullLeft = left;
    system.voicePullSays = says;
    system.voicePullFor = filledFor;
  } else {
    system.voiceKillLeft = left;
    system.voiceKillSays = says;
    system.voiceKillFor = filledFor;
  }
  if !speaks {
    CyberGrappleVoiceMissed(system, occasion, says, left, filledFor);
  }
  return speaks;
}

public func CyberGrappleVoiceOn(settings: ref<CyberGrappleSettings>) -> Bool {
  return settings.enabled && settings.voiceLines;
}

// Switched off, nothing more is read nor told: the player chose it. Audioware missing, a pull of a person no longer
// active, or the bag gave no line, the line is left out and the log says why, what the trial needs to tell a silence
// from a fault. The bag last, so that an occasion where no line could be said takes nothing from it (VoiceKill.reds
// keeps the game's other actions and another grab away).
// Kevin, 19 November 2026, "oui il se tait sur les cadavres": no Get over here to a person pulled who is dead, down,
// knocked out or an android switched off, as ScriptedPuppet.IsActive tells (scriptedPuppet.script:1524-1530), read
// once the pull has started (Shot.reds). An execution passes no person: the person the game's grab holds has the
// execution's line, androids included (Kevin, same day).
public func CyberGrappleVoiceLeftOut(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, occasion: String, pull: Bool, person: ref<GameObject>) -> Bool {
  if !CyberGrappleVoiceOn(settings) {
    return true;
  }
  if !CyberGrappleVoiceThere() {
    CyberGrappleVoiceNone(system, occasion, "Audioware is not installed");
    return true;
  }
  if pull && !ScriptedPuppet.IsActive(person) {
    CyberGrappleVoiceDead(system, occasion);
    return true;
  }
  let chance: Float = pull ? settings.voicePullChance : settings.voiceKillChance;
  if !CyberGrappleVoiceBagDraw(system, occasion, pull, chance) {
    return true;
  }
  return false;
}

// person: the one the pull brings (CyberGrappleAttach in Shot.reds).
public func CyberGrappleVoicePull(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, player: ref<GameObject>, person: ref<GameObject>) -> Void {
  if CyberGrappleVoiceLeftOut(system, settings, "a pull", true, person) {
    return;
  }
  let line: CName = CyberGrappleVoicePullLine(system.voicePullLast, CyberGrappleVoiceFemaleOf(settings.voiceGender, player));
  system.voicePullLast = line;
  CyberGrappleVoiceAsk(system, player, line, "a pull");
}

// How the log names an execution's occasion, a knock-out apart from a kill, in the words of every line about it.
public func CyberGrappleVoiceOccasion(knockOut: Bool) -> String {
  return knockOut ? "a knock-out" : "an execution";
}

// A knock-out is an execution's occasion like a kill, from the same slider and bag (Kevin, 19 November 2026); the log
// names it apart so that a trial tells the two.
public func CyberGrappleVoiceKill(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, player: ref<GameObject>, knockOut: Bool) -> Void {
  let occasion: String = CyberGrappleVoiceOccasion(knockOut);
  if CyberGrappleVoiceLeftOut(system, settings, occasion, false, null) {
    return;
  }
  let line: CName = CyberGrappleVoiceKillLine(system.voiceLast, settings.voiceKillStyle, CyberGrappleVoiceFemaleOf(settings.voiceGender, player), knockOut);
  system.voiceLast = line;
  CyberGrappleVoiceAsk(system, player, line, occasion);
}

// Kevin, 19 November 2026, with his new tones: the phrase first, the other one than the last line's whenever V has it
// in the style, so that the two take turns, either at the first line of a load; then the tone among that phrase's takes,
// another than the last one said whenever there is one. On a knock-out the person lives: Your soul is weak alone,
// never Your death will be swift (Kevin, 19 November 2026). The style picks the takes: Normal the spoken ones, Whisper
// the whispered ones, Normal + Whisper both; a style this function does not know gives both, the menu's default.
public func CyberGrappleVoiceKillLine(last: CName, style: CyberGrappleVoiceKillStyle, female: Bool, knockOut: Bool) -> CName {
  let table: array<CyberGrappleVoiceLine> = CyberGrappleVoiceTable();
  let spoken: Bool = NotEquals(style, CyberGrappleVoiceKillStyle.Whisper);
  let whispered: Bool = NotEquals(style, CyberGrappleVoiceKillStyle.Normal);
  let soul: array<CName> = CyberGrappleVoiceLinesOf(table, CyberGrappleVoicePhrase.Soul, female, spoken, whispered);
  let death: array<CName>;
  if !knockOut {
    death = CyberGrappleVoiceLinesOf(table, CyberGrappleVoicePhrase.Death, female, spoken, whispered);
  }
  let saidSoul: Bool = CyberGrappleVoiceSays(table, last, CyberGrappleVoicePhrase.Soul);
  let saidDeath: Bool = CyberGrappleVoiceSays(table, last, CyberGrappleVoicePhrase.Death);
  let deathNow: Bool = saidSoul || (!saidDeath && RandRange(0, 2) == 0) || ArraySize(soul) == 0;
  if ArraySize(death) > 0 && deathNow {
    return CyberGrappleVoiceOtherThan(death, last);
  }
  return CyberGrappleVoiceOtherThan(soul, last);
}

// One of the lines other than the last one said, each as likely; the last one again only if no other is left.
public func CyberGrappleVoiceOtherThan(lines: array<CName>, last: CName) -> CName {
  let others: array<CName>;
  for line in lines {
    if NotEquals(line, last) {
      ArrayPush(others, line);
    }
  }
  if ArraySize(others) == 0 {
    return last;
  }
  return others[RandRange(0, ArraySize(others))];
}

// The line is told before Audioware is asked, so a fault while it plays leaves the line in the log. Whether it was
// heard is in Audioware's own log.
public func CyberGrappleVoiceAsk(system: ref<CyberGrappleSystem>, player: ref<GameObject>, line: CName, occasion: String) -> Void {
  if system.voiceLines <= CyberGrappleVoiceMostLines() {
    system.voiceLines = CyberGrappleLogUpTo(system.voiceLines, CyberGrappleVoiceMostLines(), "voice lines", "voice line " + NameToString(line) + " asked of Audioware for " + occasion);
  }
  CyberGrappleVoicePlay(player, line);
}

public func CyberGrappleVoiceNone(system: ref<CyberGrappleSystem>, occasion: String, why: String) -> Void {
  if system.voiceNoneLines <= CyberGrappleVoiceMostLines() {
    system.voiceNoneLines = CyberGrappleLogUpTo(system.voiceNoneLines, CyberGrappleVoiceMostLines(), "voice lines left out", "voice line for " + occasion + ": none, " + why);
  }
}

// A person dead or out is told under a bound of its own: pulling bodies to hide them is a normal move of the game, and
// it must not use up the lines that tell the other reasons (review of 19 November 2026).
public func CyberGrappleVoiceDead(system: ref<CyberGrappleSystem>, occasion: String) -> Void {
  if system.voiceDeadLines <= CyberGrappleVoiceMostLines() {
    system.voiceDeadLines = CyberGrappleLogUpTo(system.voiceDeadLines, CyberGrappleVoiceMostLines(), "voice lines left out on the dead", "voice line for " + occasion + ": none, the person is dead or out");
  }
}

// An execution left to Execution Lines (VoiceKill.reds) is told under a bound of its own: with it installed this
// silence comes at each execution, and it must not use up the lines that tell the other reasons.
public func CyberGrappleVoiceHandedOver(system: ref<CyberGrappleSystem>, occasion: String) -> Void {
  if system.voiceHandedLines <= CyberGrappleVoiceMostLines() {
    system.voiceHandedLines = CyberGrappleLogUpTo(system.voiceHandedLines, CyberGrappleVoiceMostLines(), "voice lines left to Execution Lines", "voice line for " + occasion + ": none, Execution Lines says it");
  }
}

// A draw missed is the player's chance at work, not a fault: under a bound of its own, since at the menu's default it
// comes once in two occasions and would use up the lines that tell the other reasons. Where the bag stands after the
// draw tells a trial whether the series keeps its count.
public func CyberGrappleVoiceMissed(system: ref<CyberGrappleSystem>, occasion: String, says: Int32, left: Int32, chance: Float) -> Void {
  if system.voiceMissLines <= CyberGrappleVoiceMostLines() {
    system.voiceMissLines = CyberGrappleLogUpTo(system.voiceMissLines, CyberGrappleVoiceMostLines(), "voice draws missed", "voice line for " + occasion + ": none, the draw missed, " + ToString(says) + " lines left in " + ToString(left) + " occasions of the bag filled for " + FloatToStringPrec(chance, 0) + " %");
  }
}
