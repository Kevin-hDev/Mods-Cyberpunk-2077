// The game's own grab on a person pulled to V ("Grab pulled people", docs/apex-grapple/saisie/conception.md). Two
// players asked for it; Kevin, 11 November 2026: by hand, with the game's grab key. Seen between the shot and the
// hook's bite (Kevin, 12 November 2026: "Oui on part sur avant que le crochet morde"; GrabKey.reds), the person is not
// thrown: the game's slide brings them standing to V (GrabCarry.reds, GrabSlide.reds), then V is sent the event the
// game sends on its "Grab" choice, and the game plays its grab to the end (GrabHold.reds). Not seen: the pull as it
// was. The 22 trials behind the rules of these files are in releves/apex-grapple/2026-11-11-saisie.

public class ApexGrappleGrab {
  // Grabs asked this load, for the log's lines.
  public let count: Int32;
  // The carry: going on, its pace, the spot in front of V, when it began, its limit and the latest that limit may be
  // pushed to, where the hook found the person, where V stood the frame before.
  public let carried: Bool;
  public let pace: Float;
  public let spot: Vector4;
  public let startedAt: Float;
  public let until: Float;
  public let longest: Float;
  public let from: Vector4;
  public let vAt: Vector4;
  // The person came by V with a leg still going: that leg was stopped, the event goes the frame after.
  public let byV: Bool;
  // A carry that fails may hand over to the plain pull: "Pull people to V" is on and it found a spot by V to throw
  // the person to (Yank.reds).
  public let canThrow: Bool;
  public let stunned: Bool;
  // The carry's last frame: a carry found again long after (V drove away meanwhile) no longer drops the person.
  public let frameAt: Float;
  // The slide and whose it is, the slides never let go of, the legs launched, when the last one was, and the leg the
  // AI's animation was last stopped for (GrabSlide.reds).
  public let slide: ref<ActionSlideToScriptProxy>;
  public let slideOf: wref<GameObject>;
  public let keeper: ref<ApexGrappleGrabKeeper>;
  public let legs: Int32;
  public let legAt: Float;
  public let clearedLeg: Int32;
  // After the event (GrabHold.reds): the person, when it was sent, the game's grab seen begun, since when V holds,
  // the person's fall cut, the body put away in a container by the game.
  public let person: wref<GameObject>;
  public let personID: EntityID;
  public let sentAt: Float;
  public let begun: Bool;
  public let heldAt: Float;
  public let cut: Bool;
  public let disposed: Bool;
  // The two execution choices (GrabChoices.reds): looked at, ours to make, tries, when the last one was, how many
  // the game's function made.
  public let choicesChecked: Bool;
  public let choicesOurs: Bool;
  public let choiceTries: Int32;
  public let choiceAt: Float;
  public let choicesMade: Int32;
  // A held person stopped existing (GrabLost.reds): when, and who.
  public let lostAt: Float;
  public let lostID: EntityID;
}

public func ApexGrappleGrabOf(system: ref<ApexGrappleSystem>) -> ref<ApexGrappleGrab> {
  if !IsDefined(system.grab) {
    system.grab = new ApexGrappleGrab();
  }
  return system.grab;
}

// Alive and out: knocked out, defeated, or what the game calls incapacitated.
public func ApexGrappleKnockedOut(person: ref<GameObject>) -> Bool {
  let npc: ref<NPCPuppet> = person as NPCPuppet;
  return IsDefined(npc) && ScriptedPuppet.IsAlive(person) && (ScriptedPuppet.IsUnconscious(person) || ScriptedPuppet.IsDefeated(person) || npc.IsIncapacitated());
}

// V's takedown state as the game holds it: 0 none, 2 V holds the person, 4 an execution. 0 when it cannot be read.
public func ApexGrappleTakedownOf(player: ref<GameObject>, game: GameInstance) -> Int32 {
  let defs: ref<AllBlackboardDefinitions> = GetAllBlackboardDefs();
  let boards: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(game);
  let board: ref<IBlackboard> = boards.GetLocalInstanced(player.GetEntityID(), defs.PlayerStateMachine);
  if !IsDefined(board) {
    return 0;
  }
  return board.GetInt(defs.PlayerStateMachine.Takedown);
}

