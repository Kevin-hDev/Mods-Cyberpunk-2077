// The player's choice for one phrase, read from the section of the voice that speaks and of the phrase's kind: the
// grab lines of that voice for a grab line, its execution lines otherwise. No call to the game. Each section's
// phrase-to-field pairs are written out here, and the compiler cannot tell a wrong pair: fabrique/test_texts.py runs
// this function against lines.py for every voice, phrase and Custom switch.

// Both when the section's Custom is off, so that only the global style counts, and for a phrase the section does not
// have: Chooses is recorded in the male voice only, Respect in the female voice only. The six phrases that are only
// conclusions have no field and get Both. Death and SweetDreams, also the conclusions of LockedIn, keep their
// execution fields: this function cannot tell a conclusion from an execution line, so whoever picks a conclusion
// must not call it (conception-saisies, 3.2, point 2).
public func ExecutionLinesChoiceOf(settings: ref<ExecutionLinesSettings>, phrase: ExecutionLinesPhrase, female: Bool) -> ExecutionLinesChoice {
  if ExecutionLinesIsGrab(phrase) {
    if female {
      return ExecutionLinesFemaleGrabChoice(settings, phrase);
    }
    return ExecutionLinesMaleGrabChoice(settings, phrase);
  }
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
    case ExecutionLinesPhrase.ExitLight:
      return settings.maleExitLight;
    case ExecutionLinesPhrase.KillOrBeKilled:
      return settings.maleKillOrBeKilled;
    case ExecutionLinesPhrase.NotPersonal:
      return settings.maleNotPersonal;
    case ExecutionLinesPhrase.OneOfUs:
      return settings.maleOneOfUs;
    case ExecutionLinesPhrase.SweetDreams:
      return settings.maleSweetDreams;
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
    case ExecutionLinesPhrase.ExitLight:
      return settings.femaleExitLight;
    case ExecutionLinesPhrase.KillOrBeKilled:
      return settings.femaleKillOrBeKilled;
    case ExecutionLinesPhrase.NotPersonal:
      return settings.femaleNotPersonal;
    case ExecutionLinesPhrase.Respect:
      return settings.femaleRespect;
    case ExecutionLinesPhrase.OneOfUs:
      return settings.femaleOneOfUs;
    case ExecutionLinesPhrase.SweetDreams:
      return settings.femaleSweetDreams;
    case ExecutionLinesPhrase.Death:
      return settings.femaleDeath;
    case ExecutionLinesPhrase.Soul:
      return settings.femaleSoul;
    default:
      return ExecutionLinesChoice.Both;
  }
}

public func ExecutionLinesMaleGrabChoice(settings: ref<ExecutionLinesSettings>, phrase: ExecutionLinesPhrase) -> ExecutionLinesChoice {
  if !settings.customMaleGrab {
    return ExecutionLinesChoice.Both;
  }
  switch phrase {
    case ExecutionLinesPhrase.Ticket:
      return settings.maleTicket;
    case ExecutionLinesPhrase.LockedIn:
      return settings.maleLockedIn;
    case ExecutionLinesPhrase.LetYouGo:
      return settings.maleLetYouGo;
    case ExecutionLinesPhrase.Scars:
      return settings.maleScars;
    case ExecutionLinesPhrase.Serious:
      return settings.maleSerious;
    default:
      return ExecutionLinesChoice.Both;
  }
}

public func ExecutionLinesFemaleGrabChoice(settings: ref<ExecutionLinesSettings>, phrase: ExecutionLinesPhrase) -> ExecutionLinesChoice {
  if !settings.customFemaleGrab {
    return ExecutionLinesChoice.Both;
  }
  switch phrase {
    case ExecutionLinesPhrase.Ticket:
      return settings.femaleTicket;
    case ExecutionLinesPhrase.LockedIn:
      return settings.femaleLockedIn;
    case ExecutionLinesPhrase.LetYouGo:
      return settings.femaleLetYouGo;
    case ExecutionLinesPhrase.Scars:
      return settings.femaleScars;
    case ExecutionLinesPhrase.Serious:
      return settings.femaleSerious;
    default:
      return ExecutionLinesChoice.Both;
  }
}
