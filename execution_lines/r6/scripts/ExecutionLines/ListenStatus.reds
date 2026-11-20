// Two listeners on the status effects applied to a person. E3: an effect of the Unconscious or Defeated type applied
// in V's name (evt.instigatorEntityID). Always non-lethal (conception, section 5). An effect of the Kill type reaches
// Kill, so E2 (ListenKill.reds). E5: the start of an execution played by a mod that plays its own execution
// animations, which applies DefeatedFinisherWorkspot to the person just before it starts; the outcome that follows,
// heard by E2 or E3, finds the person counted.

// The declaration is the game's own (NPCPuppet.script:1262, scripts 2.5). The plan leaves the order open: the game's
// work comes first and its result is the one returned, so that nothing of ours stands before a knock-out.
@wrapMethod(NPCPuppet)
protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
  let result: Bool = wrappedMethod(evt);
  ExecutionLinesHeardStatus(this, evt);
  return result;
}

// Called for each status effect on each person, the busiest of the listeners: for E3, the effect's identifier, its type
// and the instigator are tested before any object is made or any setting read. E5's effect is tested on its identifier
// alone, and E5 reads the settings first.
public func ExecutionLinesHeardStatus(victim: ref<NPCPuppet>, evt: ref<ApplyStatusEffectEvent>) -> Void {
  if !IsDefined(evt) || !IsDefined(evt.staticData) {
    return;
  }
  // Never an occasion of E3, whoever applied it. The game applies it too at the start of its own finishers
  // (finisher.script:18) without an instigator, through the two-parameter StatusEffectHelper.ApplyStatusEffect
  // (statusEffectSystem.script:4-7), so E3 never made an occasion of it before E5 either.
  if evt.staticData.GetID() == t"BaseStatusEffect.DefeatedFinisherWorkspot" {
    ExecutionLinesHeardFinisherStart(victim);
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

// A mod that plays its own execution animations sets this quest fact to 1 for the length of each attempt; read in its
// files on 20 November 2026. Without the fact at that value E5 does nothing, so that the game's finishers, which apply
// the same effect (finisher.script:18), are heard as before, by E2 or E3 at their outcome. The game keeps a quest fact
// in the save: a game saved during an attempt and loaded without that mod would keep the fact at 1, and E5 would then
// hear the start of the game's finishers, as an occasion chosen by the weapon in V's hand. Not tried in game.
public func ExecutionLinesOtherModExecutingFact() -> String {
  return "xn_td_active";
}

public func ExecutionLinesOtherModExecutingValue() -> Int32 {
  return 1;
}

// No workspot nor reach test, unlike E2 and E3: V is not in the workspot yet, and the fact already says an execution
// starts. The mod's state comes first, as in every listener (ListenRule.reds); then the fact, the exit of every game
// finisher, before the player, there at nearly every call.
// Every start is an occasion, a weapon in V's hand or not, and the listener's text names the weapon, so that the log
// tells which weapon each line was chosen with. Verified in game on 20 November 2026: that mod's own animations kill,
// and are often played with a weapon in V's hand; with a katana, the game's finisher it plays killed nine times in nine,
// with a two-handed club it knocked out three times in three.
public func ExecutionLinesHeardFinisherStart(victim: ref<NPCPuppet>) -> Void {
  if !ExecutionLinesListening() {
    return;
  }
  let game: GameInstance = victim.GetGame();
  if GameInstance.GetQuestsSystem(game).GetFactStr(ExecutionLinesOtherModExecutingFact()) != ExecutionLinesOtherModExecutingValue() {
    return;
  }
  let player: ref<PlayerPuppet> = GetPlayer(game);
  if !IsDefined(player) {
    return;
  }
  let weapon: ref<WeaponObject> = GameObject.GetActiveWeapon(player);
  if !IsDefined(weapon) {
    ExecutionLinesOccasion(game, player, victim, true, "E5, no weapon in hand");
    return;
  }
  let weaponType: gamedataItemType = WeaponObject.GetWeaponType(weapon.GetItemID());
  ExecutionLinesOccasion(game, player, victim, !ExecutionLinesFinisherStartKnocksOut(weaponType), "E5, weapon " + ExecutionLinesWeaponTypeText(weaponType));
}

// The weapons whose finisher knocks out, in that mod's path through the game's finisher: the two-handed and the
// one-handed club verified in game (20 November 2026), the hammer and the fists read in that mod's table. Not the
// game's IsBlunt (weapon.script:265-271), which counts the Gorilla Arms too, whose finisher kills in that table (read,
// not tried in game). Any other weapon is taken to kill: verified in game for the katana, the machete and the knife,
// not for the others.
public func ExecutionLinesFinisherStartKnocksOut(weaponType: gamedataItemType) -> Bool {
  return Equals(weaponType, gamedataItemType.Wea_Hammer) || Equals(weaponType, gamedataItemType.Wea_OneHandedClub) || Equals(weaponType, gamedataItemType.Wea_TwoHandedClub) || Equals(weaponType, gamedataItemType.Wea_Fists);
}

// The type's name as the game declares it (orphans.script:1070), read the way the game names it
// (craftingSystem.script:222).
public func ExecutionLinesWeaponTypeText(weaponType: gamedataItemType) -> String {
  return EnumValueToString("gamedataItemType", Cast<Int64>(EnumInt(weaponType)));
}
