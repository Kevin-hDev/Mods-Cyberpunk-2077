// The widgets of the favourite icons: a layer over the list of mods and one heart per line, placed by
// FavoriteMarks.reds. A heart is the game's icon with the line's style (hub_menu_style: red, cyan on the mod shown).

// The favourite icon of the game's photo gallery (favoriteIcon in codex_gallery.inkwidget, probe 4): a white heart with
// square corners, tinted by the widget, shown at its own size. Its atlas is loaded by FavoriteAtlas.reds.
public func ModSettingsNavigatorFavoriteAtlasPath() -> ResRef {
  return r"base\\gameplay\\gui\\fullscreen\\codex\\gallery\\gallery_atlas.inkatlas";
}

public func ModSettingsNavigatorHeartPart() -> CName {
  return n"filter_favorite";
}

public func ModSettingsNavigatorHeartSize() -> Vector2 {
  return new Vector2(34.0, 38.0);
}

public func ModSettingsNavigatorLineStyle() -> ResRef {
  return r"base\\gameplay\\gui\\fullscreen\\hub_menu\\hub_menu_style.inkstyle";
}

// Where a heart, or the line under the favourites, waits while it is not shown: far outside the screen. Hidden or
// transparent when the game first draws the menu, it would never be drawn afterwards (trials 10 and 11 of 1.0.1);
// kept there, it is (trial 12).
public func ModSettingsNavigatorHeartAway() -> Vector2 {
  return new Vector2(-10000.0, -10000.0);
}

public func ModSettingsNavigatorHeartLayerName() -> CName {
  return n"msn_favorite_marks";
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public abstract class ModSettingsNavigatorFavoriteHearts {
  // The layer in mod_flex, added at its first call for this menu; null when the menu has no mod_flex (another mod
  // changed Mod Settings' layout).
  public static func Layer(menu: wref<ModStngsMainGameController>) -> wref<inkCompoundWidget> {
    let flex = ModSettingsNavigatorListView.Flex(menu);
    if !IsDefined(flex) {
      ModSettingsNavigatorLog("favorite marks stopped reason=no_mod_flex");
      return null;
    }
    let layer = flex.GetWidget(ModSettingsNavigatorHeartLayerName()) as inkCompoundWidget;
    if IsDefined(layer) {
      return layer;
    }
    // Small, so that mod_flex, which fits its content, keeps the list's size; what it holds is drawn outside its
    // bounds, placed by translations from its corner, which is the list's top left corner (trial 8).
    let added = new inkCanvas();
    added.SetName(ModSettingsNavigatorHeartLayerName());
    added.SetSize(new Vector2(1.0, 1.0));
    added.SetHAlign(inkEHorizontalAlign.Left);
    added.SetVAlign(inkEVerticalAlign.Top);
    added.Reparent(flex);
    return added;
  }

  // After the hearts are added. The game sizes what a script adds to mod_flex only when it lays out again the panel
  // around it, which a child added to that panel causes. With several pages the page row was that child; with a list
  // of one page nothing was, the hearts kept a size of 0 and none was drawn (trial 16).
  public static func AskLayout(menu: wref<ModStngsMainGameController>) {
    let panel = ModSettingsNavigatorListView.Panel(menu);
    if !IsDefined(panel) {
      return;
    }
    let old = panel.GetWidget(n"msn_layout_ask");
    if IsDefined(old) {
      panel.RemoveChild(old);
    }
    let added = new inkCanvas();
    added.SetName(n"msn_layout_ask");
    added.SetSize(new Vector2(1.0, 1.0));
    added.Reparent(panel);
  }

  private static func SetIcon(heart: ref<inkImage>) {
    heart.SetAtlasResource(ModSettingsNavigatorFavoriteAtlasPath());
    heart.SetTexturePart(ModSettingsNavigatorHeartPart());
  }

  // Returns the heart, opaque and away from the screen.
  public static func AddHeart(layer: ref<inkCompoundWidget>) -> ref<inkImage> {
    let heart = new inkImage();
    ModSettingsNavigatorFavoriteHearts.SetIcon(heart);
    heart.SetSize(ModSettingsNavigatorHeartSize());
    heart.SetStyle(ModSettingsNavigatorLineStyle());
    heart.BindProperty(n"tintColor", n"MenuLabel.MainColor");
    heart.BindProperty(n"opacity", n"MenuLabel.MainOpacity");
    heart.SetTranslation(ModSettingsNavigatorHeartAway());
    heart.Reparent(layer);
    return heart;
  }

  // Sets the icon again on every heart, once the atlas is loaded (FavoriteAtlas.reds).
  public static func Redraw(menu: wref<ModStngsMainGameController>) -> Int32 {
    let flex = ModSettingsNavigatorListView.Flex(menu);
    if !IsDefined(flex) {
      return 0;
    }
    let layer = flex.GetWidget(ModSettingsNavigatorHeartLayerName()) as inkCompoundWidget;
    if !IsDefined(layer) {
      return 0;
    }
    let redrawn = 0;
    let count = layer.GetNumChildren();
    let i = 0;
    while i < count {
      let heart = layer.GetWidgetByIndex(i) as inkImage;
      if IsDefined(heart) {
        ModSettingsNavigatorFavoriteHearts.SetIcon(heart);
        redrawn += 1;
      }
      i += 1;
    }
    return redrawn;
  }
}
