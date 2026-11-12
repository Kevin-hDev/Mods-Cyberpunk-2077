// Why a person cannot be pulled to V (Yank.reds): then V is pulled to them, and the log says why and who.

// Nothing to pull: the person already stands about where a pull would leave them.
public func ApexGrappleAlreadyByV(person: ref<GameObject>, feet: Vector4) -> Bool {
  return Vector4.Length(ApexGrappleFlat(person.GetWorldPosition() - feet)) <= ApexGrappleYankStop() + 0.5;
}

// V hanging on a ladder or a wall: the ground under V is looked for this far down. Wall Climb holds V on a wall up to
// 3.5 m above where the climb began (Kevin's setting); at V's own height the spot was in the air, and every person
// shot from the wall in game pulled V instead (docs/apex-grapple/echelle/conception.md).
public func ApexGrappleYankGroundBelow() -> Float {
  return 5.0;
}

// The ground under a point, down to ApexGrappleYankGroundBelow(); the point itself when there is none.
public func ApexGrappleGroundUnder(point: Vector4, scriptInterface: ref<StateGameScriptInterface>) -> Vector4 {
  let below: Vector4 = point - DefaultTransition.GetUpVector() * ApexGrappleYankGroundBelow();
  let hit: TraceResult = scriptInterface.RaycastWithASingleGroup(point, below, n"Static");
  if !TraceResult.IsValid(hit) {
    return point;
  }
  return Vector4.Vector3To4(hit.position);
}

// A spot by V on the person's side where the AI can stand: left off its navigation mesh, the game puts a person back
// toward the last place they could stand (aiStatusEffectTask.script:272-343). None, and V is pulled to them instead.
// `hanging`: V on a ladder, the spot is looked for at V's height first (a catwalk or a roof edge by V), then on the
// ground under it.
public func ApexGrappleYankSpot(person: ref<GameObject>, feet: Vector4, hanging: Bool, scriptInterface: ref<StateGameScriptInterface>, out spot: Vector4) -> Bool {
  if ApexGrappleAlreadyByV(person, feet) {
    return false;
  }
  let away: Vector4 = ApexGrappleFlat(person.GetWorldPosition() - feet);
  let far: Float = Vector4.Length(away);
  let navigation: ref<AINavigationSystem> = GameInstance.GetAINavigationSystem(scriptInterface.GetGame());
  let extents: Vector4 = new Vector4(0.5, 0.5, 1.0, 1.0);
  let distance: Float = ApexGrappleYankStop();
  while distance <= ApexGrappleYankStop() + 2.0 && distance < far {
    let candidate: Vector4 = feet + away / far * distance;
    if navigation.IsPointOnNavmesh(person, candidate, extents, spot) {
      return true;
    }
    if hanging {
      if navigation.IsPointOnNavmesh(person, ApexGrappleGroundUnder(candidate, scriptInterface), extents, spot) {
        return true;
      }
    }
    distance += 1.0;
  }
  return false;
}

// A wall or a car between the person and V does not stop the pull: they crash into it, which is what the player aimed
// at. Kevin, 9 November 2026: refused, V herself was pulled and crashed into it instead, "c'est encore pire". A body
// stopped short ends the pull as late (YankFrame.reds), with no second push. What stood in the way goes to the log.
public func ApexGrappleYankWayBlock(person: ref<GameObject>, spot: Vector4, scriptInterface: ref<StateGameScriptInterface>) -> String {
  let up: Vector4 = DefaultTransition.GetUpVector() * ApexGrappleYankChestUp();
  return ApexGrappleWayBlock(person.GetWorldPosition() + up, spot + up, scriptInterface);
}

