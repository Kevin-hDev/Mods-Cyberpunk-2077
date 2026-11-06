// The automatic sprint waits for a reload. A held sprint key starts no sprint during a reload without a new press
// (SprintDecisions.EnterCondition), and an empty magazine reloads only out of a sprint (NoAmmoDecisions.ToReload). The
// sprint toggle that the mod switches on skips the first rule, and entering a sprint stops the reload
// (SprintEvents.OnEnter, TryInterruptReload): without this wait, walking forward would cancel every reload, and an
// empty magazine would not reload while V moves forward (read in the scripts 2.31, audit of 25 October 2026). The
// perk that allows reloading while sprinting lifts both rules, and so the wait. Since 2.5 each hand has its own weapon
// state, and the game's sprint rule looks at both (SprintDecisions.EnterCondition, decompiled 2.5 scripts, 29 October).

@addMethod(SprintDecisions)
private final const func AutoSprintWaitsForReload(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if scriptInterface.HasStatFlag(gamedataStatType.CanWeaponReloadWhileSprinting) {
    return false;
  }
  let states: ref<PlayerStateMachineDef> = GetAllBlackboardDefs().PlayerStateMachine;
  return AutoSprintHandWaits(scriptInterface.localBlackboard.GetInt(states.RightWeapon), ShootTransition.GetRightWeapon(scriptInterface))
    || AutoSprintHandWaits(scriptInterface.localBlackboard.GetInt(states.LeftWeapon), ShootTransition.GetLeftWeapon(scriptInterface));
}

public func AutoSprintHandWaits(weaponState: Int32, weapon: ref<WeaponObject>) -> Bool {
  if weaponState == EnumInt(gamePSMRangedWeaponStates.Reload) {
    return true;
  }
  return weaponState == EnumInt(gamePSMRangedWeaponStates.NoAmmo) && IsDefined(weapon) && WeaponObject.CanReload(weapon);
}

// One line per reload, for the log: whether it went to its end.
@wrapMethod(ReloadEvents)
protected func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  AutoSprintLogReloadEnd(stateContext, this.GetInStateTime());
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(ReloadEvents)
protected func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  AutoSprintLogReloadEnd(stateContext, this.GetInStateTime());
  wrappedMethod(stateContext, scriptInterface);
}

public func AutoSprintLogReloadEnd(stateContext: ref<StateContext>, duration: Float) -> Void {
  if !AutoSprintIsEnabled() {
    return;
  }
  let finished: Bool = stateContext.GetBoolParameter(n"FinishedReload", true);
  AutoSprintLog("reload " + (finished ? "finished" : "interrupted") + " after " + ToString(duration) + " s");
}
