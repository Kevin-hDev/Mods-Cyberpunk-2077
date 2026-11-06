// The flight of a person pulled to V (Yank.reds): one throw at the hook's speed toward the goal above the spot, one
// correction halfway, and at the goal a brake (they land unhurt, YankShield.reds) or a slam into the ground ("Damage when
// pulling people": the game counts the blow, 11 m/s or more kills, damageSystem.script:615). The first test threw people
// this way and brought them 6 m in 0.3 s; it pushed every frame in another way and the bodies ran away to 3,483 m/s:
// here, never more than two pushes in flight.

// The fall's own gravity, for the throw's arc.
public func ApexGrappleYankGravity() -> Float {
  return 9.81;
}

// From the fall to the throw, as the game's knockdown pushes a body 0.1 s after asking for its fall.
public func ApexGrappleYankThrowDelay() -> Float {
  return 0.1;
}

// Push per m/s wanted: pushes worked out at 110 to 117 sent the chest at about 30 m/s in the first test (0.28 m/s per
// unit, 4 throws). The correction makes up for a body that answers otherwise.
public func ApexGrappleImpulsePerSpeed() -> Float {
  return 3.6;
}

// The game's knockdown pushes the whole body within 5 m of the hit.
public func ApexGrappleYankRadius() -> Float {
  return 5.0;
}

// The correction makes up this share of the gap between the speed wanted and the speed read, never more: a full share
// on a body that answers twice as hard would overshoot as much.
public func ApexGrappleYankGain() -> Float {
  return 0.7;
}

// Share of the speed left by the brake at the goal.
public func ApexGrappleYankBrakeLeft() -> Float {
  return 0.1;
}

// The speed that carries the chest from where it is to the goal in `time`, against the fall.
public func ApexGrappleThrowVelocity(chest: Vector4, goal: Vector4, time: Float) -> Vector4 {
  let velocity: Vector4 = (goal - chest) / time;
  velocity.Z = velocity.Z + 0.5 * ApexGrappleYankGravity() * time;
  return velocity;
}

// Whether the body is in the game's fall: a push only moves a fallen body. Fifth test: 15 throws had not moved the
// body halfway, 14 of them steered, cause not found.
public func ApexGrappleFallen(person: ref<GameObject>) -> Bool {
  let npc: ref<NPCPuppet> = person as NPCPuppet;
  return IsDefined(npc) && npc.IsRagdolling();
}

public func ApexGrappleYankPush(person: ref<GameObject>, chest: Vector4, change: Vector4) -> Void {
  person.QueueEvent(CreateRagdollApplyImpulseEvent(chest, change * ApexGrappleImpulsePerSpeed(), ApexGrappleYankRadius()));
}

public func ApexGrappleYankThrow(yank: ref<ApexGrappleYank>, person: ref<GameObject>, chest: Vector4, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  ApexGrappleYankSteer(yank, chest, "at the throw", scriptInterface);
  let time: Float = MaxF(Vector4.Distance(chest, yank.goal) / yank.speed, 0.08);
  let wanted: Vector4 = ApexGrappleThrowVelocity(chest, yank.goal, time);
  ApexGrappleYankPush(person, chest, wanted - yank.velocity);
  yank.thrownAt = now;
  yank.thrownSpeed = Vector4.Length(wanted);
  yank.chestAtThrow = chest;
  yank.line = Vector4.Normalize(ApexGrappleFlat(yank.goal - chest));
  yank.arriveAt = now + time;
  ApexGrappleLog("person pulled to V: thrown at " + ToString(now - yank.startedAt) + " s, " + ToString(Vector4.Distance(chest, yank.goal)) + " m in " + ToString(time) + " s, at " + ToString(Vector4.Length(wanted)) + " m/s, speed then " + ToString(Vector4.Length(yank.velocity)) + ", fallen " + ToString(ApexGrappleFallen(person)));
}

// Below this share of the throw's speed halfway, the throw has not taken yet. Fourth test: a correction pushed on a
// body read at 4.97 m/s for 60 thrown, both pushes then added up, and the person was read at 1,012 m/s and ended 59 m
// away; the bodies the throw moved were read at 0.42 of it or more, the others at 0.08 or less.
public func ApexGrappleYankTaken() -> Float {
  return 0.25;
}

// The speed the person was meant to fly at: the throw's, faster than the hook's on a long, slow throw, whose arc climbs.
public func ApexGrappleYankMeant(yank: ref<ApexGrappleYank>) -> Float {
  return MaxF(yank.speed, yank.thrownSpeed);
}

// The brake or the slam never changes the speed by more than this: a body read wrong must not be thrown by it.
public func ApexGrappleYankMostChange(yank: ref<ApexGrappleYank>) -> Float {
  return 2.0 * ApexGrappleYankMeant(yank);
}

public func ApexGrappleClamp(change: Vector4, most: Float) -> Vector4 {
  let size: Float = Vector4.Length(change);
  return size > most ? change / size * most : change;
}

// Halfway, the throw is set right once from the speed the body really took; not at all if it has not taken yet.
public func ApexGrappleYankCorrect(yank: ref<ApexGrappleYank>, person: ref<GameObject>, chest: Vector4, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  yank.corrected = true;
  let read: Float = Vector4.Length(yank.velocity);
  if read < ApexGrappleYankTaken() * yank.thrownSpeed {
    ApexGrappleLog("person pulled to V: no correction at " + ToString(now - yank.thrownAt) + " s after the throw, speed read " + ToString(read) + ", the throw not taken yet, fallen " + ToString(ApexGrappleFallen(person)));
    yank.skipped = true;
    return;
  }
  ApexGrappleYankSteer(yank, chest, "halfway", scriptInterface);
  let wanted: Vector4 = ApexGrappleThrowVelocity(chest, yank.goal, MaxF(yank.arriveAt - now, 0.05));
  let change: Vector4 = ApexGrappleClamp((wanted - yank.velocity) * ApexGrappleYankGain(), ApexGrappleYankMeant(yank));
  ApexGrappleYankPush(person, chest, change);
  ApexGrappleLog("person pulled to V: corrected at " + ToString(now - yank.thrownAt) + " s after the throw, speed read " + ToString(read) + " for " + ToString(Vector4.Length(wanted)) + " wanted, push " + ToString(Vector4.Length(change)) + " m/s");
}

// At the goal, or when the pull ends early in flight: braked, or driven straight into the ground at full speed. Once.
public func ApexGrappleYankLand(yank: ref<ApexGrappleYank>, person: ref<GameObject>, chest: Vector4) -> Void {
  yank.pushesOver = true;
  let speed: Float = Vector4.Length(yank.velocity);
  let after: Vector4 = yank.velocity * ApexGrappleYankBrakeLeft();
  if yank.hurts {
    after = new Vector4(0.0, 0.0, -speed, 0.0);
  }
  ApexGrappleYankPush(person, chest, ApexGrappleClamp(after - yank.velocity, ApexGrappleYankMostChange(yank)));
  ApexGrappleLog("person pulled to V: " + (yank.hurts ? "slammed down" : "braked") + " at " + ToString(speed) + " m/s");
}
