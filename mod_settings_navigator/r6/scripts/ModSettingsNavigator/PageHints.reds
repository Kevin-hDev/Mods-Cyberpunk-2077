// The two hint lines of the pages, after Mod Settings' own: previous page and next page, with the icon of the key on the
// device in use (L3/R3 on a controller, Q/E on a keyboard). ButtonHints.AddButtonHint(EInputKey, ...) is declared
// without code in the PC game (scripts 2.5) and showed nothing in the first trial of 11 November 2026. The lines are
// spawned here from the bar's own library item, and their icon set by key, as radialSlot.script does for R3. Owning
// them lets the icons follow a change of device while the menu is open.

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorPageHints extends IScriptable {
  private let previous: wref<inkInputDisplayController>;
  private let next: wref<inkInputDisplayController>;
  private let board: wref<IBlackboard>;
  private let listener: ref<CallbackHandle>;

  public func Add(menu: wref<ModStngsMainGameController>) {
    this.StopListening();
    let hints = menu.m_buttonHintsController;
    if !IsDefined(hints) {
      ModSettingsNavigatorLog("page hints stopped reason=no_hint_bar");
      return;
    }
    // The bar shows the line added last on its left (trial 2: "Next page" stood before "Previous page"): the next page
    // goes in first, so that the bar reads like the arrows under the list.
    this.next = this.Line(hints, GetLocalizedTextByKey(n"ModSettingsNavigator-NextPage"));
    this.previous = this.Line(hints, GetLocalizedTextByKey(n"ModSettingsNavigator-PreviousPage"));
    let defs = GetAllBlackboardDefs();
    let board = menu.GetBlackboardSystem().Get(defs.InputSchemes);
    let device = InputDevice.KBM;
    if IsDefined(board) {
      device = IntEnum<InputDevice>(Cast<Uint8>(board.GetUint(defs.InputSchemes.Device)));
      this.board = board;
      this.listener = board.RegisterListenerUint(defs.InputSchemes.Device, this, n"OnDeviceChanged");
    }
    this.ShowKeys(device);
    ModSettingsNavigatorLog("page hints previous=" + ToString(IsDefined(this.previous)) + " next="
      + ToString(IsDefined(this.next)) + " device=" + ToString(device));
  }

  // A line spawned in the bar the way ButtonHints.AddButtonHint does for an action; returns its icon display.
  private func Line(hints: wref<ButtonHints>, label: String) -> wref<inkInputDisplayController> {
    let widget = hints.SpawnFromLocal(inkWidgetRef.Get(hints.m_horizontalHolder), n"ButtonHintListItem");
    if !IsDefined(widget) {
      return null;
    }
    let item = widget.GetController() as ButtonHintListItem;
    if IsDefined(item) {
      item.SetData(n"None", label);
    }
    return this.Display(widget, 0);
  }

  // The icon display inside a hint line, a few levels down at most.
  private func Display(widget: wref<inkWidget>, depth: Int32) -> wref<inkInputDisplayController> {
    let display = widget.GetController() as inkInputDisplayController;
    if IsDefined(display) || depth >= 4 {
      return display;
    }
    let compound = widget as inkCompoundWidget;
    if !IsDefined(compound) {
      return null;
    }
    let count = compound.GetNumChildren();
    let i = 0;
    while i < count {
      let found = this.Display(compound.GetWidgetByIndex(i), depth + 1);
      if IsDefined(found) {
        return found;
      }
      i += 1;
    }
    return null;
  }

  private func ShowKeys(device: InputDevice) {
    let pad = Equals(device, InputDevice.PAD);
    this.SetKey(this.previous, pad ? EInputKey.IK_Pad_LeftThumb : EInputKey.IK_Q);
    this.SetKey(this.next, pad ? EInputKey.IK_Pad_RightThumb : EInputKey.IK_E);
  }

  private func SetKey(display: wref<inkInputDisplayController>, key: EInputKey) {
    if !IsDefined(display) {
      return;
    }
    let data: inkInputKeyData;
    inkInputKeyData.SetInputKey(data, key);
    display.SetInputKey(data);
    display.SetVisible(true);
  }

  // The board also calls while the player plays: the first call with Mod Settings closed stops the listening.
  protected cb func OnDeviceChanged(value: Uint32) -> Bool {
    if !ModSettingsNavigatorMenu.IsOpen() {
      this.StopListening();
      return false;
    }
    this.ShowKeys(IntEnum<InputDevice>(Cast<Uint8>(value)));
    return false;
  }

  private func StopListening() {
    let board = this.board;
    let handle = this.listener;
    if IsDefined(board) && IsDefined(handle) {
      let defs = GetAllBlackboardDefs();
      board.UnregisterListenerUint(defs.InputSchemes.Device, handle);
    }
    this.board = null;
    this.listener = null;
  }
}
