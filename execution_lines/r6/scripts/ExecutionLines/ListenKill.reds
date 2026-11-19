// E2: a person killed in V's name by a direct call, or by a status effect of the Kill type. Always lethal (conception,
// section 5). The effect goes through the parent's handler (NPCPuppet.script:1355, then scriptedPuppet.script:1921-1926),
// which calls Kill: read in the code, never tried in game. The decompiled scripts write that parent call as
// this.OnStatusEffectApplied.

// The declaration is the game's own (NPCPuppet.script:641, scripts 2.5). The plan hears the kill before the game's
// work: the game's first condition, the person invulnerable, is read on the same state the game reads it on. The
// game's work is called once whatever we found, with the three parameters received.
@wrapMethod(NPCPuppet)
public func Kill(opt instigator: wref<GameObject>, opt skipNPCDeathAnim: Bool, opt disableNPCRagdoll: Bool) -> Void {
  ExecutionLinesHeardKill(this, instigator);
  wrappedMethod(instigator, skipNPCDeathAnim, disableNPCRagdoll);
}

// Called at each kill of any person by anyone: the instigator test, which reads nothing from the game, comes first.
public func ExecutionLinesHeardKill(victim: ref<NPCPuppet>, instigator: wref<GameObject>) -> Void {
  if !IsDefined(instigator) || !instigator.IsPlayer() {
    return;
  }
  if !ExecutionLinesListening() {
    return;
  }
  let game: GameInstance = victim.GetGame();
  let system: ref<ExecutionLinesSystem> = ExecutionLinesSystemOf(game);
  let most: Int32 = ExecutionLinesLogMost();
  // The game calls Kill(V, true, true) again, whatever the person's state, on a body put into a container
  // (disposalDevice.script:268): a person already dead is no execution.
  if victim.IsDead() {
    if IsDefined(system) && system.alreadyDeadLines <= most {
      system.alreadyDeadLines = ExecutionLinesLogUpTo(system.alreadyDeadLines, most, "kills in V's name on a person already dead", "kill in V's name on a person already dead: not an execution, heard by E2");
    }
    return;
  }
  // The game's own first condition (NPCPuppet.script:642): it returns without killing, so there is no kill to speak of.
  // Read on GetOwner() as the game reads it: GetOwner is native, so whether it is always the person cannot be read.
  let owner: wref<GameObject> = victim.GetOwner();
  if IsDefined(owner) && ExecutionLinesInvulnerable(game, owner) {
    if IsDefined(system) && system.invulnerableLines <= most {
      system.invulnerableLines = ExecutionLinesLogUpTo(system.invulnerableLines, most, "kills in V's name refused by the game", "kill in V's name refused by the game, the person is invulnerable: not an execution, heard by E2");
    }
    return;
  }
  let player: ref<GameObject> = instigator;
  if !ExecutionLinesIsExecution(game, player, victim, "E2") {
    return;
  }
  ExecutionLinesOccasion(game, player, victim, true, "E2");
}

public func ExecutionLinesInvulnerable(game: GameInstance, owner: wref<GameObject>) -> Bool {
  let ownerID: EntityID = owner.GetEntityID();
  return GameInstance.GetStatsSystem(game).GetStatValue(Cast<StatsObjectID>(ownerID), gamedataStatType.IsInvulnerable) > 0.00;
}
