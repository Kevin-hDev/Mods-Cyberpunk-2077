// The grab's moment (conception-saisies, section 3.1, points 2 to 5): the callback S1 asked for comes back here, and V
// says a grab line if he still holds the person and nothing stops him. Each silence leaves a bounded line in the log.
// Called once per grab, never each frame.

// The grab lines' own series of ten, made at its first use, apart from the executions' (section 3.1, point 3).
public func ExecutionLinesGrabBagOf(system: ref<ExecutionLinesSystem>) -> ref<ExecutionLinesBag> {
  if !IsDefined(system.grabBag) {
    system.grabBag = new ExecutionLinesBag();
  }
  return system.grabBag;
}

// Whether V still holds the person of the grab, read on what the game sets and takes off itself: the person is there,
// carries the grab's effect, is alive and not defeated, and no occasion was counted for them (section 3.1, point 2).
public func ExecutionLinesStillHeld(system: ref<ExecutionLinesSystem>, game: GameInstance, now: Float) -> Bool {
  let victim: ref<GameObject> = GameInstance.FindEntityByID(game, system.grabVictim) as GameObject;
  return IsDefined(victim) && ExecutionLinesHeld(game, system.grabVictim) && ScriptedPuppet.IsAlive(victim) && !ScriptedPuppet.IsDefeated(victim) && !ExecutionLinesCounted(system, system.grabVictim, now);
}

// The grab lines' series in the log, in the words of grab moments (Bag.reds says the same of the occasions').
public func ExecutionLinesGrabBagText(bag: ref<ExecutionLinesBag>) -> String {
  return "silent this time at " + ToString(bag.filledFor) + " %, " + ToString(bag.says) + " grab lines left in the " + ToString(bag.left) + " grab moments left of this ten";
}

// A moment turned away for the mod, Audioware or the player, under one bound: each comes rarely.
public func ExecutionLinesGrabRefused(system: ref<ExecutionLinesSystem>, number: Int32, why: String) -> Void {
  let most: Int32 = ExecutionLinesLogMost();
  if system.grabRefusedLines <= most {
    system.grabRefusedLines = ExecutionLinesLogUpTo(system.grabRefusedLines, most, "grabs without a grab line", "no grab line at the moment of grab " + ToString(number) + ": " + why);
  }
}

