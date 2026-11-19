// V's voice lines, the same as Cyber Grapple's (Kevin, 18 November 2026): Get over here as a person really starts
// coming to V, and one of the execution lines when V kills or knocks out the person the grapple brought and grabbed
// (the knock-out since Kevin, 19 November 2026). Audioware plays them, from the manifest of r6/audioware/ApexGrapple
// (voices.yml); VoicePlay.reds alone reaches it, VoiceLines.reds names them. Asked from the start of a person's pull
// (ApexGrappleAttach in Shot.reds) and from the game's execution (VoiceKill.reds): once each, nothing here runs each
// frame. The settings are those of the profile whose grapple brought the person.

// Kevin, 18 November 2026: "On part sur Normal + Whisper, c'est bien pour decouvrir".
enum ApexGrappleVoiceKillStyle {
  Normal = 0,
  Whisper = 1,
  Both = 2
}

public func ApexGrappleVoiceMostLines() -> Int32 {
  return 30;
}

// An execution's line is drawn in two steps, as in Cyber Grapple (19 November 2026): the phrase, then its tone. The
// phrase is the other one than the phrase said last, so that the two take turns, either of them at a load's first. A
// knock-out leaves the person alive: Your soul is weak alone, never Your death will be swift (the Cyber Grapple
// session's choice, told to Kevin, who did not object).
public func ApexGrappleVoicePhraseFor(last: ApexGrappleVoicePhrase, knockOut: Bool) -> ApexGrappleVoicePhrase {
  if knockOut || Equals(last, ApexGrappleVoicePhrase.Death) {
    return ApexGrappleVoicePhrase.Soul;
  }
  if Equals(last, ApexGrappleVoicePhrase.Soul) {
    return ApexGrappleVoicePhrase.Death;
  }
  return RandRange(0, 2) == 0 ? ApexGrappleVoicePhrase.Death : ApexGrappleVoicePhrase.Soul;
}

// The tones of the phrase V may say in this style: the spoken ones unless Whisper, the whispered ones unless Normal.
// Both voices have each phrase spoken and whispered (fabrique/test_voices.py), a male V's whispered ones since his
// recordings of 19 November 2026.
public func ApexGrappleVoiceToneLines(style: ApexGrappleVoiceKillStyle, female: Bool, phrase: ApexGrappleVoicePhrase) -> array<CName> {
  let all: array<CName> = ApexGrappleVoiceKillLines(female);
  let lines: array<CName>;
  for line in all {
    let allowed: Bool = ApexGrappleVoiceIsWhispered(line) ? NotEquals(style, ApexGrappleVoiceKillStyle.Normal) : NotEquals(style, ApexGrappleVoiceKillStyle.Whisper);
    if allowed && ApexGrappleVoiceIsPhrase(line, phrase) {
      ArrayPush(lines, line);
    }
  }
  return lines;
}

// For the settings' line in the log (Profiles.reds).
public func ApexGrappleVoiceText(s: ref<ApexGrappleSettings>) -> String {
  if !s.voiceLines {
    return "off";
  }
  let style: String = NameToString(EnumValueToName(n"ApexGrappleVoiceKillStyle", Cast<Int64>(EnumInt(s.voiceKillStyle))));
  let voice: String = NameToString(EnumValueToName(n"ApexGrappleVoiceGender", Cast<Int64>(EnumInt(s.voiceGender))));
  return "voice " + voice + ", pull " + ToString(s.voicePullChance) + " %, execution " + ToString(s.voiceKillChance) + " % " + style;
}

public func ApexGrappleVoiceOn(settings: ref<ApexGrappleSettings>) -> Bool {
  return IsDefined(settings) && settings.enabled && settings.voiceLines;
}

// Switched off, nothing more is read nor told: the player chose it; Audioware missing, the log said it once at the
// load (VoicePlay.reds). A pull of a person dead or knocked out has no line, before the bag is drawn so that it takes
// nothing from the series (Kevin, 19 November 2026: "oui il se tait sur les cadavres"); the game's
// ScriptedPuppet.IsActive says alive, not defeated, not unconscious, not turned off (scriptedPuppet.script:1524), so a
// person down but not finished and a turned-off android are silent too; an android's kill keeps its line ("oui on
// garde"). Silent this time by the bag (VoiceBag.reds), the line is left out and the log says where the bag stands,
// what a trial needs to tell a silence from a fault.
public func ApexGrappleVoiceLeftOut(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, pull: Bool, occasion: String, person: ref<GameObject>) -> Bool {
  if !ApexGrappleVoiceOn(settings) {
    return true;
  }
  if !ApexGrappleVoiceThere() {
    return true;
  }
  if pull && !ScriptedPuppet.IsActive(person) {
    ApexGrappleVoiceDead(system, occasion);
    return true;
  }
  let bag: ref<ApexGrappleVoiceBag> = ApexGrappleVoiceBagOf(system, pull);
  if !ApexGrappleVoiceBagDraw(bag, pull ? settings.voicePullChance : settings.voiceKillChance) {
    ApexGrappleVoiceMissed(system, occasion, bag);
    return true;
  }
  return false;
}

