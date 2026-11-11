// What Favorites.reds changes on a line of the list of mods. A line is Mod Settings' library item menu_item
// (mod_settings_main.inkwidget 0.2.29): a flex root, with the game's SettingsCategoryItem as its controller, and the
// name shown in its child txtValueHighlight, aligned left, with margins.
// The list never sizes again what is in it (trials 3 to 9 of 1.0.1): a widget added stays at size 0 and never draws,
// a text changed is not redrawn, a padding is ignored, and a margin moves the lines without making the list longer (the
// end of the last line would be cut off). Only the name's margin changes here: it moves right on a favourite, to leave
// room for its heart (FavoriteMarks.reds).

// How far the name moves right on a favourite: the heart's width and some space.
public func ModSettingsNavigatorFavoriteShift() -> Float {
  return 48.0;
}

// Whether this mod moved the line's name, so that it is moved once and moved back exactly.
@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
@addField(SettingsCategoryItem)
public let modSettingsNavigatorShifted: Bool;

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public abstract class ModSettingsNavigatorFavoriteLine {
  // Moves the name right on a favourite, back on another mod (verified in game, trial 3 of 1.0.1).
  public static func Shift(item: wref<inkWidget>, favorite: Bool) {
    let controller = ModSettingsNavigatorFavoriteLine.ControllerOf(item);
    if !IsDefined(controller) || Equals(controller.modSettingsNavigatorShifted, favorite) {
      return;
    }
    let name = ModSettingsNavigatorFavoriteLine.NameOf(item);
    if !IsDefined(name) {
      return;
    }
    let margin = name.GetMargin();
    margin.left += favorite ? ModSettingsNavigatorFavoriteShift() : -ModSettingsNavigatorFavoriteShift();
    name.SetMargin(margin);
    controller.modSettingsNavigatorShifted = favorite;
  }

  // Where the name starts when it is not moved, from the line's left side: the heart goes there.
  public static func NameLeft(item: wref<inkWidget>) -> Float {
    let controller = ModSettingsNavigatorFavoriteLine.ControllerOf(item);
    let name = ModSettingsNavigatorFavoriteLine.NameOf(item);
    if !IsDefined(controller) || !IsDefined(name) {
      return 0.0;
    }
    let margin = name.GetMargin();
    return controller.modSettingsNavigatorShifted ? margin.left - ModSettingsNavigatorFavoriteShift() : margin.left;
  }

  private static func ControllerOf(item: wref<inkWidget>) -> wref<SettingsCategoryItem> {
    if !IsDefined(item) {
      return null;
    }
    return item.GetController() as SettingsCategoryItem;
  }

  private static func NameOf(item: wref<inkWidget>) -> wref<inkWidget> {
    let line = item as inkCompoundWidget;
    if !IsDefined(line) {
      return null;
    }
    return line.GetWidget(n"txtValueHighlight");
  }
}
