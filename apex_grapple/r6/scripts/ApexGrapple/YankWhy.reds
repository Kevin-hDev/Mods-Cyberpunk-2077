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

// Thrown into a wall or a car between them and V, the person would stop there: the way must be clear at chest height.
public func ApexGrappleYankWayBlocked(person: ref<GameObject>, spot: Vector4, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let up: Vector4 = DefaultTransition.GetUpVector() * ApexGrappleYankChestUp();
  return ApexGrappleWayBlockedBetween(person.GetWorldPosition() + up, spot + up, scriptInterface);
}

// Scenery, a movable object or a vehicle between the two points.
public func ApexGrappleWayBlockedBetween(from: Vector4, to: Vector4, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  return TraceResult.IsValid(scriptInterface.RaycastWithASingleGroup(from, to, n"Static")) || TraceResult.IsValid(scriptInterface.RaycastWithASingleGroup(from, to, n"Dynamic")) || TraceResult.IsValid(scriptInterface.RaycastWithASingleGroup(from, to, n"Vehicle"));
}

// Why this person cannot be pulled to V; empty when they can.
public func ApexGrappleCannotYank(person: ref<GameObject>, feet: Vector4, hanging: Bool, scriptInterface: ref<StateGameScriptInterface>, out spot: Vector4) -> String {
  let game: GameInstance = scriptInterface.GetGame();
  if !IsDefined(person as NPCPuppet) {
    return "not a person the game throws";
  }
  if !ScriptedPuppet.CanRagdoll(person) {
    return "the game keeps this person from falling: " + ApexGrappleNoFallRule(person, game);
  }
  if VehicleComponent.IsMountedToVehicle(game, person) {
    return "in a vehicle";
  }
  let held: String = ApexGrappleHeldBy(person, game);
  if StrLen(held) > 0 {
    return held;
  }
  if ApexGrappleAlreadyByV(person, feet) {
    return "already by V";
  }
  if !ApexGrappleYankSpot(person, feet, hanging, scriptInterface, spot) {
    return hanging ? "no ground within " + ToString(ApexGrappleYankGroundBelow()) + " m under V where they could stand" : "no ground by V where they could stand";
  }
  if ApexGrappleYankWayBlocked(person, spot, scriptInterface) {
    return "something in the way between them and V";
  }
  return "";
}

public func ApexGrappleWhoText(person: ref<GameObject>) -> String {
  let puppet: ref<ScriptedPuppet> = person as ScriptedPuppet;
  return "crowd " + ToString(puppet.IsCrowd()) + ", alive " + ToString(ScriptedPuppet.IsAlive(person)) + ", rarity " + NameToString(EnumValueToName(n"gamedataNPCRarity", Cast<Int64>(EnumInt(puppet.GetNPCRarity()))));
}

// Which of the game's rules keeps this person from falling (ScriptedPuppet.CanRagdoll, NPCPuppet.CanEnableRagdollComponent),
// for the log: the fifth test refused 13 people this way without saying why.
public func ApexGrappleNoFallRule(person: ref<GameObject>, game: GameInstance) -> String {
  let puppet: ref<ScriptedPuppet> = person as ScriptedPuppet;
  let gods: ref<GodModeSystem> = GameInstance.GetGodModeSystem(game);
  if Equals(puppet.GetNPCRarity(), gamedataNPCRarity.MaxTac) && !puppet.GetPS().GetWasIncapacitated() {
    return "MaxTac";
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
  return "its fall switched off";
}

// A scene, a dialogue, or a posed animation a mission counts on holds this person: taken out of it, a mission could
// break. Any other posed animation, standing guard included, is left by the person before the pull (Yank.reds). The
// game marks a person a mission needs (gameObject.script:2121, scriptedPuppet.script:3013); one moving freely, as a
// contract's enemies, is pulled. Which test answered, and whether they were posed, goes to the log: the sixth test
// refused two police officers as "a scene or a dialogue" without saying which.
public func ApexGrappleHeldBy(person: ref<GameObject>, game: GameInstance) -> String {
  let scenes: ref<SceneSystemInterface> = GameInstance.GetSceneSystem(game).GetScriptInterface();
  let posed: Bool = GameInstance.GetWorkspotSystem(game).IsActorInWorkspot(person);
  if scenes.IsEntityInScene(person.GetEntityID()) {
    return "playing a scene, posed " + ToString(posed);
  }
  if scenes.IsEntityInDialogue(person.GetEntityID()) {
    return "in a dialogue, posed " + ToString(posed);
  }
  if posed && person.IsQuest() {
    return "posed where a mission needs them";
  }
  return "";
}
