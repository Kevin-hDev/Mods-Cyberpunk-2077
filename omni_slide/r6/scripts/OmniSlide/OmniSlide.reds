// Omni Slide: the slide works in every direction, and V's body turns with the camera during it.
// The tweak file opens the game's rules when a save loads. While the switch is off, these wrappers bring the
// game's own rules back, so the switch acts at once.
//
// Another mod may open the same rules (the heading lock and the back key's braking). Each mod that opens them stamps
// the game time of the slide's start in the shared SlideRulesOpenedAt parameter; a mod that is off puts a rule back
// only when nothing stamped this slide. Whatever order the mods' wrappers run in, a mod that is on writes the open
// value after a mod that is off has written the game's, or the mod that is off sees the stamp.

// The game's entry limit, as for the sprint: playerStateMachineLocomotion.slide.enterAngleThreshold, and the same
// for the slide after a fall (slideAfterFall).
public func OmniSlideGameAngle() -> Float {
  return 55.0;
}

public func OmniSlideGameTime(const scriptInterface: ref<StateGameScriptInterface>) -> Float {
  return EngineTime.ToFloat(GameInstance.GetSimTime(scriptInterface.executionOwner.GetGame()));
}

@wrapMethod(SlideDecisions)
protected const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !wrappedMethod(stateContext, scriptInterface) {
    return false;
  }
  if OmniSlideIsEnabled() {
    return true;
  }
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  let angle: Float = Vector4.GetAngleBetween(scriptInterface.executionOwner.GetWorldForward(), velocity);
  if AbsF(angle) <= OmniSlideGameAngle() {
    return true;
  }
  OmniSlideLogRefusal(stateContext, scriptInterface, angle);
  return false;
}

@addField(SlideEvents)
public let omniSlideEnteredAt: Float;

@addMethod(SlideEvents)
private final func OmniSlideRulesOpenedByOther(stateContext: ref<StateContext>) -> Bool {
  return stateContext.GetFloatParameter(n"SlideRulesOpenedAt", true) == this.omniSlideEnteredAt;
}

@wrapMethod(SlideEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  // Before the game asks the camera for its slide settings, so the camera reads the lock wanted.
  this.omniSlideEnteredAt = OmniSlideGameTime(scriptInterface);
  if OmniSlideIsEnabled() {
    stateContext.SetPermanentFloatParameter(n"SlideRulesOpenedAt", this.omniSlideEnteredAt, true);
    OmniSlideSetHeadingLock(false);
  } else {
    if !this.OmniSlideRulesOpenedByOther(stateContext) {
      OmniSlideSetHeadingLock(true);
    }
  }
  wrappedMethod(stateContext, scriptInterface);
}

// The game brakes the slide while the back key is held; the tweak file turns that off for backward slides.
@wrapMethod(SlideEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  if !OmniSlideIsEnabled() && !this.OmniSlideRulesOpenedByOther(stateContext) {
    this.EvaluateSlideDeceleration(stateContext, scriptInterface);
  }
}
