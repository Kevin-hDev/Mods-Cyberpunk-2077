// The soft landing tells the game every landing is regular (Landing.reds), and the game takes V onto a ladder from a
// fall only when the landing would be less than very hard (LadderDecisions.EnterCondition, scripts 2.31). Without
// this, V caught a ladder, the game's or another mod's, falling at up to 38 m/s after a grapple and stopped dead on it.
// So the entry is judged on the landing the game itself worked out, as without the mod: a fast fall passes ladders by
// and lands softly.

// The game refuses a ladder from LandingType VeryHard on.
public func ApexGrappleLadderLandingLimit() -> Int32 {
  return 3;
}

@wrapMethod(LadderDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !wrappedMethod(stateContext, scriptInterface) {
    return false;
  }
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !IsDefined(system) || !system.trajectory || system.gameLanding < ApexGrappleLadderLandingLimit() {
    return true;
  }
  system.ladderRefusals = system.ladderRefusals + 1;
  return false;
}
