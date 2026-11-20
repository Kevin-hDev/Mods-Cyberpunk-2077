// V knocked down or dead: the line V says, whichever of this mod's lines it is, stops with a very short fade, and
// nothing is said after it (conception-saisies, section 3.4). A mere flinch under a blow does not stop V: it comes too
// often, and V can speak while taking a hit.

// The declaration is the game's own (player.script:4512, scripts 2.5). The game's work comes first and its result is
// the one returned.
@wrapMethod(PlayerPuppet)
protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
  let result: Bool = wrappedMethod(evt);
  ExecutionLinesHeardPlayerStatus(this, evt);
  return result;
}

// The declaration is the game's own (player.script:5644, scripts 2.5).
@wrapMethod(PlayerPuppet)
protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
  let result: Bool = wrappedMethod(evt);
  ExecutionLinesPlayerDown(this, "V died");
  return result;
}

// Called for each status effect applied to V: the effect's type is tested before anything else is read. Knockdown is
// the blast of an explosion or the blow of a heavy enemy, VehicleKnockdown a car; both are declared in
// gamedataStatusEffectType (orphans.script:4432, :4466), and the game tests them together (carriedObject.script:94).
// A bike: the game knocks V down with its own record, BaseStatusEffect.BikeKnockdown (player.script:6096), whose type
// the scripts do not show. Not verified that it is VehicleKnockdown.
public func ExecutionLinesHeardPlayerStatus(player: ref<PlayerPuppet>, evt: ref<ApplyStatusEffectEvent>) -> Void {
  if !IsDefined(evt) || !IsDefined(evt.staticData) {
    return;
  }
  let kind: wref<StatusEffectType_Record> = evt.staticData.StatusEffectType();
  if !IsDefined(kind) {
    return;
  }
  let effect: gamedataStatusEffectType = kind.Type();
  if NotEquals(effect, gamedataStatusEffectType.Knockdown) && NotEquals(effect, gamedataStatusEffectType.VehicleKnockdown) {
    return;
  }
  ExecutionLinesPlayerDown(player, Equals(effect, gamedataStatusEffectType.VehicleKnockdown) ? "V knocked down by a vehicle" : "V knocked down");
}

// The line playing is stopped whether the mod is on or not, since one said before it was switched off still plays
// (Speaking.reds writes its line). With nothing playing, a bounded line says the listener heard V go down, so that the
// trial tells a line already over from a listener that never runs; the mod off leaves no such line.
public func ExecutionLinesPlayerDown(player: ref<PlayerPuppet>, why: String) -> Void {
  let game: GameInstance = player.GetGame();
  let system: ref<ExecutionLinesSystem> = ExecutionLinesSystemOf(game);
  if !IsDefined(system) {
    return;
  }
  if ExecutionLinesSpeaking(system, ExecutionLinesNow(game)) {
    ExecutionLinesHush(game, player, why);
    return;
  }
  let most: Int32 = ExecutionLinesLogMost();
  if system.downQuietLines <= most && ExecutionLinesListening() {
    system.downQuietLines = ExecutionLinesLogUpTo(system.downQuietLines, most, "V down with no line playing", why + ": no voice line playing, nothing to stop");
  }
}
