// Which voice V says the lines in (Voice.reds): the menu's choice, else V's own, the same reading and rule as Cyber
// Grapple's (19 November 2026). The game keeps the voice chosen in its character creator apart from the body, and lets
// a V of either body have either voice: the creator's state holds both, the voice as the brain's gender
// (IsBodyGenderMale, IsBrainGenderMale). The body is the gender the game reads for V's head and clothes
// (GetResolvedGenderName). Until 19 November 2026 the lines followed the body alone, through Codeware.

// The menu's choice of voice (Kevin, 19 November 2026: "choix entre voix homme et femme, ca peux etre interessant pour
// des joueurs vu que les gens aiment bien changer de genre a la volé maintenant"): Automatic, the default, V's own
// voice; Feminine and Masculine, always that voice. Mod Settings keeps the player's choice under a member's name: a
// member is never renamed.
enum ApexGrappleVoiceGender {
  Auto = 0,
  Female = 1,
  Male = 2
}

// Whether the menu says the voice itself. Any other value, Automatic or one this mod does not know, leaves the voice
// to V, as the menu's default does.
public func ApexGrappleVoiceMenuSets(choice: ApexGrappleVoiceGender) -> Bool {
  return Equals(choice, ApexGrappleVoiceGender.Female) || Equals(choice, ApexGrappleVoiceGender.Male);
}

// The voice of every line, the pull's and the execution's: the menu's when it says one, without reading V, else V's
// own. Asked at each occasion with the settings the grapple took at its shot (Shot.reds), so that a change in the menu
// is heard from the next grapple on: an execution of a person already brought keeps the voice of the grapple that
// brought them.
public func ApexGrappleVoiceFemaleOf(choice: ApexGrappleVoiceGender, player: ref<GameObject>) -> Bool {
  if ApexGrappleVoiceMenuSets(choice) {
    return Equals(choice, ApexGrappleVoiceGender.Female);
  }
  return ApexGrappleVoiceFemale(player);
}

// What was read: the body's name as the game gives it, then the creator's state, when there is one.
public struct ApexGrappleVoiceRead {
  let bodyName: CName;
  let bodyMale: Bool;
  let stateThere: Bool;
  let stateBodyMale: Bool;
  let stateVoiceMale: Bool;
}

// Male for the name Male alone, as Codeware read it: a name not resolved keeps the female voice it gave.
public func ApexGrappleVoiceReadOf(puppet: ref<gamePuppet>) -> ApexGrappleVoiceRead {
  let read: ApexGrappleVoiceRead;
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
// female voice, the body's, as the lines did before. The game fills this state at a load and it follows the game
// loaded: a male V, then a female V loaded without quitting, each read right (Kevin's trials of 19 November 2026,
// releves/apex-grapple/2026-11-19-corrections-audit-repliques). It empties it when a new game starts
// (playerDevelopmentSystem.script:2779): a V just made keeps the voice of their body until a first load (read, not
// tried).
public func ApexGrappleVoiceFromState(read: ApexGrappleVoiceRead) -> Bool {
  return read.stateThere && Equals(read.stateBodyMale, read.bodyMale);
}

public func ApexGrappleVoiceMale(read: ApexGrappleVoiceRead) -> Bool {
  return ApexGrappleVoiceFromState(read) ? read.stateVoiceMale : read.bodyMale;
}

// Read at each occasion, never kept from the load. Without a player, the male voice: no line is played without one
// (VoicePlay.reds).
public func ApexGrappleVoiceFemale(player: ref<GameObject>) -> Bool {
  let puppet: ref<gamePuppet> = player as gamePuppet;
  if !IsDefined(puppet) {
    return false;
  }
  return !ApexGrappleVoiceMale(ApexGrappleVoiceReadOf(puppet));
}

// Once a load, as soon as V exists (the crosshair's attach, Crosshair.reds): what was read and the voice kept, by the
// same reading and rule as at each occasion, so that a trial with a V whose body and voice differ shows which of the
// two the lines follow, and whether profile 1's menu chose instead (the other profiles' choices are in the settings'
// line, Profiles.reds).
public func ApexGrappleVoiceTell(system: ref<ApexGrappleSystem>, player: ref<GameObject>) -> Void {
  let puppet: ref<gamePuppet> = player as gamePuppet;
  if !IsDefined(system) || system.voiceTold || !IsDefined(puppet) {
    return;
  }
  system.voiceTold = true;
  let read: ApexGrappleVoiceRead = ApexGrappleVoiceReadOf(puppet);
  let fromState: Bool = ApexGrappleVoiceFromState(read);
  let state: String = "is none";
  if read.stateThere {
    let says: String = "body " + ApexGrappleVoiceGenderText(read.stateBodyMale) + " and voice " + ApexGrappleVoiceGenderText(read.stateVoiceMale);
    state = fromState ? "says " + says : "disagrees on the body: it says " + says;
  }
  let choice: ApexGrappleVoiceGender = ApexGrappleVoiceGender.Auto;
  let settings: ref<ApexGrappleSettings> = ApexGrappleProfileSettings(system, 1);
  if IsDefined(settings) {
    choice = settings.voiceGender;
  }
  let voice: String = ApexGrappleVoiceFemaleOf(choice, player) ? "female" : "male";
  let source: String = ApexGrappleVoiceMenuSets(choice) ? "profile 1's menu choice" : "read from the " + (fromState ? "character's state" : "body");
  ApexGrappleLog("voice: V's body " + NameToString(read.bodyName) + ", the character's state " + state + ", lines of profile 1 said in the " + voice + " voice (" + source + ")");
}

public func ApexGrappleVoiceGenderText(male: Bool) -> String {
  return male ? "Male" : "Female";
}
