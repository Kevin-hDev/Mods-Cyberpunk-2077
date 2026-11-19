// The player is told once a load that Audioware is missing (conception, section 9, and rules 6 and 14 of the root
// conception.md): without it V says nothing, and silence with no word would read as a bug. The game's own on-screen
// message, for a few seconds; where the game puts it on screen is not yet seen in a trial of this mod.

public func ExecutionLinesNoticeSeconds() -> Float {
  return 10.0;
}

// Once a load at most: the system is made again at each load (System.reds).
public func ExecutionLinesNoticeNoAudioware(system: ref<ExecutionLinesSystem>, game: GameInstance) -> Void {
  if system.noticeTold {
    return;
  }
  system.noticeTold = true;
  ExecutionLinesTellOnScreen(game, ExecutionLinesNoAudiowareText());
}

// The text in the player's language, from the translations of Texts.reds, which Codeware registers.
@if(ModuleExists("Codeware.Localization"))
public func ExecutionLinesNoAudiowareText() -> String {
  return GetLocalizedTextByKey(n"ExecutionLines-NoAudioware");
}

// Without Codeware no translation is registered, and what the game's lookup gives for an unknown key cannot be read
// outside the game: the English sentence is written here a second time, so that the player still reads the true cause
// rather than an empty message or a key. fabrique/test_texts.py checks that it stays the same as the English of
// Texts.reds.
@if(!ModuleExists("Codeware.Localization"))
public func ExecutionLinesNoAudiowareText() -> String {
  return "Execution Lines: Audioware is not installed, V's lines cannot be heard. Install Audioware to hear them.";
}

public func ExecutionLinesTellOnScreen(game: GameInstance, text: String) -> Void {
  let message: SimpleScreenMessage;
  message.isShown = true;
  message.isInstant = true;
  message.duration = ExecutionLinesNoticeSeconds();
  message.message = text;
  let notifications: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).Get(GetAllBlackboardDefs().UI_Notifications);
  if IsDefined(notifications) {
    notifications.SetVariant(GetAllBlackboardDefs().UI_Notifications.OnscreenMessage, ToVariant(message), true);
  }
}