// Scenery, a movable object or a vehicle between the two points, with where and what; empty when the way is clear.
public func ApexGrappleWayBlock(from: Vector4, to: Vector4, scriptInterface: ref<StateGameScriptInterface>) -> String {
  let groups: array<CName> = [n"Static", n"Dynamic", n"Vehicle"];
  for group in groups {
    let hit: TraceResult = scriptInterface.RaycastWithASingleGroup(from, to, group);
    if TraceResult.IsValid(hit) {
      let object: ref<GameObject> = ApexGrappleHitObject(hit);
      let what: String = IsDefined(object) ? NameToString(object.GetClassName()) : "no object read";
      return NameToString(group) + " " + ToString(Vector4.Distance(from, Vector4.Vector3To4(hit.position))) + " m along a way of " + ToString(Vector4.Distance(from, to)) + " m (" + what + ", material " + NameToString(hit.material) + ")";
    }
  }
  return "";
}

// The reason given when no spot is found by V, V on the ground: one text, for the log and for what reads it.
public func ApexGrappleNoGroundByV() -> String {
  return "no ground by V where they could stand";
}

// Why this person cannot be pulled to V; empty when they can. A person on a vehicle is taken off it first
// (YankVehicle.reds), once the scenes are ruled out. Just taken off, they may still count as mounted this frame: the game
// itself sets a rider falling while still on the motorcycle (vehicleComponent.script:3615).
public func ApexGrappleCannotYank(person: ref<GameObject>, feet: Vector4, hanging: Bool, scriptInterface: ref<StateGameScriptInterface>, out spot: Vector4) -> String {
  let game: GameInstance = scriptInterface.GetGame();
  if !IsDefined(person as NPCPuppet) {
    return "not a person the game throws";
  }
  let held: String = ApexGrappleHeldBy(person, game);
  if StrLen(held) > 0 {
    return held;
  }
  let takenOff: String = ApexGrappleTakeOffVehicle(person, game);
  if StrLen(takenOff) > 0 {
    ApexGrappleLog("person hooked on a vehicle: " + takenOff + ", still mounted " + ToString(VehicleComponent.IsMountedToVehicle(game, person)));
  }
  if !ScriptedPuppet.CanRagdoll(person) {
    let rule: String = ApexGrappleNoFallRule(person, game);
    if StrLen(rule) > 0 {
      return "the game keeps this person from falling: " + rule;
    }
    if !VehicleComponent.IsMountedToVehicle(game, person) {
      return "the game keeps this person from falling: its fall switched off";
    }
    if StrLen(takenOff) == 0 {
      return "sitting in a vehicle";
    }
  }
  if ApexGrappleAlreadyByV(person, feet) {
    return "already by V";
  }
  if !ApexGrappleYankSpot(person, feet, hanging, scriptInterface, spot) {
    return hanging ? "no ground within " + ToString(ApexGrappleYankGroundBelow()) + " m under V where they could stand" : ApexGrappleNoGroundByV();
  }
  let block: String = ApexGrappleYankWayBlock(person, spot, scriptInterface);
  if StrLen(block) > 0 {
    ApexGrappleLog("something in the way between the person and V, pulled anyway: " + block);
  }
  return "";
}

public func ApexGrappleWhoText(person: ref<GameObject>) -> String {
  let puppet: ref<ScriptedPuppet> = person as ScriptedPuppet;
  return "crowd " + ToString(puppet.IsCrowd()) + ", alive " + ToString(ScriptedPuppet.IsAlive(person)) + ", rarity " + NameToString(EnumValueToName(n"gamedataNPCRarity", Cast<Int64>(EnumInt(puppet.GetNPCRarity()))));
}

