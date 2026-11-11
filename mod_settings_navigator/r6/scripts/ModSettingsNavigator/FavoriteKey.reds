// The favourite key: Square held on a controller, V held on a keyboard, the game's favourite_item action (a button with
// a hold of 0.4 s in inputContexts.xml). The mod shown is marked or unmarked once per press, when the hold is complete
// (verified in game, probe 5). Listened to only while Mod Settings is open and RedFileSystem is installed.

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorFavoriteKey extends IScriptable {
  private let favorites: wref<ModSettingsNavigatorFavorites>;
  private let menu: wref<ModStngsMainGameController>;
  // One press: seen, allowed (no shortcut row nor confirmation wanted the key then), done, and the signal that saw it.
  private let armed: Bool;
  private let allowed: Bool;
  private let done: Bool;
  private let armedBy: String;

  public func Init(favorites: wref<ModSettingsNavigatorFavorites>) {
    this.favorites = favorites;
  }

  // A closed menu takes its callbacks with it; a menu still alive is released here (as in Arrows.reds).
  public func Watch(menu: wref<ModStngsMainGameController>, on: Bool) {
    let previous = this.menu;
    if IsDefined(previous) {
      previous.UnregisterFromGlobalInputCallback(n"OnPreOnPress", this, n"OnFavoritePress");
      previous.UnregisterFromGlobalInputCallback(n"OnPostOnHold", this, n"OnFavoriteHold");
      previous.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnFavoriteRelease");
    }
    this.menu = menu;
    this.armed = false;
    this.done = false;
    if !on {
      return;
    }
    menu.RegisterToGlobalInputCallback(n"OnPreOnPress", this, n"OnFavoritePress");
    menu.RegisterToGlobalInputCallback(n"OnPostOnHold", this, n"OnFavoriteHold");
    menu.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnFavoriteRelease");
  }

  // Read at the press, before a shortcut row takes the key: choosing V as a mod's shortcut must not mark a favourite.
  // The first hold signal stands in if the press was not seen under the action's name.
  private func Arm(by: String) {
    let menu = this.menu;
    this.armed = true;
    this.armedBy = by;
    let busy = IsDefined(menu) ? ModSettingsNavigatorMenu.InputBusy(menu) : "no_menu";
    this.allowed = Equals(busy, "");
    if !this.allowed {
      ModSettingsNavigatorLog("favorite refused reason=" + busy + " armed_by=" + by);
    }
  }

  protected cb func OnFavoritePress(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"favourite_item") {
      this.done = false;
      this.Arm("press");
    }
    return false;
  }

  protected cb func OnFavoriteHold(evt: ref<inkPointerEvent>) -> Bool {
    let menu = this.menu;
    let favorites = this.favorites;
    if !evt.IsAction(n"favourite_item") || this.done || !IsDefined(menu) || !IsDefined(favorites) {
      return false;
    }
    if !this.armed {
      this.Arm("hold");
    }
    if evt.GetHoldProgress() < 1.0 {
      return false;
    }
    this.done = true;
    if this.allowed && Equals(ModSettingsNavigatorMenu.InputBusy(menu), "") {
      favorites.Toggle(menu, this.armedBy);
    }
    return false;
  }

  protected cb func OnFavoriteRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"favourite_item") {
      this.armed = false;
      this.done = false;
    }
    return false;
  }
}
