// The one script that reaches Audioware, which plays V's lines from the manifest of r6/audioware/ExecutionLines
// (voices.yml) and stops them. Audioware is optional for the compiler: each function here exists with it and without
// it, where it does nothing, so that the mod compiles either way and a missing Audioware never stops the player's other
// mods. Speaking.reds is the one caller. Each of Audioware's types used here is imported, as Tween left out failed to
// compile on some passes ("unresolved type 'Tween'", redscript-cli, 20 November 2026).
@if(ModuleExists("Audioware"))
import Audioware.{Tween, LinearTween, AudioSettingsExt}

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
// `volume` goes from 0 to 1 (ExecutionLinesVolumeOf). At 1 the call is 1.0.1's, with no settings at all, so that the
// sound at 100 % is the one players had: Audioware's native code, which reads a settings object, cannot be read, and
// one is given only to lower the sound. The line type left unset is what Audioware's own short Play passes
// (Ext.reds:77-81, Audioware as installed in the game).
@if(ModuleExists("Audioware"))
public func ExecutionLinesPlay(player: ref<GameObject>, line: CName, volume: Float) -> Void {
  if !IsDefined(player) {
    return;
  }
  if volume >= 1.0 {
    GameInstance.GetAudioSystemExt(player.GetGame()).Play(line, player.GetEntityID(), n"V");
    return;
  }
  let dialogLine: scnDialogLineType;
  let ext: ref<AudioSettingsExt> = new AudioSettingsExt();
  ext.volume = volume;
  GameInstance.GetAudioSystemExt(player.GetGame()).Play(line, player.GetEntityID(), n"V", dialogLine, ext);
}

@if(!ModuleExists("Audioware"))
public func ExecutionLinesPlay(player: ref<GameObject>, line: CName, volume: Float) -> Void {}

// Stopped on the entity and under the names it was played with, fading out over `fadeSeconds` rather than cut, which
// would click (Audioware's Stop with a linear tween: Ext.reds:14, Tween.reds:16, Audioware as installed in the game).
@if(ModuleExists("Audioware"))
public func ExecutionLinesStop(player: ref<GameObject>, line: CName, fadeSeconds: Float) -> Void {
  if !IsDefined(player) {
    return;
  }
  GameInstance.GetAudioSystemExt(player.GetGame()).Stop(line, player.GetEntityID(), n"V", LinearTween.Immediate(fadeSeconds));
}

@if(!ModuleExists("Audioware"))
public func ExecutionLinesStop(player: ref<GameObject>, line: CName, fadeSeconds: Float) -> Void {}
