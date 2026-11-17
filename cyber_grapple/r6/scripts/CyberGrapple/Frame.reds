// Made by fabrique/grapple.py from Apex Grapple's Frame.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Each frame of every locomotion state: the key, the shot and the hook's flight (Shot.reds), the pull (Pulling.reds),
// the grapple's flight ending on the ground (Ground.reds), V's left arm (Arm.reds), the right-hand weapon
// (RightWeapon.reds), our pieces (PiecesDraw.reds), the sounds (Sounds.reds), the game's grab on a person brought to V
// (GrabHold.reds), the field of view (FovFrame.reds), the crosshair's range indicator (CrosshairRange.reds) and
// the charges in the gadget slot (SlotCharges.reds). Ground, air, ladder and swimming states derive from LocomotionEventsTransition and call its
// OnUpdate (scripts 2.31); the two met during a grapple whose own OnUpdate does not are in TakenOver.reds.

// Half of V's height (1.8 m): the pull acts on V's middle, as Borderlands 4 pulled the centre of the capsule.
public func CyberGrappleMiddleHeight() -> Float {
  return 0.9;
}

// Game time the frame may go without running before a hook or a pull counts as stopped by the game. Some scene states
// have no update at all (hasOnUpdate false in the scene tiers' states), and the locomotion state machine is suspended
// while V drives: without this, a hook in flight would bite its old point at the end, and a pull would push V on with
// its old speed.
public func CyberGrappleLongestGap() -> Float {
  return 0.25;
}

@wrapMethod(LocomotionEventsTransition)
public func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  this.CyberGrappleFrame(timeDelta, stateContext, scriptInterface);
}

@addMethod(LocomotionEventsTransition)
private final func CyberGrappleFrame(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  // The game and this state's name read once for the whole frame (A14).
  let game: GameInstance = scriptInterface.executionOwner.GetGame();
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(game);
  if !IsDefined(system) {
    return;
  }
  let now: Float = CyberGrappleTime(game);
  let missed: Float = now - system.lastFrameAt - timeDelta;
  system.lastFrameAt = now;
  // From 1 on: the frame numbers kept by FrameReads.reds start at 0, never this frame's.
  system.frames = system.frames + 1;
  system.stateName = this.GetStateName();
  CyberGrappleCostFrame(system, now);
  if system.phase != CyberGrappleIdle() && missed > CyberGrappleLongestGap() {
    this.CyberGrappleLetGo(system, "the game did not run the grapple for " + ToString(missed) + " s", now, scriptInterface);
  }
  if system.phase != CyberGrappleIdle() && system.onTarget {
    let middle: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface) + DefaultTransition.GetUpVector() * CyberGrappleMiddleHeight();
    let lost: String = CyberGrappleFollowTarget(system, middle, timeDelta);
    if StrLen(lost) > 0 {
      this.CyberGrappleLetGo(system, lost, now, scriptInterface);
    }
  }
  // The settings of the profile whose key is read, for the key and a shot (KeyProfile.reds); during a grapple, the
  // grapple's own (Profiles.reds), which are the same.
  let own: array<CyberGrappleOwnKey> = CyberGrappleOwnKeysFor(system, game);
  let keySettings: ref<CyberGrappleSettings> = CyberGrappleKeySettingsNow(system, own, scriptInterface);
  if CyberGrappleIsHitReaction(system.stateName) {
    CyberGrappleHitTakesOver(system, stateContext);
  }
  let key: CyberGrappleKey = this.CyberGrappleReadKey(scriptInterface, system, keySettings, own, now);
  if key.sharedPress {
    this.CyberGrappleSharedPress(system, keySettings, now, stateContext, scriptInterface);
  }
  if system.phase == CyberGrappleIdle() {
    this.CyberGrappleIdleFrame(system, key, keySettings, now, stateContext, scriptInterface);
  } else {
    if system.phase == CyberGrappleFlying() {
      this.CyberGrappleFlyingFrame(system, key, keySettings, now, stateContext, scriptInterface);
    } else {
      this.CyberGrapplePullFrame(system, key, keySettings, now, timeDelta, stateContext, scriptInterface);
    }
  }
  // The grapple's settings for the arm and the pieces, read after the phase is settled for this frame: a shot raises
  // its own profile's arm in the frame it is fired, and the hook flies back with the settings it went out with.
  let settings: ref<CyberGrappleSettings> = CyberGrappleGrappleSettings(system, keySettings);
  CyberGrappleArmFrame(system, settings, now, stateContext, scriptInterface);
  CyberGrappleRightWeaponFrame(system, stateContext, scriptInterface);
  CyberGrappleDrawPieces(system, settings, now, timeDelta, scriptInterface);
  // After the pieces, so that the hook home is heard in the frame it gets there.
  CyberGrappleSoundsFrame(system, scriptInterface);
  this.CyberGrappleGrabFrame(system, now, stateContext, scriptInterface);
  CyberGrappleYankWatch(system, now, game);
  CyberGrappleBikeWatch(system, now);
  // After the phase is settled: a pull that starts or stops this frame widens or brings back the view in this frame.
  CyberGrappleFovFrame(system, settings, now, timeDelta, stateContext, scriptInterface);
  // Once this frame's shot is settled: the colour answers for the next press, the gadget slot shows the charges
  // left.
  CyberGrappleCrosshairRangeFrame(system, now, scriptInterface);
  CyberGrappleSlotFrame(system, now);
}

@addMethod(LocomotionEventsTransition)
private final func CyberGrappleLetGo(system: ref<CyberGrappleSystem>, reason: String, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if system.phase == CyberGrappleFlying() {
    system.phase = CyberGrappleIdle();
    CyberGrappleLog("hook cancelled after " + ToString(now - system.firedAt) + " s: " + reason);
    return;
  }
  this.CyberGrappleEndPull(system, reason, now, scriptInterface);
}

// Why the grapple cannot start or go on here; empty when it can. Where the game takes V over, or forbids jumping and
// climbing, the grapple lets go too. state: this state's name, read once a frame (CyberGrappleFrame).
@addMethod(LocomotionEventsTransition)
private final func CyberGrappleBlockedHere(state: CName, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> String {
  if CyberGrappleIsHitReaction(state) {
    return "knocked down (" + NameToString(state) + ")";
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
    return "held by a scene (" + NameToString(state) + ")";
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
