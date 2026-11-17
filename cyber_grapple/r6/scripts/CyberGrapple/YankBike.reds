// Made by fabrique/grapple.py from Apex Grapple's YankBike.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// A motorcycle pulled to V ("Pull motorcycles to V"). Kevin, 13 November 2026: "Les moto, est ce qu'on pourrait les
// tiré aussi ? avec ou sans motard et les laisser s'abimer ou exploser en fonction de l'impact et de comment elles
// sont projeter". The hook that meets the motorcycle takes it, and its rider falls off; the hook that meets the rider
// takes the rider alone (AimRule.reds). Moved as a person is (YankDrive.reds, YankSteer.reds): pushed to a spot in
// front of V, or wherever the aim sends it; its own pushes are in YankBikeFlight.reds. The game itself breaks a
// motorcycle that hits something: Kevin saw one catch fire (eleventh trial), nothing is added to it.

public class CyberGrappleBikePull {
  public let bike: wref<VehicleObject>;
  // Where it is pushed to, and the pushes (YankDrive.reds).
  public let drive: ref<CyberGrappleDrive>;
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
public func CyberGrappleBikeStop() -> Float {
  return 3.0;
}

// The spot is this far above the ground V stands on: the motorcycle's own place is at its wheels.
public func CyberGrappleBikeGoalUp() -> Float {
  return 0.5;
}

// The motorcycle this close to the spot along the ground has arrived.
public func CyberGrappleBikeAtGoal() -> Float {
  return 1.5;
}

// The hook bites a motorcycle that comes to V. False, and V is pulled to it, when it already stands by V.
public func CyberGrappleStartBikePull(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let bike: ref<BikeObject> = system.target as BikeObject;
  let game: GameInstance = scriptInterface.GetGame();
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  system.bikeComes = false;
  if !IsDefined(bike) {
    return false;
  }
  let place: Vector4 = bike.GetWorldPosition();
  let away: Vector4 = CyberGrappleFlat(place - feet);
  let far: Float = Vector4.Length(away);
  if far <= CyberGrappleBikeStop() + 0.5 {
    CyberGrappleLog("motorcycle not pulled to V: already by V, " + ToString(far) + " m away; V is pulled to it");
    return false;
  }
  let rider: ref<GameObject> = VehicleComponent.GetDriverMounted(game, bike.GetEntityID());
  let off: String = "no rider";
  let counted: Bool = IsDefined(rider) && !rider.IsPlayer();
  // A rider knocked off earlier, whom the game still counts on the motorcycle while their body lies elsewhere
  // (YankVehicle.reds), is not on it: their mounting is ended, and they are left where they are.
  let ridden: Bool = false;
  if counted {
    ridden = Vector4.Distance(CyberGrappleChestOf(rider), place) <= CyberGrappleRiderReach();
  }
  if ridden {
    // As for a person aimed at (YankWhy.reds): a rider a scene or a mission holds is not thrown off, and V is pulled.
    let held: String = CyberGrappleHeldBy(rider, game);
    if StrLen(held) > 0 {
      CyberGrappleLog("motorcycle not pulled to V: its rider is held (" + held + "); V is pulled to it");
      return false;
    }
  }
  if counted {
    off = CyberGrappleTakeOffVehicle(rider, game);
  }
  if ridden {
    CyberGrappleYankFall(rider, scriptInterface.executionOwner);
  } else {
    // A parked motorcycle is held upright by the game until it is knocked over (motorcycleComponent.script:95-110).
    let knockOver: ref<KnockOverBikeEvent> = new KnockOverBikeEvent();
    knockOver.forceKnockdown = true;
    bike.QueueEvent(knockOver);
  }
  bike.PhysicsWakeUp();
  if !IsDefined(system.bikePull) {
    system.bikePull = new CyberGrappleBikePull();
    system.bikePull.drive = new CyberGrappleDrive();
  }
  let pull: ref<CyberGrappleBikePull> = system.bikePull;
  pull.bike = bike;
  CyberGrappleDriveSet(pull.drive, feet + away / far * CyberGrappleBikeStop() + DefaultTransition.GetUpVector() * CyberGrappleBikeGoalUp(), CyberGrappleBikeGoalUp(), feet, Vector4.Normalize(system.anchor - Transform.GetPosition(scriptInterface.GetCameraWorldTransform())), settings.steerPeople, MinF(CyberGrapplePulledSpeedOf(settings) * CyberGrappleBikeSpeedShare(), CyberGrappleBikeMostSpeed()));
  // The first push goes at the pull's first frame, sized from the speed the motorcycle already has: rolling or parked,
  // it leaves at the same speed.
  CyberGrappleDriveBegin(pull.drive, place, now);
  pull.slams = settings.pullSlam;
  pull.startedAt = now;
  pull.startGap = far;
  pull.brakeTries = 0;
  pull.brakeAt = 0.0;
  pull.topSpeed = 0.0;
  pull.watchAt = 0.0;
  system.bikeComes = true;
  system.phase = CyberGrapplePulling();
  system.startedAt = now;
  CyberGrappleLog("motorcycle pulled to V: hook set after " + ToString(now - system.firedAt) + " s, " + ToString(far) + " m away and " + ToString(place.Z - feet.Z) + " m above V's feet, at " + ToString(pull.drive.speed) + " m/s, speed then " + ToString(Vector4.Length(bike.GetLinearVelocity())) + ", mass " + ToString(bike.GetTotalMass()) + ", slam " + ToString(pull.slams) + ", steered " + ToString(pull.drive.steers) + ", rider: " + off + ", destroyed " + ToString(bike.IsDestroyed()) + ", in traffic " + ToString(bike.IsInTrafficPhysicsState()));
  return true;
}

@addMethod(LocomotionEventsTransition)
private final func CyberGrappleBikeFrame(system: ref<CyberGrappleSystem>, key: CyberGrappleKey, settings: ref<CyberGrappleSettings>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let pull: ref<CyberGrappleBikePull> = system.bikePull;
  let bike: ref<VehicleObject> = pull.bike;
  let drive: ref<CyberGrappleDrive> = pull.drive;
  let reason: String = this.CyberGrappleLetGoOfPulled(system, key, settings, now, stateContext, scriptInterface);
  if !IsDefined(bike) {
    reason = "the motorcycle is gone";
  }
  if StrLen(reason) > 0 {
    this.CyberGrappleEndPull(system, reason, now, scriptInterface);
    return;
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  CyberGrappleDriveFollow(drive, feet);
  let place: Vector4 = bike.GetWorldPosition();
  let velocity: Vector4 = bike.GetLinearVelocity();
  let read: Float = Vector4.Length(velocity);
  pull.topSpeed = MaxF(pull.topSpeed, read);
  CyberGrappleDriveAim(drive, scriptInterface);
  // As a person (YankFrame.reds): at the goal, braked; against the ground the lowered aim asked for, nothing more.
  let there: Int32 = CyberGrappleDriveArrived(drive, place, velocity, feet, CyberGrappleBikeAtGoal(), CyberGrappleBikeStop(), CyberGrappleYankAtGoalHeight());
  if there == 1 {
    CyberGrappleBikeLand(pull, bike, now);
    this.CyberGrappleEndPull(system, "arrived", now, scriptInterface);
    return;
  }
  if there == 2 {
    this.CyberGrappleEndPull(system, "thrown against the ground at " + ToString(read) + " m/s", now, scriptInterface);
    return;
  }
  if CyberGrappleDriveOverdue(drive, now) {
    this.CyberGrappleEndPull(system, "the motorcycle did not come: " + ToString(Vector4.Distance(place, drive.goal)) + " m from the goal", now, scriptInterface);
    return;
  }
  let change: Vector4;
  if CyberGrappleDriveDue(drive, velocity, now) && CyberGrappleDriveStep(drive, place, velocity, now, change) {
    CyberGrappleBikePush(bike, place, velocity, change);
    if CyberGrappleDriveTells(drive, now) {
      CyberGrappleLog("motorcycle pulled to V: " + CyberGrappleDrivePushText(drive, place, read, change, now));
    }
  }
}

// A hook that lets go before the goal does nothing to the motorcycle: it keeps the speed it has.
public func CyberGrappleEndBike(system: ref<CyberGrappleSystem>, reason: String, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let pull: ref<CyberGrappleBikePull> = system.bikePull;
  let bike: ref<VehicleObject> = pull.bike;
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  system.bikeComes = false;
  if !IsDefined(bike) {
    CyberGrappleLog("motorcycle pulled to V ended: " + reason + " after " + ToString(now - pull.startedAt) + " s");
    return;
  }
  pull.watchAt = now + 1.0;
  pull.endPlace = bike.GetWorldPosition();
  CyberGrappleLog("motorcycle pulled to V ended: " + reason + " after " + ToString(now - pull.startedAt) + " s, from " + ToString(pull.startGap) + " m to " + ToString(Vector4.Length(CyberGrappleFlat(pull.endPlace - feet))) + " m from V and " + ToString(pull.endPlace.Z - feet.Z) + " m above V's feet, speed " + ToString(Vector4.Length(bike.GetLinearVelocity())) + " then, top speed " + ToString(pull.topSpeed) + ", " + CyberGrappleDriveEndText(pull.drive, now) + ", destroyed " + ToString(bike.IsDestroyed()));
}
