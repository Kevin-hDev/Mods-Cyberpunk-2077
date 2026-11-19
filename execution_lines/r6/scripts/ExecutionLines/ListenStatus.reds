// E3: a status effect of the Unconscious or Defeated type applied in V's name (evt.instigatorEntityID). Always
// non-lethal (conception, section 5). An effect of the Kill type reaches Kill, so E2 (ListenKill.reds).

// The declaration is the game's own (NPCPuppet.script:1262, scripts 2.5). The plan leaves the order open: the game's
// work comes first and its result is the one returned, so that nothing of ours stands before a knock-out.
@wrapMethod(NPCPuppet)
protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
  let result: Bool = wrappedMethod(evt);
  ExecutionLinesHeardStatus(this, evt);
  return result;
}

// Called for each status effect on each person, the busiest of the listeners: the effect's type and the
// instigator are tested before any object is made or any setting read.
public func ExecutionLinesHeardStatus(victim: ref<NPCPuppet>, evt: ref<ApplyStatusEffectEvent>) -> Void {
  if !IsDefined(evt) || !IsDefined(evt.staticData) {
    return;
  }
  let kind: wref<StatusEffectType_Record> = evt.staticData.StatusEffectType();
  if !IsDefined(kind) {
    return;
  }
  let effect: gamedataStatusEffectType = kind.Type();
  if NotEquals(effect, gamedataStatusEffectType.Unconscious) && NotEquals(effect, gamedataStatusEffectType.Defeated) {
    return;
  }
  let instigatorID: EntityID = evt.instigatorEntityID;
  if !EntityID.IsDefined(instigatorID) {
    return;
  }
  let game: GameInstance = victim.GetGame();
  let player: ref<PlayerPuppet> = GetPlayer(game);
  if !IsDefined(player) {
    return;
  }
  let playerID: EntityID = player.GetEntityID();
  if NotEquals(instigatorID, playerID) {
    return;
  }
  if !ExecutionLinesListening() {
    return;
  }
  if !ExecutionLinesIsExecution(game, player, victim, "E3") {
    return;
  }
  ExecutionLinesOccasion(game, player, victim, false, "E3");
}
