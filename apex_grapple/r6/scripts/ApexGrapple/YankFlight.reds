// What moves a person pulled to V (Yank.reds): the push itself, sized by YankDrive.reds, and what is done when they
// get to the goal: a brake, or, with "Slam at the end of the pull", a slam into the ground (with "Damage when pulling
// people" the game counts the blow, 11 m/s or more kills, damageSystem.script:615). A hook that lets go before the
// goal does nothing: the person keeps the speed they have. Kevin, 13 November 2026: "avec degat ce qui est projeter
// senvole et se fait toujours plaquer au sol a la fin de la traction, on ne peut pas juste projeter un ennemies dans
// les airs"; the slam was the damage setting's until then, and is a setting of its own since (Settings.reds).

// From the fall to the first push, as the game's knockdown pushes a body 0.1 s after asking for its fall.
public func ApexGrappleYankThrowDelay() -> Float {
  return 0.1;
}

// Push per m/s wanted: pushes worked out at 110 to 117 sent the chest at about 30 m/s in the first test (0.28 m/s per
// unit, 4 throws). The pushes that follow make up for a body that answers otherwise.
public func ApexGrappleImpulsePerSpeed() -> Float {
  return 3.6;
}

// The game's knockdown pushes the whole body within 5 m of the hit.
public func ApexGrappleYankRadius() -> Float {
  return 5.0;
}

// Share of the speed left by the brake by V.
public func ApexGrappleYankBrakeLeft() -> Float {
  return 0.1;
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

// At the goal: braked, or driven straight into the ground, at the pull's speed at least. Never by more than twice the
// pull's speed: a body read wrong must not be thrown by it.
public func ApexGrappleYankLand(yank: ref<ApexGrappleYank>, person: ref<GameObject>, chest: Vector4) -> Void {
  let slam: Bool = yank.slams;
  let speed: Float = Vector4.Length(yank.velocity);
  let after: Vector4 = yank.velocity * ApexGrappleYankBrakeLeft();
  if slam {
    after = new Vector4(0.0, 0.0, -MaxF(speed, yank.drive.speed), 0.0);
  }
  yank.braked = !slam;
  ApexGrappleYankPush(person, chest, ApexGrappleClamp(after - yank.velocity, 2.0 * yank.drive.speed));
  ApexGrappleLog("person pulled to V: " + (slam ? "slammed down" : "braked") + " at " + ToString(speed) + " m/s");
}

// The brake is given again this long after the first, from the way the body really went since.
public func ApexGrappleYankBrakeAgainAfter() -> Float {
  return 0.15;
}

// Slower than this along the ground, the body is left alone.
public func ApexGrappleYankSlowEnough() -> Float {
  return 2.0;
}

// The brake once more, after the pull's end: the first one left bodies sliding 2 to 11 m in the next second (sixth
// height trial, 13 November 2026, braked at 28 to 55 m/s), and 3 people brought up to a roof slid off it. Along the
// ground only: the fall is left to the game. Not after a slam, which goes down.
public func ApexGrappleYankBrakeAgain(yank: ref<ApexGrappleYank>, person: ref<GameObject>, chest: Vector4, after: Float) -> Void {
  yank.brakedAgain = true;
  let going: Vector4 = ApexGrappleFlat(chest - yank.endChest) / after;
  let speed: Float = Vector4.Length(going);
  if speed < ApexGrappleYankSlowEnough() || !ApexGrappleFallen(person) {
    return;
  }
  // A measure for the log, to go once a trial has read it: `going` counts the time the first brake had not taken
  // yet, and the audit of 13 November 2026 supposes it well above the speed the body still has, here over the last
  // frame watched (YankWatch.reds).
  let step: Float = yank.watchFrom + after - yank.watchAt;
  let lately: Float = step > ApexGrappleTiny() ? Vector4.Length(ApexGrappleFlat(chest - yank.watchChest)) / step : 0.0;
  ApexGrappleYankPush(person, chest, ApexGrappleClamp(going * -1.0, yank.drive.speed));
  ApexGrappleLog("person pulled to V: braked again " + ToString(after) + " s after, going " + ToString(speed) + " m/s along the ground since the pull's end, " + ToString(lately) + " m/s over the last frame");
}
