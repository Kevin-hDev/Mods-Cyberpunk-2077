// The crosshair only while the aim key is held, off by default (docs/apex-grapple/reticule/seulement-en-visant.md).
// The key is heard through the game's CameraAim action: the aim button sends it on foot, with or without a weapon
// (inputContexts.xml, context Camera), and the game listens to it before aiming (AimingStateDecisions.OnAttach). The
// player's "toggle aim" option is not followed (decision 4). Heard only while the setting is on (optimisation.md,
// section 3, rules 1 and 5), and taken off as the crosshair detaches (Crosshair.reds).

// The controller is not named "host": a keyword of CD Projekt Red's script language, which the console version is
// compiled with (fabrique/console.py).
public class ApexGrappleCrosshairAim extends IScriptable {
  public let controller: wref<CrosshairGameControllerPersistentDot>;
  public let player: wref<GameObject>;
  public let held: Bool;

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let held: Bool = ListenerAction.GetValue(action) > 0.0;
    if NotEquals(held, this.held) {
      this.held = held;
      let controller: ref<CrosshairGameControllerPersistentDot> = this.controller;
      if IsDefined(controller) {
        controller.ApexGrappleCrosshairRefresh();
      }
    }
    return false;
  }
}

// The reason the crosshair's rule gives while the key is not held (CrosshairRule.reds).
public func ApexGrappleCrosshairNotAimingWhy() -> String {
  return "the aim key is not held";
}

public func ApexGrappleCrosshairAimHeld(state: ref<ApexGrappleCrosshairState>) -> Bool {
  let aim: ref<ApexGrappleCrosshairAim> = state.aim;
  return IsDefined(aim) && aim.held;
}

// Called at each update of the crosshair, before its rule is read: the key is listened to while the setting is on.
public func ApexGrappleCrosshairAimFollow(state: ref<ApexGrappleCrosshairState>, settings: ref<ApexGrappleCrosshairSettings>, controller: ref<CrosshairGameControllerPersistentDot>) -> Void {
  if !settings.onlyWhileAiming {
    if IsDefined(state.aim) {
      ApexGrappleCrosshairAimStop(state);
      ApexGrappleLog("crosshair no longer follows the aim key");
    }
    return;
  }
  let player: ref<GameObject> = state.player;
  if IsDefined(state.aim) || !IsDefined(player) {
    return;
  }
  let aim: ref<ApexGrappleCrosshairAim> = new ApexGrappleCrosshairAim();
  aim.controller = controller;
  aim.player = player;
  state.aim = aim;
  player.RegisterInputListener(aim, n"CameraAim");
  ApexGrappleLog("crosshair follows the aim key (CameraAim)");
}

public func ApexGrappleCrosshairAimStop(state: ref<ApexGrappleCrosshairState>) -> Void {
  let aim: ref<ApexGrappleCrosshairAim> = state.aim;
  if !IsDefined(aim) {
    return;
  }
  let player: ref<GameObject> = aim.player;
  if IsDefined(player) {
    player.UnregisterInputListener(aim, n"CameraAim");
  }
  state.aim = null;
}

// Decision 5: once a menu opens or the crosshair hides for another reason, the key counts as released. In menus and
// scenes the game hears the key in other contexts, and its release may not reach us: better a crosshair called back
// by a press than one left on screen with no key held. Not for the grapple's own lent launcher (CrosshairRule.reds).
public func ApexGrappleCrosshairAimLetGo(state: ref<ApexGrappleCrosshairState>) -> Void {
  let aim: ref<ApexGrappleCrosshairAim> = state.aim;
  if IsDefined(aim) {
    aim.held = false;
  }
}

// Writes a change of what shows. Those that come from the key are bounded per load (decision 7): a fist fight blocks
// often.
public func ApexGrappleCrosshairWriteLine(state: ref<ApexGrappleCrosshairState>, line: String, why: String) -> Void {
  let hiddenByKey: Bool = Equals(why, ApexGrappleCrosshairNotAimingWhy());
  let fromKey: Bool = hiddenByKey || state.hiddenByKey;
  state.hiddenByKey = hiddenByKey;
  state.logLine = line;
  if fromKey {
    state.aimLines = ApexGrappleLogUpTo(state.aimLines, 100, "crosshair shows and hides from the aim key", line);
  } else {
    ApexGrappleLog(line);
  }
}
