// A ladder that is not in the world, for "Hold on when stopping" (Hold.reds). The game puts V on a ladder when its
// state machine holds a "usingLadder" description (scripts 2.5, LadderDecisions.TestParameters), and that description
// is plain data (position, facing, height, steps): we make one against the wall where V stopped.

// The ladder ends this far above the highest climb, so its own exit at the top never plays: that exit lifted V 0.4 m
// above the top and held V there almost a second before standing V up.
public func WallClimbLadderAboveTop() -> Float {
  return 1.0;
}

// The game's bottom step. Its entry from the bottom keeps V's height, then takes V to the foot plus this step
// (measured in game on the ladder climb); with the foot this far below V's feet, V holds on where it stopped.
public func WallClimbLadderStep() -> Float {
  return 0.4;
}

// The steps are the defaults of the game's ladder component (WolvenKit's class definitions, generated from the
// game), except verticalStepTop: -0.4, as on a ladder placed in the game's world, where the class default says -1.
public func WallClimbLadderAt(wallPoint: Vector4, normal: Vector4, feet: Vector4, letGoZ: Float) -> ref<LadderDescription> {
  let ladder: ref<LadderDescription> = new LadderDescription();
  let base: Vector4 = wallPoint;
  base.Z = feet.Z - WallClimbLadderStep();
  ladder.position = base;
  ladder.normal = normal;
  ladder.up = DefaultTransition.GetUpVector();
  ladder.topHeightFromPosition = letGoZ + WallClimbLadderAboveTop() - base.Z;
  ladder.exitStepTop = -1.0;
  ladder.verticalStepTop = -0.4;
  ladder.exitStepBottom = 0.6;
  ladder.verticalStepBottom = WallClimbLadderStep();
  ladder.exitStepJump = 0.6;
  ladder.verticalStepJump = 0.2;
  ladder.enterOffset = 0.5;
  return ladder;
}

// The whole grab, entry and bottom step, while the game moves V itself.
public func WallClimbGrabTime() -> Float {
  return WallClimbStateValue("ladder", "enterDurationBottom", 0.2) + WallClimbStateValue("ladder", "verticalStepDurationBottom", 0.3);
}

// Our ladder when it is the one the state machine holds, else null.
public func WallClimbOurLadder(const stateContext: ref<StateContext>) -> ref<LadderDescription> {
  let ours: ref<IScriptable> = stateContext.GetPermanentScriptableParameter(n"wallClimbLadder");
  if IsDefined(ours) && stateContext.GetConditionScriptableParameter(n"usingLadder") == ours {
    return ours as LadderDescription;
  }
  return null;
}

// Takes our ladder back, never one of the game's. True when there was one.
public func WallClimbWithdraw(const stateContext: ref<StateContext>) -> Bool {
  if !IsDefined(WallClimbOurLadder(stateContext)) {
    return false;
  }
  stateContext.RemoveConditionScriptableParameter(n"usingLadder");
  return true;
}
