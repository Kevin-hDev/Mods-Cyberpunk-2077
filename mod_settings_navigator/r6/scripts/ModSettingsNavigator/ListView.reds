// Measures of Mod Settings' list of mods, read from its own scroller each time and never kept: a list rebuilt or resized
// is measured again. Places are counted in the order shown (ListOrder). Probes of 11 November 2026: visible height
// 1500, line 80, 18 whole lines per page; the scroller is mod_settings/mod_flex, its scrolling area mod_scroller.

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public abstract class ModSettingsNavigatorListView {
  // Mod Settings' widgets this mod reads or adds to (mod_settings_main.inkwidget 0.2.29): the panel that holds the
  // list and what is under it, the list's scroller, and its scrolling area. Null when another mod changed the layout.
  public static func Panel(menu: wref<ModStngsMainGameController>) -> wref<inkCompoundWidget> {
    return menu.GetWidget(n"mod_settings") as inkCompoundWidget;
  }

  public static func Flex(menu: wref<ModStngsMainGameController>) -> wref<inkCompoundWidget> {
    return menu.GetWidget(n"mod_settings/mod_flex") as inkCompoundWidget;
  }

  public static func ScrollArea(menu: wref<ModStngsMainGameController>) -> wref<inkWidget> {
    return menu.GetWidget(n"mod_settings/mod_flex/mod_scroller");
  }

  public static func Scroller(menu: wref<ModStngsMainGameController>) -> wref<inkScrollController> {
    let flex = ModSettingsNavigatorListView.Flex(menu);
    if !IsDefined(flex) {
      return null;
    }
    return flex.GetController() as inkScrollController;
  }

  // The height of one line, read on the line shown first: all lines have the same height.
  public static func RowHeight(menu: wref<ModStngsMainGameController>, order: ref<ModSettingsNavigatorListOrder>)
    -> Float {
    let item = menu.m_selectorCtrl.GetItemAt(order.IndexAt(0));
    if !IsDefined(item) {
      return 0.0;
    }
    let size = item.GetDesiredSize();
    return size.Y;
  }

  // Whole lines the list shows at once; 0 while the list has no size yet.
  public static func PerPage(menu: wref<ModStngsMainGameController>, order: ref<ModSettingsNavigatorListOrder>)
    -> Int32 {
    let scroll = ModSettingsNavigatorListView.Scroller(menu);
    let row = ModSettingsNavigatorListView.RowHeight(menu, order);
    if !IsDefined(scroll) || row <= 0.0 {
      return 0;
    }
    let viewport = scroll.GetViewportSize();
    return Cast<Int32>(viewport.Y / row);
  }

  // Distance from the top of the list to the top of the line at this place.
  public static func LineTop(position: Int32, row: Float) -> Float {
    return Cast<Float>(position) * row;
  }

  // The scroll that brings the line at this place to the top of the list, as far as the list can scroll.
  public static func RatioFor(menu: wref<ModStngsMainGameController>, order: ref<ModSettingsNavigatorListOrder>,
    position: Int32) -> Float {
    let scroll = ModSettingsNavigatorListView.Scroller(menu);
    if !IsDefined(scroll) {
      return 0.0;
    }
    let viewport = scroll.GetViewportSize();
    let content = scroll.GetContentSize();
    let room = content.Y - viewport.Y;
    if room <= 0.0 {
      return 0.0;
    }
    let row = ModSettingsNavigatorListView.RowHeight(menu, order);
    return ClampF(ModSettingsNavigatorListView.LineTop(position, row) / room, 0.0, 1.0);
  }

  // The scroll Mod Settings gives itself for L1 and R1 (ScrollToMod, 0.2.29): proportional to the line's place in the
  // list, which keeps the line on screen. Counted here in the order shown.
  public static func Follow(menu: wref<ModStngsMainGameController>, position: Int32) {
    let size = menu.m_selectorCtrl.Size();
    if size > 1 {
      menu.ScrollToMod(Cast<Float>(position) / Cast<Float>(size - 1));
    }
  }

  // How far the list is scrolled, in the menu's units.
  public static func Offset(scroll: wref<inkScrollController>) -> Float {
    let viewport = scroll.GetViewportSize();
    let content = scroll.GetContentSize();
    let room = content.Y - viewport.Y;
    return room > 0.0 ? scroll.GetScrollPosition() * room : 0.0;
  }

  // True when the whole line at this place is on screen.
  public static func IsOnScreen(menu: wref<ModStngsMainGameController>, order: ref<ModSettingsNavigatorListOrder>,
    position: Int32) -> Bool {
    let scroll = ModSettingsNavigatorListView.Scroller(menu);
    let row = ModSettingsNavigatorListView.RowHeight(menu, order);
    if !IsDefined(scroll) || row <= 0.0 {
      return false;
    }
    let viewport = scroll.GetViewportSize();
    let offset = ModSettingsNavigatorListView.Offset(scroll);
    let top = ModSettingsNavigatorListView.LineTop(position, row);
    // One unit of slack: a scroll set by ratio lands a fraction of a unit off.
    return top >= offset - 1.0 && top + row <= offset + viewport.Y + 1.0;
  }

  // The place of the line at the middle of the visible part of the list.
  public static func MiddlePosition(menu: wref<ModStngsMainGameController>, order: ref<ModSettingsNavigatorListOrder>)
    -> Int32 {
    let scroll = ModSettingsNavigatorListView.Scroller(menu);
    let row = ModSettingsNavigatorListView.RowHeight(menu, order);
    let size = menu.m_selectorCtrl.Size();
    if !IsDefined(scroll) || row <= 0.0 || size == 0 {
      return 0;
    }
    let viewport = scroll.GetViewportSize();
    let middle = ModSettingsNavigatorListView.Offset(scroll) + viewport.Y / 2.0;
    return Clamp(Cast<Int32>(middle / row), 0, size - 1);
  }
}
