// Reaching Mod Settings' menu. redscript 0.5.32 refuses @wrapMethod and @addMethod on a class that another mod
// declares in its scripts ("no method with this name exists on the target type", "constant pool error"), so this mod
// hooks the game's own classes that Mod Settings uses (rows, lists) and reads the menu from there.

// How far up the script call stack the menu is looked for. A row is set up by the menu's PopulateOptions, four or
// five calls above this mod's own functions; 24 leaves room for the wrappers of other mods.
public func ModSettingsNavigatorStackDepth() -> Int32 {
  return 24;
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public abstract class ModSettingsNavigatorMenu {
  // The Mod Settings menu that is building a page right now, read from the script call stack (Codeware): a row is set
  // up by the menu's own PopulateOptions. Unlike Find, it answers during the first page of an opening, when the menu
  // is not listed among the interface layers yet (essais 2 to 4: the menu was only found at the first hover, a second
  // or more after it opened, and never with a controller).
  public static func Building() -> wref<ModStngsMainGameController> {
    let trace = GetStackTrace(ModSettingsNavigatorStackDepth(), true);
    for entry in trace {
      let menu = entry.object as ModStngsMainGameController;
      if IsDefined(menu) {
        return menu;
      }
    }
    return null;
  }

  // True while Mod Settings' menu is open: the game's own settings menu uses the same titles and rows.
  public static func IsOpen() -> Bool {
    return ModSettings.GetInstance().isActive;
  }

  // The Mod Settings menu that holds this widget, looked up among the game's interface layers; used when no page is
  // being built. A menu that is closing can still be listed beside the new one (essai 1: the second reopening was
  // sent to the wrong one), so the menu is the one whose root widget is an ancestor of the widget.
  public static func Find(widget: wref<inkWidget>) -> wref<ModStngsMainGameController> {
    for layer in GameInstance.GetInkSystem().GetLayers() {
      for controller in layer.GetGameControllers() {
        let menu = controller as ModStngsMainGameController;
        if IsDefined(menu) && ModSettingsNavigatorMenu.Holds(menu.GetRootWidget(), widget) {
          return menu;
        }
      }
    }
    return null;
  }

  private static func Holds(root: wref<inkWidget>, widget: wref<inkWidget>) -> Bool {
    let target: ref<inkWidget> = root;
    let current: ref<inkWidget> = widget;
    // The menu's tree is a few dozen levels deep at most; the bound only guards against a loop.
    let depth = 0;
    while IsDefined(current) && depth < 64 {
      if current == target {
        return true;
      }
      current = current.GetParentWidget();
      depth += 1;
    }
    return false;
  }

  // The name of the mod shown, as Mod Settings lists it; empty when none is shown.
  public static func ShownMod(menu: wref<ModStngsMainGameController>) -> String {
    let index = menu.m_selectorCtrl.GetToggledIndex();
    if index < 0 || index >= ArraySize(menu.m_data) {
      return "";
    }
    return NameToString(menu.m_data[index].label);
  }

  public static func Scroll(menu: wref<ModStngsMainGameController>) -> Float {
    let scroll = inkWidgetRef.GetController(menu.m_scrollPanel) as inkScrollController;
    return IsDefined(scroll) ? scroll.GetScrollPosition() : 0.0;
  }
}
