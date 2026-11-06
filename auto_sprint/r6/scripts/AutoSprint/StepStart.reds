// Starting a step: a step in reach, in the direction the player pushes V, low enough and with room on top. Each frame
// a step in reach cannot start, the reason goes to the watch (StepWatch.reds), and from there to the log.

// After a step that stopped short, none starts for this long, in seconds.
public func AutoSprintStepPause() -> Float {
  return 0.3;
}

// Beyond this vertical speed, in m/s, V rises or falls as after a jump, and no step starts. A run down a 3 degree road
// at 12 m/s already gives 0.6 (decisions of 22 October 2026), so the ground's own slope is taken off first.
public func AutoSprintSteadyVertical() -> Float {
  return 0.5;
}

// A step starts when V would reach the face within the rise time plus this many frames.
public func AutoSprintLeadFrames() -> Float {
  return 2.0;
}

// V's vertical speed beyond what the ground under V gives: running down a 3 degree road at 12 m/s alone gives -0.6 m/s.
@addMethod(LocomotionEventsTransition)
protected final func AutoSprintOffSlopeSpeed(scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, velocity: Vector4) -> Float {
  let up: Vector4 = DefaultTransition.GetUpVector();
  let ground: TraceResult = scriptInterface.LocomotionRaycastTest(feet + up * 0.3, feet - up * 0.3);
  if !TraceResult.IsValid(ground) || ground.normal.Z < 0.5 {
    return velocity.Z;
  }
  return velocity.Z + (velocity.X * ground.normal.X + velocity.Y * ground.normal.Y) / ground.normal.Z;
}

// Why a step in reach cannot start now, or an empty text when it can.
@addMethod(LocomotionEventsTransition)
protected final func AutoSprintStepRefusal(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, velocity: Vector4, direction: Vector4, face: Vector4, normal: Vector4, height: Float, ahead: Float, radius: Float, now: Float) -> String {
  if !scriptInterface.IsOnGround() {
    return "in the air";
  }
  if scriptInterface.IsOnMovingPlatform() {
    return "on a moving platform";
  }
  let pause: StateResultFloat = stateContext.GetPermanentFloatParameter(n"AutoSprintStepPauseFrom");
  if pause.valid && now >= pause.value && now - pause.value < AutoSprintStepPause() {
    return "pause after a step that stopped";
  }
  if AbsF(velocity.Z) > AutoSprintSteadyVertical() {
    let offSlope: Float = this.AutoSprintOffSlopeSpeed(scriptInterface, feet, velocity);
    if AbsF(offSlope) > AutoSprintSteadyVertical() {
      return "vertical speed " + ToString(velocity.Z) + " m/s, " + ToString(offSlope) + " beyond the ground's slope";
    }
  }
  if Vector4.Dot2D(direction, normal) > AutoSprintIntoFaceCosine() {
    return "met side-on";
  }
  if height < 0.0 {
    return "no walkable top";
  }
  if height > AutoSprintHighestStep() {
    return "higher than " + ToString(AutoSprintHighestStep()) + " m";
  }
  if ahead <= 0.0 {
    return "face behind V";
  }
  if !this.AutoSprintFitsOnStep(scriptInterface, face, normal, radius) {
    return "no room on top";
  }
  return "";
}

@addMethod(LocomotionEventsTransition)
protected final func AutoSprintTryStartStep(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let watch: ref<AutoSprintStepWatch> = AutoSprintStepWatchOf(stateContext);
  if !scriptInterface.IsMoveInputConsiderable() {
    watch.Clear();
    return;
  }
  let now: Float = AutoSprintNow(scriptInterface);
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  let direction: Vector4 = AutoSprintInputDirection(scriptInterface);
  let lead: Float = AutoSprintLeadFrames() * timeDelta;
  let radius: Float = this.GetStaticFloatParameterDefault("capsuleRadius", 0.4);
  let progress: Float = MaxF(Vector4.Dot2D(velocity, direction), 0.0);
  let reach: Float = radius + AutoSprintStepGap() + MaxF(AutoSprintStepRamp(), progress * (AutoSprintHighestStep() / AutoSprintRiseFastest() + lead));
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let face: Vector4;
  let normal: Vector4;
  let height: Float;
  let seen: String;
  // A wall gives back the probes' full height; a lip lower than the lowest step is left to the engine.
  if !this.AutoSprintFindStep(scriptInterface, feet, direction, reach, face, normal, height, seen) || height >= AutoSprintProbeTop() || (height >= 0.0 && height < AutoSprintLowestStep()) {
    watch.Clear();
    return;
  }
  let ahead: Float = Vector4.Dot2D(feet - face, normal);
  let speedIn: Float = MaxF(-Vector4.Dot2D(velocity, normal), 0.0);
  let ramp: Float = MaxF(AutoSprintStepRamp(), speedIn * (MaxF(height, 0.0) / AutoSprintRiseFastest() + lead));
  if ahead > AutoSprintStepGap() + ramp {
    watch.Clear();
    return;
  }
  let refusal: String = this.AutoSprintStepRefusal(stateContext, scriptInterface, feet, velocity, direction, face, normal, height, ahead, radius, now);
  if NotEquals(refusal, "") {
    watch.Refuse(refusal, ToString(height) + " m high, face " + ToString(ahead) + " m ahead, " + seen, now, progress);
    return;
  }
  stateContext.SetPermanentVectorParameter(n"AutoSprintStepFace", face, true);
  stateContext.SetPermanentVectorParameter(n"AutoSprintStepNormal", normal, true);
  stateContext.SetPermanentFloatParameter(n"AutoSprintStepStart", now, true);
  stateContext.SetPermanentFloatParameter(n"AutoSprintStepFeet", feet.Z, true);
  stateContext.SetPermanentBoolParameter(n"AutoSprintStepOn", true, true);
  AutoSprintLog("step up start: " + ToString(height) + " m high (" + seen + "), face " + ToString(ahead) + " m ahead, speed " + ToString(speedIn) + ", state " + NameToString(this.GetStateName()) + ", " + watch.History(now));
  watch.Clear();
}
