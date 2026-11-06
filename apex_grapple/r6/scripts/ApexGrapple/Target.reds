// A vehicle or a person taken by the hook ("Grapple onto vehicles and people", docs/apex-grapple/
// vehicules-et-personnes/conception.md). The hook follows them: the anchor is worked out again each frame of its
// flight and pull, on a person's chest, or on the vehicle at the point hit, kept in the vehicle's own frame.

// Codeware reads what a ray hit; without it no hook or rope is drawn either (Prerequisites.reds).
@if(ModuleExists("Codeware"))
public func ApexGrappleTargetsAvailable() -> Bool {
  return true;
}

@if(!ModuleExists("Codeware"))
public func ApexGrappleTargetsAvailable() -> Bool {
  return false;
}

@if(ModuleExists("Codeware"))
public func ApexGrappleHitObject(hit: TraceResult) -> ref<GameObject> {
  if !TraceResult.IsValid(hit) {
    return null;
  }
  return TraceResult.GetHitEntity(hit) as GameObject;
}

@if(!ModuleExists("Codeware"))
public func ApexGrappleHitObject(hit: TraceResult) -> ref<GameObject> {
  return null;
}

// A person or a vehicle: what the hook may follow.
public func ApexGrappleIsTarget(object: ref<GameObject>) -> Bool {
  return IsDefined(object as ScriptedPuppet) || IsDefined(object as VehicleObject);
}

// Where a person's chest is when its slot cannot be read: above their feet, for a standing person.
public func ApexGrappleChestHeight() -> Float {
  return 1.3;
}

// The slot the game's own AI aims a throw at (AIActionHelper.GetTargetSlotPosition, scripts 2.5).
public func ApexGrappleChestOf(person: ref<GameObject>) -> Vector4 {
  let chest: Vector4;
  if AIActionHelper.GetTargetSlotPosition(person, n"Chest", chest) {
    return chest;
  }
  return person.GetWorldPosition() + DefaultTransition.GetUpVector() * ApexGrappleChestHeight();
}

public func ApexGrappleAimAtPerson(person: ref<GameObject>, from: Vector4) -> ApexGrappleAim {
  let aim: ApexGrappleAim;
  aim.found = true;
  aim.target = person;
  aim.person = true;
  aim.anchor = ApexGrappleChestOf(person);
  aim.distance = Vector4.Distance(from, aim.anchor);
  aim.seen = "a person " + ToString(aim.distance) + " m away";
  return aim;
}

public func ApexGrappleAimAtVehicle(vehicle: ref<GameObject>, hit: TraceResult, from: Vector4) -> ApexGrappleAim {
  let aim: ApexGrappleAim;
  aim.found = true;
  aim.target = vehicle;
  aim.anchor = Vector4.Vector3To4(hit.position);
  aim.local = WorldTransform.TransformInvPoint(vehicle.GetWorldTransform(), aim.anchor);
  aim.distance = Vector4.Distance(from, aim.anchor);
  aim.seen = "a vehicle " + ToString(aim.distance) + " m away";
  return aim;
}

// Only humans and androids come, bosses never: drones, spider bots and mechs do not stand and walk as a person does, and
// moving a boss could break a fight the game wrote.
public func ApexGrappleComesToV(settings: ref<ApexGrappleSettings>, aim: ApexGrappleAim) -> Bool {
  if !settings.pullPeople || !aim.person {
    return false;
  }
  let puppet: ref<ScriptedPuppet> = aim.target as ScriptedPuppet;
  return IsDefined(puppet) && puppet.IsHumanoid() && !puppet.IsBoss();
}

public func ApexGrappleTakeTarget(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, aim: ApexGrappleAim) -> Void {
  system.target = aim.target;
  system.onTarget = IsDefined(aim.target);
  system.targetPerson = aim.person;
  system.targetLocal = aim.local;
  system.comesToV = system.onTarget && ApexGrappleComesToV(settings, aim);
}

// For the shot's line.
public func ApexGrappleTargetText(system: ref<ApexGrappleSystem>) -> String {
  if !system.onTarget {
    return "";
  }
  return system.comesToV ? ", pulled to V" : ", V pulled to it";
}

// Faster than this, the target was moved by the game, not by its own motion: a passer-by put back on their path, a
// person respawned. Followed, the rope would whip across the street. A speed, not a distance a frame: a long frame
// behind a fast car would read as a jump (the audit of 2 November 2026). Under the shortest frame counted, a frame
// tells nothing.
public func ApexGrappleTargetJumpSpeed() -> Float {
  return 150.0;
}

public func ApexGrappleTargetShortestFrame() -> Float {
  return 0.005;
}

// Moves the anchor with the target; why the hook lets go, or empty.
public func ApexGrappleFollowTarget(system: ref<ApexGrappleSystem>, middle: Vector4, frame: Float) -> String {
  if !system.onTarget {
    return "";
  }
  let target: ref<GameObject> = system.target;
  if !IsDefined(target) {
    return "the target is gone";
  }
  let moved: Vector4;
  if system.targetPerson {
    moved = ApexGrappleChestOf(target);
  } else {
    moved = WorldPosition.ToVector4(WorldTransform.TransformPoint(target.GetWorldTransform(), system.targetLocal));
  }
  // A person pulled to V is thrown by the grapple itself, faster than a jump: only once the pull has started. While
  // the hook flies, a jump lets go as for any target. The anchor is kept where it was, for the rope let go.
  let jump: Float = Vector4.Distance(system.anchor, moved);
  let thrown: Bool = system.phase == ApexGrapplePulling() && system.comesToV;
  if !thrown && frame >= ApexGrappleTargetShortestFrame() && jump / frame > ApexGrappleTargetJumpSpeed() {
    return "the target jumped " + ToString(jump) + " m in " + ToString(frame) + " s";
  }
  system.anchor = moved;
  if Vector4.Distance(middle, system.anchor) > system.settings.range {
    return "the target is out of range";
  }
  return "";
}
