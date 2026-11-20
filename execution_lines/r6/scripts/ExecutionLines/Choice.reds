// Which recordings V may say at an occasion or at a grab's moment, then which one (conception, section 2, points 3 to 5
// and 7; conception-saisies, section 3.1, point 4). No call to the game here but RandRange: the table, the settings and
// the player's choices are this mod's own.

// The global style: the spoken takes unless Whisper, the whispered ones unless Normal.
public func ExecutionLinesStyleAccepts(style: ExecutionLinesStyle, whispered: Bool) -> Bool {
  if whispered {
    return NotEquals(style, ExecutionLinesStyle.Normal);
  }
  return NotEquals(style, ExecutionLinesStyle.Whisper);
}

// A phrase's own choice in the Custom section of the voice that speaks: None refuses every take of the phrase.
public func ExecutionLinesChoiceAccepts(choice: ExecutionLinesChoice, whispered: Bool) -> Bool {
  if Equals(choice, ExecutionLinesChoice.None) {
    return false;
  }
  if whispered {
    return NotEquals(choice, ExecutionLinesChoice.Normal);
  }
  return NotEquals(choice, ExecutionLinesChoice.Whisper);
}

// The takes of this voice whose phrase is said at this kind of occasion (a kill, or a knock-out that leaves the person
// alive: SweetDreams at a knock-out only, Kevin, 20 November 2026), and that the global style and the phrase's choice
// both accept. A grab line or a pure conclusion is said at neither kind, so never at an occasion (conception-saisies,
// section 2). Empty when the settings allow none, and V then stays silent without drawing from the series of ten.
public func ExecutionLinesAllowed(settings: ref<ExecutionLinesSettings>, female: Bool, lethal: Bool) -> array<ExecutionLinesLine> {
  let table: array<ExecutionLinesLine> = ExecutionLinesTable();
  let allowed: array<ExecutionLinesLine>;
  for line in table {
    if Equals(line.female, female)
      && (lethal ? ExecutionLinesFitsLethal(line.phrase) : ExecutionLinesFitsNonLethal(line.phrase))
      && ExecutionLinesStyleAccepts(settings.style, line.whispered)
      && ExecutionLinesChoiceAccepts(ExecutionLinesChoiceOf(settings, line.phrase, female), line.whispered) {
      ArrayPush(allowed, line);
    }
  }
  return allowed;
}

// The grab lines of this voice that the global style and the phrase's choice in the voice's grab section both accept
// (conception-saisies, section 3.1, point 4). Empty when the settings allow none, and V then stays silent without
// drawing from the grab lines' series of ten.
public func ExecutionLinesGrabAllowed(settings: ref<ExecutionLinesSettings>, female: Bool) -> array<ExecutionLinesLine> {
  let table: array<ExecutionLinesLine> = ExecutionLinesTable();
  let allowed: array<ExecutionLinesLine>;
  for line in table {
    if Equals(line.female, female)
      && ExecutionLinesIsGrab(line.phrase)
      && ExecutionLinesStyleAccepts(settings.style, line.whispered)
      && ExecutionLinesChoiceAccepts(ExecutionLinesChoiceOf(settings, line.phrase, female), line.whispered) {
      ArrayPush(allowed, line);
    }
  }
  return allowed;
}

// Phrases and takes are drawn as the least said. Kevin, 19 November 2026: the same phrase came back every other time,
// as a knock-out leaves a voice three phrases and the draw kept out the last one only, and the same take of it with it.
// A draw by rounds kept the phrases of knock-outs ahead of the others, kills taking them again as soon as their round
// was over (measure of 19 November 2026: the most said phrase of 35 lines, 9.4 on average, 8.2 by rounds, 6.3 so).
// Each phrase and each take is known by a key, a phrase by its enum value, a take by its place in ExecutionLinesTable;
// `counts` holds a count for each key, a key past its end counting 0 (the system keeps the counts: the executions'
// and the conclusions' in Occasion.reds and Conclusion.reds, the grab lines' own in GrabLine.reds).

// The keys of the allowed phrases, each once.
public func ExecutionLinesPhraseKeys(allowed: array<ExecutionLinesLine>) -> array<Int32> {
  let keys: array<Int32>;
  for line in allowed {
    let key: Int32 = EnumInt(line.phrase);
    if !ArrayContains(keys, key) {
      ArrayPush(keys, key);
    }
  }
  return keys;
}

// The keys of the allowed takes of that phrase.
public func ExecutionLinesTakeKeys(allowed: array<ExecutionLinesLine>, phrase: ExecutionLinesPhrase) -> array<Int32> {
  let table: array<ExecutionLinesLine> = ExecutionLinesTable();
  let keys: array<Int32>;
  let key: Int32 = 0;
  for line in table {
    if Equals(line.phrase, phrase) && ExecutionLinesAllowsTake(allowed, line.name) {
      ArrayPush(keys, key);
    }
    key += 1;
  }
  return keys;
}

public func ExecutionLinesAllowsTake(allowed: array<ExecutionLinesLine>, name: CName) -> Bool {
  for line in allowed {
    if Equals(line.name, name) {
      return true;
    }
  }
  return false;
}

public func ExecutionLinesCount(counts: array<Int32>, key: Int32) -> Int32 {
  if key >= 0 && key < ArraySize(counts) {
    return counts[key];
  }
  return 0;
}

// One of the keys counted fewest, `last` left out unless it is the only key, each as likely. `keys` is never empty
// here: each caller has checked that a line is allowed, and the phrase drawn is one of the allowed, so are its takes.
public func ExecutionLinesLeastSaid(keys: array<Int32>, counts: array<Int32>, last: Int32) -> Int32 {
  let others: array<Int32>;
  for key in keys {
    if key != last {
      ArrayPush(others, key);
    }
  }
  if ArraySize(others) == 0 {
    return last;
  }
  let low: Int32 = ExecutionLinesCount(counts, others[0]);
  for key in others {
    low = Min(low, ExecutionLinesCount(counts, key));
  }
  let least: array<Int32>;
  for key in others {
    if ExecutionLinesCount(counts, key) == low {
      ArrayPush(least, key);
    }
  }
  return least[RandRange(0, ArraySize(least))];
}

// The counts once `key` is said among `keys`: its count plus one, raised to the lowest count of the other keys, so that
// a phrase or take allowed again late in the load, or never allowed before, catches up with the others at once rather
// than being said every other time until it has.
public func ExecutionLinesCountsAfter(counts: array<Int32>, keys: array<Int32>, key: Int32) -> array<Int32> {
  let value: Int32 = ExecutionLinesCount(counts, key) + 1;
  let lowest: Int32 = -1;
  for other in keys {
    if other != key {
      let count: Int32 = ExecutionLinesCount(counts, other);
      if lowest < 0 || count < lowest {
        lowest = count;
      }
    }
  }
  return ExecutionLinesCountsWith(counts, key, Max(value, lowest));
}

// The counts with this value at `key`, the keys before it that had none counting 0. A key is a phrase's enum value or a
// place in the table, so that the counts never hold more than 23 or the table's number of lines.
public func ExecutionLinesCountsWith(counts: array<Int32>, key: Int32, value: Int32) -> array<Int32> {
  let after: array<Int32>;
  let size: Int32 = Max(ArraySize(counts), key + 1);
  let at: Int32 = 0;
  while at < size {
    ArrayPush(after, at == key ? value : ExecutionLinesCount(counts, at));
    at += 1;
  }
  return after;
}
