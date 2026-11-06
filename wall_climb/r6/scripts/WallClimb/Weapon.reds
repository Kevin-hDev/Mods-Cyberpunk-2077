// The weapon is put away for the climb, so both hands are free for the wall, and comes back when the climb ends. This
// is the game's own temporary unequip: while the flag is set the game puts the weapon away, and once it is cleared the
// game takes it out again (TemporaryUnequipDecisions, scripts 2.5).

public func WallClimbHolster(stateContext: ref<StateContext>, climb: ref<WallClimbClimb>) -> Void {
  // Set by something else, the flag is not ours to clear.
  if stateContext.GetBoolParameter(n"forcedTemporaryUnequip", true) {
    return;
  }
  stateContext.SetPermanentBoolParameter(n"forcedTemporaryUnequip", true, true);
  climb.holstered = true;
}

public func WallClimbRedraw(stateContext: ref<StateContext>, climb: ref<WallClimbClimb>) -> Void {
  if !climb.holstered {
    return;
  }
  climb.holstered = false;
  stateContext.SetPermanentBoolParameter(n"forcedTemporaryUnequip", false, true);
}
