// The atlas of the favourite icon. The menus that hold Mod Settings do not load the photo gallery's atlas: an icon set
// to it has no part to draw until it is (trial 4 of 1.0.1: SetTexturePart answered true, IsTexturePartExist false;
// trial 6: true at the next opening, after this load). It is loaded here
// through Codeware at the first need and kept for the rest of the launch, so that later openings draw the icon at once.
// Cost: the atlas stays in memory (gallery_atlas.xbm, the 4K version, weighs 2.9 MB in the game files), as soon as
// favourites can be used (Favorites.reds says why). Codeware can call a function when the load ends, but from a
// loading thread: the interface is
// only touched from the menu's own events, so the load is checked once per event, a bounded number of times.

public class ModSettingsNavigatorAtlasCheckEvent extends Event {}

// About five seconds at 60 frames a second.
public func ModSettingsNavigatorAtlasChecks() -> Int32 {
  return 300;
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorFavoriteAtlas extends IScriptable {
  private let token: ref<ResourceToken>;
  private let menu: wref<ModStngsMainGameController>;
  // Icons were added before the atlas was ready and must be set again once it is.
  private let pending: Bool;
  private let checking: Bool;
  private let checks: Int32;

  // Asks for the atlas, and for the hearts to be set again once it is loaded.
  public func Need(menu: wref<ModStngsMainGameController>) {
    if !IsDefined(this.token) {
      this.token = GameInstance.GetResourceDepot().LoadResource(ModSettingsNavigatorFavoriteAtlasPath());
    }
    if this.IsLoaded() {
      return;
    }
    this.pending = true;
    // The checks of a menu closed meanwhile stopped with it: they start again in the new one.
    let known: ref<ModStngsMainGameController> = this.menu;
    let current: ref<ModStngsMainGameController> = menu;
    if !this.checking || known != current {
      this.menu = menu;
      this.checking = true;
      this.checks = 0;
      menu.m_selectorCtrl.QueueEvent(new ModSettingsNavigatorAtlasCheckEvent());
    }
  }

  private func IsLoaded() -> Bool {
    let token = this.token;
    return IsDefined(token) && token.IsLoaded();
  }

  public func State() -> String {
    let token = this.token;
    if !IsDefined(token) {
      return "none";
    }
    if token.IsLoaded() {
      return "loaded";
    }
    return token.IsFailed() ? "failed" : "loading";
  }

  // One check per event, until the atlas is loaded, has failed, or the checks are used up.
  public func Check(menu: wref<ModStngsMainGameController>) {
    this.checks += 1;
    let token = this.token;
    let loaded = this.IsLoaded();
    let failed = !IsDefined(token) || token.IsFailed();
    if !loaded && !failed && this.checks < ModSettingsNavigatorAtlasChecks() {
      menu.m_selectorCtrl.QueueEvent(new ModSettingsNavigatorAtlasCheckEvent());
      return;
    }
    this.checking = false;
    let redrawn = loaded ? this.Redraw(menu) : 0;
    ModSettingsNavigatorLog("favorite atlas state=" + this.State() + " checks=" + ToString(this.checks)
      + " icons_redrawn=" + ToString(redrawn));
  }

  // At each page of a mod built: the bounded checks may have ended before the load.
  public func RedrawIfReady(menu: wref<ModStngsMainGameController>) {
    if this.pending && this.IsLoaded() {
      ModSettingsNavigatorLog("favorite atlas state=loaded late icons_redrawn=" + ToString(this.Redraw(menu)));
    }
  }

  private func Redraw(menu: wref<ModStngsMainGameController>) -> Int32 {
    this.pending = false;
    return ModSettingsNavigatorFavoriteHearts.Redraw(menu);
  }
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
@addMethod(ListController)
protected cb func OnModSettingsNavigatorAtlasCheck(evt: ref<ModSettingsNavigatorAtlasCheckEvent>) -> Bool {
  let menu = ModSettingsNavigatorPosition.MenuOf(this);
  let memory = ModSettingsNavigatorMemory.Get();
  if !IsDefined(menu) || !IsDefined(memory) {
    return false;
  }
  memory.Favorites().OnAtlasCheck(menu);
  return true;
}
