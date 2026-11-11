// Where the favourite icons (FavoriteHearts.reds) and the thin line under the favourites stand over the list of mods.
// What this menu accepts (trials 3 to 12 of 1.0.1): nothing a script adds inside the list's scrolling area is sized or
// drawn; in mod_flex, which holds that area, a widget added when the list is sorted at the opening is drawn, even kept
// away from the screen (trial 12), but one added later never is, nor one that was hidden (trial 10) or transparent
// (trial 11) when the menu was first drawn. Colour (the style's state) and translation are followed afterwards.
// And what is added to mod_flex is sized only once the panel around it is laid out again (trial 16, AskLayout).
// So at each opening one heart per line and the line are added, opaque, away from the screen; afterwards only their
// translation and state change. A heart shown sits in front of its line's name and follows the list when it scrolls;
// it goes away while its line is not whole on screen (the list's mask does not cut it).

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorFavoriteMarks extends IScriptable {
  private let area: wref<inkWidget>;
  // The list's scroller, looked up once per sort and not at each scroll signal.
  private let scroll: wref<inkScrollController>;
  // By Mod Settings' index.
  private let hearts: array<wref<inkWidget>>;
  private let favorite: array<Bool>;
  // Whether the heart is at its line now; false while it is away from the screen.
  private let placed: array<Bool>;
  // Each heart's height from the top of the list, without the scroll.
  private let tops: array<Float>;
  // The indices whose heart may be at its line: the favourites, and a mod unmarked since the sort. Only these are
  // gone through when the list scrolls.
  private let marked: array<Int32>;
  // Where a name starts from the list's left side: the same on every line, they are one library item.
  private let left: Float;
  private let divider: wref<inkWidget>;
  // -1 without a line: no favourite, or nothing after them.
  private let dividerTop: Float;
  private let dividerPlaced: Bool;
  private let selected: Int32;
  // How far the list was scrolled when the hearts were last placed: the list signals several times for one move.
  private let offset: Float;

  // At each sort, the favourites being first in the order shown. Returns how many hearts the menu has, or -1 when it
  // has no mod_flex (another mod changed Mod Settings' layout).
  public func Build(menu: wref<ModStngsMainGameController>, order: ref<ModSettingsNavigatorListOrder>) -> Int32 {
    this.Watch(menu);
    this.scroll = ModSettingsNavigatorListView.Scroller(menu);
    let layer = ModSettingsNavigatorFavoriteHearts.Layer(menu);
    let list = menu.m_selectorCtrl;
    let count = list.Size();
    if !IsDefined(layer) {
      ArrayClear(this.hearts);
      ArrayClear(this.placed);
      ArrayClear(this.marked);
      return -1;
    }
    let away = ModSettingsNavigatorHeartAway();
    if layer.GetNumChildren() != count + 1 || ArraySize(this.hearts) != count {
      if layer.GetNumChildren() > 0 {
        // The list has another number of lines than at the opening: hearts added now do not draw before the menu
        // is opened again.
        ModSettingsNavigatorLog("favorite marks rebuilt reason=line_count lines=" + ToString(count));
      }
      layer.RemoveAllChildren();
      ArrayClear(this.hearts);
      ArrayClear(this.placed);
      let divider = ModSettingsNavigatorNewDivider(n"msn_favorite_divider");
      divider.SetTranslation(away);
      divider.Reparent(layer);
      this.divider = divider;
      this.dividerPlaced = false;
      let i = 0;
      while i < count {
        let heart = ModSettingsNavigatorFavoriteHearts.AddHeart(layer);
        heart.SetState(n"Default");
        ArrayPush(this.hearts, heart);
        ArrayPush(this.placed, false);
        i += 1;
      }
      ModSettingsNavigatorFavoriteHearts.AskLayout(menu);
    } else {
      // The same menu sorting its lines again (rebuilt by Mod Settings) keeps its hearts, new ones would not draw:
      // those at a line go away and are placed again below.
      for index in this.marked {
        if this.placed[index] && IsDefined(this.hearts[index]) {
          this.hearts[index].SetTranslation(away);
          this.placed[index] = false;
        }
      }
      if this.selected >= 0 && this.selected < count && IsDefined(this.hearts[this.selected]) {
        this.hearts[this.selected].SetState(n"Default");
      }
    }
    ArrayResize(this.favorite, count);
    ArrayResize(this.tops, count);
    ArrayClear(this.marked);
    let row = ModSettingsNavigatorListView.RowHeight(menu, order);
    let size = ModSettingsNavigatorHeartSize();
    let favorites = order.FavoriteCount();
    this.left = ModSettingsNavigatorFavoriteLine.NameLeft(list.GetItemAt(order.IndexAt(0)));
    let position = 0;
    while position < count {
      let index = order.IndexAt(position);
      if index >= 0 && index < count {
        this.favorite[index] = position < favorites;
        this.tops[index] = ModSettingsNavigatorListView.LineTop(position, row) + (row - size.Y) / 2.0;
        if this.favorite[index] {
          ArrayPush(this.marked, index);
        }
      }
      position += 1;
    }
    this.dividerTop = favorites > 0 && favorites < count ? ModSettingsNavigatorListView.LineTop(favorites, row) - 1.0
      : -1.0;
    this.selected = -1;
    this.Place(true);
    this.Select(menu);
    return ArraySize(this.hearts);
  }

  // A favourite added or removed: its heart comes to its line or goes away, the list does not move.
  // Returns false when the line has no heart.
  public func Mark(index: Int32, favorite: Bool) -> Bool {
    if index < 0 || index >= ArraySize(this.hearts) || !IsDefined(this.hearts[index]) {
      return false;
    }
    this.favorite[index] = favorite;
    if favorite && !ArrayContains(this.marked, index) {
      ArrayPush(this.marked, index);
    }
    this.Place(true);
    return true;
  }

  // The heart of the mod shown takes the colours of a selected line, the others those of a line at rest.
  public func Select(menu: wref<ModStngsMainGameController>) {
    let toggled = menu.m_selectorCtrl.GetToggledIndex();
    if toggled == this.selected {
      return;
    }
    if this.selected >= 0 && this.selected < ArraySize(this.hearts) && IsDefined(this.hearts[this.selected]) {
      this.hearts[this.selected].SetState(n"Default");
    }
    if toggled >= 0 && toggled < ArraySize(this.hearts) && IsDefined(this.hearts[toggled]) {
      this.hearts[toggled].SetState(n"Selected");
    }
    this.selected = toggled;
  }

  // Brings each favourite's heart whose line is whole on screen in front of its name, and sends the others away; the
  // same for the line under the favourites. Unless forced, nothing is done while the list has not moved.
  private func Place(force: Bool) {
    let scroll = this.scroll;
    if !IsDefined(scroll) {
      return;
    }
    let offset = ModSettingsNavigatorListView.Offset(scroll);
    if !force && offset == this.offset {
      return;
    }
    this.offset = offset;
    let viewport = scroll.GetViewportSize();
    let size = ModSettingsNavigatorHeartSize();
    let away = ModSettingsNavigatorHeartAway();
    for index in this.marked {
      let heart = this.hearts[index];
      if IsDefined(heart) {
        let top = this.tops[index] - offset;
        let shown = this.favorite[index] && top >= -0.5 && top + size.Y <= viewport.Y + 0.5;
        if shown {
          heart.SetTranslation(new Vector2(this.left, top));
        } else {
          if this.placed[index] {
            heart.SetTranslation(away);
          }
        }
        this.placed[index] = shown;
      }
    }
    let divider = this.divider;
    if IsDefined(divider) {
      let top = this.dividerTop - offset;
      let shown = this.dividerTop >= 0.0 && top >= 0.0 && top <= viewport.Y;
      if shown {
        divider.SetTranslation(new Vector2(ModSettingsNavigatorDividerLeft(), top));
      } else {
        if this.dividerPlaced {
          divider.SetTranslation(away);
        }
      }
      this.dividerPlaced = shown;
    }
  }

  // Once per menu: the list's scrolling area tells when it moves (wheel, scrollbar, L1/R1, a page turned). Its
  // scroller has the new place already when it signals (trial 11).
  private func Watch(menu: wref<ModStngsMainGameController>) {
    let area = ModSettingsNavigatorListView.ScrollArea(menu);
    let known: ref<inkWidget> = this.area;
    let current: ref<inkWidget> = area;
    if !IsDefined(area) || known == current {
      return;
    }
    this.area = area;
    area.RegisterToCallback(n"OnScrollChanged", this, n"OnScrollChanged");
  }

  protected cb func OnScrollChanged(value: Vector2) -> Bool {
    this.Place(false);
    return false;
  }
}
