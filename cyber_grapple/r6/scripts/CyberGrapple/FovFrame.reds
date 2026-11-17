// Made by fabrique/grapple.py from Apex Grapple's FovFrame.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Each frame of the grapple (Frame.reds), the field of view follows the pull that moves V, with the numbers of Fov.reds.
// Nothing runs while the effect is off and no pull moves V.

// Why a pull that moves V does not widen the field of view this frame; empty when it does. Without the game's setting
// there is no player's value to widen from.
public func CyberGrappleFovRefusal(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, setting: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> String {
  if !settings.dynamicFov {
    return "Dynamic Field of View is off";
  }
  if setting <= 0.0 {
    return "the game's Field of View setting cannot be read";
  }
  if CyberGrappleFovWideningOf(settings) <= 0.0 {
    return "the widening is 0";
  }
  // Aiming a weapon has its own zoom (conception, decision 6).
  if stateContext.IsStateActive(n"UpperBody", n"aimingState") {
    return "aiming a weapon";
  }
  // First person only (conception, decision 8): seen from outside, the camera is another mod's.
  let eyes: Float = CyberGrappleEyesNow(system, scriptInterface);
  if !CyberGrappleNearEyes(eyes, true) {
    return "third person";
  }
  return "";
}

// A refusal is written once per pull, and again when its reason changes. No pull, no refusal.
public func CyberGrappleFovSayRefusal(system: ref<CyberGrappleSystem>, refusal: String) -> Void {
  if StrLen(refusal) == 0 {
    CyberGrappleFovForgetRefusal(system);
    return;
  }
  if !IsDefined(system.fov) {
    system.fov = new CyberGrappleFov();
  }
  if !Equals(refusal, system.fov.refused) {
    system.fov.refused = refusal;
    system.fov.refusing = true;
    if CyberGrappleFovLogs(system.fov) {
      CyberGrappleFovLog(system.fov, "field of view not widened: " + refusal);
    }
  }
}

public func CyberGrappleFovForgetRefusal(system: ref<CyberGrappleSystem>) -> Void {
  let fov: ref<CyberGrappleFov> = system.fov;
  if IsDefined(fov) && fov.refusing {
    fov.refused = "";
    fov.refusing = false;
  }
}

public func CyberGrappleFovFrame(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, now: Float, timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let moves: Bool = CyberGrappleMovesV(system);
  let on: Bool = IsDefined(system.fov) && system.fov.on;
  if !moves && !on {
    CyberGrappleFovForgetRefusal(system);
    return;
  }
  // Read once a frame, while a pull moves V or the effect is on only.
  let setting: Float = CyberGrappleFovSetting(scriptInterface.GetGame());
  let refusal: String = moves ? CyberGrappleFovRefusal(system, settings, setting, stateContext, scriptInterface) : "";
  CyberGrappleFovSayRefusal(system, refusal);
  let want: Bool = moves && StrLen(refusal) == 0;
  if !want && !on {
    return;
  }
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let camera: ref<FPPCameraComponent> = IsDefined(player) ? player.GetFPPCameraComponent() : null;
  if !IsDefined(camera) {
    return;
  }
  if !IsDefined(system.fov) {
    system.fov = new CyberGrappleFov();
  }
  let fov: ref<CyberGrappleFov> = system.fov;
  // Without the setting, the way back goes to the last player's value read (a widening is refused above).
  CyberGrappleFovHomeNow(fov, setting);
  // After frames without the grapple's frame (some scenes, the braindance), the camera may have moved meanwhile.
  let cut: Bool = fov.on && now - fov.lastAt - timeDelta > CyberGrappleLongestGap();
  if !fov.on || NotEquals(want, fov.wide) || cut {
    CyberGrappleFovStart(fov, want, settings, camera.GetFOV(), now, setting, cut ? now - fov.lastAt : 0.0);
  }
  let to: Float = want ? CyberGrappleFovWideNow(fov, setting) : fov.home;
  let t: Float = now - fov.since;
  let value: Float = CyberGrappleFovSafe(CyberGrappleFovWritten(fov.from, to, fov.transition, t, timeDelta));
  if AbsF(value - fov.written) > 0.001 {
    camera.SetFOV(value);
    fov.written = value;
  }
  fov.lastAt = now;
  if t >= fov.transition && !fov.reached {
    fov.reached = true;
    if CyberGrappleFovLogs(fov) {
      CyberGrappleFovLog(fov, "field of view " + (want ? "widened" : "back") + ": camera " + ToString(camera.GetFOV()) + " for " + ToString(to) + ", " + ToString(t) + " s after the start");
    }
    if !want {
      fov.on = false;
    }
  }
}

// A transition starts from where the camera is: a new pull during the way back widens again without a jump.
public func CyberGrappleFovStart(fov: ref<CyberGrappleFov>, want: Bool, settings: ref<CyberGrappleSettings>, shown: Float, now: Float, setting: Float, gap: Float) -> Void {
  if want {
    fov.widening = CyberGrappleFovWideningOf(settings);
    fov.transition = CyberGrappleFovTransitionOf(settings);
  }
  fov.on = true;
  fov.wide = want;
  fov.from = shown;
  fov.since = now;
  fov.reached = false;
  if !CyberGrappleFovLogs(fov) {
    return;
  }
  let why: String = gap > 0.0 ? " after " + ToString(gap) + " s without the grapple's frame" : "";
  CyberGrappleFovLog(fov, "field of view " + (want ? "widening" : "coming back") + why + ": setting " + ToString(setting) + ", camera from " + ToString(shown) + " to " + ToString(want ? CyberGrappleFovWideNow(fov, setting) : fov.home) + " in " + ToString(fov.transition) + " s");
}

// Mounting a vehicle or starting a scene stops the grapple's frame, maybe mid-transition: the camera would go on to the
// last value written, which leads the curve and can lie past both ends. The player's own value is written at once,
// before the game's own handling of the event.
public func CyberGrappleFovGiveBack(player: ref<PlayerPuppet>, why: String) -> Void {
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(player.GetGame());
  if !IsDefined(system) || !IsDefined(system.fov) || !system.fov.on {
    return;
  }
  system.fov.on = false;
  let camera: ref<FPPCameraComponent> = player.GetFPPCameraComponent();
  if IsDefined(camera) {
    camera.SetFOV(system.fov.home);
    system.fov.written = system.fov.home;
  }
  if CyberGrappleFovLogs(system.fov) {
    CyberGrappleFovLog(system.fov, "field of view given back at once, " + why + ": " + ToString(system.fov.home));
  }
}

@wrapMethod(PlayerPuppet)
protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
  CyberGrappleFovGiveBack(this, "mounting a vehicle");
  return wrappedMethod(evt);
}

@wrapMethod(PlayerPuppet)
protected cb func OnWorkspotStartedEvent(evt: ref<WorkspotStartedEvent>) -> Bool {
  CyberGrappleFovGiveBack(this, "a scene starts");
  return wrappedMethod(evt);
}
