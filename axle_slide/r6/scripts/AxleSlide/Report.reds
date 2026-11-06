// One log line per slide, written as it ends: each line is written to disk at once (Log.reds), so a slide is told
// once instead of at every change. The other parts of the mod note what they did; this file tells it.

@addField(SlideEvents)
public let axleSlideStartSpeed: Float;

@addField(SlideEvents)
public let axleSlideResumed: Bool;

@addField(SlideEvents)
public let axleSlideRulesKept: Bool;

@addField(SlideEvents)
public let axleSlideNormalStart: Float;

@addField(SlideEvents)
public let axleSlideTarget: Float;

@addField(SlideEvents)
public let axleSlideLowestBraking: Float;

@addField(SlideEvents)
public let axleSlideHighestBraking: Float;

@addMethod(SlideEvents)
private final func AxleSlideReportBegin(stateContext: ref<StateContext>, speed: Float, resumed: Bool) -> Void {
  this.axleSlideStartSpeed = speed;
  this.axleSlideResumed = resumed;
  this.axleSlideRulesKept = !this.axleSlideBoosted && this.AxleSlideRulesOpenedByOther(stateContext);
  this.axleSlideNormalStart = 0.0;
  this.axleSlideTarget = 0.0;
  this.axleSlideLowestBraking = 1.0;
  this.axleSlideHighestBraking = 1.0;
}

@addMethod(SlideEvents)
private final func AxleSlideReportBoost(normal: Float, target: Float) -> Void {
  this.axleSlideNormalStart = normal;
  this.axleSlideTarget = target;
}

@addMethod(SlideEvents)
private final func AxleSlideReportBraking(braking: Float) -> Void {
  this.axleSlideLowestBraking = MinF(this.axleSlideLowestBraking, braking);
  this.axleSlideHighestBraking = MaxF(this.axleSlideHighestBraking, braking);
}

@addMethod(SlideEvents)
private final func AxleSlideBoostFacts() -> String {
  if !this.axleSlideBoosted {
    return "switch off at the start, the game's rules kept open by another mod " + ToString(this.axleSlideRulesKept);
  }
  let facts: String = "speed boost none";
  if this.axleSlideResumed {
    facts = "resumed after a bump, boosts kept";
  } else {
    if this.axleSlideTarget > 0.0 {
      facts = "normal start " + ToString(this.axleSlideNormalStart) + ", start asked " + ToString(this.axleSlideTarget);
    }
  }
  return facts + ", distance gain " + ToString(this.axleSlideGain) + ", braking x" + ToString(this.axleSlideLowestBraking) + " to x" + ToString(this.axleSlideHighestBraking);
}

@addMethod(SlideEvents)
private final func AxleSlideReportEnd(scriptInterface: ref<StateGameScriptInterface>, enabled: Bool) -> Void {
  AxleSlideLog(NameToString(this.GetStateName()) + " end after " + ToString(this.GetInStateTime()) + " s: speed " + ToString(this.axleSlideStartSpeed) + " at the start, " + ToString(Vector4.Length2D(DefaultTransition.GetLinearVelocity(scriptInterface))) + " at the end; " + this.AxleSlideBoostFacts() + "; steering asked " + ToString(this.axleSlideAsked) + ", turned " + ToString(this.axleSlideTurned) + ", frames cut by the push limit " + ToString(this.axleSlidePushesCut) + "; switch on " + ToString(enabled));
}
