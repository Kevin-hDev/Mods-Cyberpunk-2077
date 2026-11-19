// E4: the game's execution by a container: V holds a person, then takes them down or knocks them out and hides them
// inside. Lethal unless the player chose to knock out. This path never calls DefeatTarget
// (disposalDevice.script:189-253), so E1 does not hear it.

// The declaration is the game's own (disposalDevice.script:199, scripts 2.5). The game's work comes first and nothing
// of ours stands before it: the game itself finds the person V holds and keeps them in m_npcBody (:209), read after.
// Once the animation ends the game kills that person in V's name, whatever the player chose (:268): E2 hears that kill,
// and it falls on "the same person was already counted" (Occasion.reds, step 2) or on E2's own rule.
@wrapMethod(DisposalDevice)
private final func TakedownAndDispose(isNonlethal: Bool) -> Void {
  wrappedMethod(isNonlethal);
  ExecutionLinesHeardDisposal(this.GetGame(), this.m_npcBody, isNonlethal);
}

// The player is read as the game reads it in TakedownAndDispose (:207).
public func ExecutionLinesHeardDisposal(game: GameInstance, body: wref<NPCPuppet>, isNonlethal: Bool) -> Void {
  if !ExecutionLinesListening() {
    return;
  }
  let player: ref<GameObject> = GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject();
  let victim: ref<GameObject> = body;
  ExecutionLinesOccasion(game, player, victim, !isNonlethal, "E4");
}
