// Small edges: the game ends a slide at once when the ground under V climbs 10 degrees or more. The edge of a step a
// few centimetres high reads that way for a moment: slides stopped dead on one, still at 9 to 10 m/s (log of
// 21 October 2026). The tweak file turns the game's test off; this wrapper keeps the rule for a climb that lasts,
// and lets a passing edge go. Switched off, the rule acts at once again, as in the game.

// The game's angle: playerStateMachineLocomotion.slide.minAngleToStopUphillSlide before the tweak file, the same
// for the slide after a fall (slideAfterFall).
public func OmniSlideGameClimbAngle() -> Float {
  return 10.0;
}

// Above this angle the game's test ignores the ground: a wall, not a climb.
public func OmniSlideGameClimbCeiling() -> Float {
  return 89.5;
}

// How long a climb must last to end the slide. Edges seen at slide speeds passed in 0.008 to 0.17 s (log of
// 21 October 2026, the longest at 3.5 m/s).
public func OmniSlideClimbDelay() -> Float {
  return 0.2;
}

// The game's test, copied from SlideDecisions.ToCrouch.
@addMethod(SlideDecisions)
private final const func OmniSlideClimbsSteeply(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !this.IsTouchingGround(scriptInterface) {
    return false;
  }
  let footing: SecureFootingResult = scriptInterface.HasSecureFooting();
  if NotEquals(footing.type, moveSecureFootingFailureType.Invalid) {
    return false;
  }
  if StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"JustVaultedLocomotion") {
    return false;
  }
  let flat: Vector4 = footing.slidingDirection;
  flat.Z = 0.0;
  let angle: Float = Vector4.GetAngleBetween(footing.slidingDirection, flat);
  let uphill: Bool = Vector4.Dot(footing.slidingDirection, DefaultTransition.GetLinearVelocity(scriptInterface)) < 0.0;
  return uphill && angle >= OmniSlideGameClimbAngle() && angle < OmniSlideGameClimbCeiling();
}

// What the slide's report tells about edges (Report.reds).
@addMethod(SlideDecisions)
private final const func OmniSlideNoteEdgePassed(const stateContext: ref<StateContext>, lasted: Float) -> Void {
  stateContext.SetConditionIntParameter(n"OmniSlideEdgesPassed", stateContext.GetConditionInt(n"OmniSlideEdgesPassed") + 1, true);
  if lasted > stateContext.GetConditionFloat(n"OmniSlideLongestEdge") {
    stateContext.SetConditionFloatParameter(n"OmniSlideLongestEdge", lasted, true);
  }
}

@wrapMethod(SlideDecisions)
protected const func ToCrouch(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if wrappedMethod(stateContext, scriptInterface) {
    return true;
  }
  let climbing: Bool = stateContext.GetConditionBool(n"OmniSlideClimbing");
  let now: Float = this.GetInStateTime();
  if !this.OmniSlideClimbsSteeply(scriptInterface) {
    if climbing {
      stateContext.SetConditionBoolParameter(n"OmniSlideClimbing", false, true);
      this.OmniSlideNoteEdgePassed(stateContext, now - stateContext.GetConditionFloat(n"OmniSlideClimbStart"));
    }
    return false;
  }
  if !OmniSlideIsEnabled() {
    return true;
  }
  if !climbing {
    stateContext.SetConditionBoolParameter(n"OmniSlideClimbing", true, true);
    stateContext.SetConditionFloatParameter(n"OmniSlideClimbStart", now, true);
    return false;
  }
  let lasted: Float = now - stateContext.GetConditionFloat(n"OmniSlideClimbStart");
  if lasted < OmniSlideClimbDelay() {
    return false;
  }
  stateContext.SetConditionBoolParameter(n"OmniSlideClimbing", false, true);
  stateContext.SetConditionBoolParameter(n"OmniSlideEndedByClimb", true, true);
  stateContext.SetConditionFloatParameter(n"OmniSlideClimbLasted", lasted, true);
  return true;
}

// A slide that ended for another reason during a climb must not start the next one halfway through its delay.
@wrapMethod(SlideEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  stateContext.SetConditionBoolParameter(n"OmniSlideClimbing", false, true);
  stateContext.SetConditionBoolParameter(n"OmniSlideEndedByClimb", false, true);
  stateContext.SetConditionIntParameter(n"OmniSlideEdgesPassed", 0, true);
  stateContext.SetConditionFloatParameter(n"OmniSlideLongestEdge", 0.0, true);
  wrappedMethod(stateContext, scriptInterface);
}
