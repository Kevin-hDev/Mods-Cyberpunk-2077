// The one way this mod puts a message on screen: the game's own on-screen message, for a few seconds. Each caller
// tells its message once a load at most (Silence.reds, Upgrade.reds).

public func CyberGrappleMessageSeconds() -> Float {
  return 10.0;
}

public func CyberGrappleTellOnScreen(game: GameInstance, text: String) -> Void {
  let message: SimpleScreenMessage;
  message.isShown = true;
  message.isInstant = true;
  message.duration = CyberGrappleMessageSeconds();
  message.message = text;
  let notifications: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).Get(GetAllBlackboardDefs().UI_Notifications);
  notifications.SetVariant(GetAllBlackboardDefs().UI_Notifications.OnscreenMessage, ToVariant(message), true);
}
