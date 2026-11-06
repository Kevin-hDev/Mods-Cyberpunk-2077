// The speed settings: each is a multiplier on the MaxSpeed stat, the stat each locomotion state sets through its stat
// group, and that the game itself lowers during a sprint when V reloads. A multiplier is kept in the state machine's
// context under its own name, so that whichever state comes next can take it off again.

// The settings past 1.0 lift the engine's hold on speed (SpeedLimit.reds) and guard the landings (Landings.reds).
public func AutoSprintFastestFactor() -> Float {
  return MaxF(AutoSprintSpeedFactor(), AutoSprintWalkFactor());
}

// A scene that walks V beside someone sets V's pace by adding to MaxSpeed (SceneTierIIEvents, scripts 2.31): a
// multiplier on top would make V outrun them. The speed settings wait for the end of such a scene.
public func AutoSprintSceneSetsPace(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  return scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel) == EnumInt(gamePSMHighLevel.SceneTier2);
}

// Replaces the multiplier kept under this name by one of this factor; 1.0 only takes the old one off. False when the
// same factor was already on, so that a caller can log only the changes.
public func AutoSprintSetSpeedFactor(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, key: CName, factor: Float) -> Bool {
  let old: ref<gameConstantStatModifierData> = stateContext.GetPermanentScriptableParameter(key) as gameConstantStatModifierData;
  let oldFactor: Float = 1.0;
  if IsDefined(old) {
    oldFactor = old.value;
  }
  if oldFactor == factor {
    return false;
  }
  let statsSystem: ref<StatsSystem> = scriptInterface.GetStatsSystem();
  let ownerID: StatsObjectID = Cast<StatsObjectID>(scriptInterface.ownerEntityID);
  if IsDefined(old) {
    if !statsSystem.RemoveModifier(ownerID, old) {
      AutoSprintLog("the game refused to take off the speed x" + ToString(old.value) + " kept under " + NameToString(key));
    }
    stateContext.RemovePermanentScriptableParameter(key);
  }
  if factor != 1.0 {
    let modifier: ref<gameStatModifierData> = RPGManager.CreateStatModifier(gamedataStatType.MaxSpeed, gameStatModifierType.Multiplier, factor);
    if !statsSystem.AddModifier(ownerID, modifier) {
      AutoSprintLog("the game refused the speed x" + ToString(factor) + " under " + NameToString(key));
    }
    // Kept even when refused, so that a refusal is logged once rather than at every frame that asks again.
    stateContext.SetPermanentScriptableParameter(key, modifier, true);
  }
  return true;
}

public func AutoSprintMaxSpeed(scriptInterface: ref<StateGameScriptInterface>) -> Float {
  return scriptInterface.GetStatsSystem().GetStatValue(Cast<StatsObjectID>(scriptInterface.ownerEntityID), gamedataStatType.MaxSpeed);
}
