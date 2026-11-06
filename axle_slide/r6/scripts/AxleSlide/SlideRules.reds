// Two game rules stand in the way of a slide that follows the keys: V's body is held still while the view turns, so
// the game ends the slide once the view is 96 degrees off the body; and the back key brakes the slide instead of
// turning it backward. The tweak file opens both when a save loads; these functions put the game's rules back while
// the switch is off.
//
// Another mod may open the same rules. Each mod that opens them stamps the game time of the slide's start in the
// shared SlideRulesOpenedAt parameter; a mod that is off puts a rule back only when nothing stamped this slide.
// Whatever order the mods' wrappers run in, a mod that is on writes the open value after a mod that is off has
// written the game's, or the mod that is off sees the stamp: the rules are open when any mod wants them open.

public func AxleSlideGameTime(scriptInterface: ref<StateGameScriptInterface>) -> Float {
  return EngineTime.ToFloat(GameInstance.GetSimTime(scriptInterface.executionOwner.GetGame()));
}

// In a script, only TweakXL can change a game value during play: without it this does nothing, and the tweak file is
// not read either, so the slide keeps the game's lock.
@if(ModuleExists("TweakXL"))
public func AxleSlideSetHeadingLock(locked: Bool) -> Void {
  let flat: TweakDBID = t"fppCameraParamSets.Slide.headingLocked";
  if Equals(TweakDBInterface.GetBool(flat, true), locked) {
    return;
  }
  let written: Bool = TweakDBManager.SetFlat(flat, ToVariant(locked));
  AxleSlideLog("heading lock " + ToString(locked) + ", written " + ToString(written));
}

@if(!ModuleExists("TweakXL"))
public func AxleSlideSetHeadingLock(locked: Bool) -> Void {}

@addField(SlideEvents)
public let axleSlideEnteredAt: Float;

// Before the game asks the camera for its slide settings, so the camera reads the lock wanted.
@addMethod(SlideEvents)
private final func AxleSlideOpenRules(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, enabled: Bool) -> Void {
  this.axleSlideEnteredAt = AxleSlideGameTime(scriptInterface);
  if enabled {
    stateContext.SetPermanentFloatParameter(n"SlideRulesOpenedAt", this.axleSlideEnteredAt, true);
    AxleSlideSetHeadingLock(false);
    return;
  }
  if !this.AxleSlideRulesOpenedByOther(stateContext) {
    AxleSlideSetHeadingLock(true);
  }
}

// Switched off in the middle of a slide, the mod takes its own stamp for another mod's: the game's rules come back
// from the next slide.
@addMethod(SlideEvents)
private final func AxleSlideRulesOpenedByOther(stateContext: ref<StateContext>) -> Bool {
  return stateContext.GetFloatParameter(n"SlideRulesOpenedAt", true) == this.axleSlideEnteredAt;
}

// The game's braking on the back key, while the switch is off and no other mod opened the rules for this slide.
@addMethod(SlideEvents)
private final func AxleSlideKeepGameBraking(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !this.AxleSlideRulesOpenedByOther(stateContext) {
    this.EvaluateSlideDeceleration(stateContext, scriptInterface);
  }
}
