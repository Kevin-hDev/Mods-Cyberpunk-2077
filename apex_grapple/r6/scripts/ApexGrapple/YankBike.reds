// A motorcycle pulled to V ("Pull motorcycles to V"). Kevin, 13 November 2026: "Les moto, est ce qu'on pourrait les
// tiré aussi ? avec ou sans motard et les laisser s'abimer ou exploser en fonction de l'impact et de comment elles
// sont projeter". The hook that meets the motorcycle takes it, and its rider falls off; the hook that meets the rider
// takes the rider alone (AimRule.reds). Moved as a person is (YankDrive.reds, YankSteer.reds): pushed to a spot in
// front of V, or wherever the aim sends it; its own pushes are in YankBikeFlight.reds. The game itself breaks a
// motorcycle that hits something: Kevin saw one catch fire (eleventh trial), nothing is added to it.

public class ApexGrappleBikePull {
  public let bike: wref<VehicleObject>;
  // Where it is pushed to, and the pushes (YankDrive.reds).
  public let drive: ref<ApexGrappleDrive>;
  // "Slam at the end of the pull": at the goal, driven into the ground and not braked.
  public let slams: Bool;
  public let startedAt: Float;
  public let startGap: Float;
  // The brake or the slam by V: how many times it was given, when last, and the speed along the ground it was given at.
  public let brakeTries: Int32;
  public let brakeAt: Float;
  public let brakeFrom: Float;
  public let topSpeed: Float;
  // After the end, looked at once for the log.
  public let watchAt: Float;
  public let endPlace: Vector4;
}

// The motorcycle stops this far from V, along the ground: farther than a person (Yank.reds), it is 2 m long and heavy.
public func ApexGrappleBikeStop() -> Float {
  return 3.0;
}

// The spot is this far above the ground V stands on: the motorcycle's own place is at its wheels.
public func ApexGrappleBikeGoalUp() -> Float {
  return 0.5;
}

// The motorcycle this close to the spot along the ground has arrived.
public func ApexGrappleBikeAtGoal() -> Float {
  return 1.5;
}

