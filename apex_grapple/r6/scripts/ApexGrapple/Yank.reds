// A person pulled to V ("Pull people to V", docs/apex-grapple/vehicules-et-personnes/conception.md): yanked off their
// feet and thrown along the rope at the hook's speed, to a spot by V where the AI can stand, then left to the game,
// which gets them up there. Kevin, 2 November 2026: "le grappin attrape et ramène ce qu'il attrape jusqu'à V", as in
// Apex Legends, and "c'est pas grave s'il meurt", with a setting for it (YankFlight.reds). The game would move no
// passer-by standing: its AI slide never started and 27 to 29 AI teleports a pull moved no one (third test).

public class ApexGrappleYank {
  public let person: wref<GameObject>;
  // Kept apart: the request to keep the person updated off screen is ended by it, even once the person is gone.
  public let personID: EntityID;
  // Where the chest is thrown to: above the spot, at chest height, moved by the aim when it steers (YankSteer.reds).
  public let goal: Vector4;
  public let baseGoal: Vector4;
  public let steers: Bool;
  // From the view to the bite, at the bite: the line the aim is measured against.
  public let aimFrom: Vector4;
  public let speed: Float;
  // "Damage when pulling people": slammed down at the end, unprotected.
  public let hurts: Bool;
  public let startedAt: Float;
  public let startGap: Float;
  // The throw, once made: when, at what speed, where the chest was, its line along the ground, the arrival planned.
  public let thrownAt: Float;
  public let thrownSpeed: Float;
  public let chestAtThrow: Vector4;
  public let line: Vector4;
  public let arriveAt: Float;
  // The correction halfway: made, or skipped as the throw had not taken.
  public let corrected: Bool;
  public let skipped: Bool;
  // No push may follow: the brake or slam was given, or the speed read ran away.
  public let pushesOver: Bool;
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

// The hook bites a person to pull to V: false, and V is pulled to them, when the game would not let it work. The
// person falls as the game knocks a living person down (aiHitReactionTasks.script:567-569,
// hitReactionComponent.script:2719-2729): with it, the person's place followed their body in every pull of the second
// test, where the first test's thrown-body fall left it behind.
public func ApexGrappleStartYank(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, now: Float, hanging: Bool, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let person: ref<GameObject> = system.target;
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let spot: Vector4;
  let why: String = IsDefined(person) ? ApexGrappleCannotYank(person, feet, hanging, scriptInterface, spot) : "the person is gone";
  if StrLen(why) > 0 {
    system.comesToV = false;
    ApexGrappleLog("person not pulled to V: " + why + "; V is pulled to them" + (IsDefined(person) ? ", " + ApexGrappleWhoText(person) : ""));
    return false;
  }
  if !IsDefined(system.yank) {
    system.yank = new ApexGrappleYank();
  }
  let yank: ref<ApexGrappleYank> = system.yank;
  yank.person = person;
  yank.baseGoal = spot + DefaultTransition.GetUpVector() * ApexGrappleYankChestUp();
  yank.goal = yank.baseGoal;
  yank.steers = settings.steerPeople;
  yank.aimFrom = Vector4.Normalize(system.anchor - Transform.GetPosition(scriptInterface.GetCameraWorldTransform()));
  yank.speed = ApexGrappleHookSpeedOf(settings);
  yank.hurts = settings.pullDamage;
  yank.startedAt = now;
  yank.startGap = Vector4.Length(ApexGrappleFlat(system.anchor - feet));
  yank.thrownAt = 0.0;
  yank.thrownSpeed = 0.0;
  yank.corrected = false;
  yank.skipped = false;
  yank.pushesOver = false;
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
  if ScriptedPuppet.IsAlive(person) {
    StatusEffectHelper.ApplyStatusEffect(person, t"BaseStatusEffect.UncontrolledMovement_Default", scriptInterface.executionOwner.GetEntityID());
  }
  person.QueueEvent(CreateForceRagdollEvent(n"ApexGrapple"));
  yank.personID = person.GetEntityID();
  ApexGrappleKeepSeen(scriptInterface.GetGame(), yank.personID, true, 0.0);
  ApexGrappleLog("person pulled to V: hook set after " + ToString(now - system.firedAt) + " s, " + ToString(yank.startGap) + " m away, to a spot " + ToString(Vector4.Length(ApexGrappleFlat(spot - feet))) + " m from V and " + ToString(feet.Z - spot.Z) + " m below V's feet" + (hanging ? " (V on a ladder)" : "") + ", at " + ToString(yank.speed) + " m/s, damage " + ToString(yank.hurts) + ", steered " + ToString(yank.steers) + ", posed " + ToString(posed) + ", " + ApexGrappleWhoText(person));
  return true;
}
