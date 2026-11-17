// Made by fabrique/grapple.py from Apex Grapple's OwnKey.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The keys of the player's choice, one place per profile, profile 1 first: profile 1's "Own key" when it is on, and
// the key of each profile 2 to 5 that is on (the settings' copy, SettingsCopy.reds). Heard through Codeware's raw key events
// (Input/Key), as Air Strafe's tap strafe key. The mouse wheel never arrives there. Without Codeware no own key does
// anything, said in the log once a load (Prerequisites.reds); this mod then fires nothing at all.

public struct CyberGrappleOwnKey {
  let held: Bool;
  let presses: Int32;
}

@if(ModuleExists("Codeware"))
public class CyberGrappleKeyListener extends ScriptableSystem {
  private let held: array<Bool>;

  private let presses: array<Int32>;

  // The key that holds each place, so that its release frees it even if the menu changed that profile's key meanwhile.
  private let heldKey: array<EInputKey>;

  private func OnAttach() -> Void {
    ArrayResize(this.held, CyberGrappleProfileCount());
    ArrayResize(this.presses, CyberGrappleProfileCount());
    ArrayResize(this.heldKey, CyberGrappleProfileCount());
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
    let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(this.GetGameInstance());
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

  public func States() -> array<CyberGrappleOwnKey> {
    let states: array<CyberGrappleOwnKey>;
    let i: Int32 = 0;
    while i < ArraySize(this.held) {
      let state: CyberGrappleOwnKey;
      state.held = this.held[i];
      state.presses = this.presses[i];
      ArrayPush(states, state);
      i += 1;
    }
    return states;
  }
}

@if(ModuleExists("Codeware"))
public func CyberGrappleOwnKeysNow(game: GameInstance) -> array<CyberGrappleOwnKey> {
  let listener: ref<CyberGrappleKeyListener> = GameInstance.GetScriptableSystemsContainer(game).Get(n"CyberGrappleKeyListener") as CyberGrappleKeyListener;
  if IsDefined(listener) {
    let states: array<CyberGrappleOwnKey> = listener.States();
    if ArraySize(states) == CyberGrappleProfileCount() {
      return states;
    }
  }
  return CyberGrappleNoOwnKeys();
}

@if(!ModuleExists("Codeware"))
public func CyberGrappleOwnKeysNow(game: GameInstance) -> array<CyberGrappleOwnKey> {
  return CyberGrappleNoOwnKeys();
}

public func CyberGrappleNoOwnKeys() -> array<CyberGrappleOwnKey> {
  let states: array<CyberGrappleOwnKey>;
  ArrayResize(states, CyberGrappleProfileCount());
  return states;
}
