// The one script that reaches Audioware, which plays V's voice lines (Voice.reds). Audioware is optional: each function
// here exists for it and without it, where it does nothing, so the mod compiles and works the same without it.

@if(ModuleExists("Audioware"))
public func ApexGrappleVoiceThere() -> Bool {
  return true;
}

// On V's entity, named as Audioware asks of a line played on an entity, else it warns in its log. Each line holds one
// recording, of the voice the scripts chose (ApexGrappleVoiceFemaleOf, VoiceGender.reds): none is declared with fem and
// male for Audioware to pick by the gender it holds for the player. Kevin, 19 November 2026: a female V loaded after a
// male V in the same session said the lines so declared in the male voice. Cause read in the scripts the same day:
// Codeware tells a gender only when it changes and starts from female at each load; Audioware is told once a launch
// (Audioware/Codeware.reds, Session/Ready run once) and at each change, and keeps it from one game to the next.
@if(ModuleExists("Audioware"))
public func ApexGrappleVoicePlay(player: ref<GameObject>, line: CName) -> Void {
  if !IsDefined(player) {
    return;
  }
  GameInstance.GetAudioSystemExt(player.GetGame()).Play(line, player.GetEntityID(), n"V");
}

@if(!ModuleExists("Audioware"))
public func ApexGrappleVoiceThere() -> Bool {
  return false;
}

// Once a load, as Codeware's (Prerequisites.reds), rather than at each line left out.
@if(ModuleExists("Audioware"))
public func ApexGrappleSayWhatAudiowareGives() -> Void {}

@if(!ModuleExists("Audioware"))
public func ApexGrappleSayWhatAudiowareGives() -> Void {
  ApexGrappleLog("Audioware is not installed: V's voice lines are not heard");
}

@if(!ModuleExists("Audioware"))
public func ApexGrappleVoicePlay(player: ref<GameObject>, line: CName) -> Void {}
