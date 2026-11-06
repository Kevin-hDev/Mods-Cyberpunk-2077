// Boosts, as Axle's slides in Borderlands 4 (Apex Movement 0.7.0, validated by Kevin on 17 September 2026): each slide
// starts faster than a normal one, and goes farther on flat ground and on slopes. Both are measured against the
// normal slide, so whatever else shapes the slide counts for the Axle slide too. A slide keeps to its end the boosts
// it started with, through a bump too (Bumps.reds).
//
// Speed: at the start the game gives V its boost (the SpeedBoost stat, never past SpeedBoostMaxSpeed, never slowing
// V down: log of 21 October 2026). The mod reads both stats, works out the normal start speed, and raises both so the
// slide starts the boost faster, but never past the boost above the game's top start (SpeedBoostMaxSpeed): as in
// Borderlands 4, V arriving faster than that keeps the speed and gets nothing more, so slides chained after jumps or
// bumps do not build up speed (Kevin, 25 October 2026). Reading the stats rather than the game's numbers lets another
// mod do the same: the one that acts second reads the boost and the top start already raised by the first.
//
// Distance: the game brakes a slide by the same amount every second (Deceleration stat), so it goes
// (start² - stop²) / (2 × braking). Starting faster already goes farther by the ratio of those squares; the braking is
// multiplied by that gain over the distance wanted, ten times a second as the slope under V changes.

// The game ends a slide below this speed: playerStateMachineLocomotion.slide.minSpeedToExit.
public func AxleSlideStopSpeed() -> Float {
  return 2.5;
}

// The flat boost holds up to this sine of slope, and has given way to the slope boost by the next one (about 3 and
// 6 degrees): Borderlands 4's thresholds, where flat slides read -0.06 to +0.04 and real slopes 0.11 to 0.28.
public func AxleSlideFlatSlope() -> Float {
  return 0.05;
}

public func AxleSlideFullSlope() -> Float {
  return 0.10;
}

// The fastest a boosted slide may start: the engine's extended ground limit (30 in the game, higher when a tweak
// raises it). Asking for more would only be cut by the engine.
public func AxleSlideTopSpeed() -> Float {
  return TweakDBInterface.GetFloat(t"player.locomotion.extendedMaxGroundSpeed", 30.0);
}

// How often the braking follows the slope, in seconds.
public func AxleSlideBrakingInterval() -> Float {
  return 0.1;
}

// A braking change smaller than this is not written.
public func AxleSlideBrakingChange() -> Float {
  return 0.02;
}

// The braking multiplier stays within these, whatever a very slow start gives.
public func AxleSlideLeastBraking() -> Float {
  return 0.1;
}

public func AxleSlideMostBraking() -> Float {
  return 5.0;
}

@addField(SlideEvents)
public let axleSlideBoostModifier: ref<gameStatModifierData>;

@addField(SlideEvents)
public let axleSlideBoostCapModifier: ref<gameStatModifierData>;

@addField(SlideEvents)
public let axleSlideBrakingModifier: ref<gameStatModifierData>;

@addField(SlideEvents)
public let axleSlideBraking: Float;

@addField(SlideEvents)
public let axleSlideBrakingTick: Int32;

@addField(SlideEvents)
public let axleSlideGain: Float;

@addField(SlideEvents)
public let axleSlideFlatDistance: Float;

@addField(SlideEvents)
public let axleSlideSlopeDistance: Float;

// Whether the braking differs from the game's at all, and whether it follows the slope.
@addField(SlideEvents)
public let axleSlideBrakes: Bool;

@addField(SlideEvents)
public let axleSlideBrakingVaries: Bool;

@addMethod(SlideEvents)
private final func AxleSlideSetModifier(scriptInterface: ref<StateGameScriptInterface>, old: ref<gameStatModifierData>, stat: gamedataStatType, type: gameStatModifierType, value: Float) -> ref<gameStatModifierData> {
  let stats: ref<StatsSystem> = scriptInterface.GetStatsSystem();
  let ownerID: StatsObjectID = Cast<StatsObjectID>(scriptInterface.ownerEntityID);
  if IsDefined(old) {
    stats.RemoveModifier(ownerID, old);
  }
  if (Equals(type, gameStatModifierType.Additive) && value == 0.0) || (Equals(type, gameStatModifierType.Multiplier) && value == 1.0) {
    return null;
  }
  let modifier: ref<gameStatModifierData> = RPGManager.CreateStatModifier(stat, type, value);
  stats.AddModifier(ownerID, modifier);
  return modifier;
}

@addMethod(SlideEvents)
private final func AxleSlideStat(scriptInterface: ref<StateGameScriptInterface>, stat: gamedataStatType) -> Float {
  return scriptInterface.GetStatsSystem().GetStatValue(Cast<StatsObjectID>(scriptInterface.ownerEntityID), stat);
}

