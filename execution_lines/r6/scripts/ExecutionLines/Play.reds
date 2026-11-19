// The one script that reaches Audioware, which plays V's lines from the manifest of r6/audioware/ExecutionLines
// (voices.yml). Audioware is optional for the compiler: each function here exists with it and without it, where it
// does nothing, so that the mod compiles either way and a missing Audioware never stops the player's other mods.

@if(ModuleExists("Audioware"))
public func ExecutionLinesAudioThere() -> Bool {
  return true;
}

@if(!ModuleExists("Audioware"))
public func ExecutionLinesAudioThere() -> Bool {
  return false;
}

// On V's entity, named as Audioware asks of a line played on an entity, else it warns in its own log. Each name holds
// one recording of the voice this mod chose (Voice.reds): none is declared for both voices, so that Audioware never
// picks the voice by the gender it keeps from one game to the next (the error of 19 November 2026 on V's voice).
@if(ModuleExists("Audioware"))
public func ExecutionLinesPlay(player: ref<GameObject>, line: CName) -> Void {
  if !IsDefined(player) {
    return;
  }
  GameInstance.GetAudioSystemExt(player.GetGame()).Play(line, player.GetEntityID(), n"V");
}

@if(!ModuleExists("Audioware"))
public func ExecutionLinesPlay(player: ref<GameObject>, line: CName) -> Void {}
