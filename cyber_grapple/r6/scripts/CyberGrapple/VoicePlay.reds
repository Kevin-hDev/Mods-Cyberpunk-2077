// The one script that reaches Audioware, which plays V's voice lines (Voice.reds). Audioware is optional: each function
// here exists for it and without it, where it does nothing, so the mod compiles and works the same without it.

@if(ModuleExists("Audioware"))
public func CyberGrappleVoiceThere() -> Bool {
  return true;
}

// On V's entity, named as Audioware asks of a line played on an entity, else it warns in its log. Each line holds one
// recording, of the voice the scripts chose (CyberGrappleVoiceFemaleOf, VoiceGender.reds): none is declared with fem and
// male for Audioware to pick by the gender it holds for the player. Kevin, 19 November 2026: a female V loaded after a
// male V in the same session said the lines so declared in the male voice, while the lines our scripts chose were hers.
// Cause read on 19 November 2026: Codeware tells a gender only when it changes and starts from female at each load;
// Audioware keeps the one it was told from one game to the next.
@if(ModuleExists("Audioware"))
public func CyberGrappleVoicePlay(player: ref<GameObject>, line: CName) -> Void {
  if !IsDefined(player) {
    return;
  }
  GameInstance.GetAudioSystemExt(player.GetGame()).Play(line, player.GetEntityID(), n"V");
}

@if(!ModuleExists("Audioware"))
public func CyberGrappleVoiceThere() -> Bool {
  return false;
}

@if(!ModuleExists("Audioware"))
public func CyberGrappleVoicePlay(player: ref<GameObject>, line: CName) -> Void {}
