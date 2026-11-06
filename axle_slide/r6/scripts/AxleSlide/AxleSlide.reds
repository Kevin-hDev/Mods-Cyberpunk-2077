// Axle Slide: slides that follow the move keys as walking does, start faster and go farther, as Axle's slides in
// Apex Legends. The slide's start, every frame of it and its end are wired here; the parts live in Bumps.reds,
// SlideRules.reds, Steering.reds, Boost.reds and Report.reds.

// Whether this slide is an Axle slide: its boosts stay to its end even if the switch goes off meanwhile, and a slide
// resumed after a bump keeps what its first part had.
@addField(SlideEvents)
public let axleSlideBoosted: Bool;

@wrapMethod(SlideEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let resumed: Bool = this.AxleSlideIsResumed(stateContext);
  let settings: ref<AxleSlideSettings> = AxleSlideCurrentSettings();
  this.AxleSlideOpenRules(stateContext, scriptInterface, settings.enabled);
  wrappedMethod(stateContext, scriptInterface);
  if resumed {
    this.axleSlideBoosted = stateContext.GetBoolParameter(n"AxleSlideRunBoosted", true);
  } else {
    this.axleSlideBoosted = settings.enabled;
    stateContext.SetPermanentBoolParameter(n"AxleSlideRunBoosted", settings.enabled, true);
  }
  let speed: Float = Vector4.Length2D(DefaultTransition.GetLinearVelocity(scriptInterface));
  this.AxleSlideReportBegin(stateContext, speed, resumed);
  this.AxleSlideStartSteering(scriptInterface);
  if this.axleSlideBoosted {
    this.AxleSlideStartBoost(stateContext, scriptInterface, settings, speed, resumed);
  }
}

@wrapMethod(SlideEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  if this.axleSlideBoosted && this.axleSlideBrakes {
    this.AxleSlideUpdateBraking(scriptInterface);
  }
  let settings: ref<AxleSlideSettings> = AxleSlideCurrentSettings();
  if !settings.enabled {
    this.AxleSlideKeepGameBraking(stateContext, scriptInterface);
    return;
  }
  if settings.steering > 0.0 {
    this.AxleSlideSteer(timeDelta, settings.steering, stateContext, scriptInterface);
  }
}

// Every way out of the slide goes through OnExitHelper.
@wrapMethod(SlideEvents)
public final func OnExitHelper(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, dontStopRumble: Bool) -> Void {
  let settings: ref<AxleSlideSettings> = AxleSlideCurrentSettings();
  this.AxleSlideReportEnd(scriptInterface, settings.enabled);
  this.AxleSlideRemoveBoost(scriptInterface);
  wrappedMethod(stateContext, scriptInterface, dontStopRumble);
}
