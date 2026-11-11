// What the player chose to keep: favourite mods and folded sections. Kept as long as the game runs and, when
// RedFileSystem is installed, on disk (Storage.reds), written once per change: a write costs 1 to 4 ms, and the player
// changes one thing at a time (optimisation.md). Without RedFileSystem there are no favourites at all, and folds last
// until the game closes, as in version 1.0.0 (Kevin, 10 November 2026).
// Lines in the file: "favorite <mod name as Mod Settings lists it>" and "folded <section key of Sections.reds>". A mod
// uninstalled stays a favourite in the file: installed again, it is a favourite again.

// A player marks a few mods and folds one section at a time, so 256 is far above real use. Past it the oldest fold is
// forgotten, as in 1.0.0; a favourite past it is refused, so that no favourite the player chose is lost unseen.
public func ModSettingsNavigatorMaxFolds() -> Int32 {
  return 256;
}

public func ModSettingsNavigatorMaxFavorites() -> Int32 {
  return 256;
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorChoices extends IScriptable {
  private let storage: ref<ModSettingsNavigatorStorage>;
  private let favorites: array<String>;
  private let folded: array<String>;

  // Once per launch, at the first opening of Mod Settings (Memory.reds).
  public func Load() {
    this.storage = new ModSettingsNavigatorStorage();
    if !this.storage.Open() {
      return;
    }
    let ignored = 0;
    let word: String;
    let value: String;
    for line in this.storage.Load() {
      if !StrSplitFirst(line, " ", word, value) || StrLen(value) == 0 {
        ignored += 1;
      } else {
        if Equals(word, "favorite") && ArraySize(this.favorites) < ModSettingsNavigatorMaxFavorites()
          && !ArrayContains(this.favorites, value) {
          ArrayPush(this.favorites, value);
        } else {
          if Equals(word, "folded") && ArraySize(this.folded) < ModSettingsNavigatorMaxFolds()
            && !ArrayContains(this.folded, value) {
            ArrayPush(this.folded, value);
          } else {
            ignored += 1;
          }
        }
      }
    }
    ModSettingsNavigatorLog("choices loaded favorites=" + ToString(ArraySize(this.favorites)) + " folded="
      + ToString(ArraySize(this.folded)) + " ignored=" + ToString(ignored));
  }

  // Favourites exist only where they can be kept: shown and broken would be worse than absent.
  public func FavoritesOn() -> Bool {
    return IsDefined(this.storage) && this.storage.IsOn();
  }

  public func IsFavorite(mod: String) -> Bool {
    return this.FavoritesOn() && ArrayContains(this.favorites, mod);
  }
  // Returns the new state: true when the mod is now a favourite.
  public func ToggleFavorite(mod: String) -> Bool {
    if !this.FavoritesOn() || StrLen(mod) == 0 {
      return false;
    }
    let i = ArrayFindFirst(this.favorites, mod);
    if i >= 0 {
      ArrayErase(this.favorites, i);
      this.Save();
      return false;
    }
    if ArraySize(this.favorites) >= ModSettingsNavigatorMaxFavorites() {
      ModSettingsNavigatorLog("favorite refused reason=full mod=" + mod);
      return false;
    }
    ArrayPush(this.favorites, mod);
    this.Save();
    return true;
  }

  public func IsFolded(key: String) -> Bool {
    return ArrayContains(this.folded, key);
  }

  // Returns the new state: true when the section is now folded.
  public func ToggleFold(key: String) -> Bool {
    let i = ArrayFindFirst(this.folded, key);
    if i >= 0 {
      ArrayErase(this.folded, i);
      this.Save();
      return false;
    }
    if ArraySize(this.folded) >= ModSettingsNavigatorMaxFolds() {
      ArrayErase(this.folded, 0);
    }
    ArrayPush(this.folded, key);
    this.Save();
    return true;
  }

  public func FoldedCount() -> Int32 {
    return ArraySize(this.folded);
  }

  private func Save() {
    if !this.FavoritesOn() {
      return;
    }
    let body: array<String>;
    for mod in this.favorites {
      ArrayPush(body, "favorite " + mod);
    }
    for key in this.folded {
      ArrayPush(body, "folded " + key);
    }
    this.storage.Save(body);
  }
}
