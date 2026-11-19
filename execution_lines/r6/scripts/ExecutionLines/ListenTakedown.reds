// E1: every execution the game makes from a grab (on the ground, from above, on a massive target, on a boss), and
// those of a mod that goes through the same function, heard as the animation starts (conception, section 5).

// The declaration is the game's own (locomotionTakedown.script:519, scripts 2.5). The game's work comes first and
// nothing of ours stands before it, so that our listener can never keep the game from killing or knocking out.
@wrapMethod(LocomotionTakedownEvents)
private final func DefeatTarget(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, activator: wref<GameObject>, target: wref<GameObject>, effectName: CName, effectTag: CName) -> Void {
  wrappedMethod(stateContext, scriptInterface, activator, target, effectName, effectTag);
  ExecutionLinesHeardTakedown(scriptInterface, target, effectTag);
}

// The game calls DefeatTarget for every grab action, also those that are not executions: a grab that fails, a person
// who breaks free, already dead, or shoved away. Those come with no effect tag (locomotionTakedown.script:460-467,
// :501-503, :516).
// Lethal when the tag is the game's "kill" or names one of the game's finishers: a finisher always marks the person
// for death (finisher.script:121-123), and HasEffect(n"playFinisher", tag) is the game's own test for such a name
// (finisher.script:182). Any other tag is non-lethal, the game's setUnconscious... tags and a boss's <phase>_damage
// among them: a tag nobody knows gets a phrase that fits both, since a killing phrase said to someone who lives is the
// failure to avoid. The person's killer is not read: the game names V the killer of people who may live on
// (NPCPuppet.script:3082, OnPotentialDeath) and never clears it, and the one SetMyKiller made before this call (:472)
// already comes with the "kill" tag.
public func ExecutionLinesHeardTakedown(scriptInterface: ref<StateGameScriptInterface>, target: wref<GameObject>, effectTag: CName) -> Void {
  if !IsDefined(scriptInterface) {
    return;
  }
  if !ExecutionLinesListening() {
    return;
  }
  let game: GameInstance = scriptInterface.GetGame();
  if !IsNameValid(effectTag) {
    let system: ref<ExecutionLinesSystem> = ExecutionLinesSystemOf(game);
    let most: Int32 = ExecutionLinesLogMost();
    if IsDefined(system) && system.noEffectLines <= most {
      system.noEffectLines = ExecutionLinesLogUpTo(system.noEffectLines, most, "takedown actions without an effect", "takedown action without an effect: not an execution");
    }
    return;
  }
  let player: ref<GameObject> = scriptInterface.executionOwner;
  let victim: ref<GameObject> = target;
  let lethal: Bool = Equals(effectTag, n"kill") || GameInstance.GetGameEffectSystem(game).HasEffect(n"playFinisher", effectTag);
  ExecutionLinesOccasion(game, player, victim, lethal, "E1, tag " + NameToString(effectTag));
}
