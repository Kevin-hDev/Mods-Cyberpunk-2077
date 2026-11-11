// Favourite mods (Kevin, 10 November 2026, drawing F). Holding Square or V (FavoriteKey.reds) marks or unmarks the mod
// shown: its heart changes at once and the list does not move. At the next opening the favourites come first, in Mod
// Settings' order, then a thin line, then the other mods. Only the lines on screen move (ReorderChild on the list's panel):
// Mod Settings rebuilds its data in its own order at each setting changed and finds the page by the index selected, so
// its indices and data are never touched (probes, trials 1 to 3). ListOrder.reds keeps which line is at which place.
// Without RedFileSystem there are no favourites and nothing here acts.

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorFavorites extends IScriptable {
  private let order: ref<ModSettingsNavigatorListOrder>;
  private let choices: ref<ModSettingsNavigatorChoices>;
  private let key: ref<ModSettingsNavigatorFavoriteKey>;
  private let atlas: ref<ModSettingsNavigatorFavoriteAtlas>;
  private let marks: ref<ModSettingsNavigatorFavoriteMarks>;
  // The first line of the list at the last sort: another one there means the lines were built again.
  private let firstLine: wref<inkWidget>;

  public func Init(order: ref<ModSettingsNavigatorListOrder>, choices: ref<ModSettingsNavigatorChoices>) {
    this.order = order;
    this.choices = choices;
    this.key = new ModSettingsNavigatorFavoriteKey();
    this.key.Init(this);
    this.atlas = new ModSettingsNavigatorFavoriteAtlas();
    this.marks = new ModSettingsNavigatorFavoriteMarks();
  }

  // A frame after the menu opened, before the pages are measured: before, the list has no lines yet.
  public func Arrange(menu: wref<ModStngsMainGameController>) {
    this.key.Watch(menu, this.choices.FavoritesOn());
    this.order.Reset();
    if !this.choices.FavoritesOn() {
      return;
    }
    this.Sort(menu, false);
    // Mod Settings opens on its first mod, which the favourites push down the list: with a page of favourites or
    // more it would be off screen.
    if this.order.FavoriteCount() > 0 {
      let position = this.order.PositionOf(menu.m_selectorCtrl.GetToggledIndex());
      if !ModSettingsNavigatorListView.IsOnScreen(menu, this.order, position) {
        ModSettingsNavigatorListView.Follow(menu, position);
      }
    }
    this.ShowHint(menu);
  }

  // rebuilt: the lines were built again in a menu already open, and are sorted a second time.
  private func Sort(menu: wref<ModStngsMainGameController>, rebuilt: Bool) {
    let list = menu.m_selectorCtrl;
    let panel = list.GetRootWidget() as inkCompoundWidget;
    let size = list.Size();
    if !IsDefined(panel) || size == 0 {
      ModSettingsNavigatorLog("favorites stopped reason=no_list");
      return;
    }
    let shown: array<Int32>;
    let others: array<Int32>;
    let i = 0;
    while i < size {
      if i < ArraySize(menu.m_data) && this.choices.IsFavorite(NameToString(menu.m_data[i].label)) {
        ArrayPush(shown, i);
      } else {
        ArrayPush(others, i);
      }
      i += 1;
    }
    let favoriteCount = ArraySize(shown);
    // Asked for before the hearts are added, with or without favourites: a heart is known to draw when its atlas was
    // asked for first (trial 12); one added without it, for a first favourite marked later, was never tried.
    this.atlas.Need(menu);
    for index in others {
      ArrayPush(shown, index);
    }
    // Every line is put at its place and its name moved or not, so that the result does not depend on what the panel
    // had before. A list Mod Settings has just built, without favourites, is in order already.
    if favoriteCount > 0 || rebuilt {
      let position = 0;
      for index in shown {
        let item = list.GetItemAt(index);
        panel.ReorderChild(item, position);
        ModSettingsNavigatorFavoriteLine.Shift(item, position < favoriteCount);
        position += 1;
      }
    }
    this.firstLine = panel.GetWidgetByIndex(0);
    if favoriteCount == 0 {
      this.order.Reset();
    } else {
      if !this.order.Set(shown, favoriteCount) {
        ModSettingsNavigatorLog("favorites stopped reason=order_refused");
        return;
      }
    }
    let hearts = this.marks.Build(menu, this.order);
    ModSettingsNavigatorLog("favorites arranged favorites=" + ToString(favoriteCount) + " hearts=" + ToString(hearts)
      + " atlas=" + this.atlas.State() + " reason=" + (rebuilt ? "list_rebuilt" : "opened"));
  }

  // A frame after each page of a mod is built: the selection may have changed.
  public func OnPageShown(menu: wref<ModStngsMainGameController>) {
    if !this.choices.FavoritesOn() {
      return;
    }
    // Mod Settings builds new lines in its own order when the game's language changes (OnLocalizationChanged, read in
    // its code 0.2.29), and another mod may rebuild them too: the first line is then not the one seen at the sort.
    let panel = menu.m_selectorCtrl.GetRootWidget() as inkCompoundWidget;
    let first: ref<inkWidget>;
    if IsDefined(panel) {
      first = panel.GetWidgetByIndex(0);
    }
    let known: ref<inkWidget> = this.firstLine;
    if IsDefined(first) && first != known {
      this.Sort(menu, true);
    }
    this.atlas.RedrawIfReady(menu);
    this.marks.Select(menu);
    this.ShowHint(menu);
  }

  public func OnAtlasCheck(menu: wref<ModStngsMainGameController>) {
    this.atlas.Check(menu);
  }

  // The game's own texts, as the backpack writes them (backpack_main.script). Written again at each page: Mod Settings
  // empties the hint bar when it writes its own again.
  private func ShowHint(menu: wref<ModStngsMainGameController>) {
    let hints = menu.m_buttonHintsController;
    if !IsDefined(hints) {
      return;
    }
    let favorite = this.choices.IsFavorite(ModSettingsNavigatorMenu.ShownMod(menu));
    let action = GetLocalizedText(favorite ? "UI-UserActions-ItemRemoveFavourite" : "UI-UserActions-ItemAddFavourite");
    hints.AddButtonHint(n"favourite_item", "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] "
      + action);
  }

  // The favourite key held to the end; armedBy says which signal saw the press (FavoriteKey.reds).
  public func Toggle(menu: wref<ModStngsMainGameController>, armedBy: String) {
    let mod = ModSettingsNavigatorMenu.ShownMod(menu);
    if StrLen(mod) == 0 {
      ModSettingsNavigatorLog("favorite refused reason=no_mod_shown");
      return;
    }
    let favorite = this.choices.ToggleFavorite(mod);
    let list = menu.m_selectorCtrl;
    let index = list.GetToggledIndex();
    ModSettingsNavigatorFavoriteLine.Shift(list.GetItemAt(index), favorite);
    let heart = this.marks.Mark(index, favorite);
    this.ShowHint(menu);
    ModSettingsNavigatorLog("favorite mod=" + mod + " favorite=" + ToString(favorite) + " heart=" + ToString(heart)
      + " armed_by=" + armedBy);
  }
}
