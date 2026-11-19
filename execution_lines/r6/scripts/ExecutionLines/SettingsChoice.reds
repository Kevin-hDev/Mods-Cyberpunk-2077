// The player's choice for one phrase, read from the section of the voice that speaks. No call to the game. Each
// voice's phrase-to-field pairs are written out here, and the compiler cannot tell a wrong pair: fabrique/test_texts.py
// checks them.

// Both when the section's Custom is off, so that only the global style counts, and for a phrase the voice does not
// have: Chooses is recorded in the male voice only, Respect in the female voice only.
public func ExecutionLinesChoiceOf(settings: ref<ExecutionLinesSettings>, phrase: ExecutionLinesPhrase, female: Bool) -> ExecutionLinesChoice {
  if female {
    return ExecutionLinesFemaleChoice(settings, phrase);
  }
  return ExecutionLinesMaleChoice(settings, phrase);
}

public func ExecutionLinesMaleChoice(settings: ref<ExecutionLinesSettings>, phrase: ExecutionLinesPhrase) -> ExecutionLinesChoice {
  if !settings.customMale {
    return ExecutionLinesChoice.Both;
  }
  switch phrase {
    case ExecutionLinesPhrase.Chooses:
      return settings.maleChooses;
    case ExecutionLinesPhrase.Insanity:
      return settings.maleInsanity;
    case ExecutionLinesPhrase.Impunity:
      return settings.maleImpunity;
    case ExecutionLinesPhrase.KillOrBeKilled:
      return settings.maleKillOrBeKilled;
    case ExecutionLinesPhrase.OneOfUs:
      return settings.maleOneOfUs;
    case ExecutionLinesPhrase.Death:
      return settings.maleDeath;
    case ExecutionLinesPhrase.Soul:
      return settings.maleSoul;
    default:
      return ExecutionLinesChoice.Both;
  }
}

public func ExecutionLinesFemaleChoice(settings: ref<ExecutionLinesSettings>, phrase: ExecutionLinesPhrase) -> ExecutionLinesChoice {
  if !settings.customFemale {
    return ExecutionLinesChoice.Both;
  }
  switch phrase {
    case ExecutionLinesPhrase.Insanity:
      return settings.femaleInsanity;
    case ExecutionLinesPhrase.Impunity:
      return settings.femaleImpunity;
    case ExecutionLinesPhrase.KillOrBeKilled:
      return settings.femaleKillOrBeKilled;
    case ExecutionLinesPhrase.Respect:
      return settings.femaleRespect;
    case ExecutionLinesPhrase.OneOfUs:
      return settings.femaleOneOfUs;
    case ExecutionLinesPhrase.Death:
      return settings.femaleDeath;
    case ExecutionLinesPhrase.Soul:
      return settings.femaleSoul;
    default:
      return ExecutionLinesChoice.Both;
  }
}
