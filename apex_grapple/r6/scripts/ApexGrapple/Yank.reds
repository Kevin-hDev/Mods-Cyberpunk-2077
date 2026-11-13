// A person pulled to V ("Pull people to V", docs/apex-grapple/vehicules-et-personnes/conception.md): yanked off their
// feet and pushed at a speed of their own setting to a spot by V (YankSpot.reds), or wherever the aim sends them
// (YankDrive.reds, YankSteer.reds), then left to the game, which gets them up there. Kevin, 2 November 2026: "le
// grappin attrape et ramène ce qu'il attrape jusqu'à V", as in Apex Legends, and "c'est pas grave s'il meurt", with a
// setting for it (YankFlight.reds). The game would move no passer-by standing: its AI slide never started and 27 to 29
// AI teleports a pull moved no one (third test).
// With the game's grab key seen before the bite, a person the game lets be grabbed is brought standing instead, for
// the game's own grab (Grab.reds).

public class ApexGrappleYank {
  public let person: wref<GameObject>;
  // Kept apart: the request to keep the person updated off screen is ended by it, even once the person is gone.
  public let personID: EntityID;
  // Where the chest is pushed to, and the pushes (YankDrive.reds): the spot by V at chest height, or where the aim
  // sends it.
  public let drive: ref<ApexGrappleDrive>;
  // V's feet at the bite, for the log: how far V moved during the pull.
  public let feetAtBite: Vector4;
  // "Damage when pulling people": unprotected from what they hit.
  public let hurts: Bool;
  // "Slam at the end of the pull": at the goal, driven into the ground and not braked.
  public let slams: Bool;
  public let startedAt: Float;
  public let startGap: Float;
  // Braked on arriving by V: the brake is then given once more (YankFlight.reds).
  public let braked: Bool;
  // Times the fall was asked for again during the pull (ApexGrappleYankFallAgain).
  public let fallAsks: Int32;
  // The chest's speed, read frame to frame.
  public let lastChest: Vector4;
  public let lastAt: Float;
  public let velocity: Vector4;
  public let topSpeed: Float;
  // After the end, the person watched a few seconds for the log: do they stay where they were brought?
  public let watchFrom: Float;
  public let endChest: Vector4;
  public let endPlace: Vector4;
  public let watchLines: Int32;
  // The last frame watched: chest, place, ragdoll and when, to see the game move the person (YankWatch.reds).
  public let watchChest: Vector4;
  public let watchPlace: Vector4;
  public let watchAt: Float;
  public let watchFallen: Bool;
  public let watchJumps: Int32;
  public let watchAlive: Bool;
  public let brakedAgain: Bool;
}

// The person stops this close to V, along the ground.
public func ApexGrappleYankStop() -> Float {
  return 2.0;
}

// Where a person's chest is above their feet: the thrown chest's goal, and the ray that checks the way to V is clear.
public func ApexGrappleYankChestUp() -> Float {
  return 1.0;
}

public func ApexGrappleFlat(v: Vector4) -> Vector4 {
  let flat: Vector4 = v;
  flat.Z = 0.0;
  return flat;
}

