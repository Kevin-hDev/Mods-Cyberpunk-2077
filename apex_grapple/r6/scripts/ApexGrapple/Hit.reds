// A car, a blast or a heavy blow: the game takes V over in a locomotion state of its own and throws V, and the
// grapple lets go (ApexGrappleBlockedHere, Frame.reds). Without it, a pull went on up to 2.5 s in the state
// vehicleKnockdown after a car hit V.

// The hit states of the locomotion state machine (statemachine_locomotion.tweak); vehicleKnockdown and knockdown seen
// in game.
public func ApexGrappleIsHitReaction(state: CName) -> Bool {
  return Equals(state, n"knockdown") || Equals(state, n"vehicleKnockdown") || Equals(state, n"forcedKnockdown") || Equals(state, n"stunned") || Equals(state, n"felled");
}

// The game's speed hold, which the grapple lifts for a pull and its momentum, is back at once, not on the ground: with
// it lifted, a car met head-on threw V back at sprint speed.
public func ApexGrappleHitTakesOver(system: ref<ApexGrappleSystem>, stateContext: ref<StateContext>) -> Void {
  if system.speedLimitToRestore {
    system.speedLimitToRestore = false;
    stateContext.SetPermanentBoolParameter(n"TemporarySpeedLimitIgnore", false, true);
  }
}
