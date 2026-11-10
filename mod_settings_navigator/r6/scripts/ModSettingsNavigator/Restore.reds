// Puts the player back where Position.reds saw them last: same mod in the list of mods, same scroll, cursor on the
// same row or title. Asked for while the menu builds its first page, it runs on the next frame, in two steps a frame
// apart, sent to the menu's list of mods: first the mod is shown, then, once its page is built, the scroll and the
// cursor are set. Changing the mod while the first page is still being built would rebuild the list under Mod
// Settings' own loop, and nothing of the game's that this mod can hook runs after that loop in the same frame.

public class ModSettingsNavigatorRestoreEvent extends Event {}

public class ModSettingsNavigatorRestoreRowEvent extends Event {}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public abstract class ModSettingsNavigatorRestore {
  public static func Ask(menu: wref<ModStngsMainGameController>, reason: String) {
    let memory = ModSettingsNavigatorMemory.Get();
    if !IsDefined(memory) {
      return;
    }
    memory.SetRestorePending(true);
    menu.m_selectorCtrl.QueueEvent(new ModSettingsNavigatorRestoreEvent());
    ModSettingsNavigatorLog("restore asked reason=" + reason + " mod=" + memory.TargetMod()
      + " row=" + memory.TargetRow());
  }
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
@addMethod(ListController)
protected cb func OnModSettingsNavigatorRestore(evt: ref<ModSettingsNavigatorRestoreEvent>) -> Bool {
  let menu = ModSettingsNavigatorPosition.MenuOf(this);
  if !IsDefined(menu) {
    return false;
  }
  let memory = ModSettingsNavigatorMemory.Get();
  // Asked for twice when a hover came before the first request ran: it runs once.
  if !memory.IsRestorePending() {
    return true;
  }
  memory.SetRestorePending(false);
  let index = -1;
  let i = 0;
  while i < ArraySize(menu.m_data) {
    if Equals(NameToString(menu.m_data[i].label), memory.TargetMod()) {
      index = i;
    }
    i += 1;
  }
  if index < 0 {
    ModSettingsNavigatorLog("restore stopped reason=mod_not_listed mod=" + memory.TargetMod());
    return true;
  }
  let builtBy = "none";
  if index != this.GetToggledIndex() {
    // Setting the index makes Mod Settings build the mod's page, as L1 and R1 do (essai 5: two pages were built at
    // each restore, Mod Settings' and ours). Ours is kept only for the case where the list built nothing.
    let pages = memory.Sections().PagesStarted();
    this.SetToggledIndex(index);
    builtBy = "list";
    if memory.Sections().PagesStarted() == pages {
      menu.PopulateCategorySettingsOptions(index);
      builtBy = "us";
    }
    let size = this.Size();
    if size > 1 {
      menu.ScrollToMod(Cast<Float>(index) / Cast<Float>(size - 1));
    }
  }
  ModSettingsNavigatorLog("restore step=mod index=" + ToString(index) + " page_built_by=" + builtBy);
  this.QueueEvent(new ModSettingsNavigatorRestoreRowEvent());
  return true;
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
@addMethod(ListController)
protected cb func OnModSettingsNavigatorRestoreRow(evt: ref<ModSettingsNavigatorRestoreRowEvent>) -> Bool {
  let menu = ModSettingsNavigatorPosition.MenuOf(this);
  if !IsDefined(menu) {
    return false;
  }
  let memory = ModSettingsNavigatorMemory.Get();
  let scroll = inkWidgetRef.GetController(menu.m_scrollPanel) as inkScrollController;
  if IsDefined(scroll) {
    scroll.SetScrollPosition(memory.TargetScroll());
  }
  let found = false;
  let list = inkWidgetRef.Get(menu.m_settingsOptionsList) as inkCompoundWidget;
  if IsDefined(list) && StrLen(memory.TargetRow()) > 0 {
    let count = list.GetNumChildren();
    let i = 0;
    while i < count && !found {
      let widget = list.GetWidgetByIndex(i);
      if widget.IsVisible() && Equals(ModSettingsNavigatorPosition.WidgetKey(widget), memory.TargetRow()) {
        // The saved scroll stayed at 0 in essai 2 whatever the row: the row is also brought into view.
        if IsDefined(scroll) {
          scroll.EnsureVisible(widget);
        }
        menu.SetCursorOverWidget(widget, 0.0, true);
        found = true;
      }
      i += 1;
    }
  }
  // The place is saved again here, so that it never depends on a hover. Essai 5: the restore's page builds reset the
  // row, and the cursor set by the mod brought no hover in three restores of twelve, which kept no row for the next
  // opening.
  memory.SavePosition(memory.TargetMod(), memory.TargetScroll(), memory.TargetRow());
  ModSettingsNavigatorLog("restore step=row row=" + memory.TargetRow() + " row_found=" + ToString(found));
  return true;
}
