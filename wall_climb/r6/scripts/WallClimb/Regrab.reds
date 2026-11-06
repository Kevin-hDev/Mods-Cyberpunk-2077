// Grabbing a wall again in the fall after a climb, as in our Borderlands 4 mod (Kevin, 31 October 2026, on by
// default): after a wait, as many times as the player wants, each grab a climb of its own, up to the highest climb;
// the ground clears the wait, as it allows a new climb. A highest climb kept from the first grab left V only the few
// metres up to it after a grab again in game (Kevin asked why the climb did not start over). Each grab gives the jumps
// back (Jump.reds), and a jump in the wait puts V above where it let go when the wait ends: tapping jump climbs a
// tall wall without end, at any highest climb. Kept on purpose (Kevin, 31 October 2026), as in Borderlands 4.

// In s from the end of the last climb: the wait of our Borderlands 4 mod (reclimb_delay, its settings.py).
public func WallClimbRegrabWait() -> Float {
  return 0.9;
}

// Why V may not grab a wall again in this fall, as the line the log writes, or n"None" when it may. `last`: the last
// climb since the ground.
public func WallClimbRegrabRefusal(last: ref<WallClimbClimb>, settings: ref<WallClimbSettings>, now: Float) -> CName {
  if !settings.regrab || !IsDefined(last) {
    return n"already climbed since the last ground";
  }
  if last.onWall || now - last.endedAt < WallClimbRegrabWait() {
    return n"waiting to grab a wall again";
  }
  return n"None";
}

public func WallClimbRegrabText(last: ref<WallClimbClimb>, now: Float) -> String {
  return ", grabbed again " + ToString(now - last.endedAt) + " s after the last climb ended (" + last.endReason + ")";
}
