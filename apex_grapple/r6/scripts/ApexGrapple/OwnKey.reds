// The keys of the player's choice, one place per profile, profile 1 first: profile 1's "Own key" when it is on, and
// the key of each profile 2 to 5 that is on (the settings' copy, SettingsCopy.reds). Heard through Codeware's raw key events
// (Input/Key), as Air Strafe's tap strafe key. The mouse wheel never arrives there. Without Codeware no own key does
// anything, said in the log once a load (Prerequisites.reds); the quick melee key still grapples for profile 1.

public struct ApexGrappleOwnKey {
  let held: Bool;
  let presses: Int32;
}

@if(ModuleExists("Codeware"))
public class ApexGrappleKeyListener extends ScriptableSystem {
  private let held: array<Bool>;

  private let presses: array<Int32>;

  // The key that holds each place, so that its release frees it even if the menu changed that profile's key meanwhile.
  private let heldKey: array<EInputKey>;

  private func OnAttach() -> Void {
    ArrayResize(this.held, ApexGrappleProfileCount());
    ArrayResize(this.presses, ApexGrappleProfileCount());
    ArrayResize(this.heldKey, ApexGrappleProfileCount());
    GameInstance.GetCallbackSystem().RegisterCallback(n"Input/Key", this, n"OnKeyInput");
  }

  // A press goes to the first profile on that key: two profiles on one key, the lower number fires. A key repeats its
  // press event while held: only the first one counts as a press.
  private cb func OnKeyInput(evt: ref<KeyInputEvent>) {
    let key: EInputKey = evt.GetKey();
    let i: Int32 = 0;
    if Equals(evt.GetAction(), EInputAction.IACT_Release) {
      while i < ArraySize(this.held) {
        if this.held[i] && Equals(this.heldKey[i], key) {
          this.held[i] = false;
        }
        i += 1;
      }
      return;
    }
    // The repeat of a key already held: nothing to count, and the profiles' keys need not be read again.
    while i < ArraySize(this.held) {
      if this.held[i] && Equals(this.heldKey[i], key) {
        return;
      }
      i += 1;
    }
    let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(this.GetGameInstance());
    if !IsDefined(system) {
      return;
    }
    let keys: array<EInputKey> = system.ownKeys;
    i = 0;
    while i < ArraySize(keys) && i < ArraySize(this.held) {
      if Equals(keys[i], key) {
        if !this.held[i] {
          this.held[i] = true;
          this.heldKey[i] = key;
          this.presses[i] = this.presses[i] + 1;
        }
        return;
      }
      i += 1;
    }
  }

  public func States() -> array<ApexGrappleOwnKey> {
    let states: array<ApexGrappleOwnKey>;
    let i: Int32 = 0;
    while i < ArraySize(this.held) {
      let state: ApexGrappleOwnKey;
      state.held = this.held[i];
      state.presses = this.presses[i];
      ArrayPush(states, state);
      i += 1;
    }
    return states;
  }
}

@if(ModuleExists("Codeware"))
public func ApexGrappleOwnKeysNow(game: GameInstance) -> array<ApexGrappleOwnKey> {
  let listener: ref<ApexGrappleKeyListener> = GameInstance.GetScriptableSystemsContainer(game).Get(n"ApexGrappleKeyListener") as ApexGrappleKeyListener;
  if IsDefined(listener) {
    let states: array<ApexGrappleOwnKey> = listener.States();
    if ArraySize(states) == ApexGrappleProfileCount() {
      return states;
    }
  }
  return ApexGrappleNoOwnKeys();
}

@if(!ModuleExists("Codeware"))
public func ApexGrappleOwnKeysNow(game: GameInstance) -> array<ApexGrappleOwnKey> {
  return ApexGrappleNoOwnKeys();
}

public func ApexGrappleNoOwnKeys() -> array<ApexGrappleOwnKey> {
  let states: array<ApexGrappleOwnKey>;
  ArrayResize(states, ApexGrappleProfileCount());
  return states;
}
