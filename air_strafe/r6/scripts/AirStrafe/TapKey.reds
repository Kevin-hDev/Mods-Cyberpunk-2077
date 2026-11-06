// The tap strafe key: the key chosen in the menu, spammed or held, counts as forward at the tap strafe rate, and
// while it is on, forward itself no longer swings the momentum (Steering.reds). Kevin, 22 October 2026: an option,
// with a key he can change, its own rate, working with the air strafe off too.
//
// Keys are heard through Codeware's raw input events (Input/Key). The mouse wheel never arrives there (essai 2:
// no notch heard while the weapons switched), so it cannot be the key. Without Codeware the key does nothing;
// everything else of the mod works.

// How long one press counts as forward held, in seconds: long enough that a spammed key reads as held, short enough
// that a single press is only a nudge.
public func AirStrafeTapWindow() -> Float {
  return 0.15;
}

// Longer than any jump or fall a player steers through: past it, a hold whose release was lost stops counting.
public func AirStrafeLongestHold() -> Float {
  return 10.0;
}

public func AirStrafeKeyName(key: EInputKey) -> String {
  return NameToString(EnumValueToName(n"EInputKey", Cast<Int64>(EnumInt(key))));
}

public func AirStrafeGameTime(game: GameInstance) -> Float {
  return EngineTime.ToFloat(GameInstance.GetSimTime(game));
}

@if(ModuleExists("Codeware"))
public class AirStrafeTapListener extends ScriptableSystem {
  private let lastPress: Float;

  private let presses: Int32;

  private let lastReport: Float;

  private func OnAttach() -> Void {
    GameInstance.GetCallbackSystem().RegisterCallback(n"Input/Key", this, n"OnKeyInput");
  }

  // Held counts too (Kevin: the key works spammed or held). A release lost while the game is out of focus would
  // leave it held, so a hold counts only up to AirStrafeLongestHold() after its press.
  private let held: Bool;

  private cb func OnKeyInput(evt: ref<KeyInputEvent>) {
    let key: EInputKey = evt.GetKey();
    if !Equals(key, AirStrafeTapKey()) {
      return;
    }
    if Equals(evt.GetAction(), EInputAction.IACT_Release) {
      this.held = false;
      return;
    }
    if !AirStrafeTapEnabled() {
      return;
    }
    let now: Float = AirStrafeGameTime(this.GetGameInstance());
    this.held = true;
    this.lastPress = now;
    this.presses += 1;
    if now - this.lastReport >= 1.0 {
      this.lastReport = now;
      AirStrafeLog("tap key " + AirStrafeKeyName(key) + " pressed, " + ToString(this.presses) + " presses so far");
    }
  }

  public func IsActive(now: Float) -> Bool {
    if this.presses == 0 {
      return false;
    }
    if this.held {
      return now - this.lastPress <= AirStrafeLongestHold();
    }
    return now - this.lastPress <= AirStrafeTapWindow();
  }
}

@if(ModuleExists("Codeware"))
public func AirStrafeTapHeld(game: GameInstance) -> Bool {
  let listener: ref<AirStrafeTapListener> = GameInstance.GetScriptableSystemsContainer(game).Get(n"AirStrafeTapListener") as AirStrafeTapListener;
  if !IsDefined(listener) {
    return false;
  }
  return listener.IsActive(AirStrafeGameTime(game));
}

@if(!ModuleExists("Codeware"))
public func AirStrafeTapHeld(game: GameInstance) -> Bool {
  return false;
}
