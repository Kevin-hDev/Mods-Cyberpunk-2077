// Remembers where the player is in Mod Settings: the mod shown, the scroll, the row or title under the cursor. The
// place is saved each time the cursor goes over a row or a title, and a frame after a page of another mod is built.
// Restore.reds puts the player back there when the menu is opened again; Memory.reds forgets the place when a save is
// loaded.

// Sent a frame after a page is built. While the list of mods changes the mod shown (L1, R1, the restore), it builds
// the new page before it marks the new mod: during the build the list still names the previous one (essai 5 log,
// "page built shown=Air Strafe toggled=0" while Apex Grapple's page was built).
public class ModSettingsNavigatorPageShownEvent extends Event {}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public abstract class ModSettingsNavigatorPosition {
  // Called by the first row of each page Mod Settings builds. The first page of a menu not seen before is the menu
  // opening: the place is restored from there, while the menu builds itself, before the player sees it.
  // Essais 2 to 4 found the menu among the interface layers, where it is only listed once open: the restore waited
  // for the first hover, a second or more late with the mouse, never with a controller.
  public static func OnPageStart(row: wref<inkWidget>, memory: ref<ModSettingsNavigatorMemory>) {
    let foundBy = "stack";
    let menu = ModSettingsNavigatorMenu.Building();
    if !IsDefined(menu) {
      foundBy = "layers";
      menu = ModSettingsNavigatorMenu.Find(row);
    }
    if !IsDefined(menu) {
      if !memory.IsMenuPending() {
        ModSettingsNavigatorLog("menu not found, looked for again at the next hover");
      }
      memory.SetMenuPending(true);
      return;
    }
    memory.SetMenuPending(false);
    if memory.SeeMenu(menu) {
      memory.Arrows().Watch(menu);
      memory.SetRestorePending(false);
      ModSettingsNavigatorLog("menu opened found_by=" + foundBy);
      if memory.RememberOn() && memory.TakeTarget() {
        ModSettingsNavigatorRestore.Ask(menu, "menu_opened");
      }
      return;
    }
    menu.m_selectorCtrl.QueueEvent(new ModSettingsNavigatorPageShownEvent());
  }

  public static func OnHover(key: String, widget: wref<inkWidget>) {
    let memory = ModSettingsNavigatorMemory.Get();
    if !IsDefined(memory) {
      return;
    }
    if memory.IsMenuPending() {
      ModSettingsNavigatorPosition.OnPageStart(widget, memory);
    }
    let menu = memory.Menu();
    if !IsDefined(menu) {
      return;
    }
    memory.Arrows().OnHovered(widget);
    if !memory.RememberOn() {
      memory.ForgetPosition();
      return;
    }
    // The restore asked for when the menu opened has not run: the place hovered is not saved over the one to go back
    // to, and the restore is asked for again.
    if memory.IsRestorePending() {
      ModSettingsNavigatorRestore.Ask(menu, "not_run_before_a_hover");
      return;
    }
    memory.SavePosition(ModSettingsNavigatorMenu.ShownMod(menu), ModSettingsNavigatorMenu.Scroll(menu), key);
  }

  public static func RowKey(row: ref<SettingsSelectorController>) -> String {
    return "row:" + NameToString(row.GetGroupPath()) + "/" + NameToString(row.GetVarName());
  }

  public static func WidgetKey(widget: wref<inkWidget>) -> String {
    let title = widget.GetController() as SettingsCategoryController;
    if IsDefined(title) {
      return "title:" + title.modSettingsNavigatorKey;
    }
    let row = widget.GetController() as SettingsSelectorController;
    return IsDefined(row) ? ModSettingsNavigatorPosition.RowKey(row) : "";
  }

  // The menu whose list of mods is this one, or null. An event also reaches the lists that hold the sender (essai 1:
  // each step ran two to four times), so each step acts only in the menu's own list.
  public static func MenuOf(list: ref<ListController>) -> wref<ModStngsMainGameController> {
    let memory = ModSettingsNavigatorMemory.Get();
    if !IsDefined(memory) {
      return null;
    }
    let menu = memory.Menu();
    if !IsDefined(menu) {
      return null;
    }
    let own: ref<ListController> = menu.m_selectorCtrl;
    return own == list ? menu : null;
  }
}

// Mod Settings also rebuilds the page of the same mod (saving the settings on Back, a row that shows others): the place
// is reset only when the mod changed (essai 2: Back wiped the row).
@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
@addMethod(ListController)
protected cb func OnModSettingsNavigatorPageShown(evt: ref<ModSettingsNavigatorPageShownEvent>) -> Bool {
  let menu = ModSettingsNavigatorPosition.MenuOf(this);
  if !IsDefined(menu) {
    return false;
  }
  let memory = ModSettingsNavigatorMemory.Get();
  let shown = ModSettingsNavigatorMenu.ShownMod(menu);
  if memory.RememberOn() && !memory.IsRestorePending() && !Equals(shown, memory.PositionMod()) {
    memory.SavePosition(shown, 0.0, "");
  }
  return true;
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
@wrapMethod(SettingsSelectorController)
protected cb func OnHoverOver(e: ref<inkPointerEvent>) -> Bool {
  let result = wrappedMethod(e);
  if ModSettingsNavigatorMenu.IsOpen() {
    ModSettingsNavigatorPosition.OnHover(ModSettingsNavigatorPosition.RowKey(this), this.GetRootWidget());
  }
  return result;
}
