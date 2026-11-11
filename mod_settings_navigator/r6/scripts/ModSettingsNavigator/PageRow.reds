// Under the list of mods: a thin line, then "PAGE 2 / 7" and two arrows (drawing A, chosen by Kevin on 10 November
// 2026). They are added to Mod Settings' mod_settings panel after the list, so the game's own layout puts them under
// it whatever the screen (probe of 11 November 2026). The arrows are the game's own setting arrows (settings_main
// .inkwidget: arrow_rect_fg, filled arrow_rect_bg under the mouse, MainColors.PanelBlue); Kevin found plain text
// arrows did not look like the game's buttons (probe, trial 2).

public func ModSettingsNavigatorPageStyle() -> ResRef {
  return r"base\\gameplay\\gui\\common\\main_colors.inkstyle";
}

// The thin line above the page row, also drawn under the favourites (FavoriteMarks.reds; Kevin, 11 November 2026, in
// place of the gap of drawing F, which the list could not make room for).
public func ModSettingsNavigatorDividerLeft() -> Float {
  return 30.0;
}

public func ModSettingsNavigatorDividerWidth() -> Float {
  return 780.0;
}

public func ModSettingsNavigatorDividerOpacity() -> Float {
  return 0.4;
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public func ModSettingsNavigatorNewDivider(name: CName) -> ref<inkRectangle> {
  let line = new inkRectangle();
  line.SetName(name);
  line.SetSize(new Vector2(ModSettingsNavigatorDividerWidth(), 2.0));
  line.SetStyle(ModSettingsNavigatorPageStyle());
  line.BindProperty(n"tintColor", n"MainColors.Red");
  line.SetOpacity(ModSettingsNavigatorDividerOpacity());
  return line;
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorPageRow extends IScriptable {
  private let pages: wref<ModSettingsNavigatorPages>;
  private let label: wref<inkText>;
  private let previous: wref<inkImage>;
  private let next: wref<inkImage>;

  // Returns false when the menu has no mod_settings panel (another mod changed Mod Settings' layout).
  public func Build(menu: wref<ModStngsMainGameController>, pages: wref<ModSettingsNavigatorPages>) -> Bool {
    this.pages = pages;
    let parent = ModSettingsNavigatorListView.Panel(menu);
    if !IsDefined(parent) {
      return false;
    }
    let line = ModSettingsNavigatorNewDivider(n"msn_page_line");
    line.SetHAlign(inkEHorizontalAlign.Left);
    line.SetMargin(new inkMargin(ModSettingsNavigatorDividerLeft(), 10.0, 0.0, 0.0));
    line.Reparent(parent);
    let row = new inkHorizontalPanel();
    row.SetName(n"msn_page_row");
    row.SetHAlign(inkEHorizontalAlign.Left);
    row.SetMargin(new inkMargin(ModSettingsNavigatorDividerLeft(), 14.0, 0.0, 0.0));
    row.Reparent(parent);
    let label = new inkText();
    label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Medium");
    label.SetFontSize(45);
    label.SetLetterCase(textLetterCase.UpperCase);
    label.SetStyle(ModSettingsNavigatorPageStyle());
    label.BindProperty(n"tintColor", n"MainColors.Red");
    label.SetVAlign(inkEVerticalAlign.Center);
    label.Reparent(row);
    this.label = label;
    this.previous = this.Arrow(row, n"msn_page_previous", -90.0, 36.0);
    this.next = this.Arrow(row, n"msn_page_next", 90.0, 8.0);
    return true;
  }

  private func Arrow(row: ref<inkCompoundWidget>, name: CName, rotation: Float, left: Float) -> ref<inkImage> {
    let button = new inkCanvas();
    button.SetName(name);
    button.SetSize(new Vector2(60.0, 60.0));
    button.SetMargin(new inkMargin(left, 0.0, 0.0, 0.0));
    button.SetVAlign(inkEVerticalAlign.Center);
    button.SetInteractive(true);
    button.Reparent(row);
    let image = new inkImage();
    image.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    image.SetTexturePart(n"arrow_rect_fg");
    image.SetAnchor(inkEAnchor.Centered);
    image.SetAnchorPoint(new Vector2(0.5, 0.5));
    image.SetSize(new Vector2(40.0, 40.0));
    image.SetRenderTransformPivot(new Vector2(0.5, 0.5));
    image.SetRotation(rotation);
    image.SetStyle(ModSettingsNavigatorPageStyle());
    image.BindProperty(n"tintColor", n"MainColors.PanelBlue");
    image.Reparent(button);
    button.RegisterToCallback(n"OnEnter", this, n"OnArrowEnter");
    button.RegisterToCallback(n"OnLeave", this, n"OnArrowLeave");
    button.RegisterToCallback(n"OnRelease", this, n"OnArrowRelease");
    return image;
  }

  public func ShowPage(page: Int32, pages: Int32) {
    let label = this.label;
    if !IsDefined(label) {
      return;
    }
    let text = GetLocalizedTextByKey(n"ModSettingsNavigator-Page");
    text = StrReplace(text, "{0}", ToString(page));
    label.SetText(StrReplace(text, "{1}", ToString(pages)));
  }

  private func ArrowOf(evt: ref<inkPointerEvent>) -> wref<inkImage> {
    let target = evt.GetCurrentTarget();
    if !IsDefined(target) {
      return null;
    }
    return Equals(target.GetName(), n"msn_page_previous") ? this.previous : this.next;
  }

  protected cb func OnArrowEnter(evt: ref<inkPointerEvent>) -> Bool {
    let image = this.ArrowOf(evt);
    if IsDefined(image) {
      image.SetTexturePart(n"arrow_rect_bg");
    }
    return false;
  }

  protected cb func OnArrowLeave(evt: ref<inkPointerEvent>) -> Bool {
    let image = this.ArrowOf(evt);
    if IsDefined(image) {
      image.SetTexturePart(n"arrow_rect_fg");
    }
    return false;
  }

  protected cb func OnArrowRelease(evt: ref<inkPointerEvent>) -> Bool {
    let pages = this.pages;
    if !evt.IsAction(n"click") || !IsDefined(pages) {
      return false;
    }
    let target = evt.GetCurrentTarget();
    let back = IsDefined(target) && Equals(target.GetName(), n"msn_page_previous");
    pages.Flip(back ? -1 : 1, "click");
    return true;
  }
}
