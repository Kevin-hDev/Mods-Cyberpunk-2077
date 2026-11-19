// Which voice V says the lines in: the menu's choice, else V's own. The game keeps the voice chosen in its character
// creator apart from the body, and lets a V of either body have either voice: the creator's state holds both, the voice
// as the brain's gender (IsBrainGenderMale). The body is the gender the game reads for V's head and clothes
// (GetResolvedGenderName). Never a gender kept by a library: one kept from one game to the next gave a female V loaded
// after a male V the male voice (the error of 19 November 2026 on V's voice). Verified in game on 19 November 2026 with
// the same reading in another of our mods, for a V with a male body and a male voice: the state was filled in a loaded
// game and agreed on the body. Never tried for a V whose body and voice differ, nor in this mod, whose first trial
// checks it (conception, section 10, point 7).

// Whether the menu says the voice itself. Any other value, Automatic or one this mod does not know, leaves the voice to
// V, as the menu's default does.
public func ExecutionLinesVoiceMenuSets(choice: ExecutionLinesVoice) -> Bool {
  return Equals(choice, ExecutionLinesVoice.Female) || Equals(choice, ExecutionLinesVoice.Male);
}

// Asked with the setting as it stands at each occasion, so that a change in the menu is heard at the next line, and V
// read at each occasion, never kept from a load.
public func ExecutionLinesFemaleOf(choice: ExecutionLinesVoice, player: ref<GameObject>) -> Bool {
  if ExecutionLinesVoiceMenuSets(choice) {
    return Equals(choice, ExecutionLinesVoice.Female);
  }
  let puppet: ref<gamePuppet> = player as gamePuppet;
  if !IsDefined(puppet) {
    return false;
  }
  let read: ExecutionLinesVoiceRead = ExecutionLinesVoiceReadOf(puppet);
  return !ExecutionLinesVoiceMale(read);
}

// What was read: the body's name as the game gives it, then the creator's state, when there is one.
public struct ExecutionLinesVoiceRead {
  let bodyName: CName;
  let bodyMale: Bool;
  let stateThere: Bool;
  let stateBodyMale: Bool;
  let stateVoiceMale: Bool;
}

// Male for the name Male alone: a name not resolved gives the female voice.
public func ExecutionLinesVoiceReadOf(puppet: ref<gamePuppet>) -> ExecutionLinesVoiceRead {
  let read: ExecutionLinesVoiceRead;
  read.bodyName = puppet.GetResolvedGenderName();
  read.bodyMale = Equals(read.bodyName, n"Male");
  let creator: ref<gameuiICharacterCustomizationSystem> = GameInstance.GetCharacterCustomizationSystem(puppet.GetGame());
  if !IsDefined(creator) {
    return read;
  }
  let state: ref<gameuiICharacterCustomizationState> = creator.GetState();
  if !IsDefined(state) {
    return read;
  }
  read.stateThere = true;
  read.stateBodyMale = state.IsBodyGenderMale();
  read.stateVoiceMale = state.IsBrainGenderMale();
  return read;
}

// The state's voice is believed only when the state exists and says the body the game shows. A state left empty says
// female for both: for a male body it disagrees on the body, and the body is kept; for a female body it gives the
// female voice, the body's. The game filled this state in a loaded game on 19 November 2026 (male body and voice, see
// above); whether it is always filled, for every V, is not known, hence the rule.
public func ExecutionLinesVoiceFromState(read: ExecutionLinesVoiceRead) -> Bool {
  return read.stateThere && Equals(read.stateBodyMale, read.bodyMale);
}

public func ExecutionLinesVoiceMale(read: ExecutionLinesVoiceRead) -> Bool {
  return ExecutionLinesVoiceFromState(read) ? read.stateVoiceMale : read.bodyMale;
}

// Once a load, at the load's first occasion that reaches the voice (Occasion.reds, step 4): what was read and the voice
// kept, by the same reading and rule as at each occasion, so that a trial with a V whose body and voice differ shows
// which of the two the lines follow, and whether the menu chose instead.
public func ExecutionLinesVoiceTell(system: ref<ExecutionLinesSystem>, choice: ExecutionLinesVoice, player: ref<GameObject>) -> Void {
  let puppet: ref<gamePuppet> = player as gamePuppet;
  if system.voiceTold || !IsDefined(puppet) {
    return;
  }
  system.voiceTold = true;
  let read: ExecutionLinesVoiceRead = ExecutionLinesVoiceReadOf(puppet);
  let fromState: Bool = ExecutionLinesVoiceFromState(read);
  let state: String = "is none";
  if read.stateThere {
    let says: String = "body " + ExecutionLinesVoiceGenderText(read.stateBodyMale) + " and voice " + ExecutionLinesVoiceGenderText(read.stateVoiceMale);
    state = fromState ? "says " + says : "disagrees on the body: it says " + says;
  }
  let voice: String = ExecutionLinesFemaleOf(choice, player) ? "female" : "male";
  let source: String = ExecutionLinesVoiceMenuSets(choice) ? "the menu's choice" : "read from the " + (fromState ? "character's state" : "body");
  ExecutionLinesLog("voice: V's body " + NameToString(read.bodyName) + ", the character's state " + state + ", lines said in the " + voice + " voice (" + source + ")");
}

public func ExecutionLinesVoiceGenderText(male: Bool) -> String {
  return male ? "Male" : "Female";
}
