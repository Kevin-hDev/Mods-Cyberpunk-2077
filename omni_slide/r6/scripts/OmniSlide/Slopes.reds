// Slopes: going down, a slide brakes less and goes farther; on a steep enough
// descent it stops slowing and goes on until the ground flattens; going up, it brakes harder. The game itself brakes
// a slide by the same 2.75 m/s every second on any slope (log of 21 October 2026, from 7 degrees up to 7 down), and
// ends it on a climb of 10 degrees or more, a rule kept as it is.
// The braking comes from the Deceleration stat: ten times a second, a multiplier on it follows the slope under V,
// 1 - strength x sin(slope) / sin(12 degrees). A slope pulls like gravity, in proportion to its sine, so at strength
// 1 a 12 degree descent cancels the braking whatever its measured value; a 7 degree climb multiplies it by 1.6.
// It may go below 0 on a steep descent, to push V on; whether the engine accepts that, the log will tell.

// The descent on which, at strength 1, the slope's pull cancels the game's braking.
public func OmniSlideBalancedDescent() -> Float {
  return 12.0;
}

// How often the braking follows the slope, in seconds.
public func OmniSlideBrakingInterval() -> Float {
  return 0.1;
}

@addField(SlideEvents)
public let omniSlideSlopeModifier: ref<gameStatModifierData>;

@addField(SlideEvents)
public let omniSlideSlopeFactor: Float;

@addField(SlideEvents)
public let omniSlideBrakingTick: Int32;

@addMethod(SlideEvents)
private final func OmniSlideSetBraking(scriptInterface: ref<StateGameScriptInterface>, factor: Float) -> Void {
  let stats: ref<StatsSystem> = scriptInterface.GetStatsSystem();
  let ownerID: StatsObjectID = Cast<StatsObjectID>(scriptInterface.ownerEntityID);
  if IsDefined(this.omniSlideSlopeModifier) {
    stats.RemoveModifier(ownerID, this.omniSlideSlopeModifier);
    this.omniSlideSlopeModifier = null;
  }
  this.omniSlideSlopeFactor = factor;
  if factor != 1.0 {
    this.omniSlideSlopeModifier = RPGManager.CreateStatModifier(gamedataStatType.Deceleration, gameStatModifierType.Multiplier, factor);
    stats.AddModifier(ownerID, this.omniSlideSlopeModifier);
  }
}

// The sine of the slope along the slide, positive going down: ground that falls away ahead tilts its normal forward.
@addMethod(SlideEvents)
private final func OmniSlideDownhill(scriptInterface: ref<StateGameScriptInterface>) -> Float {
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  let flat: Float = Vector4.Length2D(velocity);
  if flat < 0.5 || !scriptInterface.IsOnGround() {
    return 0.0;
  }
  let footing: SecureFootingResult = scriptInterface.HasSecureFooting();
  let normal: Vector4 = footing.normalDirection;
  return ClampF((normal.X * velocity.X + normal.Y * velocity.Y) / flat, -1.0, 1.0);
}

@wrapMethod(SlideEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  this.omniSlideBrakingTick = -1;
  this.omniSlideSlopeFactor = 1.0;
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(SlideEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  let tick: Int32 = Cast<Int32>(this.GetInStateTime() / OmniSlideBrakingInterval());
  if tick == this.omniSlideBrakingTick {
    return;
  }
  this.omniSlideBrakingTick = tick;
  let factor: Float = 1.0;
  let strength: Float = OmniSlideSlopeStrength();
  if strength > 0.0 {
    let downhill: Float = this.OmniSlideDownhill(scriptInterface);
    factor = ClampF(1.0 - strength * downhill / SinF(Deg2Rad(OmniSlideBalancedDescent())), -1.0, 3.0);
  }
  if AbsF(factor - this.omniSlideSlopeFactor) < 0.05 {
    return;
  }
  this.OmniSlideSetBraking(scriptInterface, factor);
  this.OmniSlideReportBraking(factor);
}

@wrapMethod(SlideEvents)
public final func OnExitHelper(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, dontStopRumble: Bool) -> Void {
  this.OmniSlideSetBraking(scriptInterface, 1.0);
  wrappedMethod(stateContext, scriptInterface, dontStopRumble);
}