public func ApexGrappleVoicePull(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, player: ref<GameObject>, person: ref<GameObject>) -> Void {
  if ApexGrappleVoiceLeftOut(system, settings, true, "a pull", person) {
    return;
  }
  let line: CName = ApexGrappleVoiceOther(ApexGrappleVoicePullLines(ApexGrappleVoiceFemaleOf(settings.voiceGender, player)), system.voicePullLast);
  system.voicePullLast = line;
  ApexGrappleVoiceAsk(system, player, line, "a pull");
}

// A knock-out is an execution's occasion like a kill, from the same slider and bag (Kevin, 19 November 2026); the log
// names it apart so that a trial tells the two.
public func ApexGrappleVoiceKill(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, player: ref<GameObject>, knockOut: Bool) -> Void {
  let occasion: String = knockOut ? "a knock-out" : "an execution";
  if ApexGrappleVoiceLeftOut(system, settings, false, occasion, null) {
    return;
  }
  let phrase: ApexGrappleVoicePhrase = ApexGrappleVoicePhraseFor(system.voiceLastPhrase, knockOut);
  let lines: array<CName> = ApexGrappleVoiceToneLines(settings.voiceKillStyle, ApexGrappleVoiceFemaleOf(settings.voiceGender, player), phrase);
  if ArraySize(lines) == 0 {
    ApexGrappleVoiceNone(system, occasion, "no recording of this phrase in this style");
    return;
  }
  let line: CName = ApexGrappleVoiceOther(lines, system.voiceLast);
  system.voiceLastPhrase = phrase;
  system.voiceLast = line;
  ApexGrappleVoiceAsk(system, player, line, occasion);
}

// One of the lines other than the last one said, each as likely; the last one again only if no other is left.
public func ApexGrappleVoiceOther(lines: array<CName>, last: CName) -> CName {
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
public func ApexGrappleVoiceAsk(system: ref<ApexGrappleSystem>, player: ref<GameObject>, line: CName, occasion: String) -> Void {
  if system.voiceLines <= ApexGrappleVoiceMostLines() {
    system.voiceLines = ApexGrappleLogUpTo(system.voiceLines, ApexGrappleVoiceMostLines(), "voice lines", "voice line " + NameToString(line) + " asked of Audioware for " + occasion);
  }
  ApexGrappleVoicePlay(player, line);
}

public func ApexGrappleVoiceNone(system: ref<ApexGrappleSystem>, occasion: String, why: String) -> Void {
  if system.voiceNoneLines <= ApexGrappleVoiceMostLines() {
    system.voiceNoneLines = ApexGrappleLogUpTo(system.voiceNoneLines, ApexGrappleVoiceMostLines(), "voice lines left out", "voice line for " + occasion + ": none, " + why);
  }
}

// A draw missed is the player's chance at work, not a fault: under a bound of its own (optimisation.md 9.1), since at
// the menu's default it comes once in two occasions and would use up the lines that tell the other reasons (audit of
// 19 November 2026, as in Cyber Grapple).
public func ApexGrappleVoiceMissed(system: ref<ApexGrappleSystem>, occasion: String, bag: ref<ApexGrappleVoiceBag>) -> Void {
  if system.voiceMissLines <= ApexGrappleVoiceMostLines() {
    system.voiceMissLines = ApexGrappleLogUpTo(system.voiceMissLines, ApexGrappleVoiceMostLines(), "voice draws missed", "voice line for " + occasion + ": none, " + ApexGrappleVoiceBagText(system, bag));
  }
}

// An execution left to Execution Lines (VoiceExecutionLines.reds) is told under a bound of its own, as in Cyber Grapple.
public func ApexGrappleVoiceHandedOver(system: ref<ApexGrappleSystem>, occasion: String) -> Void {
  if system.voiceHandedLines <= ApexGrappleVoiceMostLines() {
    system.voiceHandedLines = ApexGrappleLogUpTo(system.voiceHandedLines, ApexGrappleVoiceMostLines(), "voice lines left to Execution Lines", "voice line for " + occasion + ": none, Execution Lines says it");
  }
}

// A person dead or out pulled is told under a bound of its own, as a draw missed: a trial dragging bodies would else
// use up the lines that tell why an execution had no line (second audit of 19 November 2026, as in Cyber Grapple). The
// words are those the trials already cite.
public func ApexGrappleVoiceDead(system: ref<ApexGrappleSystem>, occasion: String) -> Void {
  if system.voiceDeadLines <= ApexGrappleVoiceMostLines() {
    system.voiceDeadLines = ApexGrappleLogUpTo(system.voiceDeadLines, ApexGrappleVoiceMostLines(), "voice lines left out on the dead", "voice line for " + occasion + ": none, the person is dead or out");
  }
}
