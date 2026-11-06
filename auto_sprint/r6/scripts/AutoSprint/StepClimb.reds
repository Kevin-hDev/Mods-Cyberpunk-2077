// Step up: V stopped against a curb as against a wall, walking, running or sprinting; only a jump got over it (log of
// 21 October 2026: against a curb, the sprint started again every second). No step height of the engine is open to
// scripts. A single push upward lifted V twice as high as computed, 0.9 to 1.05 m for curbs of 0.25 to 0.35 m (trial
// of 21 October 2026): a jump anyone could see. So V now climbs a short invisible slope: every frame a push gives V
// the upward speed that brings the feet just above the top before the capsule reaches the face, then holds them there
// until V's centre is over the top. The game counts V as falling only below -2.5 m/s, so the walk or sprint goes on.
// When a step starts: StepStart.reds; finding the step: StepFinder.reds.

// The engine moved V about twice as fast as pushed (same trial): each push asks for half of the missing speed.
public func AutoSprintPushGain() -> Float {
  return 0.5;
}

// The rise ends while V's centre is still this far from the face: closer, the bottom of the capsule catches the edge.
public func AutoSprintStepGap() -> Float {
  return 0.2;
}

// The shortest slope, so that a walk does not rise in one go.
public func AutoSprintStepRamp() -> Float {
  return 0.6;
}

// Rising speeds, in m/s: the slowest for V stopped against the face, the fastest for a sprint at full speed.
public func AutoSprintRiseSlowest() -> Float {
  return 2.0;
}

public func AutoSprintRiseFastest() -> Float {
  return 6.0;
}

// The feet go this far above the top, and the step ends once V's centre is this far over it.
public func AutoSprintStepAbove() -> Float {
  return 0.04;
}

public func AutoSprintStepPast() -> Float {
  return 0.25;
}

// The feet count as on the top from this far below it.
public func AutoSprintTopSlack() -> Float {
  return 0.02;
}

// Steps from V stopped against the face took 0.18 to 0.36 s for 0.4 m (trial of 21 October 2026); 0.6 m takes longer.
public func AutoSprintStepTimeout() -> Float {
  return 1.0;
}

// The push goes into a face when its cosine with the face's normal, turned toward V, is at most this: more than about
// 100 degrees apart. Closer to the face's line, V runs along it (trial of 21 October 2026: the three "turned away"
// had started from a face met side-on).
public func AutoSprintIntoFaceCosine() -> Float {
  return -0.2;
}

// The states where V walks or runs on foot: the step up works there only. Not the slide, which is Omni Slide's.
@addMethod(LocomotionEventsTransition)
protected final const func AutoSprintWalksOnFoot() -> Bool {
  let state: CName = this.GetStateName();
  return Equals(state, n"stand") || Equals(state, n"aimWalk") || Equals(state, n"forceWalk") || Equals(state, n"sprint") || Equals(state, n"crouch") || Equals(state, n"crouchSprint");
}

// Where the player pushes V, aimed as the game aims a dodge: the camera's heading turned by the input's.
public func AutoSprintInputDirection(scriptInterface: ref<StateGameScriptInterface>) -> Vector4 {
  return Vector4.FromHeading(AngleNormalize180(Transform.GetYaw(scriptInterface.GetCameraWorldTransform()) + scriptInterface.GetInputHeading()));
}

// Why the step must stop before V is over the top, or an empty text while it goes on.
@addMethod(LocomotionEventsTransition)
protected final func AutoSprintStepBroken(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, normal: Vector4, now: Float) -> String {
  if !AutoSprintStepsUp() {
    return "switched off";
  }
  if !this.AutoSprintWalksOnFoot() {
    return "state " + NameToString(this.GetStateName());
  }
  // A key let go for a moment no longer ends the step (trial of 21 October 2026: eight steps ended after 0.03 to
  // 0.34 s for "no input" while Kevin kept pushing); the time limit ends a step the player really gave up.
  if scriptInterface.IsMoveInputConsiderable() && Vector4.Dot2D(AutoSprintInputDirection(scriptInterface), normal) > AutoSprintIntoFaceCosine() {
    return "turned away";
  }
  let start: Float = stateContext.GetFloatParameter(n"AutoSprintStepStart", true);
  if now < start || now - start > AutoSprintStepTimeout() {
    return "took too long";
  }
  return "";
}

@addMethod(LocomotionEventsTransition)
protected final func AutoSprintEndStep(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, result: String, now: Float) -> Void {
  stateContext.SetPermanentBoolParameter(n"AutoSprintStepOn", false, true);
  if NotEquals(result, "done") {
    stateContext.SetPermanentFloatParameter(n"AutoSprintStepPauseFrom", now, true);
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let lift: Float = feet.Z - stateContext.GetFloatParameter(n"AutoSprintStepFeet", true);
  let duration: Float = now - stateContext.GetFloatParameter(n"AutoSprintStepStart", true);
  AutoSprintLog("step up " + result + " after " + ToString(duration) + " s: feet " + ToString(lift) + " m higher, speed " + ToString(Vector4.Length2D(DefaultTransition.GetLinearVelocity(scriptInterface))) + ", state " + NameToString(this.GetStateName()));
}

@addMethod(LocomotionEventsTransition)
protected final func AutoSprintUpdateStep(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let now: Float = AutoSprintNow(scriptInterface);
  let face: Vector4 = stateContext.GetVectorParameter(n"AutoSprintStepFace", true);
  let normal: Vector4 = stateContext.GetVectorParameter(n"AutoSprintStepNormal", true);
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let ahead: Float = Vector4.Dot2D(feet - face, normal);
  if -ahead >= AutoSprintStepPast() && feet.Z >= face.Z - AutoSprintTopSlack() {
    this.AutoSprintEndStep(stateContext, scriptInterface, "done", now);
    return;
  }
  let broken: String = this.AutoSprintStepBroken(stateContext, scriptInterface, normal, now);
  if NotEquals(broken, "") {
    this.AutoSprintEndStep(stateContext, scriptInterface, broken, now);
    return;
  }
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  let missing: Float = face.Z + AutoSprintStepAbove() - feet.Z;
  let wanted: Float;
  if missing > 0.0 {
    let speedIn: Float = MaxF(-Vector4.Dot2D(velocity, normal), 0.1);
    let time: Float = MaxF((ahead - AutoSprintStepGap()) / speedIn, 0.05);
    wanted = MinF(ClampF(missing / time, AutoSprintRiseSlowest(), AutoSprintRiseFastest()), missing / MaxF(timeDelta, 0.005));
  } else {
    // Hold the height: cancel the gravity of the coming frame.
    wanted = AbsF(this.GetStaticFloatParameterDefault("upwardsGravity", -16.0)) * timeDelta;
  }
  this.AddVerticalImpulse(stateContext, (wanted - velocity.Z) * AutoSprintPushGain());
}

// Each frame of the states that call the common update. The walking states all do; outils/boucle_commune.py lists
// the states that do not.
@wrapMethod(LocomotionEventsTransition)
public func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  if !stateContext.GetBoolParameter(n"AutoSprintStepOn", true) {
    if !this.AutoSprintWalksOnFoot() || !AutoSprintStepsUp() {
      AutoSprintStepWatchOf(stateContext).Clear();
      return;
    }
    this.AutoSprintTryStartStep(timeDelta, stateContext, scriptInterface);
    if !stateContext.GetBoolParameter(n"AutoSprintStepOn", true) {
      return;
    }
  }
  this.AutoSprintUpdateStep(timeDelta, stateContext, scriptInterface);
}