// Where the game refuses its own grab to V (Takedown.Grapple's conditions on V, read in the game's data: not in a
// safe zone, no gameplay restriction): the event the mod sends goes past those conditions, so they are asked here.
// Empty when V may grab.
public func ApexGrappleGrabNotHere(player: ref<GameObject>, game: GameInstance) -> String {
  let defs: ref<AllBlackboardDefinitions> = GetAllBlackboardDefs();
  let boards: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(game);
  let board: ref<IBlackboard> = boards.GetLocalInstanced(player.GetEntityID(), defs.PlayerStateMachine);
  if IsDefined(board) && board.GetInt(defs.PlayerStateMachine.Zones) == EnumInt(gamePSMZones.Safe) {
    return "V is in a safe zone";
  }
  if StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"NoCombat") {
    return "the game forbids fighting here";
  }
  return "";
}

// Why this person is not grabbed, for the log; empty when they are. As the game for its own grab
// (scriptedPuppet.script:889-937): not the crowd's passers-by (Kevin, 12 November 2026: "on ne va pas chercher a
// saisir les passent dans la rue"), a massive enemy or a vendor; a boss never comes to V (Target.reds). The game gave
// up after 2 s on four people already knocked out (fourth trial), and a person already falling cannot be brought
// standing. A child, a companion of V's and a person the game keeps from dying are left out for the kill the mod
// offers on a held person (GrabChoices.reds): it must never reach them; so is a person friendly to V, whom the game's
// own grab refuses (its condition Takedown.IsTargetEnemy). From a ladder V cannot hold anyone. A person on a vehicle
// is not grabbed: the pull's test would throw them off it first (YankWhy.reds), and a falling person is not brought
// standing.
public func ApexGrappleCannotGrab(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, person: ref<GameObject>, hanging: Bool, player: ref<GameObject>) -> String {
  if !settings.grabPeople {
    return "switched off";
  }
  if !system.grabKeySeen {
    return "the grab key was not seen";
  }
  let puppet: ref<ScriptedPuppet> = person as ScriptedPuppet;
  if !IsDefined(puppet) || !ScriptedPuppet.IsAlive(person) {
    return "not a living person";
  }
  if hanging {
    return "V on a ladder";
  }
  let game: GameInstance = player.GetGame();
  let grab: ref<ApexGrappleGrab> = system.grab;
  if (IsDefined(grab) && grab.sentAt > 0.0) || ApexGrappleTakedownOf(player, game) != 0 {
    return "V already holds someone";
  }
  if IsDefined(grab) && !ApexGrappleGrabSlideFree(grab) {
    return "too many slides kept, until the game is loaded again";
  }
  let notHere: String = ApexGrappleGrabNotHere(player, game);
  if StrLen(notHere) > 0 {
    return notHere;
  }
  if puppet.IsCrowd() {
    return "a passer-by of the crowd";
  }
  if puppet.IsBoss() || puppet.IsMassive() {
    return "a boss or a massive enemy";
  }
  if puppet.IsVendor() {
    return "a vendor";
  }
  if puppet.IsCharacterChildren() {
    return "a child";
  }
  if puppet.IsPlayerCompanion() {
    return "a companion of V's";
  }
  if Equals(GameObject.GetAttitudeTowards(person, player), EAIAttitude.AIA_Friendly) {
    return "friendly to V";
  }
  if VehicleComponent.IsMountedToVehicle(game, person) {
    return "on a vehicle";
  }
  let gods: ref<GodModeSystem> = GameInstance.GetGodModeSystem(game);
  let id: EntityID = person.GetEntityID();
  if gods.HasGodMode(id, gameGodModeType.Immortal) || gods.HasGodMode(id, gameGodModeType.Invulnerable) {
    return "kept from dying by the game";
  }
  if ApexGrappleKnockedOut(person) {
    return "already knocked out";
  }
  if ApexGrappleFallen(person) {
    return "already falling";
  }
  return "";
}
