// Each frame of every locomotion state: the key, the shot and the hook's flight (Shot.reds), the pull (Pulling.reds),
// the grapple's flight ending on the ground (Ground.reds), V's left arm (Arm.reds), the right-hand weapon
// (RightWeapon.reds), our pieces (PiecesDraw.reds), the sounds (Sounds.reds), the field of view (FovFrame.reds) and the
// crosshair's range indicator (CrosshairRange.reds). Ground, air, ladder and swimming states derive from LocomotionEventsTransition and call its
// OnUpdate (scripts 2.31); the two met during a grapple whose own OnUpdate does not are in TakenOver.reds.

// Half of V's height (1.8 m): the pull acts on V's middle, as Borderlands 4 pulled the centre of the capsule.
public func ApexGrappleMiddleHeight() -> Float {
  return 0.9;
}

// Game time the frame may go without running before a hook or a pull counts as stopped by the game. Some scene states
// have no update at all (hasOnUpdate false in the scene tiers' states), and the locomotion state machine is suspended
// while V drives: without this, a hook in flight would bite its old point at the end, and a pull would push V on with
// its old speed.
public func ApexGrappleLongestGap() -> Float {
  return 0.25;
}

@wrapMethod(LocomotionEventsTransition)
public func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  this.ApexGrappleFrame(timeDelta, stateContext, scriptInterface);
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleFrame(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.executionOwner.GetGame());
  if !IsDefined(system) {
    return;
  }
  let now: Float = ApexGrappleTime(scriptInterface.executionOwner.GetGame());
  let missed: Float = now - system.lastFrameAt - timeDelta;
  system.lastFrameAt = now;
  if system.phase != ApexGrappleIdle() && missed > ApexGrappleLongestGap() {
    this.ApexGrappleLetGo(system, "the game did not run the grapple for " + ToString(missed) + " s", now, scriptInterface);
  }
  if system.phase != ApexGrappleIdle() && system.onTarget {
    let middle: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface) + DefaultTransition.GetUpVector() * ApexGrappleMiddleHeight();
    let lost: String = ApexGrappleFollowTarget(system, middle, timeDelta);
    if StrLen(lost) > 0 {
      this.ApexGrappleLetGo(system, lost, now, scriptInterface);
    }
  }
  // The settings of the profile whose key is read, for the key and a shot (KeyProfile.reds); during a grapple, the
  // grapple's own (Profiles.reds), which are the same.
  let own: array<ApexGrappleOwnKey> = ApexGrappleOwnKeysNow(scriptInterface.executionOwner.GetGame());
  let keySettings: ref<ApexGrappleSettings> = ApexGrappleKeySettingsNow(system, own, scriptInterface);
  if ApexGrappleIsHitReaction(this.GetStateName()) {
    ApexGrappleHitTakesOver(system, stateContext);
  }
  let key: ApexGrappleKey = this.ApexGrappleReadKey(scriptInterface, system, keySettings, own, now);
  if key.sharedPress {
    this.ApexGrappleSharedPress(system, keySettings, now, stateContext, scriptInterface);
  }
  if system.phase == ApexGrappleIdle() {
    this.ApexGrappleIdleFrame(system, key, keySettings, now, stateContext, scriptInterface);
  } else {
    if system.phase == ApexGrappleFlying() {
      this.ApexGrappleFlyingFrame(system, key, keySettings, now, stateContext, scriptInterface);
    } else {
      this.ApexGrapplePullFrame(system, key, keySettings, now, timeDelta, stateContext, scriptInterface);
    }
  }
  // The grapple's settings for the arm and the pieces, read after the phase is settled for this frame: a shot raises
  // its own profile's arm in the frame it is fired, and the hook flies back with the settings it went out with.
  let settings: ref<ApexGrappleSettings> = ApexGrappleGrappleSettings(system, keySettings);
  ApexGrappleArmFrame(system, settings, now, stateContext, scriptInterface);
  ApexGrappleRightWeaponFrame(system, stateContext, scriptInterface);
  ApexGrappleDrawPieces(system, settings, now, timeDelta, scriptInterface);
  // After the pieces, so that the hook home is heard in the frame it gets there.
  ApexGrappleSoundsFrame(system, scriptInterface);
  ApexGrappleYankWatch(system, now, scriptInterface.executionOwner.GetGame());
  // After the phase is settled: a pull that starts or stops this frame widens or brings back the view in this frame.
  ApexGrappleFovFrame(system, settings, now, timeDelta, stateContext, scriptInterface);
  // Last: the colour answers for the next press, once this frame's shot is settled.
  ApexGrappleCrosshairRangeFrame(system, now, scriptInterface);
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleLetGo(system: ref<ApexGrappleSystem>, reason: String, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if system.phase == ApexGrappleFlying() {
    system.phase = ApexGrappleIdle();
    ApexGrappleLog("hook cancelled after " + ToString(now - system.firedAt) + " s: " + reason);
    return;
  }
  this.ApexGrappleEndPull(system, reason, now, scriptInterface);
}

// Why the grapple cannot start or go on here; empty when it can. Where the game takes V over, or forbids jumping and
// climbing, the grapple lets go too.
@addMethod(LocomotionEventsTransition)
private final func ApexGrappleBlockedHere(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> String {
  if ApexGrappleIsHitReaction(this.GetStateName()) {
    return "knocked down (" + NameToString(this.GetStateName()) + ")";
  }
  // A ladder is not refused: the pull takes V off it (LadderExit.reds). Except sliding down one, a state without the
  // crouch exit (its exits in the locomotion tweak; Wall Climb's audit of 25 October 2026, B2): the pull would freeze.
  if Equals(stateContext.GetStateMachineCurrentState(n"Locomotion"), n"ladderSlide") {
    return "sliding down a ladder";
  }
  if IsDefined(this as ClimbEvents) || IsDefined(this as VaultEvents) {
    return "climbing a ledge";
  }
  if IsDefined(this as SuperheroLandEvents) {
    return "superhero landing";
  }
  // Swimming is not refused: the pull draws V through the water and out of it (docs/apex-grapple/eau/conception.md).
  if IsDefined(this as LocomotionTakedownEvents) {
    return "in a takedown";
  }
  if IsDefined(this as ForceIdleEvents) || IsDefined(this as ForceWalkEvents) || IsDefined(this as ForceFreezeEvents) {
    return "held by a scene (" + NameToString(this.GetStateName()) + ")";
  }
  if VehicleComponent.IsMountedToVehicle(scriptInterface.executionOwner.GetGame(), scriptInterface.executionOwner) {
    return "in a vehicle";
  }
  if DefaultTransition.IsInWorkspot(scriptInterface) {
    return "in a scene";
  }
  if this.IsVaultingClimbingRestricted(scriptInterface) {
    return "the game forbids climbing here";
  }
  return "";
}
