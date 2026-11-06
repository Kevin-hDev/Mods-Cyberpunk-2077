// Slide speed. At the start of a slide the game gives V a boost: the SpeedBoost stat, never past the
// SpeedBoostMaxSpeed stat, never slowing V down (log of 21 October 2026: 8.2 -> 11.0, 11.8 -> 12.8, 15 -> 15).
// A push of our own (AddImpulse) at 15 m/s did nothing, so the setting raises the game's boost and its cap instead,
// to reach the game's start speed times the setting. A faster start also makes the slide go farther.
// The engine holds V at 15 m/s unless the hold is lifted (SpeedLimit.reds). Read at the start of each slide.

// The fastest a boosted slide may start: the engine's extended ground limit, raised to 50 m/s (180 km/h) by
// r6/tweaks/OmniSlide/speed_cap.yaml, 30 in the game. Asking for more would only be cut by the engine.
public func OmniSlideTopSpeed() -> Float {
  return TweakDBInterface.GetFloat(t"player.locomotion.extendedMaxGroundSpeed", 30.0);
}

@addField(SlideEvents)
public let omniSlideBoostModifier: ref<gameStatModifierData>;

@addField(SlideEvents)
public let omniSlideBoostCapModifier: ref<gameStatModifierData>;

@addMethod(SlideEvents)
private final func OmniSlideAddModifier(scriptInterface: ref<StateGameScriptInterface>, stat: gamedataStatType, value: Float) -> ref<gameStatModifierData> {
  let modifier: ref<gameStatModifierData> = RPGManager.CreateStatModifier(stat, gameStatModifierType.Additive, value);
  scriptInterface.GetStatsSystem().AddModifier(Cast<StatsObjectID>(scriptInterface.ownerEntityID), modifier);
  return modifier;
}

@addMethod(SlideEvents)
private final func OmniSlideDropModifier(scriptInterface: ref<StateGameScriptInterface>, modifier: ref<gameStatModifierData>) -> Void {
  if IsDefined(modifier) {
    scriptInterface.GetStatsSystem().RemoveModifier(Cast<StatsObjectID>(scriptInterface.ownerEntityID), modifier);
  }
}

@addMethod(SlideEvents)
private final func OmniSlideRemoveSpeed(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  this.OmniSlideDropModifier(scriptInterface, this.omniSlideBoostModifier);
  this.OmniSlideDropModifier(scriptInterface, this.omniSlideBoostCapModifier);
  this.omniSlideBoostModifier = null;
  this.omniSlideBoostCapModifier = null;
}

// Returns the speed asked for, or 0 when the game's own boost stands.
@addMethod(SlideEvents)
private final func OmniSlideApplySpeed(scriptInterface: ref<StateGameScriptInterface>, speed: Float, resumed: Bool) -> Float {
  this.OmniSlideRemoveSpeed(scriptInterface);
  let factor: Float = OmniSlideSpeedFactor();
  if factor <= 1.0 || resumed {
    return 0.0;
  }
  let stats: ref<StatsSystem> = scriptInterface.GetStatsSystem();
  let ownerID: StatsObjectID = Cast<StatsObjectID>(scriptInterface.ownerEntityID);
  // Read here, these are the slide's own values (log: 3 up to 13 at every start).
  let boost: Float = stats.GetStatValue(ownerID, gamedataStatType.SpeedBoost);
  let cap: Float = stats.GetStatValue(ownerID, gamedataStatType.SpeedBoostMaxSpeed);
  let gameStart: Float = speed + ClampF(cap - speed, 0.0, boost);
  let target: Float = MinF(gameStart * factor, OmniSlideTopSpeed());
  if target <= gameStart {
    return 0.0;
  }
  this.omniSlideBoostModifier = this.OmniSlideAddModifier(scriptInterface, gamedataStatType.SpeedBoost, target - speed - boost);
  this.omniSlideBoostCapModifier = this.OmniSlideAddModifier(scriptInterface, gamedataStatType.SpeedBoostMaxSpeed, target - cap);
  return target;
}

@wrapMethod(SlideEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let resumed: Bool = this.OmniSlideIsResumed(stateContext);
  wrappedMethod(stateContext, scriptInterface);
  let speed: Float = Vector4.Length2D(DefaultTransition.GetLinearVelocity(scriptInterface));
  let target: Float = this.OmniSlideApplySpeed(scriptInterface, speed, resumed);
  this.OmniSlideReportBegin(speed, target, resumed);
}

// Every way out of the slide goes through OnExitHelper.
@wrapMethod(SlideEvents)
public final func OnExitHelper(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, dontStopRumble: Bool) -> Void {
  this.OmniSlideRemoveSpeed(scriptInterface);
  wrappedMethod(stateContext, scriptInterface, dontStopRumble);
}
