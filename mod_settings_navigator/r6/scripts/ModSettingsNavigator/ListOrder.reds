// The order the list of mods is shown in: which of Mod Settings' indices sits at each place on screen. Mod Settings
// rebuilds its data in its own order at each setting changed, so its indices are never touched: this mod only moves the
// lines on screen (favourites first). Pages, the page number, L1/R1 and the restore all go through this table.
// Empty: the lines are in Mod Settings' order.
public class ModSettingsNavigatorListOrder extends IScriptable {
  // shown[position] = index; placeOf[index] = position. Both are rebuilt together, at most once per opening.
  private let shown: array<Int32>;
  private let placeOf: array<Int32>;
  private let favoriteCount: Int32;

  public func Reset() {
    ArrayClear(this.shown);
    ArrayClear(this.placeOf);
    this.favoriteCount = 0;
  }

  // The list's indices in the order shown, favourites first. Every index from 0 to the list's size minus one must be
  // in it once: otherwise the table is emptied, the lines' order is taken as Mod Settings' own, and false is returned.
  public func Set(shown: array<Int32>, favoriteCount: Int32) -> Bool {
    let size = ArraySize(shown);
    ArrayResize(this.placeOf, size);
    let position = 0;
    while position < size {
      this.placeOf[position] = -1;
      position += 1;
    }
    position = 0;
    while position < size {
      let index = shown[position];
      if index < 0 || index >= size || this.placeOf[index] >= 0 {
        this.Reset();
        return false;
      }
      this.placeOf[index] = position;
      position += 1;
    }
    this.shown = shown;
    this.favoriteCount = Clamp(favoriteCount, 0, size);
    return true;
  }

  public func FavoriteCount() -> Int32 {
    return this.favoriteCount;
  }

  public func PositionOf(index: Int32) -> Int32 {
    if index < 0 || index >= ArraySize(this.placeOf) {
      return index;
    }
    return this.placeOf[index];
  }

  public func IndexAt(position: Int32) -> Int32 {
    if position < 0 || position >= ArraySize(this.shown) {
      return position;
    }
    return this.shown[position];
  }
}