// The callback of grab `number` came back. The checks come in the conception's order, the cheapest first.
public func ExecutionLinesGrabMoment(game: GameInstance, number: Int32) -> Void {
  let system: ref<ExecutionLinesSystem> = ExecutionLinesSystemOf(game);
  if !IsDefined(system) {
    return;
  }
  let settings: ref<ExecutionLinesSettings> = new ExecutionLinesSettings();
  // The mod switched off forgets the grab of this moment, so that once it is on again, holding the same person is a
  // new grab with its own moment (conception-saisies, 3.4, point 6).
  if !settings.enabled {
    if number == system.grabNumber {
      ExecutionLinesForgetGrabOf(system, system.grabVictim);
    }
    ExecutionLinesGrabRefused(system, number, "the mod is switched off, the grab is forgotten");
    return;
  }
  if !ExecutionLinesAudioThere() {
    ExecutionLinesGrabRefused(system, number, "Audioware is not installed");
    return;
  }
  let player: ref<GameObject> = GetPlayer(game);
  if !IsDefined(player) {
    ExecutionLinesGrabRefused(system, number, "no player found");
    return;
  }
  if !ExecutionLinesPlayerIsV(player) {
    ExecutionLinesGrabRefused(system, number, "the player is not V");
    return;
  }
  // The ordinary end of a grab, executed or let go before its moment, under a bound of its own, so that it never uses
  // up the lines of the refusals above.
  let most: Int32 = ExecutionLinesLogMost();
  let now: Float = ExecutionLinesNow(game);
  if number != system.grabNumber || !system.grabHeld {
    if system.grabOverLines <= most {
      system.grabOverLines = ExecutionLinesLogUpTo(system.grabOverLines, most, "grab moments after their grab", "no grab line at the moment of grab " + ToString(number) + ": " + (number != system.grabNumber ? "grab " + ToString(system.grabNumber) + " began since" : "the grab already ended"));
    }
    return;
  }
  // Let go with no takedown action heard (the game took its effect off, the person died or fell): the grab is
  // forgotten, so that holding the same person again is a new grab with its own moment, not a pass of this one.
  if !ExecutionLinesStillHeld(system, game, now) {
    ExecutionLinesForgetGrabOf(system, system.grabVictim);
    if system.grabOverLines <= most {
      system.grabOverLines = ExecutionLinesLogUpTo(system.grabOverLines, most, "grab moments after their grab", "no grab line at the moment of grab " + ToString(number) + ": V no longer holds the person, the grab is forgotten");
    }
    return;
  }
  if ExecutionLinesSpeaking(system, now) {
    if system.grabBusyLines <= most {
      system.grabBusyLines = ExecutionLinesLogUpTo(system.grabBusyLines, most, "grab moments while V speaks", "no grab line at the moment of grab " + ToString(number) + ": V is still saying a line");
    }
    return;
  }
  // The voice, as at an occasion (Occasion.reds, step 4).
  let female: Bool = ExecutionLinesFemaleOf(settings.voice, player);
  ExecutionLinesVoiceTell(system, settings.voice, player);
  let allowed: array<ExecutionLinesLine> = ExecutionLinesGrabAllowed(settings, female);
  if ArraySize(allowed) == 0 {
    if system.grabNoneLines <= most {
      system.grabNoneLines = ExecutionLinesLogUpTo(system.grabNoneLines, most, "grab moments with no grab line allowed", "no grab line at the moment of grab " + ToString(number) + ": no grab line allowed by the settings");
    }
    return;
  }
  // The place in the series is taken here alone, every check passed: a grab over before its moment takes none.
  let bag: ref<ExecutionLinesBag> = ExecutionLinesGrabBagOf(system);
  if !ExecutionLinesBagDraw(bag, settings.grabChance) {
    if system.grabMissedLines <= most {
      system.grabMissedLines = ExecutionLinesLogUpTo(system.grabMissedLines, most, "grab draws missed", "no grab line at the moment of grab " + ToString(number) + ": " + ExecutionLinesGrabBagText(bag));
    }
    return;
  }
  // The phrase, then its take, each the least said among the grab lines (Choice.reds), the last grab line said left
  // aside, with counts of their own.
  let phraseKeys: array<Int32> = ExecutionLinesPhraseKeys(allowed);
  let phraseKey: Int32 = ExecutionLinesLeastSaid(phraseKeys, system.grabPhraseCounts, EnumInt(system.grabLastPhrase));
  let phrase: ExecutionLinesPhrase = IntEnum<ExecutionLinesPhrase>(phraseKey);
  let takeKeys: array<Int32> = ExecutionLinesTakeKeys(allowed, phrase);
  let takeKey: Int32 = ExecutionLinesLeastSaid(takeKeys, system.grabTakeCounts, ExecutionLinesCount(system.grabLastTakes, phraseKey) - 1);
  let table: array<ExecutionLinesLine> = ExecutionLinesTable();
  let line: ExecutionLinesLine = table[takeKey];
  system.grabPhraseCounts = ExecutionLinesCountsAfter(system.grabPhraseCounts, phraseKeys, phraseKey);
  system.grabTakeCounts = ExecutionLinesCountsAfter(system.grabTakeCounts, takeKeys, takeKey);
  system.grabLastTakes = ExecutionLinesCountsWith(system.grabLastTakes, phraseKey, takeKey + 1);
  system.grabLastPhrase = phrase;
  if system.grabAskedLines <= most {
    system.grabAskedLines = ExecutionLinesLogUpTo(system.grabAskedLines, most, "grab lines asked", "grab line " + NameToString(line.name) + " asked of Audioware at the moment of grab " + ToString(number) + ", " + ExecutionLinesClocksText(game));
  }
  ExecutionLinesSay(system, game, player, line);
  system.grabLineSaid = true;
  system.grabLine = new ExecutionLinesGrabLine(phrase, female, line.whispered, system.sayingUntil);
}
