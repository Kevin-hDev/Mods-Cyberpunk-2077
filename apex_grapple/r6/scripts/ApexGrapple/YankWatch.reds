// The few seconds after a person was pulled to V, for the log: where they stay, whether the game moves their body or
// their place in one frame, and where they get up. Kevin, 2 November 2026: passers-by only, never seen with the police,
// vanish, one still in the air, and show up again farther off, walking or running. Passers-by are moved by the crowd
// (TryStopTrafficMovement and the fear stages, CrowdMemberComponent), and their place runs off some 7 m in the first
// second while the body lies (the watch lines since the fourth test): which of the two the game moves is not yet seen.

// When the person is looked at again after the pull, in seconds.
public func ApexGrappleYankWatchAt(line: Int32) -> Float {
  if line == 0 {
    return 1.0;
  }
  if line == 1 {
    return 3.0;
  }
  return 6.0;
}

// A body lying, rolling or slid by the brake never covers this much in one frame, nor this fast: the game moved it.
// Both, so that a long frame after a hitch does not count.
public func ApexGrappleYankJump() -> Float {
  return 1.5;
}

public func ApexGrappleYankJumpSpeed() -> Float {
  return 30.0;
}

public func ApexGrappleYankJumped(moved: Float, step: Float) -> Bool {
  return moved > ApexGrappleYankJump() && moved > ApexGrappleYankJumpSpeed() * step;
}

// Lines of moves written for one pull: a place catching up with its body in a few long steps is not written on and on.
public func ApexGrappleYankMostJumpLines() -> Int32 {
  return 4;
}

// Around a point, the box where the AI must find ground it can stand on: a lying body's chest is 0.2 to 0.3 m up, a
// standing one's 1.3 m.
public func ApexGrappleYankStandBox() -> Vector4 {
  return new Vector4(0.5, 0.5, 1.5, 1.0);
}

public func ApexGrappleCanStandAt(person: ref<GameObject>, point: Vector4, game: GameInstance) -> Bool {
  return GameInstance.GetAINavigationSystem(game).IsPointOnNavmesh(person, point, ApexGrappleYankStandBox());
}

// The game's own test for a standing person in view (NPCPuppet.script:4263).
public func ApexGrappleOnScreen(person: ref<GameObject>, game: GameInstance) -> Bool {
  return GameInstance.GetCameraSystem(game).IsInCameraFrustum(person, 2.0, 0.75);
}

// From the chest to the last point where the AI stood, the one the game moves a person back toward.
public func ApexGrappleLastStandText(person: ref<GameObject>, chest: Vector4) -> String {
  let puppet: ref<ScriptedPuppet> = person as ScriptedPuppet;
  if !IsDefined(puppet) {
    return "unknown";
  }
  let last: Vector4 = puppet.GetLastValidNavmeshPoint();
  return ToString(Vector4.Distance(chest, last)) + " m";
}

// Whom the game holds for a death: for a fall blow, whoever set the body falling, else the person itself
// (NPCPuppet.script:2311).
public func ApexGrappleKillerText(person: ref<GameObject>) -> String {
  let npc: ref<NPCPuppet> = person as NPCPuppet;
  if !IsDefined(npc) {
    return "unknown";
  }
  let killer: ref<GameObject> = npc.GetMyKiller();
  if !IsDefined(killer) {
    return "no one known";
  }
  if Equals(killer.GetEntityID(), person.GetEntityID()) {
    return "itself";
  }
  return NameToString(killer.GetClassName());
}

public func ApexGrappleYankWatchStart(yank: ref<ApexGrappleYank>, person: ref<GameObject>, chest: Vector4, now: Float) -> Void {
  yank.watchFrom = now;
  yank.endChest = chest;
  yank.endPlace = person.GetWorldPosition();
  yank.watchLines = 0;
  yank.watchChest = chest;
  yank.watchPlace = yank.endPlace;
  yank.watchAt = now;
  yank.watchFallen = ApexGrappleFallen(person);
  yank.watchJumps = 0;
  yank.watchAlive = ScriptedPuppet.IsAlive(person);
  // The second brake (YankFlight.reds) is for a person braked by V: not for one slammed down, brought standing, or
  // let go of anywhere else.
  yank.brakedAgain = !yank.braked;
  if !yank.watchAlive {
    ApexGrappleLog("person pulled to V: dead at the pull's end, " + ApexGrappleWhoText(person));
    ApexGrappleLootLater(person);
  }
}

