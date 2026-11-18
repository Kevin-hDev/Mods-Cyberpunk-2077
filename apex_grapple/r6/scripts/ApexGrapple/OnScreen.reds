// The one way this mod puts a message on screen: the game's own on-screen message, for a few seconds. Each caller
// tells its message once at most (Impact.reds).

public func ApexGrappleMessageSeconds() -> Float {
  return 10.0;
}

public func ApexGrappleTellOnScreen(game: GameInstance, text: String) -> Void {
  let message: SimpleScreenMessage;
  message.isShown = true;
  message.isInstant = true;
  message.duration = ApexGrappleMessageSeconds();
  message.message = text;
  let notifications: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).Get(GetAllBlackboardDefs().UI_Notifications);
  if IsDefined(notifications) {
    notifications.SetVariant(GetAllBlackboardDefs().UI_Notifications.OnscreenMessage, ToVariant(message), true);
  }
}
