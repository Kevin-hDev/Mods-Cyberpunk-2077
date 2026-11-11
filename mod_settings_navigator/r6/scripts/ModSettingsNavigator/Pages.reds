// Pages in the list of mods (Kevin, 10 November 2026): a page holds as many mods as the list shows at once; L3/R3, Q/E
// or the arrows turn it, in a loop, and select its first mod. Nothing is shown when every mod fits on one page.
// The page shown is the selected mod's while its line is on screen, else the page of the line at the middle of the
// screen: after a free scroll the screen shows the end of a page and the start of the next (plan-1.0.1.md). Pages turn
// from the page shown.

public class ModSettingsNavigatorScrolledEvent extends Event {}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorPages extends IScriptable {
  private let order: ref<ModSettingsNavigatorListOrder>;
  private let keys: ref<ModSettingsNavigatorPageKeys>;
  private let hints: ref<ModSettingsNavigatorPageHints>;
  private let menu: wref<ModStngsMainGameController>;
  private let row: ref<ModSettingsNavigatorPageRow>;
  private let perPage: Int32;
  // 0 until the pages are set up in the menu open now, and when everything fits on one page.
  private let pageCount: Int32;
  // The page written under the list, from 0; -1 before the first.
  private let shownPage: Int32;
  // A page update is already queued for the next frame.
  private let scrollQueued: Bool;

  public func Init(order: ref<ModSettingsNavigatorListOrder>) {
    this.order = order;
    this.keys = new ModSettingsNavigatorPageKeys();
    this.hints = new ModSettingsNavigatorPageHints();
  }

  // The menu was opened again: nothing is shown or turned until its list has its size, a frame later.
  public func Forget() {
    this.pageCount = 0;
    this.row = null;
  }

  // A frame after the menu opened: before, the list has no size yet.
  public func Attach(menu: wref<ModStngsMainGameController>) {
    this.menu = menu;
    this.shownPage = -1;
    this.scrollQueued = false;
    let size = menu.m_selectorCtrl.Size();
    this.perPage = ModSettingsNavigatorListView.PerPage(menu, this.order);
    let count = this.perPage > 0 ? (size + this.perPage - 1) / this.perPage : 0;
    ModSettingsNavigatorLog("pages per_page=" + ToString(this.perPage) + " pages=" + ToString(count) + " mods="
      + ToString(size));
    if count < 2 {
      return;
    }
    let row = new ModSettingsNavigatorPageRow();
    if !row.Build(menu, this) {
      ModSettingsNavigatorLog("pages stopped reason=no_mod_settings_panel");
      return;
    }
    this.row = row;
    this.pageCount = count;
    let area = ModSettingsNavigatorListView.ScrollArea(menu);
    if IsDefined(area) {
      area.RegisterToCallback(n"OnScrollChanged", this, n"OnScrollChanged");
    }
    this.hints.Add(menu);
    this.keys.Listen(this);
    this.Refresh("opened");
  }

  private func ShownPage(menu: wref<ModStngsMainGameController>) -> Int32 {
    let position = this.order.PositionOf(menu.m_selectorCtrl.GetToggledIndex());
    if position < 0 || !ModSettingsNavigatorListView.IsOnScreen(menu, this.order, position) {
      position = ModSettingsNavigatorListView.MiddlePosition(menu, this.order);
    }
    return Clamp(position / this.perPage, 0, this.pageCount - 1);
  }

  // Writes the page shown under the list when it changed, and says so in the log.
  public func Refresh(by: String) {
    if this.Update() {
      ModSettingsNavigatorLog("page shown page=" + ToString(this.shownPage + 1) + " by=" + by);
    }
  }

  // Returns true when the page shown changed.
  private func Update() -> Bool {
    let menu = this.menu;
    let row = this.row;
    if this.pageCount < 2 || !IsDefined(menu) || !IsDefined(row) {
      return false;
    }
    let page = this.ShownPage(menu);
    if page == this.shownPage {
      return false;
    }
    this.shownPage = page;
    row.ShowPage(page + 1, this.pageCount);
    return true;
  }

  // Selects the first mod of the next or previous page, in a loop, and brings it to the top of the list. Setting the
  // index makes Mod Settings build the mod's page (verified by the restore of version 1.0.0).
  public func Flip(direction: Int32, source: String) {
    let menu = this.menu;
    if this.pageCount < 2 || !IsDefined(menu) {
      return;
    }
    let from = this.ShownPage(menu);
    let to = (from + direction + this.pageCount) % this.pageCount;
    let position = to * this.perPage;
    let index = this.order.IndexAt(position);
    menu.m_selectorCtrl.SetToggledIndex(index);
    let scroll = ModSettingsNavigatorListView.Scroller(menu);
    if IsDefined(scroll) {
      scroll.SetScrollPosition(ModSettingsNavigatorListView.RatioFor(menu, this.order, position));
    }
    ModSettingsNavigatorLog("page turned source=" + source + " from=" + ToString(from + 1) + " to=" + ToString(to + 1)
      + " index=" + ToString(index));
    this.Update();
  }

  // Why the page keys must be left alone now, or "" when they may turn the page.
  public func KeysRefused() -> String {
    let menu = this.menu;
    if !IsDefined(menu) || this.pageCount < 2 {
      return "no_pages";
    }
    return ModSettingsNavigatorMenu.InputBusy(menu);
  }

  // The list moved (wheel, scrollbar, L1/R1, a page turned): the page is read again a frame later, once per frame.
  protected cb func OnScrollChanged(value: Vector2) -> Bool {
    let menu = this.menu;
    if !this.scrollQueued && IsDefined(menu) {
      this.scrollQueued = true;
      menu.m_selectorCtrl.QueueEvent(new ModSettingsNavigatorScrolledEvent());
    }
    return false;
  }

  public func OnScrolled() {
    this.scrollQueued = false;
    this.Refresh("scroll");
  }
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
@addMethod(ListController)
protected cb func OnModSettingsNavigatorScrolled(evt: ref<ModSettingsNavigatorScrolledEvent>) -> Bool {
  let memory = ModSettingsNavigatorMemory.Get();
  if !IsDefined(ModSettingsNavigatorPosition.MenuOf(this)) || !IsDefined(memory) {
    return false;
  }
  memory.Pages().OnScrolled();
  return true;
}
