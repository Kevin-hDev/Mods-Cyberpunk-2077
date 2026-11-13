// What moves a motorcycle pulled to V (YankBike.reds): the push itself, sized by YankDrive.reds, and what is done when
// it gets to the goal: a brake, or, with "Slam at the end of the pull", a slam into the ground, and the check that
// it took. The push is the one the game gives a motorcycle it
// knocks over (motorcycleComponent.script:111-121); the speed is the motorcycle's own, read from the game.

// Share of the speed people are pulled at ("Speed of what is pulled to V") a motorcycle is pulled at; until that
// setting, of the hook's speed. Kevin, 13 November 2026: "pourquoi elle part aussi vite et aussi loin ? [...] une
// moto c'est vachement plus lourd". At 40 m/s, the brake of a motorcycle going 44 m/s or more did not take in 8
// trials out of 8, and it flew 23 to 48 m on; the 2 braked at 35 and 39 m/s stopped (tenth and eleventh trials).
public func ApexGrappleBikeSpeedShare() -> Float {
  return 0.6;
}

// A motorcycle is never pulled faster than this, whatever the setting. Kevin, 13 November 2026: "on va plafoné a
// 50 m/s max". At 58 and 59 m/s (the setting at 100) the brake did not take in 4 tries, and the motorcycles went
// on 29 to 38 m (nineteenth trial); at 18 and 21 m/s it took at the first try, 4 times out of 4. Between 44 and
// 50 m/s it has not been tried since the push was aimed ahead.
public func ApexGrappleBikeMostSpeed() -> Float {
  return 50.0;
}

// A push takes effect some 0.03 to 0.05 s after it is asked for (the same trials: the speed at which a push misses):
// it is aimed where the motorcycle will be then.
public func ApexGrappleBikePushLead() -> Float {
  return 0.04;
}

// A change of speed, as a push on the whole motorcycle from the height the game pushes it at. `place` and `velocity`:
// the motorcycle's own, as read this frame.
public func ApexGrappleBikePush(bike: ref<VehicleObject>, place: Vector4, velocity: Vector4, change: Vector4) -> Void {
  let push: ref<PhysicalImpulseEvent> = new PhysicalImpulseEvent();
  let at: Vector4 = place + velocity * ApexGrappleBikePushLead();
  push.radius = 2.5;
  push.worldPosition = new Vector3(at.X, at.Y, at.Z + 0.5);
  push.worldImpulse = Vector4.Vector4To3(change * bike.GetTotalMass());
  bike.QueueEvent(push);
}

// The brake is looked at this long after it was given, and given again if it did not take, this many times at most.
public func ApexGrappleBikeBrakeCheck() -> Float {
  return 0.1;
}

public func ApexGrappleBikeBrakeTries() -> Int32 {
  return 4;
}

// At the goal: braked, or driven into the ground at the pull's speed at least.
public func ApexGrappleBikeLand(pull: ref<ApexGrappleBikePull>, bike: ref<VehicleObject>, now: Float) -> Void {
  let slam: Bool = pull.slams;
  let velocity: Vector4 = bike.GetLinearVelocity();
  let speed: Float = Vector4.Length(velocity);
  let after: Vector4 = velocity * ApexGrappleYankBrakeLeft();
  if slam {
    after = new Vector4(0.0, 0.0, -MaxF(speed, pull.drive.speed), 0.0);
  }
  pull.brakeTries += 1;
  pull.brakeAt = now;
  pull.brakeFrom = Vector4.Length(ApexGrappleFlat(velocity));
  ApexGrappleBikePush(bike, bike.GetWorldPosition(), velocity, ApexGrappleClamp(after - velocity, 2.0 * pull.drive.speed));
  ApexGrappleLog("motorcycle pulled to V: " + (slam ? "slammed down" : "braked") + " at " + ToString(speed) + " m/s, try " + ToString(pull.brakeTries));
}

// After the pull, each frame: the brake by V given again while the motorcycle still goes more than half as fast along
// the ground as when it was braked (a brake that took leaves a tenth), and a second after, where it is for the log.
public func ApexGrappleBikeWatch(system: ref<ApexGrappleSystem>, now: Float) -> Void {
  let pull: ref<ApexGrappleBikePull> = system.bikePull;
  if !IsDefined(pull) || system.bikeComes || (pull.brakeAt <= 0.0 && pull.watchAt <= 0.0) {
    return;
  }
  let bike: ref<VehicleObject> = pull.bike;
  if !IsDefined(bike) {
    pull.brakeAt = 0.0;
    pull.watchAt = 0.0;
    return;
  }
  if pull.brakeAt > 0.0 && now - pull.brakeAt >= ApexGrappleBikeBrakeCheck() {
    let going: Float = Vector4.Length(ApexGrappleFlat(bike.GetLinearVelocity()));
    if going > MaxF(0.5 * pull.brakeFrom, ApexGrappleYankSlowEnough()) && pull.brakeTries < ApexGrappleBikeBrakeTries() {
      ApexGrappleBikeLand(pull, bike, now);
    } else {
      pull.brakeAt = 0.0;
      ApexGrappleLog("motorcycle pulled to V: " + ToString(going) + " m/s along the ground " + ToString(ApexGrappleBikeBrakeCheck()) + " s after try " + ToString(pull.brakeTries) + ", was " + ToString(pull.brakeFrom));
    }
  }
  if pull.watchAt > 0.0 && now >= pull.watchAt {
    pull.watchAt = 0.0;
    ApexGrappleLog("motorcycle pulled to V, 1 s after: " + ToString(Vector4.Distance(bike.GetWorldPosition(), pull.endPlace)) + " m from where it stopped, speed " + ToString(Vector4.Length(bike.GetLinearVelocity())) + ", destroyed " + ToString(bike.IsDestroyed()));
  }
}
