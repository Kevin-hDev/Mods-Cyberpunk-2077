// A person on a vehicle, hooked to be pulled to V. Kevin, 9 November 2026: riders arriving on motorcycles, and people
// getting out of a car, pulled V toward them instead: the game counts anyone mounted on a vehicle as unable to fall
// (ScriptedPuppet.CanRagdoll, scriptedPuppet.script:1255). The person is first taken off the vehicle as the game does it
// itself (scripts 2.5): a rider is knocked off a motorcycle as after a hard hit (VehicleComponent.OnDelayedBikeKnockOffEvent,
// vehicleComponent.script:3629-3650: instant unmount, the bike knocked over, its AI told it has no driver); a person getting
// out of a car is unmounted at once, as the game's own AI does it (UnmountFromVehicle, instant). Someone sitting in a car
// stays in it, and V is pulled to them. With the exit slot the game passes for the motorcycle ("Bumped"), the two
// options before it given as no move and no turn: without it, a police rider knocked off stayed counted as mounted
// for a minute, their place left at the motorcycle 20 to 35 m from their body (seventh height trial, 13 November
// 2026, 13 shots).

// A ridden motorcycle's rider, or none: a hook that meets the motorcycle takes its rider, as a rider is most of what a
// ray meets on a motorcycle. Not a rider the game still counts on it while their body lies elsewhere: 4 shots at a
// motorcycle lying on the ground pulled the rider knocked off it earlier (same trial).
public func ApexGrappleRiderOf(object: ref<GameObject>) -> ref<GameObject> {
  let bike: ref<BikeObject> = object as BikeObject;
  if !IsDefined(bike) {
    return null;
  }
  let rider: ref<GameObject> = VehicleComponent.GetDriverMounted(bike.GetGame(), bike.GetEntityID());
  if !IsDefined(rider) || Vector4.Distance(ApexGrappleChestOf(rider), bike.GetWorldPosition()) > ApexGrappleRiderReach() {
    return null;
  }
  return rider;
}

// A rider's chest is within this of the motorcycle's own place.
public func ApexGrappleRiderReach() -> Float {
  return 3.0;
}

// The seat of a person getting out stops counting as theirs as soon as the exit starts, while they stay mounted until it
// ends (VehicleComponentPS.OnVehicleStartedUnmountingEvent, vehicleComponentPS.script:949-962).
public func ApexGrappleGettingOut(game: GameInstance, person: ref<GameObject>, vehicle: ref<VehicleObject>) -> Bool {
  let seats: ref<VehicleComponentPS> = vehicle.GetVehiclePS();
  if !IsDefined(seats) {
    return false;
  }
  let mounting: MountingInfo = GameInstance.GetMountingFacility(game).GetMountingInfoSingleWithObjects(person);
  return !seats.IsSlotOccupiedByNPC(mounting.slotId.id);
}

// What was done to take the person off a vehicle; empty when they are on none, or sit in a car.
public func ApexGrappleTakeOffVehicle(person: ref<GameObject>, game: GameInstance) -> String {
  let vehicle: ref<VehicleObject> = GetMountedVehicle(person);
  if !IsDefined(vehicle) {
    return "";
  }
  let workspots: ref<WorkspotGameSystem> = GameInstance.GetWorkspotSystem(game);
  let bike: ref<BikeObject> = vehicle as BikeObject;
  if IsDefined(bike) {
    let away: Float = Vector4.Distance(ApexGrappleChestOf(person), bike.GetWorldPosition());
    // Already knocked off, their body lies elsewhere, and the game still counts them on the motorcycle (seventh and
    // eighth height trials, with or without the exit slot): the mounting itself is ended, as the game ends V's own
    // when it takes V out of a vehicle at once (vehicleTransition.script:975-980). The motorcycle is left alone.
    if away > ApexGrappleRiderReach() {
      let request: ref<UnmountingRequest> = new UnmountingRequest();
      request.lowLevelMountingInfo = GameInstance.GetMountingFacility(game).GetMountingInfoSingleWithObjects(person);
      request.mountData = new MountEventData();
      request.mountData.isInstant = true;
      GameInstance.GetMountingFacility(game).Unmount(request);
      return "still counted on a motorcycle " + ToString(away) + " m from their body, the mounting ended";
    }
    let driver: Bool = VehicleComponent.IsDriver(game, person);
    workspots.UnmountFromVehicle(vehicle, person, true, new Vector4(0.0, 0.0, 0.0, 0.0), new Quaternion(0.0, 0.0, 0.0, 1.0), n"Bumped");
    let knockOver: ref<KnockOverBikeEvent> = new KnockOverBikeEvent();
    knockOver.forceKnockdown = true;
    knockOver.applyDirectionalForce = true;
    bike.QueueEvent(knockOver);
    if driver {
      let noDriver: ref<AIEvent> = new AIEvent();
      noDriver.name = n"NoDriver";
      bike.QueueEvent(noDriver);
    }
    return "knocked off a motorcycle (driver " + ToString(driver) + ")";
  }
  if ApexGrappleGettingOut(game, person, vehicle) {
    workspots.UnmountFromVehicle(vehicle, person, true);
    return "taken out of a car while getting out";
  }
  return "";
}
