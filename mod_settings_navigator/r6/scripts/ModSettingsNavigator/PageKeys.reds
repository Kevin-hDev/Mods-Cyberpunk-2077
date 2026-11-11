// L3 and R3 on a controller, Q and E on a keyboard, turn the pages (Kevin, 10 and 11 November 2026). Raw keys through
// Codeware's Input/Key event, not the game's actions: the game's actions on L3 have other keyboard keys (Z for the
// brightness), and the player would turn pages without meaning to. Probes of 11 November 2026: the four keys arrive,
// Q and E as IK_Q and IK_E on Kevin's AZERTY keyboard.
// The event carries every key of the game and the installed Codeware cannot filter it by key, so it is listened to
// only while Mod Settings is open: set up when the menu opens, dropped at the first key that comes with the menu closed.

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorPageKeys extends IScriptable {
  private let pages: wref<ModSettingsNavigatorPages>;
  private let handler: ref<CallbackSystemHandler>;
  // The page key pressed while nothing else wanted it; a release turns the page only after such a press.
  private let armed: EInputKey;

  public func Listen(pages: wref<ModSettingsNavigatorPages>) {
    this.pages = pages;
    this.armed = EInputKey.IK_None;
    let handler = this.handler;
    if IsDefined(handler) && handler.IsRegistered() {
      return;
    }
    this.handler = GameInstance.GetCallbackSystem().RegisterCallback(n"Input/Key", this, n"OnKeyInput");
  }

  private func Step(key: EInputKey) -> Int32 {
    if Equals(key, EInputKey.IK_Pad_LeftThumb) || Equals(key, EInputKey.IK_Q) {
      return -1;
    }
    if Equals(key, EInputKey.IK_Pad_RightThumb) || Equals(key, EInputKey.IK_E) {
      return 1;
    }
    return 0;
  }

  private cb func OnKeyInput(evt: ref<KeyInputEvent>) {
    let pages = this.pages;
    if !ModSettingsNavigatorMenu.IsOpen() || !IsDefined(pages) {
      let handler = this.handler;
      if IsDefined(handler) {
        handler.Unregister();
      }
      this.handler = null;
      return;
    }
    let key = evt.GetKey();
    let step = this.Step(key);
    if step == 0 {
      return;
    }
    let action = evt.GetAction();
    if Equals(action, EInputAction.IACT_Press) {
      let refused = pages.KeysRefused();
      this.armed = Equals(refused, "") ? key : EInputKey.IK_None;
      // Not for a menu with a single page: the listener of an earlier menu may still be set, and would say so at
      // each key.
      if !Equals(refused, "") && !Equals(refused, "no_pages") {
        ModSettingsNavigatorLog("page key refused key=" + ToString(key) + " reason=" + refused);
      }
      return;
    }
    if !Equals(action, EInputAction.IACT_Release) || !Equals(this.armed, key) {
      return;
    }
    this.armed = EInputKey.IK_None;
    // Checked again at the release: a binding row can start listening between the press and the release.
    if Equals(pages.KeysRefused(), "") {
      pages.Flip(step, ToString(key));
    }
  }
}