// The hook bites a person who comes to V: pulled ("Pull people to V"), or, with that setting off, brought for the
// game's grab alone (Shot.reds). False, and V is pulled to them, when the game would not let it work.
public func ApexGrappleStartYank(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, now: Float, hanging: Bool, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let person: ref<GameObject> = system.target;
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let spot: Vector4;
  // "Pull people to V" for this shot: the person may be thrown to V.
  let pulls: Bool = system.comesToV;
  // The game's grab asked for and possible on this person (Grab.reds): brought standing, not thrown.
  let noGrab: String = IsDefined(person) ? ApexGrappleCannotGrab(system, settings, person, hanging, scriptInterface.executionOwner) : "the person is gone";
  let grabs: Bool = StrLen(noGrab) == 0;
  let why: String;
  // Asked before anything is done to the person: the pull's own test takes them off a vehicle (YankWhy.reds).
  if !pulls && !grabs {
    ApexGrappleLog("person not grabbed: " + noGrab + "; V is pulled to them" + (IsDefined(person) ? ", " + ApexGrappleWhoText(person) : ""));
    return false;
  }
  why = IsDefined(person) ? ApexGrappleCannotYank(person, feet, hanging, scriptInterface, spot) : "the person is gone";
  if StrLen(why) > 0 {
    system.comesToV = false;
    ApexGrappleLog("person not pulled to V: " + why + "; V is pulled to them" + (IsDefined(person) ? ", " + ApexGrappleWhoText(person) : ""));
    return false;
  }
  system.comesToV = true;
  if !IsDefined(system.yank) {
    system.yank = new ApexGrappleYank();
  }
  let yank: ref<ApexGrappleYank> = system.yank;
  yank.person = person;
  if !IsDefined(yank.drive) {
    yank.drive = new ApexGrappleDrive();
  }
  // A person brought for a grab comes straight to V and is not slammed down.
  ApexGrappleDriveSet(yank.drive, spot + DefaultTransition.GetUpVector() * ApexGrappleYankChestUp(), ApexGrappleYankChestUp(), feet, Vector4.Normalize(system.anchor - Transform.GetPosition(scriptInterface.GetCameraWorldTransform())), settings.steerPeople && !grabs, ApexGrapplePulledSpeedOf(settings));
  yank.feetAtBite = feet;
  yank.hurts = settings.pullDamage && !grabs;
  yank.slams = settings.pullSlam && !grabs;
  yank.startedAt = now;
  yank.startGap = Vector4.Length(ApexGrappleFlat(system.anchor - feet));
  yank.braked = false;
  yank.fallAsks = 0;
  yank.lastChest = system.anchor;
  yank.lastAt = now;
  yank.velocity = new Vector4(0.0, 0.0, 0.0, 0.0);
  yank.topSpeed = 0.0;
  yank.watchFrom = 0.0;
  system.phase = ApexGrapplePulling();
  system.startedAt = now;
  if !yank.hurts {
    ApexGrappleShield(system, person, now, scriptInterface.GetGame());
  }
  // Standing guard, leaning, sitting: the game takes a person out of a posed animation before its own grab or carry
  // (player.script:4362-4363, carriedObject.script:502-503). Fifth test: police and gang members standing idle
  // came only once a fight had moved them.
  let workspots: ref<WorkspotGameSystem> = GameInstance.GetWorkspotSystem(scriptInterface.GetGame());
  let posed: Bool = workspots.IsActorInWorkspot(person);
  if posed {
    workspots.StopNpcInWorkspot(person);
  }
  if grabs {
    ApexGrappleGrabCarryStart(ApexGrappleGrabOf(system), person, scriptInterface.executionOwner, pulls, settings.grabSpeed, now);
  } else {
    ApexGrappleYankFall(person, scriptInterface.executionOwner);
  }
  yank.personID = person.GetEntityID();
  ApexGrappleKeepSeen(scriptInterface.GetGame(), yank.personID, true, 0.0);
  ApexGrappleLog("person pulled to V: hook set after " + ToString(now - system.firedAt) + " s, " + ToString(yank.startGap) + " m away, to a spot " + ToString(Vector4.Length(ApexGrappleFlat(spot - feet))) + " m from V and " + ToString(feet.Z - spot.Z) + " m below V's feet" + (hanging ? " (V on a ladder)" : "") + ", at " + ToString(yank.drive.speed) + " m/s, damage " + ToString(yank.hurts) + ", slam " + ToString(yank.slams) + ", steered " + ToString(yank.drive.steers) + ", posed " + ToString(posed) + ", " + ApexGrappleWhoText(person) + ", pull people " + ToString(pulls) + ", grabbed " + (grabs ? "yes" : "no: " + noGrab));
  return true;
}

// The person falls as the game knocks a living person down (aiHitReactionTasks.script:567-569,
// hitReactionComponent.script:2719-2729): with it, the person's place followed their body in every pull of the second
// test, where the first test's thrown-body fall left it behind.
public func ApexGrappleYankFall(person: ref<GameObject>, player: ref<GameObject>) -> Void {
  if ScriptedPuppet.IsAlive(person) {
    StatusEffectHelper.ApplyStatusEffect(person, t"BaseStatusEffect.UncontrolledMovement_Default", player.GetEntityID());
  }
  person.QueueEvent(CreateForceRagdollEvent(n"ApexGrapple"));
}

// The fall is asked for again at most this many times during a pull.
public func ApexGrappleYankMostFallAsks() -> Int32 {
  return 3;
}

// The fall asked for at the bite did not take, and a person standing answers no push: seen on a person hooked while
// getting up from a fall, and on a dead body come to rest (sixteenth trial, 13 November 2026: not fallen at any push,
// 1 m/s read, Kevin: "ca ne fais rien du tout"). Asked again as the game throws a person it carries, whose fall it
// had switched off (carriedObject.script:1130-1131). Why the first one did not take is not known. That call skips
// the game's own rules against a fall (NPCPuppet.script:745-749): a person one of them holds, as at the bite
// (YankWhy.reds), is left alone.
public func ApexGrappleYankFallAgain(yank: ref<ApexGrappleYank>, person: ref<GameObject>, player: ref<GameObject>) -> Void {
  let npc: ref<NPCPuppet> = person as NPCPuppet;
  let rule: String = ApexGrappleNoFallRule(person, player.GetGame());
  yank.fallAsks += 1;
  ApexGrappleLog("person pulled to V: not fallen after " + ToString(yank.drive.pushes) + " pushes (" + ToString(yank.fallAsks) + "), " + (StrLen(rule) > 0 ? "left alone, the game keeps this person from falling: " + rule : "fall asked again") + ", may fall " + ToString(ScriptedPuppet.CanRagdoll(person)) + ", alive " + ToString(ScriptedPuppet.IsAlive(person)) + ", the game's falling status " + ToString(StatusEffectSystem.ObjectHasStatusEffectOfType(person, gamedataStatusEffectType.UncontrolledMovement)));
  if StrLen(rule) > 0 {
    return;
  }
  if IsDefined(npc) {
    npc.SetDisableRagdoll(false, true);
  }
  ApexGrappleYankFall(person, player);
}
