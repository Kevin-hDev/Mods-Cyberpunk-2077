// The grab line's conclusion, at the occasion of the person held (conception-saisies, section 3.2): V ends what he
// began, with the conclusion of the pair for a kill or for a knock-out, in the voice and the style of his grab line.
// Called by Occasion.reds, step 3 bis, once per occasion.

// How long a grab line is kept after its end: past it, the execution no longer answers it (section 3.1, point 5).
public func ExecutionLinesGrabKeptSeconds() -> Float {
  return 30.0;
}

// Whether a grab line is kept for this person: said for the grab held on them, not over yet, or over for less than the
// time it is kept.
public func ExecutionLinesGrabLineKept(system: ref<ExecutionLinesSystem>, id: EntityID, now: Float) -> Bool {
  let grabLine: ExecutionLinesGrabLine = system.grabLine;
  return system.grabHeld && id == system.grabVictim && system.grabLineSaid && now - grabLine.until < ExecutionLinesGrabKeptSeconds();
}

// The takes of the conclusion in the voice and the style the grab line was said in, read from the table alone: neither
// the frequency, nor the style set since, nor any phrase's choice applies to a conclusion, the choice was made on the
// grab line (README). ExecutionLinesChoiceOf is not asked: it would give Death's or SweetDreams' own choice in the
// execution section, and V would stay silent after his grab line.
public func ExecutionLinesConclusionTakes(conclusion: ExecutionLinesPhrase, grabLine: ExecutionLinesGrabLine) -> array<ExecutionLinesLine> {
  let table: array<ExecutionLinesLine> = ExecutionLinesTable();
  let takes: array<ExecutionLinesLine>;
  for line in table {
    if Equals(line.phrase, conclusion) && Equals(line.female, grabLine.female) && Equals(line.whispered, grabLine.whispered) {
      ArrayPush(takes, line);
    }
  }
  return takes;
}

// The occasion of the person held, their grab line kept. The executions' series of ten is never drawn from, and the
// occasion stops here in each case; its grab was forgotten before (Occasion.reds).
public func ExecutionLinesConclude(system: ref<ExecutionLinesSystem>, game: GameInstance, player: ref<GameObject>, grabLine: ExecutionLinesGrabLine, lethal: Bool, now: Float, heardBy: String) -> Void {
  let most: Int32 = ExecutionLinesLogMost();
  // V still speaks: he only ends his sentence (README: "juste l'execution avec la phrase qui se termine"). A grab line
  // stopped never reaches here, its grab is forgotten (ExecutionLinesHush).
  if now < grabLine.until {
    if system.conclusionSilentLines <= most {
      system.conclusionSilentLines = ExecutionLinesLogUpTo(system.conclusionSilentLines, most, "conclusions not said", "no conclusion: V has not finished his grab line, " + ExecutionLinesOccasionText(lethal, heardBy));
    }
    return;
  }
  if ExecutionLinesSpeaking(system, now) {
    if system.conclusionSilentLines <= most {
      system.conclusionSilentLines = ExecutionLinesLogUpTo(system.conclusionSilentLines, most, "conclusions not said", "no conclusion: V is saying another line, " + ExecutionLinesOccasionText(lethal, heardBy));
    }
    return;
  }
  let conclusion: ExecutionLinesPhrase = ExecutionLinesConclusionOf(grabLine.phrase, lethal);
  let takes: array<ExecutionLinesLine> = ExecutionLinesConclusionTakes(conclusion, grabLine);
  // fabrique/test_lines.py forbids it: each conclusion has a spoken and a whispered take in each voice.
  if ArraySize(takes) == 0 {
    if system.conclusionNoTakeLines <= most {
      system.conclusionNoTakeLines = ExecutionLinesLogUpTo(system.conclusionNoTakeLines, most, "conclusions without a take", "no conclusion: phrase " + ToString(EnumInt(conclusion)) + " has no take in the grab line's voice and style, " + ExecutionLinesOccasionText(lethal, heardBy));
    }
    return;
  }
  let phraseKey: Int32 = EnumInt(conclusion);
  let takeKeys: array<Int32> = ExecutionLinesTakeKeys(takes, conclusion);
  let takeKey: Int32 = ExecutionLinesLeastSaid(takeKeys, system.takeCounts, ExecutionLinesCount(system.lastTakes, phraseKey) - 1);
  let table: array<ExecutionLinesLine> = ExecutionLinesTable();
  let line: ExecutionLinesLine = table[takeKey];
  system.takeCounts = ExecutionLinesCountsAfter(system.takeCounts, takeKeys, takeKey);
  system.lastTakes = ExecutionLinesCountsWith(system.lastTakes, phraseKey, takeKey + 1);
  // Death and SweetDreams are execution lines too: counted as said, so that the next execution does not bring them back
  // at once (section 3.2, point 2).
  if ExecutionLinesFitsLethal(conclusion) || ExecutionLinesFitsNonLethal(conclusion) {
    system.phraseCounts = ExecutionLinesCountsWith(system.phraseCounts, phraseKey, ExecutionLinesCount(system.phraseCounts, phraseKey) + 1);
    system.lastPhrase = conclusion;
  }
  if system.conclusionLines <= most {
    system.conclusionLines = ExecutionLinesLogUpTo(system.conclusionLines, most, "conclusions asked", "conclusion " + NameToString(line.name) + " asked of Audioware: " + ExecutionLinesOccasionText(lethal, heardBy) + ", " + ExecutionLinesClocksText(game));
  }
  ExecutionLinesSay(system, game, player, line);
}
