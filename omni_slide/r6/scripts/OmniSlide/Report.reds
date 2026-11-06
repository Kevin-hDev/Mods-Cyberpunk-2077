// One log line per slide, written as it ends: each line is written to disk at once (Log.reds), so a slide is told
// once instead of at every change. The other parts of the mod note what they did; this file tells it.

// When V's speed is read after the start, once the boost has acted.
public func OmniSlideEarlySpeedAfter() -> Float {
  return 0.1;
}

// At most one line about slides refused by the switch, every this many seconds.
public func OmniSlideRefusalReportEvery() -> Float {
  return 2.0;
}

@addField(SlideEvents)
public let omniSlideStartSpeed: Float;

@addField(SlideEvents)
public let omniSlideTarget: Float;

@addField(SlideEvents)
public let omniSlideResumed: Bool;

@addField(SlideEvents)
public let omniSlideEarlySpeed: Float;

@addField(SlideEvents)
public let omniSlideEarlyRead: Bool;

@addField(SlideEvents)
public let omniSlideLowestBraking: Float;

@addField(SlideEvents)
public let omniSlideHighestBraking: Float;

@addMethod(SlideEvents)
public final func OmniSlideReportBegin(speed: Float, target: Float, resumed: Bool) -> Void {
  this.omniSlideStartSpeed = speed;
  this.omniSlideTarget = target;
  this.omniSlideResumed = resumed;
  this.omniSlideEarlyRead = false;
  this.omniSlideLowestBraking = 1.0;
  this.omniSlideHighestBraking = 1.0;
}

@addMethod(SlideEvents)
public final func OmniSlideReportBraking(factor: Float) -> Void {
  this.omniSlideLowestBraking = MinF(this.omniSlideLowestBraking, factor);
  this.omniSlideHighestBraking = MaxF(this.omniSlideHighestBraking, factor);
}

@wrapMethod(SlideEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  if !this.omniSlideEarlyRead && this.GetInStateTime() >= OmniSlideEarlySpeedAfter() {
    this.omniSlideEarlyRead = true;
    this.omniSlideEarlySpeed = Vector4.Length2D(DefaultTransition.GetLinearVelocity(scriptInterface));
  }
}

@addMethod(SlideEvents)
private final func OmniSlideEdgeFacts(stateContext: ref<StateContext>) -> String {
  let passed: Int32 = stateContext.GetConditionInt(n"OmniSlideEdgesPassed");
  let facts: String = "edges passed " + ToString(passed);
  if passed > 0 {
    facts = facts + " (longest " + ToString(stateContext.GetConditionFloat(n"OmniSlideLongestEdge")) + " s)";
  }
  if stateContext.GetConditionBool(n"OmniSlideEndedByClimb") {
    facts = facts + ", ended by a climb lasting " + ToString(stateContext.GetConditionFloat(n"OmniSlideClimbLasted")) + " s";
  }
  return facts;
}

// Written before the game's exit, which takes the back key's braking off.
@wrapMethod(SlideEvents)
public final func OnExitHelper(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, dontStopRumble: Bool) -> Void {
  let boost: String = "game boost";
  if this.omniSlideTarget > 0.0 {
    boost = "boost to " + ToString(this.omniSlideTarget);
  }
  let early: String = "-";
  if this.omniSlideEarlyRead {
    early = ToString(this.omniSlideEarlySpeed);
  }
  OmniSlideLog("slide end after " + ToString(this.GetInStateTime()) + " s: speed " + ToString(this.omniSlideStartSpeed) + " at the start, " + early + " after " + ToString(OmniSlideEarlySpeedAfter()) + " s, " + ToString(Vector4.Length2D(DefaultTransition.GetLinearVelocity(scriptInterface))) + " at the end; " + boost + ", resumed " + ToString(this.omniSlideResumed) + "; slope braking x" + ToString(this.omniSlideLowestBraking) + " to x" + ToString(this.omniSlideHighestBraking) + "; " + this.OmniSlideEdgeFacts(stateContext) + "; back key braking " + ToString(this.m_decelerating) + "; switch on " + ToString(OmniSlideIsEnabled()));
  wrappedMethod(stateContext, scriptInterface, dontStopRumble);
}

// Called by the switch's entry test when it turns a slide down; the game time can go back when a save loads.
public func OmniSlideLogRefusal(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>, angle: Float) -> Void {
  let now: Float = OmniSlideGameTime(scriptInterface);
  let next: Float = stateContext.GetConditionFloat(n"OmniSlideRefusalReportAt");
  if now < next && next - now <= OmniSlideRefusalReportEvery() {
    return;
  }
  stateContext.SetConditionFloatParameter(n"OmniSlideRefusalReportAt", now + OmniSlideRefusalReportEvery(), true);
  OmniSlideLog("switch off: slide refused, moving " + ToString(RoundF(angle)) + " degrees off V's front, speed " + ToString(Vector4.Length2D(DefaultTransition.GetLinearVelocity(scriptInterface))));
}
