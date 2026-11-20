// The one entry of the listeners: an execution heard is an occasion, lethal or not, and this decides whether V says a
// line and which (conception, section 2, and conception-saisies, section 3.2). Each silence after step 1 leaves a
// bounded line in the log, what the first trial reads to tell a silence from a fault. Called once per occasion by a
// listener, never each frame.

// How long the same person heard again does not count again: E1 and E4 hear a game's execution as its animation starts,
// E5 another mod's as its own animation starts, and E2 or E3 may hear the same person as the kill or the knock-out
// lands, seconds later (conception, section 5).
public func ExecutionLinesSamePersonSeconds() -> Float {
  return 30.0;
}

public func ExecutionLinesOccasionText(lethal: Bool, heardBy: String) -> String {
  return (lethal ? "lethal" : "non-lethal") + " execution heard by " + heardBy;
}

// A character played in V's place would speak with V's voice: the game calls a replacer any player record other than
// V's own (player.script:617-619), Johnny, Kurt and the assassins of a side job among them (:983-1009). The prologue's
// simulation is a replacer too, yet the character played there is V (q000_vr_replacer, IsVRReplacer, :621-623), so V
// keeps the lines. The one rule for the occasions and the grab's moment (GrabLine.reds).
public func ExecutionLinesPlayerIsV(player: ref<GameObject>) -> Bool {
  let puppet: ref<PlayerPuppet> = player as PlayerPuppet;
  return !IsDefined(puppet) || !puppet.IsReplacer() || puppet.IsVRReplacer();
}

// How many people counted are kept. Executions in a chain leave at most two people waiting for their death at once (E5
// counts a person 2 to 4 s before E2 hears the kill); four leaves room, and the memory stays bounded.
public func ExecutionLinesCountedMost() -> Int32 {
  return 4;
}

public func ExecutionLinesCountedPlace(system: ref<ExecutionLinesSystem>, id: EntityID) -> Int32 {
  let at: Int32 = 0;
  while at < ArraySize(system.countedPeople) {
    if system.countedPeople[at] == id {
      return at;
    }
    at += 1;
  }
  return -1;
}

// Whether this person was counted for an occasion within the window: what step 2 asks, and what the grab asks too
// (Grab.reds, GrabLine.reds), since the person held still carries the grab's effect while their execution plays.
public func ExecutionLinesCounted(system: ref<ExecutionLinesSystem>, id: EntityID, now: Float) -> Bool {
  let at: Int32 = ExecutionLinesCountedPlace(system, id);
  return at >= 0 && now - system.countedAt[at] < ExecutionLinesSamePersonSeconds();
}

// The person counted now takes the last place, theirs given up first, and the oldest go once the memory is full. The
// arrays are worked on in the system itself, never through a local variable, as the grab's bag of slices (Grab.reds).
public func ExecutionLinesCountPerson(system: ref<ExecutionLinesSystem>, id: EntityID, now: Float) -> Void {
  let at: Int32 = ExecutionLinesCountedPlace(system, id);
  if at >= 0 {
    ArrayErase(system.countedPeople, at);
    ArrayErase(system.countedAt, at);
  }
  while ArraySize(system.countedPeople) >= ExecutionLinesCountedMost() {
    ArrayErase(system.countedPeople, 0);
    ArrayErase(system.countedAt, 0);
  }
  ArrayPush(system.countedPeople, id);
  ArrayPush(system.countedAt, now);
}

// heardBy: the listener that heard it, "E2", "E3", "E4", "E1" followed by the effect tag it got, or "E5" followed by
// the type of the weapon in V's hand, or by "no weapon in hand".
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
  // Tested before step 2, so that such an occasion never counts the person.
  if !ExecutionLinesPlayerIsV(player) {
    if system.replacerLines <= most {
      system.replacerLines = ExecutionLinesLogUpTo(system.replacerLines, most, "lines while the player is not V", "no voice line: the player is not V, " + ExecutionLinesOccasionText(lethal, heardBy));
    }
    return;
  }
  // 2. One person, one occasion: the person is counted before any other silence, so that a person heard again is
  // never a second occasion, whatever happened at the first.
  let now: Float = ExecutionLinesNow(game);
  let id: EntityID = victim.GetEntityID();
  if ExecutionLinesCounted(system, id, now) {
    if system.samePersonLines <= most {
      system.samePersonLines = ExecutionLinesLogUpTo(system.samePersonLines, most, "lines on a person already counted", "no voice line: the same person was already counted, " + ExecutionLinesOccasionText(lethal, heardBy));
    }
    return;
  }
  ExecutionLinesCountPerson(system, id, now);
  // An occasion for the person held ends their grab, whichever step it stops at: the grab line kept for step 3 bis is
  // read first, then the grab is forgotten.
  let concludes: Bool = ExecutionLinesGrabLineKept(system, id, now);
  let grabLine: ExecutionLinesGrabLine = system.grabLine;
  ExecutionLinesForgetGrabOf(system, id);
  // 3. Without Audioware nothing can be heard: the player is told once a load, the log at each occasion.
  if !ExecutionLinesAudioThere() {
    ExecutionLinesNoticeNoAudioware(system, game);
    if system.noAudiowareLines <= most {
      system.noAudiowareLines = ExecutionLinesLogUpTo(system.noAudiowareLines, most, "lines without Audioware", "no voice line: Audioware is not installed, " + ExecutionLinesOccasionText(lethal, heardBy));
    }
    return;
  }
  // 3 bis. The person held, their grab line kept: its conclusion, or silence (Conclusion.reds). Never more.
  if concludes {
    ExecutionLinesConclude(system, game, player, grabLine, lethal, now, heardBy);
    return;
  }
  // 4. The voice, read at each occasion.
  let female: Bool = ExecutionLinesFemaleOf(settings.voice, player);
  ExecutionLinesVoiceTell(system, settings.voice, player);
  // 4 bis. V is still saying a line, an execution's just before for instance: he does not talk over it, and the series
  // of ten is left as it is (conception-saisies, section 3.2).
  if ExecutionLinesSpeaking(system, now) {
    if system.speakingLines <= most {
      system.speakingLines = ExecutionLinesLogUpTo(system.speakingLines, most, "occasions while V speaks", "no voice line: V is still saying a line, " + ExecutionLinesOccasionText(lethal, heardBy));
    }
    return;
  }
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
  let line: ExecutionLinesLine = table[takeKey];
  system.phraseCounts = ExecutionLinesCountsAfter(system.phraseCounts, phraseKeys, phraseKey);
  system.takeCounts = ExecutionLinesCountsAfter(system.takeCounts, takeKeys, takeKey);
  system.lastTakes = ExecutionLinesCountsWith(system.lastTakes, phraseKey, takeKey + 1);
  system.lastPhrase = phrase;
  // 8. The line is told before Audioware is asked, so that a fault while it plays leaves the line in the log; whether
  // it was heard is in Audioware's own log.
  if system.askedLines <= most {
    system.askedLines = ExecutionLinesLogUpTo(system.askedLines, most, "voice lines asked", "voice line " + NameToString(line.name) + " asked of Audioware: " + ExecutionLinesOccasionText(lethal, heardBy) + ", " + ExecutionLinesClocksText(game));
  }
  ExecutionLinesSay(system, game, player, line);
}
