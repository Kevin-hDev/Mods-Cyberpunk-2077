// Folds and unfolds the sections of a mod's page. Mod Settings 0.2.29 builds a page in one list, from scratch each time
// it is shown: the rows without a section, then for each section a title (the game's SettingsCategoryController)
// followed by its rows (the game's SettingsSelectorController). Each row is set up right after it is added to the list.
// Titles are found from the rows: Mod Settings' wrapper of SettingsCategoryController.Setup does not call the methods
// wrapped under it while its menu is open, so a wrapper of ours there never runs (trial 1, 10 November 2026: no title
// marked, no fold in the log).

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
@addField(SettingsCategoryController)
public let modSettingsNavigatorKey: String;

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
@addField(SettingsCategoryController)
public let modSettingsNavigatorTitle: String;

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorSections extends IScriptable {
  // The first widget of the page being built. Mod Settings empties the list before each page, so a different first
  // widget means a new page. Guessing it from the row's place in the list missed a page that starts with a section
  // whose rows are all hidden (audit, trial 5).
  private let pageFirst: wref<inkWidget>;
  private let pagesStarted: Int32;
  private let currentFolded: Bool;

  // How many pages have started since the game was launched: tells the restore whether a page was just built.
  public func PagesStarted() -> Int32 {
    return this.pagesStarted;
  }

  public func OnRowSetup(row: ref<SettingsSelectorController>, memory: ref<ModSettingsNavigatorMemory>) {
    let root = row.GetRootWidget();
    let list = root.GetParentWidget() as inkCompoundWidget;
    if !IsDefined(list) {
      return;
    }
    let first: ref<inkWidget> = list.GetWidgetByIndex(0);
    let known: ref<inkWidget> = this.pageFirst;
    if first != known {
      this.pageFirst = first;
      this.pagesStarted += 1;
      this.currentFolded = false;
      memory.ReadSettings();
      ModSettingsNavigatorPosition.OnPageStart(root, memory);
    }
    if !memory.FoldingOn() {
      return;
    }
    let index = list.GetNumChildren() - 1;
    if index > 0 {
      let title = list.GetWidgetByIndex(index - 1).GetController() as SettingsCategoryController;
      if IsDefined(title) {
        this.currentFolded = this.SetUpTitle(title, row, memory);
      }
    }
    if this.currentFolded {
      root.SetVisible(false);
    }
  }

  // The section's key: the title as shown, and the settings group of its first row (the mod's settings class).
  // The title is the translated text: folds are forgotten when the game's language changes (audit, trial 5), on disk
  // too since 1.0.1. Returns whether the section is folded.
  private func SetUpTitle(title: ref<SettingsCategoryController>, firstRow: ref<SettingsSelectorController>,
    memory: ref<ModSettingsNavigatorMemory>) -> Bool {
    title.modSettingsNavigatorTitle = inkTextRef.GetText(title.m_label);
    title.modSettingsNavigatorKey = title.modSettingsNavigatorTitle + "|" + NameToString(firstRow.GetGroupPath());
    let folded = memory.Choices().IsFolded(title.modSettingsNavigatorKey);
    this.Mark(title, folded);
    let titleRoot = title.GetRootWidget();
    titleRoot.SetInteractive(true);
    titleRoot.RegisterToCallback(n"OnRelease", this, n"OnTitleRelease");
    titleRoot.RegisterToCallback(n"OnHoverOver", this, n"OnTitleHoverOver");
    titleRoot.RegisterToCallback(n"OnHoverOut", this, n"OnTitleHoverOut");
    return folded;
  }

  private func Mark(title: wref<SettingsCategoryController>, folded: Bool) {
    inkTextRef.SetText(title.m_label, (folded ? "[+] " : "[-] ") + title.modSettingsNavigatorTitle);
  }

  protected cb func OnTitleRelease(evt: ref<inkPointerEvent>) -> Bool {
    if !evt.IsAction(n"click") {
      return false;
    }
    let root = evt.GetCurrentTarget();
    let title = root.GetController() as SettingsCategoryController;
    let memory = ModSettingsNavigatorMemory.Get();
    // The setting switched off and applied: the page on screen keeps its marks until Mod Settings rebuilds it.
    if !IsDefined(memory) || !memory.FoldingOn() {
      return false;
    }
    if !IsDefined(title) || StrLen(title.modSettingsNavigatorKey) == 0 {
      ModSettingsNavigatorLog("fold refused reason=" + (!IsDefined(title) ? "not_a_title" : "section_without_rows"));
      return false;
    }
    let folded = memory.Choices().ToggleFold(title.modSettingsNavigatorKey);
    let rows = this.ShowSection(root, folded);
    this.Mark(title, folded);
    ModSettingsNavigatorLog("fold section=" + title.modSettingsNavigatorKey + " folded=" + ToString(folded)
      + " rows=" + ToString(rows) + " kept=" + ToString(memory.Choices().FoldedCount()));
    evt.Handle();
    return true;
  }

  // Shows or hides the rows that follow a title, up to the next title. Returns how many rows changed.
  private func ShowSection(root: wref<inkWidget>, folded: Bool) -> Int32 {
    let list = root.GetParentWidget() as inkCompoundWidget;
    if !IsDefined(list) {
      return 0;
    }
    let target: ref<inkWidget> = root;
    let count = list.GetNumChildren();
    let inside = false;
    let rows = 0;
    let i = 0;
    while i < count {
      let widget = list.GetWidgetByIndex(i);
      let isTitle = IsDefined(widget.GetController() as SettingsCategoryController);
      if inside {
        if isTitle {
          return rows;
        }
        widget.SetVisible(!folded);
        rows += 1;
      } else {
        let current: ref<inkWidget> = widget;
        inside = current == target;
      }
      i += 1;
    }
    return rows;
  }

  // Mod Settings' titles have no hover look of their own; a dimmed title shows which one the cursor is on.
  protected cb func OnTitleHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let root = evt.GetCurrentTarget();
    root.SetOpacity(0.6);
    let title = root.GetController() as SettingsCategoryController;
    if IsDefined(title) && StrLen(title.modSettingsNavigatorKey) > 0 {
      ModSettingsNavigatorPosition.OnHover(ModSettingsNavigatorPosition.TitleKey(title), root);
    }
    return false;
  }

  protected cb func OnTitleHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    evt.GetCurrentTarget().SetOpacity(1.0);
    return false;
  }
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
@wrapMethod(SettingsSelectorController)
public func Setup(entry: ref<ConfigVar>, isPreGame: Bool) -> Void {
  wrappedMethod(entry, isPreGame);
  if !ModSettingsNavigatorMenu.IsOpen() {
    return;
  }
  let memory = ModSettingsNavigatorMemory.Get();
  if IsDefined(memory) {
    memory.Sections().OnRowSetup(this, memory);
  }
}
