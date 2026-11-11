// L1 and R1 once the favourites are moved up. Mod Settings moves one index at a time (OnButtonRelease, read in its code
// 0.2.29), which is not the next line shown any more. This mod keeps where the player was before the release, then goes
// to the next line shown, in a loop as Mod Settings does. Mod Settings' handler and this one listen to the same release
// and the order between them is not stable (probes, trials 3 and 4): when Mod Settings has already moved, the correction
// is made at once; when it has not, a frame later. Without favourites the order shown is Mod Settings' own and nothing
// here acts.

public class ModSettingsNavigatorBumperCheckEvent extends Event {}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorBumpers extends IScriptable {
  private let order: ref<ModSettingsNavigatorListOrder>;
  private let menu: wref<ModStngsMainGameController>;
  // The place shown before the release, and the index to be on a frame later.
  private let from: Int32;
  private let armed: Bool;
  private let expected: Int32;

  public func Init(order: ref<ModSettingsNavigatorListOrder>) {
    this.order = order;
  }

  // A closed menu takes its callbacks with it; a menu still alive is released here (as in Arrows.reds).
  public func Watch(menu: wref<ModStngsMainGameController>) {
    let previous = this.menu;
    if IsDefined(previous) {
      previous.UnregisterFromGlobalInputCallback(n"OnPreOnRelease", this, n"OnBumperPreRelease");
      previous.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnBumperPostRelease");
    }
    this.menu = menu;
    this.armed = false;
    menu.RegisterToGlobalInputCallback(n"OnPreOnRelease", this, n"OnBumperPreRelease");
    menu.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnBumperPostRelease");
  }

  private func Step(evt: ref<inkPointerEvent>) -> Int32 {
    if evt.IsAction(n"prior_menu") {
      return -1;
    }
    if evt.IsAction(n"next_menu") {
      return 1;
    }
    return 0;
  }

  // Before Mod Settings sees the release, whatever the order of the two handlers after it.
  protected cb func OnBumperPreRelease(evt: ref<inkPointerEvent>) -> Bool {
    let menu = this.menu;
    if this.order.FavoriteCount() == 0 || !IsDefined(menu) || this.Step(evt) == 0 {
      return false;
    }
    this.from = this.order.PositionOf(menu.m_selectorCtrl.GetToggledIndex());
    this.armed = true;
    return false;
  }

  protected cb func OnBumperPostRelease(evt: ref<inkPointerEvent>) -> Bool {
    let menu = this.menu;
    if !this.armed || !IsDefined(menu) {
      return false;
    }
    let step = this.Step(evt);
    if step == 0 {
      return false;
    }
    this.armed = false;
    let list = menu.m_selectorCtrl;
    let size = list.Size();
    if size < 2 {
      return false;
    }
    let to = (this.from + step + size) % size;
    let expected = this.order.IndexAt(to);
    let toggled = list.GetToggledIndex();
    let outcome = "same_as_mod_settings";
    if toggled != expected {
      if toggled == this.order.IndexAt(this.from) {
        outcome = "next_frame";
        this.expected = expected;
        list.QueueEvent(new ModSettingsNavigatorBumperCheckEvent());
      } else {
        outcome = "corrected_now";
        list.SetToggledIndex(expected);
      }
    }
    ModSettingsNavigatorListView.Follow(menu, to);
    ModSettingsNavigatorLog("bumper step=" + ToString(step) + " to=" + ToString(to) + " outcome=" + outcome);
    return false;
  }

  // A frame after a release Mod Settings had not acted on yet: it has moved one index since.
  public func Check() {
    let menu = this.menu;
    if !IsDefined(menu) {
      return;
    }
    let list = menu.m_selectorCtrl;
    if list.GetToggledIndex() != this.expected {
      list.SetToggledIndex(this.expected);
      ModSettingsNavigatorLog("bumper corrected to=" + ToString(this.expected));
    }
    // Followed even when Mod Settings' own index is the right one: it has scrolled since to that line's place in its
    // own order, not on screen (audit of 1.0.1: L1 from its first mod to the last favourite left the list at its end).
    ModSettingsNavigatorListView.Follow(menu, this.order.PositionOf(this.expected));
  }
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
@addMethod(ListController)
protected cb func OnModSettingsNavigatorBumperCheck(evt: ref<ModSettingsNavigatorBumperCheckEvent>) -> Bool {
  let memory = ModSettingsNavigatorMemory.Get();
  if !IsDefined(ModSettingsNavigatorPosition.MenuOf(this)) || !IsDefined(memory) {
    return false;
  }
  memory.Bumpers().Check();
  return true;
}