// Which of the game's rules keeps this person from falling (ScriptedPuppet.CanRagdoll, NPCPuppet.CanEnableRagdollComponent),
// for the log: the fifth test refused 13 people this way without saying why. Empty for none of these: being on a vehicle,
// or the person's own fall switched off.
public func ApexGrappleNoFallRule(person: ref<GameObject>, game: GameInstance) -> String {
  let puppet: ref<ScriptedPuppet> = person as ScriptedPuppet;
  let gods: ref<GodModeSystem> = GameInstance.GetGodModeSystem(game);
  if Equals(puppet.GetNPCRarity(), gamedataNPCRarity.MaxTac) && !puppet.GetPS().GetWasIncapacitated() {
    return "MaxTac";
  }
  if puppet.IsBoss() && !puppet.GetPS().GetWasIncapacitated() {
    return "a boss";
  }
  if StatusEffectSystem.ObjectHasStatusEffect(puppet, t"WorkspotStatus.Death") {
    return "a death scene";
  }
  if puppet.HasWorkspotTag(n"FinisherWorkspot") {
    return "a finisher";
  }
  if gods.HasGodMode(person.GetEntityID(), gameGodModeType.Immortal) || gods.HasGodMode(person.GetEntityID(), gameGodModeType.Invulnerable) {
    return "made immortal by the game";
  }
  if StatusEffectSystem.ObjectHasStatusEffectWithTag(puppet, n"DisableRagdoll") {
    return "a status that forbids it";
  }
  return "";
}

// A scene, a dialogue, or a posed animation a mission counts on holds this person: taken out of it, a mission could
// break. Any other posed animation, standing guard included, is left by the person before the pull (Yank.reds). The
// game marks a person a mission needs (gameObject.script:2121, scriptedPuppet.script:3013); one moving freely, as a
// contract's enemies, is pulled. Which test answered, and whether they were posed, goes to the log: the sixth test
// refused two police officers as "a scene or a dialogue" without saying which.
// A scene or a dialogue only holds a person a mission needs, or any person while a scene holds V: the street's own
// talk, gang members or passers-by chatting, is a scene too, and refused them on 9 November 2026 (Kevin). Whether V is
// held is the game's own sign, the scene tiers in which it puts V's weapons away (2 to 5, IsInSafeSceneTier,
// defaultTransition.script:987, weaponTransitions.script:830). Not the scene system: it counted V in the gang
// members' talk, and refused 13 of 14 of them, in a fight too (second test of that day). A bullet takes such a person
// out of their scene anyway.
public func ApexGrappleSceneHoldsV(player: ref<GameObject>) -> Bool {
  let tier: Int32 = PlayerPuppet.GetSceneTier(player as PlayerPuppet);
  return tier > 1 && tier <= 5;
}

public func ApexGrappleHeldBy(person: ref<GameObject>, game: GameInstance) -> String {
  let scenes: ref<SceneSystemInterface> = GameInstance.GetSceneSystem(game).GetScriptInterface();
  let posed: Bool = GameInstance.GetWorkspotSystem(game).IsActorInWorkspot(person);
  let id: EntityID = person.GetEntityID();
  let player: ref<GameObject> = GetPlayer(game);
  let holdsV: Bool = IsDefined(player) && ApexGrappleSceneHoldsV(player);
  let held: Bool = person.IsQuest() || holdsV;
  let inScene: Bool = scenes.IsEntityInScene(id);
  let inDialogue: Bool = scenes.IsEntityInDialogue(id);
  if !inScene && !inDialogue {
    if posed && person.IsQuest() {
      return "posed where a mission needs them";
    }
    return "";
  }
  let detail: String = "posed " + ToString(posed) + ", needed by a mission " + ToString(person.IsQuest()) + ", V's scene tier " + ToString(PlayerPuppet.GetSceneTier(player as PlayerPuppet)) + ", V in the scene system " + ToString(IsDefined(player) && scenes.IsEntityInScene(player.GetEntityID())) + ", in a dialogue with V " + ToString(IsDefined(player) && scenes.AreEntitiesInDialogue(player.GetEntityID(), id));
  if held {
    return (inScene ? "playing a scene, " : "in a dialogue, ") + detail;
  }
  ApexGrappleLog("person in the street's own scene, pulled anyway: dialogue " + ToString(inDialogue) + ", " + detail);
  return "";
}