// Raises the game's boost and its cap toward the boosted start; returns the distance gain of that faster start.
@addMethod(SlideEvents)
private final func AxleSlideRaiseStart(scriptInterface: ref<StateGameScriptInterface>, speedBoost: Float, speed: Float) -> Float {
  if speedBoost <= 0.0 {
    return 1.0;
  }
  // Read here, these are the slide's own values (log of 21 October 2026: 3 up to 13 at every start).
  let boost: Float = this.AxleSlideStat(scriptInterface, gamedataStatType.SpeedBoost);
  let cap: Float = this.AxleSlideStat(scriptInterface, gamedataStatType.SpeedBoostMaxSpeed);
  let normal: Float = speed + ClampF(cap - speed, 0.0, boost);
  let target: Float = MaxF(MinF(MinF(normal, cap) * (1.0 + speedBoost / 100.0), AxleSlideTopSpeed()), normal);
  this.AxleSlideReportBoost(normal, target);
  if target <= normal {
    return 1.0;
  }
  this.axleSlideBoostModifier = this.AxleSlideSetModifier(scriptInterface, this.axleSlideBoostModifier, gamedataStatType.SpeedBoost, gameStatModifierType.Additive, target - speed - boost);
  this.axleSlideBoostCapModifier = this.AxleSlideSetModifier(scriptInterface, this.axleSlideBoostCapModifier, gamedataStatType.SpeedBoostMaxSpeed, gameStatModifierType.Additive, MaxF(target - cap, 0.0));
  let stop: Float = AxleSlideStopSpeed();
  return MaxF(target * target - stop * stop, 1.0) / MaxF(normal * normal - stop * stop, 1.0);
}

// A resumed slide takes the gain and distances its first part started with; they are kept in the state machine
// because the slide after a fall is another state, with fields of its own.
@addMethod(SlideEvents)
private final func AxleSlideStartBoost(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, settings: ref<AxleSlideSettings>, speed: Float, resumed: Bool) -> Void {
  this.axleSlideBrakingTick = -1;
  let carried: Float = stateContext.GetFloatParameter(n"AxleSlideGain", true);
  if resumed && carried > 0.0 {
    this.axleSlideGain = carried;
    this.axleSlideFlatDistance = stateContext.GetFloatParameter(n"AxleSlideFlatDistance", true);
    this.axleSlideSlopeDistance = stateContext.GetFloatParameter(n"AxleSlideSlopeDistance", true);
  } else {
    this.axleSlideFlatDistance = 1.0 + settings.flatBoost / 100.0;
    this.axleSlideSlopeDistance = 1.0 + settings.slopeBoost / 100.0;
    this.axleSlideGain = this.AxleSlideRaiseStart(scriptInterface, settings.speedBoost, speed);
    stateContext.SetPermanentFloatParameter(n"AxleSlideGain", this.axleSlideGain, true);
    stateContext.SetPermanentFloatParameter(n"AxleSlideFlatDistance", this.axleSlideFlatDistance, true);
    stateContext.SetPermanentFloatParameter(n"AxleSlideSlopeDistance", this.axleSlideSlopeDistance, true);
  }
  this.axleSlideBrakingVaries = this.axleSlideFlatDistance != this.axleSlideSlopeDistance;
  this.axleSlideBrakes = this.axleSlideBrakingVaries || AbsF(this.axleSlideGain / this.axleSlideFlatDistance - 1.0) >= AxleSlideBrakingChange();
}

// The sine of the slope along the slide, positive going down: ground that falls away ahead tilts its normal forward.
@addMethod(SlideEvents)
private final func AxleSlideDownhill(scriptInterface: ref<StateGameScriptInterface>) -> Float {
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  let flat: Float = Vector4.Length2D(velocity);
  if flat < 0.5 || !scriptInterface.IsOnGround() {
    return 0.0;
  }
  let footing: SecureFootingResult = scriptInterface.HasSecureFooting();
  let normal: Vector4 = footing.normalDirection;
  return ClampF((normal.X * velocity.X + normal.Y * velocity.Y) / flat, -1.0, 1.0);
}

// With equal flat and slope boosts the slope changes nothing: the braking is written once.
@addMethod(SlideEvents)
private final func AxleSlideUpdateBraking(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let tick: Int32 = Cast<Int32>(this.GetInStateTime() / AxleSlideBrakingInterval());
  if tick == this.axleSlideBrakingTick || (this.axleSlideBrakingTick >= 0 && !this.axleSlideBrakingVaries) {
    return;
  }
  this.axleSlideBrakingTick = tick;
  let distance: Float = this.axleSlideFlatDistance;
  if this.axleSlideBrakingVaries {
    let slope: Float = AbsF(this.AxleSlideDownhill(scriptInterface));
    let share: Float = ClampF((slope - AxleSlideFlatSlope()) / (AxleSlideFullSlope() - AxleSlideFlatSlope()), 0.0, 1.0);
    distance = this.axleSlideFlatDistance + (this.axleSlideSlopeDistance - this.axleSlideFlatDistance) * share;
  }
  let braking: Float = ClampF(this.axleSlideGain / distance, AxleSlideLeastBraking(), AxleSlideMostBraking());
  if AbsF(braking - this.axleSlideBraking) < AxleSlideBrakingChange() {
    return;
  }
  this.axleSlideBraking = braking;
  this.axleSlideBrakingModifier = this.AxleSlideSetModifier(scriptInterface, this.axleSlideBrakingModifier, gamedataStatType.Deceleration, gameStatModifierType.Multiplier, braking);
  this.AxleSlideReportBraking(braking);
}

@addMethod(SlideEvents)
private final func AxleSlideRemoveBoost(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  this.axleSlideBoostModifier = this.AxleSlideSetModifier(scriptInterface, this.axleSlideBoostModifier, gamedataStatType.SpeedBoost, gameStatModifierType.Additive, 0.0);
  this.axleSlideBoostCapModifier = this.AxleSlideSetModifier(scriptInterface, this.axleSlideBoostCapModifier, gamedataStatType.SpeedBoostMaxSpeed, gameStatModifierType.Additive, 0.0);
  this.axleSlideBrakingModifier = this.AxleSlideSetModifier(scriptInterface, this.axleSlideBrakingModifier, gamedataStatType.Deceleration, gameStatModifierType.Multiplier, 1.0);
  this.axleSlideBraking = 1.0;
  this.axleSlideBrakingTick = -1;
}
