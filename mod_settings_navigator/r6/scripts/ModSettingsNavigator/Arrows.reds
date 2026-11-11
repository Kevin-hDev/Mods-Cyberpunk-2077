// The controller's d-pad and the keyboard's arrow keys in Mod Settings. Without this mod they skip the section titles
// (trial 2, 10 November 2026). After each press of an arrow, the cursor is put on the widget that should come next
// from where it was before the press: a row, or the title of a section that has rows.
// Trial 3: a correction made on the first hover after the press ran once in dozens of presses, the game's hover and
// our press callback not coming in the order assumed. The check runs a frame after the arrow is released, when the
// game's own move is over whatever that order. Trial 4: the signals come as pre-press, post-press, release, with no
// hover from the game between them.

public class ModSettingsNavigatorArrowCheckEvent extends Event {}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorArrows extends IScriptable {
  private let menu: wref<ModStngsMainGameController>;
  private let lastHovered: wref<inkWidget>;
  // Where the cursor was when the arrow was pressed, the direction, and how many rows the cursor went over meanwhile.
  private let anchor: wref<inkWidget>;
  private let pressing: Bool;
  private let direction: Int32;
  private let hovers: Int32;

  // The arrows are up_button and down_button in inputUserMappings.xml: d-pad up and down, keyboard up and down.
  // A closed menu takes its callbacks with it (trial 5: one call per press over 16 openings); a menu still alive is
  // released here, as Mod Settings releases its own callback when it closes.
  public func Watch(menu: wref<ModStngsMainGameController>) {
    let previous = this.menu;
    if IsDefined(previous) {
      previous.UnregisterFromGlobalInputCallback(n"OnPreOnPress", this, n"OnArrowPrePress");
      previous.UnregisterFromGlobalInputCallback(n"OnPostOnPress", this, n"OnArrowPostPress");
      previous.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnArrowRelease");
    }
    this.menu = menu;
    this.lastHovered = null;
    this.pressing = false;
    menu.RegisterToGlobalInputCallback(n"OnPreOnPress", this, n"OnArrowPrePress");
    menu.RegisterToGlobalInputCallback(n"OnPostOnPress", this, n"OnArrowPostPress");
    menu.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnArrowRelease");
  }

  private func Direction(evt: ref<inkPointerEvent>) -> Int32 {
    if evt.IsAction(n"up_button") {
      return -1;
    }
    if evt.IsAction(n"down_button") {
      return 1;
    }
    return 0;
  }

  private func StartPress(direction: Int32) {
    this.pressing = true;
    this.direction = direction;
    this.anchor = this.lastHovered;
    this.hovers = 0;
  }

  protected cb func OnArrowPrePress(evt: ref<inkPointerEvent>) -> Bool {
    let direction = this.Direction(evt);
    if direction != 0 {
      this.StartPress(direction);
    }
    return false;
  }

  protected cb func OnArrowPostPress(evt: ref<inkPointerEvent>) -> Bool {
    let direction = this.Direction(evt);
    if direction != 0 && !this.pressing {
      this.StartPress(direction);
    }
    return false;
  }

  protected cb func OnArrowRelease(evt: ref<inkPointerEvent>) -> Bool {
    if this.Direction(evt) == 0 || !this.pressing {
      return false;
    }
    this.pressing = false;
    let menu = this.menu;
    if IsDefined(menu) {
      menu.m_selectorCtrl.QueueEvent(new ModSettingsNavigatorArrowCheckEvent());
    }
    return false;
  }

  // Called for each row or title the cursor goes over, by the mouse, the stick or this mod.
  public func OnHovered(widget: wref<inkWidget>) {
    this.lastHovered = widget;
    if this.pressing {
      this.hovers += 1;
    }
  }

  // A frame after the release. A press held down moves the cursor several rows: that move is left as it is.
  public func Check(memory: ref<ModSettingsNavigatorMemory>) {
    let menu = this.menu;
    if !memory.FoldingOn() || !IsDefined(menu) || this.hovers > 1 {
      return;
    }
    // A confirmation window of Mod Settings is open over the menu: the arrows belong to it (audit, trial 5).
    if IsDefined(menu.m_confirmationToken) {
      return;
    }
    let list = inkWidgetRef.Get(menu.m_settingsOptionsList) as inkCompoundWidget;
    if !IsDefined(list) {
      return;
    }
    // The row under the cursor at the press is gone when its page was rebuilt (L1, R1, Back): the arrows start from
    // the same row of the new page if it has one, else from the top of the page, whatever their direction (audit,
    // trial 5: they had no start until the stick moved).
    let expected: wref<inkWidget>;
    let anchor = this.anchor;
    let from = IsDefined(anchor) ? this.IndexIn(list, anchor) : -1;
    if from < 0 && Equals(ModSettingsNavigatorMenu.ShownMod(menu), memory.PositionMod()) {
      from = this.IndexOfKey(list, memory.PositionRow());
    }
    if from < 0 {
      expected = this.NextStop(list, -1, 1);
    } else {
      expected = this.NextStop(list, from, this.direction);
    }
    let reached: ref<inkWidget> = this.lastHovered;
    let wanted: ref<inkWidget> = expected;
    if IsDefined(wanted) && wanted != reached {
      menu.SetCursorOverWidget(expected, 0.0, true);
    }
  }

  // The next widget an arrow should stop on, after the given index in the given direction: a visible row, or a
  // visible title of a section that has rows.
  private func NextStop(list: wref<inkCompoundWidget>, from: Int32, step: Int32) -> wref<inkWidget> {
    if step == 0 {
      return null;
    }
    let count = list.GetNumChildren();
    let i = from + step;
    while i >= 0 && i < count {
      let widget = list.GetWidgetByIndex(i);
      if widget.IsVisible() {
        let title = widget.GetController() as SettingsCategoryController;
        if IsDefined(title) {
          if StrLen(title.modSettingsNavigatorKey) > 0 {
            return widget;
          }
        } else {
          if IsDefined(widget.GetController() as SettingsSelectorController) {
            return widget;
          }
        }
      }
      i += step;
    }
    return null;
  }

  // The index of the visible row or title saved under this key, or -1.
  private func IndexOfKey(list: wref<inkCompoundWidget>, key: String) -> Int32 {
    if StrLen(key) == 0 {
      return -1;
    }
    let count = list.GetNumChildren();
    let i = 0;
    while i < count {
      let widget = list.GetWidgetByIndex(i);
      if widget.IsVisible() && Equals(ModSettingsNavigatorPosition.WidgetKey(widget), key) {
        return i;
      }
      i += 1;
    }
    return -1;
  }

  private func IndexIn(list: wref<inkCompoundWidget>, widget: wref<inkWidget>) -> Int32 {
    let target: ref<inkWidget> = widget;
    let count = list.GetNumChildren();
    let i = 0;
    while i < count {
      let current: ref<inkWidget> = list.GetWidgetByIndex(i);
      if current == target {
        return i;
      }
      i += 1;
    }
    return -1;
  }
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
@addMethod(ListController)
protected cb func OnModSettingsNavigatorArrowCheck(evt: ref<ModSettingsNavigatorArrowCheckEvent>) -> Bool {
  if !IsDefined(ModSettingsNavigatorPosition.MenuOf(this)) {
    return false;
  }
  let memory = ModSettingsNavigatorMemory.Get();
  if IsDefined(memory) {
    memory.Arrows().Check(memory);
  }
  return true;
}
