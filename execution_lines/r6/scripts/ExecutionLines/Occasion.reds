// The one entry of the listeners: an execution heard is an occasion, lethal or not, and this decides whether V says a
// line and which (conception, section 2). Each silence after step 1 leaves a bounded line in the log, what the first
// trial reads to tell a silence from a fault. Called once per occasion by a listener, never each frame.

// How long the same person heard again does not count again: E1 and E4 hear a game's execution as its animation starts,
// and E2 or E3 may hear the same person as the kill or the knock-out lands, seconds later (conception, section 5).
public func ExecutionLinesSamePersonSeconds() -> Float {
  return 30.0;
}

public func ExecutionLinesOccasionText(lethal: Bool, heardBy: String) -> String {
  return (lethal ? "lethal" : "non-lethal") + " execution heard by " + heardBy;
}

// heardBy: the listener that heard it, "E2", "E3", "E4", or "E1" followed by the effect tag it got.
public func ExecutionLinesOccasion(game: GameInstance, player: ref<GameObject>, victim: ref<GameObject>, lethal: Bool, heardBy: String) -> Void {
  // 1. The player's settings as they stand, read anew at each occasion; the mod switched off leaves no line. Without V
  // or the person there is nobody to speak or to count: the line tells a listener called with nothing apart from a
  // listener never called.
  let system: ref<ExecutionLinesSystem> = ExecutionLinesSystemOf(game);
  if !IsDefined(system) {
    return;
  }
  let settings: ref<ExecutionLinesSettings> = new ExecutionLinesSettings();
  if !settings.enabled {
    return;
  }
  let most: Int32 = ExecutionLinesLogMost();
  if !IsDefined(player) || !IsDefined(victim) {
    if system.nobodyLines <= most {
      system.nobodyLines = ExecutionLinesLogUpTo(system.nobodyLines, most, "lines without V or the person", "no voice line: V or the person is not there, " + ExecutionLinesOccasionText(lethal, heardBy));
    }
    return;
  }
  // A character played in V's place would speak with V's voice: the game calls a replacer any player record other than
  // V's own (player.script:617-619), Johnny, Kurt and the assassins of a side job among them (:983-1009). The prologue's
  // simulation is a replacer too, yet the character played there is V (q000_vr_replacer, IsVRReplacer, :621-623), so V
  // keeps the lines. Tested before step 2, so that such an occasion never counts the person.
  let puppet: ref<PlayerPuppet> = player as PlayerPuppet;
  if IsDefined(puppet) && puppet.IsReplacer() && !puppet.IsVRReplacer() {
    if system.replacerLines <= most {
      system.replacerLines = ExecutionLinesLogUpTo(system.replacerLines, most, "lines while the player is not V", "no voice line: the player is not V, " + ExecutionLinesOccasionText(lethal, heardBy));
    }
    return;
  }
  // 2. One person, one occasion: the person is counted before any other silence, so that a person heard again is
  // never a second occasion, whatever happened at the first.
  let now: Float = EngineTime.ToFloat(GameInstance.GetSimTime(game));
  let id: EntityID = victim.GetEntityID();
  if system.victimCounted && id == system.lastVictim && now - system.lastVictimAt < ExecutionLinesSamePersonSeconds() {
    if system.samePersonLines <= most {
      system.samePersonLines = ExecutionLinesLogUpTo(system.samePersonLines, most, "lines on a person already counted", "no voice line: the same person was already counted, " + ExecutionLinesOccasionText(lethal, heardBy));
    }
    return;
  }
  system.victimCounted = true;
  system.lastVictim = id;
  system.lastVictimAt = now;
  // 3. Without Audioware nothing can be heard: the player is told once a load, the log at each occasion.
  if !ExecutionLinesAudioThere() {
    ExecutionLinesNoticeNoAudioware(system, game);
    if system.noAudiowareLines <= most {
      system.noAudiowareLines = ExecutionLinesLogUpTo(system.noAudiowareLines, most, "lines without Audioware", "no voice line: Audioware is not installed, " + ExecutionLinesOccasionText(lethal, heardBy));
    }
    return;
  }
  // 4. The voice, read at each occasion.
  let female: Bool = ExecutionLinesFemaleOf(settings.voice, player);
  ExecutionLinesVoiceTell(system, settings.voice, player);
  // 5. Nothing allowed: silent, and the series of ten is left as it is.
  let allowed: array<ExecutionLinesLine> = ExecutionLinesAllowed(settings, female, lethal);
  if ArraySize(allowed) == 0 {
    if system.noLineAllowedLines <= most {
      system.noLineAllowedLines = ExecutionLinesLogUpTo(system.noLineAllowedLines, most, "lines with no line allowed", "no voice line: no line allowed by the settings, " + ExecutionLinesOccasionText(lethal, heardBy));
    }
    return;
  }
  // 6. The draw in the series of ten. A draw missed is the player's chance at work, not a fault: under a bound of its
  // own, since at the default it comes once in two occasions.
  let bag: ref<ExecutionLinesBag> = ExecutionLinesBagOf(system);
  if !ExecutionLinesBagDraw(bag, settings.chance) {
    if system.silentLines <= most {
      system.silentLines = ExecutionLinesLogUpTo(system.silentLines, most, "draws missed", ExecutionLinesBagText(bag));
    }
    return;
  }
  // 7. The phrase, then its take, each the least said (Choice.reds). A phrase's last take is kept as its key plus one,
  // so that 0, the value of a phrase never said, stands for none.
  let phraseKeys: array<Int32> = ExecutionLinesPhraseKeys(allowed);
  let phraseKey: Int32 = ExecutionLinesLeastSaid(phraseKeys, system.phraseCounts, EnumInt(system.lastPhrase));
  let phrase: ExecutionLinesPhrase = IntEnum<ExecutionLinesPhrase>(phraseKey);
  let takeKeys: array<Int32> = ExecutionLinesTakeKeys(allowed, phrase);
  let takeKey: Int32 = ExecutionLinesLeastSaid(takeKeys, system.takeCounts, ExecutionLinesCount(system.lastTakes, phraseKey) - 1);
  let table: array<ExecutionLinesLine> = ExecutionLinesTable();
  let line: CName = table[takeKey].name;
  system.phraseCounts = ExecutionLinesCountsAfter(system.phraseCounts, phraseKeys, phraseKey);
  system.takeCounts = ExecutionLinesCountsAfter(system.takeCounts, takeKeys, takeKey);
  system.lastTakes = ExecutionLinesCountsWith(system.lastTakes, phraseKey, takeKey + 1);
  system.lastPhrase = phrase;
  // 8. The line is told before Audioware is asked, so that a fault while it plays leaves the line in the log; whether
  // it was heard is in Audioware's own log.
  if system.askedLines <= most {
    system.askedLines = ExecutionLinesLogUpTo(system.askedLines, most, "voice lines asked", "voice line " + NameToString(line) + " asked of Audioware: " + ExecutionLinesOccasionText(lethal, heardBy));
  }
  ExecutionLinesPlay(player, line);
}