// Each frame of the watch: a move no body makes, the moment the person gets up, and a death.
public func ApexGrappleYankWatchMoves(system: ref<ApexGrappleSystem>, yank: ref<ApexGrappleYank>, person: ref<GameObject>, now: Float, game: GameInstance) -> Void {
  let chest: Vector4 = ApexGrappleChestOf(person);
  let place: Vector4 = person.GetWorldPosition();
  let fallen: Bool = ApexGrappleFallen(person);
  let moved: Float = Vector4.Distance(chest, yank.watchChest);
  let placeMoved: Float = Vector4.Distance(place, yank.watchPlace);
  let step: Float = now - yank.watchAt;
  let after: Float = now - yank.watchFrom;
  if (ApexGrappleYankJumped(moved, step) || ApexGrappleYankJumped(placeMoved, step)) && yank.watchJumps < ApexGrappleYankMostJumpLines() {
    yank.watchJumps += 1;
    ApexGrappleLog("person pulled to V: in " + ToString(step) + " s, " + ToString(after) + " s after, the body moved " + ToString(moved) + " m and its place " + ToString(placeMoved) + " m; the body is now " + ToString(Vector4.Length(ApexGrappleFlat(chest - yank.watchPlace))) + " m from where the place was, the place " + ToString(Vector4.Length(ApexGrappleFlat(place - yank.watchChest))) + " m from where the body was; ragdoll " + ToString(yank.watchFallen) + " then " + ToString(fallen) + ", the AI could stand where the body was " + ToString(ApexGrappleCanStandAt(person, yank.watchChest, game)) + " and at its place " + ToString(ApexGrappleCanStandAt(person, yank.watchPlace, game)) + ", " + ToString(Vector4.Distance(chest, yank.endChest)) + " m from where it stopped, on screen " + ToString(ApexGrappleOnScreen(person, game)));
  }
  if yank.watchFallen && !fallen {
    ApexGrappleLog("person pulled to V: got up " + ToString(after) + " s after, " + ToString(Vector4.Distance(chest, yank.endChest)) + " m from where it stopped, the AI can stand there " + ToString(ApexGrappleCanStandAt(person, chest, game)) + ", place " + ToString(Vector4.Length(ApexGrappleFlat(place - chest))) + " m from the chest, last point the AI stood " + ApexGrappleLastStandText(person, chest) + " away, on screen " + ToString(ApexGrappleOnScreen(person, game)));
  }
  if !yank.brakedAgain && after >= ApexGrappleYankBrakeAgainAfter() {
    ApexGrappleYankBrakeAgain(yank, person, chest, after);
  }
  let alive: Bool = ScriptedPuppet.IsAlive(person);
  if yank.watchAlive && !alive {
    ApexGrappleLog("person pulled to V: died " + ToString(after) + " s after, ragdoll " + ToString(fallen) + ", shielded " + ToString(ApexGrappleIsShielded(system, person.GetEntityID())) + ", held for it: " + ApexGrappleKillerText(person) + ", " + ApexGrappleWhoText(person));
    ApexGrappleLootLater(person);
  }
  yank.watchChest = chest;
  yank.watchPlace = place;
  yank.watchAt = now;
  yank.watchFallen = fallen;
  yank.watchAlive = alive;
}

// After the pull: where the person is, against where they stopped. Back at their old place would be the first test's
// flaw; walking or running off is the game's own reaction.
public func ApexGrappleYankWatch(system: ref<ApexGrappleSystem>, now: Float, game: GameInstance) -> Void {
  let yank: ref<ApexGrappleYank> = system.yank;
  if !IsDefined(yank) || yank.watchFrom <= 0.0 {
    return;
  }
  let person: ref<GameObject> = yank.person;
  if IsDefined(person) {
    ApexGrappleYankWatchMoves(system, yank, person, now, game);
  }
  if now - yank.watchFrom < ApexGrappleYankWatchAt(yank.watchLines) {
    return;
  }
  let after: Float = now - yank.watchFrom;
  yank.watchLines += 1;
  if yank.watchLines >= 3 || !IsDefined(person) {
    yank.watchFrom = 0.0;
  }
  if !IsDefined(person) {
    ApexGrappleLog("person pulled to V, " + ToString(after) + " s after: gone");
    return;
  }
  ApexGrappleLog("person pulled to V, " + ToString(after) + " s after: place " + ToString(Vector4.Distance(person.GetWorldPosition(), yank.endPlace)) + " m from its place then, chest " + ToString(Vector4.Distance(ApexGrappleChestOf(person), yank.endChest)) + " m from where it stopped, place " + ToString(Vector4.Length(ApexGrappleFlat(person.GetWorldPosition() - ApexGrappleChestOf(person)))) + " m from the chest, ragdoll " + ToString(ApexGrappleFallen(person)) + ", shielded " + ToString(ApexGrappleIsShielded(system, person.GetEntityID())) + ", kept updated off screen " + ToString(person.GetAnimationSystemForcedVisibilityManager().HasVisibilityForced(person.GetEntityID())) + ", " + ApexGrappleWhoText(person));
}
