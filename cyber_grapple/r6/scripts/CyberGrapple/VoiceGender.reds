// Which voice V says the lines in (Voice.reds): the menu's choice, else V's own. The game keeps the voice chosen in its
// character creator apart from the body, and lets a V of either body have either voice: the creator's state holds
// both, the voice as the brain's gender (IsBodyGenderMale, IsBrainGenderMale). The body is the gender the game reads
// for V's head and clothes (GetResolvedGenderName). Until 19 November 2026 the lines followed the body alone, through
// Codeware.

// The menu's choice of voice (Kevin, 19 November 2026, "choix entre voix homme et femme", for players who change V's
// gender as they go): Automatic, the default, V's own voice; Feminine and Masculine, always that voice. The menu's list
// is made from this enum (fabrique/grapple_settings.py), and Mod Settings keeps the player's choice under a member's
// name: a member is never renamed.
enum CyberGrappleVoiceGender {
  Auto = 0,
  Female = 1,
  Male = 2
}

// Whether the menu says the voice itself. Any other value, Automatic or one this mod does not know, leaves the voice
// to V, as the menu's default does.
public func CyberGrappleVoiceMenuSets(choice: CyberGrappleVoiceGender) -> Bool {
  return Equals(choice, CyberGrappleVoiceGender.Female) || Equals(choice, CyberGrappleVoiceGender.Male);
}

// The voice of every line, the pull's and the execution's: the menu's when it says one, without reading V, else V's
// own (CyberGrappleVoiceFemale). Asked with the setting as it stands at each occasion, so that a change in the menu is
// heard at the next line.
public func CyberGrappleVoiceFemaleOf(choice: CyberGrappleVoiceGender, player: ref<GameObject>) -> Bool {
  if CyberGrappleVoiceMenuSets(choice) {
    return Equals(choice, CyberGrappleVoiceGender.Female);
  }
  return CyberGrappleVoiceFemale(player);
}

// What was read: the body's name as the game gives it, then the creator's state, when there is one.
public struct CyberGrappleVoiceRead {
  let bodyName: CName;
  let bodyMale: Bool;
  let stateThere: Bool;
  let stateBodyMale: Bool;
  let stateVoiceMale: Bool;
}

// Male for the name Male alone, as Codeware read it: a name not resolved keeps the female voice it gave.
public func CyberGrappleVoiceReadOf(puppet: ref<gamePuppet>) -> CyberGrappleVoiceRead {
  let read: CyberGrappleVoiceRead;
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
// female voice, the body's, as the lines did before. The game fills this state after a load and it follows the game
// loaded (two trials in game, 19 November 2026); it empties it as a new game starts (playerDevelopmentSystem.script,
// RefreshDevelopmentSystemOnNewGameStarted), so a character just made keeps the voice of its body until a save is
// first loaded (read in the game's scripts, not tried).
public func CyberGrappleVoiceFromState(read: CyberGrappleVoiceRead) -> Bool {
  return read.stateThere && Equals(read.stateBodyMale, read.bodyMale);
}

public func CyberGrappleVoiceMale(read: CyberGrappleVoiceRead) -> Bool {
  return CyberGrappleVoiceFromState(read) ? read.stateVoiceMale : read.bodyMale;
}

// Read at each occasion, never kept from the load. Without a player, the male voice the lines had before: no line is
// played without one (VoicePlay.reds).
public func CyberGrappleVoiceFemale(player: ref<GameObject>) -> Bool {
  let puppet: ref<gamePuppet> = player as gamePuppet;
  if !IsDefined(puppet) {
    return false;
  }
  let read: CyberGrappleVoiceRead = CyberGrappleVoiceReadOf(puppet);
  return !CyberGrappleVoiceMale(read);
}

// Once a load, as soon as V exists, whether V wears the implant or not (the crosshair's attach in Crosshair.reds, a
// line patched in by fabrique/grapple_spec.py): what was read and the voice kept, by the same reading and rule as at
// each occasion, so that a trial with a V whose body and voice differ shows which of the two the lines follow, and
// whether the menu chose instead. The menu's choice as the system's copy of the settings holds it (SettingsCopy.reds),
// made before the crosshair attaches; Automatic before any copy.
public func CyberGrappleVoiceTell(system: ref<CyberGrappleSystem>, player: ref<GameObject>) -> Void {
  let puppet: ref<gamePuppet> = player as gamePuppet;
  if !IsDefined(system) || system.voiceTold || !IsDefined(puppet) {
    return;
  }
  system.voiceTold = true;
  let read: CyberGrappleVoiceRead = CyberGrappleVoiceReadOf(puppet);
  let fromState: Bool = CyberGrappleVoiceFromState(read);
  let state: String = "is none";
  if read.stateThere {
    let says: String = "body " + CyberGrappleVoiceGenderText(read.stateBodyMale) + " and voice " + CyberGrappleVoiceGenderText(read.stateVoiceMale);
    state = fromState ? "says " + says : "disagrees on the body: it says " + says;
  }
  let choice: CyberGrappleVoiceGender = CyberGrappleVoiceGender.Auto;
  if ArraySize(system.profiles) > 0 {
    let settings: ref<CyberGrappleSettings> = system.profiles[0];
    if IsDefined(settings) {
      choice = settings.voiceGender;
    }
  }
  let voice: String = CyberGrappleVoiceFemaleOf(choice, player) ? "female" : "male";
  let source: String = CyberGrappleVoiceMenuSets(choice) ? "the menu's choice" : "read from the " + (fromState ? "character's state" : "body");
  CyberGrappleLog("voice: V's body " + NameToString(read.bodyName) + ", the character's state " + state + ", lines said in the " + voice + " voice (" + source + ")");
}

public func CyberGrappleVoiceGenderText(male: Bool) -> String {
  return male ? "Male" : "Female";
}