// The hook bites a motorcycle that comes to V. False, and V is pulled to it, when it already stands by V.
public func ApexGrappleStartBikePull(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let bike: ref<BikeObject> = system.target as BikeObject;
  let game: GameInstance = scriptInterface.GetGame();
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  system.bikeComes = false;
  if !IsDefined(bike) {
    return false;
  }
  let place: Vector4 = bike.GetWorldPosition();
  let away: Vector4 = ApexGrappleFlat(place - feet);
  let far: Float = Vector4.Length(away);
  if far <= ApexGrappleBikeStop() + 0.5 {
    ApexGrappleLog("motorcycle not pulled to V: already by V, " + ToString(far) + " m away; V is pulled to it");
    return false;
  }
  let rider: ref<GameObject> = VehicleComponent.GetDriverMounted(game, bike.GetEntityID());
  let off: String = "no rider";
  let counted: Bool = IsDefined(rider) && !rider.IsPlayer();
  // A rider knocked off earlier, whom the game still counts on the motorcycle while their body lies elsewhere
  // (YankVehicle.reds), is not on it: their mounting is ended, and they are left where they are.
  let ridden: Bool = false;
  if counted {
    ridden = Vector4.Distance(ApexGrappleChestOf(rider), place) <= ApexGrappleRiderReach();
  }
  if ridden {
    // As for a person aimed at (YankWhy.reds): a rider a scene or a mission holds is not thrown off, and V is pulled.
    let held: String = ApexGrappleHeldBy(rider, game);
    if StrLen(held) > 0 {
      ApexGrappleLog("motorcycle not pulled to V: its rider is held (" + held + "); V is pulled to it");
      return false;
    }
  }
  if counted {
    off = ApexGrappleTakeOffVehicle(rider, game);
  }
  if ridden {
    ApexGrappleYankFall(rider, scriptInterface.executionOwner);
  } else {
    // A parked motorcycle is held upright by the game until it is knocked over (motorcycleComponent.script:95-110).
    let knockOver: ref<KnockOverBikeEvent> = new KnockOverBikeEvent();
    knockOver.forceKnockdown = true;
    bike.QueueEvent(knockOver);
  }
  bike.PhysicsWakeUp();
  if !IsDefined(system.bikePull) {
    system.bikePull = new ApexGrappleBikePull();
    system.bikePull.drive = new ApexGrappleDrive();
  }
  let pull: ref<ApexGrappleBikePull> = system.bikePull;
  pull.bike = bike;
  ApexGrappleDriveSet(pull.drive, feet + away / far * ApexGrappleBikeStop() + DefaultTransition.GetUpVector() * ApexGrappleBikeGoalUp(), ApexGrappleBikeGoalUp(), feet, Vector4.Normalize(system.anchor - Transform.GetPosition(scriptInterface.GetCameraWorldTransform())), settings.steerPeople, MinF(ApexGrapplePulledSpeedOf(settings) * ApexGrappleBikeSpeedShare(), ApexGrappleBikeMostSpeed()));
  // The first push goes at the pull's first frame, sized from the speed the motorcycle already has: rolling or parked,
  // it leaves at the same speed.
  ApexGrappleDriveBegin(pull.drive, place, now);
  pull.slams = settings.pullSlam;
  pull.startedAt = now;
  pull.startGap = far;
  pull.brakeTries = 0;
  pull.brakeAt = 0.0;
  pull.topSpeed = 0.0;
  pull.watchAt = 0.0;
  system.bikeComes = true;
  system.phase = ApexGrapplePulling();
  system.startedAt = now;
  ApexGrappleLog("motorcycle pulled to V: hook set after " + ToString(now - system.firedAt) + " s, " + ToString(far) + " m away and " + ToString(place.Z - feet.Z) + " m above V's feet, at " + ToString(pull.drive.speed) + " m/s, speed then " + ToString(Vector4.Length(bike.GetLinearVelocity())) + ", mass " + ToString(bike.GetTotalMass()) + ", slam " + ToString(pull.slams) + ", steered " + ToString(pull.drive.steers) + ", rider: " + off + ", destroyed " + ToString(bike.IsDestroyed()) + ", in traffic " + ToString(bike.IsInTrafficPhysicsState()));
  return true;
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleBikeFrame(system: ref<ApexGrappleSystem>, key: ApexGrappleKey, settings: ref<ApexGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let pull: ref<ApexGrappleBikePull> = system.bikePull;
  let bike: ref<VehicleObject> = pull.bike;
  let drive: ref<ApexGrappleDrive> = pull.drive;
  let reason: String = this.ApexGrappleLetGoOfPulled(system, key, settings, now, stateContext, scriptInterface);
  if !IsDefined(bike) {
    reason = "the motorcycle is gone";
  }
  if StrLen(reason) > 0 {
    this.ApexGrappleEndPull(system, reason, now, scriptInterface);
    return;
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  ApexGrappleDriveFollow(drive, feet);
  let place: Vector4 = bike.GetWorldPosition();
  let velocity: Vector4 = bike.GetLinearVelocity();
  let read: Float = Vector4.Length(velocity);
  pull.topSpeed = MaxF(pull.topSpeed, read);
  ApexGrappleDriveAim(drive, scriptInterface);
  // As a person (YankFrame.reds): at the goal, braked; against the ground the lowered aim asked for, nothing more.
  let there: Int32 = ApexGrappleDriveArrived(drive, place, velocity, feet, ApexGrappleBikeAtGoal(), ApexGrappleBikeStop(), ApexGrappleYankAtGoalHeight());
  if there == 1 {
    ApexGrappleBikeLand(pull, bike, now);
    this.ApexGrappleEndPull(system, "arrived", now, scriptInterface);
    return;
  }
  if there == 2 {
    this.ApexGrappleEndPull(system, "thrown against the ground at " + ToString(read) + " m/s", now, scriptInterface);
    return;
  }
  if ApexGrappleDriveOverdue(drive, now) {
    this.ApexGrappleEndPull(system, "the motorcycle did not come: " + ToString(Vector4.Distance(place, drive.goal)) + " m from the goal", now, scriptInterface);
    return;
  }
  let change: Vector4;
  if ApexGrappleDriveDue(drive, velocity, now) && ApexGrappleDriveStep(drive, place, velocity, now, change) {
    ApexGrappleBikePush(bike, place, velocity, change);
    if ApexGrappleDriveTells(drive, now) {
      ApexGrappleLog("motorcycle pulled to V: " + ApexGrappleDrivePushText(drive, place, read, change, now));
    }
  }
}

// A hook that lets go before the goal does nothing to the motorcycle: it keeps the speed it has.
public func ApexGrappleEndBike(system: ref<ApexGrappleSystem>, reason: String, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let pull: ref<ApexGrappleBikePull> = system.bikePull;
  let bike: ref<VehicleObject> = pull.bike;
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  system.bikeComes = false;
  if !IsDefined(bike) {
    ApexGrappleLog("motorcycle pulled to V ended: " + reason + " after " + ToString(now - pull.startedAt) + " s");
    return;
  }
  pull.watchAt = now + 1.0;
  pull.endPlace = bike.GetWorldPosition();
  ApexGrappleLog("motorcycle pulled to V ended: " + reason + " after " + ToString(now - pull.startedAt) + " s, from " + ToString(pull.startGap) + " m to " + ToString(Vector4.Length(ApexGrappleFlat(pull.endPlace - feet))) + " m from V and " + ToString(pull.endPlace.Z - feet.Z) + " m above V's feet, speed " + ToString(Vector4.Length(bike.GetLinearVelocity())) + " then, top speed " + ToString(pull.topSpeed) + ", " + ApexGrappleDriveEndText(pull.drive, now) + ", destroyed " + ToString(bike.IsDestroyed()));
}
