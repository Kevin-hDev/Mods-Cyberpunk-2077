// A small bump in a slide: the game goes from the slide to its short fall (slideFall), and from there straight to the
// slide after a fall (slideAfterFall), never back to the slide (playerStateMachineLocomotion.slideFall.transitionTo
// in TweakDB). That landing slide is the same slide: it keeps the boosts the slide started with and gets no second
// one. Every locomotion state notes, as it starts, whether it is the short fall; a slide after a fall that follows
// it is a resumed slide. A real fall in between (slideFall to fall) makes the landing slide a new one.

@wrapMethod(LocomotionEventsTransition)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  stateContext.SetPermanentBoolParameter(n"AxleSlideBumped", Equals(this.GetStateName(), n"slideFall"), true);
}

// Read before the slide's common start, which notes the slide itself.
@addMethod(SlideEvents)
private final func AxleSlideIsResumed(stateContext: ref<StateContext>) -> Bool {
  return Equals(this.GetStateName(), n"slideAfterFall") && stateContext.GetBoolParameter(n"AxleSlideBumped", true);
}
