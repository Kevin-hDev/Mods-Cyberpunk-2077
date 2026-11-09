// A person on a vehicle, hooked to be pulled to V. Kevin, 9 November 2026: riders arriving on motorcycles, and people
// getting out of a car, pulled V toward them instead: the game counts anyone mounted on a vehicle as unable to fall
// (ScriptedPuppet.CanRagdoll, scriptedPuppet.script:1255). The person is first taken off the vehicle as the game does it
// itself (scripts 2.5): a rider is knocked off a motorcycle as after a hard hit (VehicleComponent.OnDelayedBikeKnockOffEvent,
// vehicleComponent.script:3629-3650: instant unmount, the bike knocked over, its AI told it has no driver); a person getting
// out of a car is unmounted at once, as the game's own AI does it (UnmountFromVehicle, instant). Someone sitting in a car
// stays in it, and V is pulled to them. Without the exit slot the game passes for the motorcycle ("Bumped"): redscript
// cannot leave the two options before it unset.

// A ridden motorcycle's rider, or none: a hook that meets the motorcycle takes its rider, as a rider is most of what a
// ray meets on a motorcycle.
public func ApexGrappleRiderOf(object: ref<GameObject>) -> ref<GameObject> {
  let bike: ref<BikeObject> = object as BikeObject;
  if !IsDefined(bike) {
    return null;
  }
  return VehicleComponent.GetDriverMounted(bike.GetGame(), bike.GetEntityID());
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
    let driver: Bool = VehicleComponent.IsDriver(game, person);
    workspots.UnmountFromVehicle(vehicle, person, true);
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
