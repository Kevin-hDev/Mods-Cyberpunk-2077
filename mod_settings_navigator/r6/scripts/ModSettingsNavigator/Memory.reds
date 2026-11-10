// What the mod remembers between two openings of Mod Settings. A Codeware service lives as long as the game runs;
// the menu's own controller dies each time the menu closes.
// Folded sections are kept until the game closes. The place in the menu is forgotten when a save is loaded and when
// the player goes back to the main menu (Kevin, 10 November 2026: only "quand on ouvre/ferme/re ouvre le menu").

// A player folds one section at a time, so 256 is far above real use; past it the oldest fold is forgotten.
public func ModSettingsNavigatorMaxFolds() -> Int32 {
  return 256;
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware"))
public class ModSettingsNavigatorMemory extends ScriptableService {
  private let folded: array<String>;
  // The place the player is at now, saved as they move.
  private let hasPosition: Bool;
  private let positionMod: String;
  private let positionScroll: Float;
  private let positionRow: String;
  // The place to go back to, copied when the menu opens: saving the new place goes on while it is restored.
  // Essai 1: a flag that stopped saving during the restore stayed set when the restore did not run.
  private let targetMod: String;
  private let targetScroll: Float;
  private let targetRow: String;
  // A restore was asked for and has not run yet.
  private let restorePending: Bool;
  // The Mod Settings menu last seen building a page: a different one means the menu was opened again.
  private let menu: wref<ModStngsMainGameController>;
  // A page started while its menu could not be found yet.
  private let menuPending: Bool;
  // The mod's two settings, read once per page built: Mod Settings rebuilds the page when a change is applied, so a
  // change takes effect there. Reading them for each row and each hover cost an object each time (audit, essai 5).
  private let foldingOn: Bool;
  private let rememberOn: Bool;
  // Kept here so that the targets of the title and arrow callbacks live as long as the pages do.
  private let sections: ref<ModSettingsNavigatorSections>;
  private let arrows: ref<ModSettingsNavigatorArrows>;

  public static func Get() -> ref<ModSettingsNavigatorMemory> {
    let container = GameInstance.GetScriptableServiceContainer();
    return container.GetService(n"ModSettingsNavigatorMemory") as ModSettingsNavigatorMemory;
  }

  private cb func OnLoad() {
    GameInstance.GetCallbackSystem().RegisterCallback(n"Session/Start", this, n"OnSessionChange");
    GameInstance.GetCallbackSystem().RegisterCallback(n"Session/End", this, n"OnSessionChange");
  }

  private cb func OnSessionChange(event: ref<GameSessionEvent>) {
    if this.hasPosition {
      ModSettingsNavigatorLog("position forgotten reason=session_change");
    }
    this.hasPosition = false;
  }

  public func Arrows() -> ref<ModSettingsNavigatorArrows> {
    if !IsDefined(this.arrows) {
      this.arrows = new ModSettingsNavigatorArrows();
    }
    return this.arrows;
  }

  public func Sections() -> ref<ModSettingsNavigatorSections> {
    if !IsDefined(this.sections) {
      this.sections = new ModSettingsNavigatorSections();
    }
    return this.sections;
  }

  public func ReadSettings() {
    let settings = new ModSettingsNavigatorSettings();
    this.foldingOn = settings.collapsibleSections;
    this.rememberOn = settings.rememberPosition;
  }

  public func FoldingOn() -> Bool {
    return this.foldingOn;
  }

  public func RememberOn() -> Bool {
    return this.rememberOn;
  }

  public func IsFolded(key: String) -> Bool {
    for known in this.folded {
      if Equals(known, key) {
        return true;
      }
    }
    return false;
  }

  // Returns the new state: true when the section is now folded.
  public func Toggle(key: String) -> Bool {
    let i = 0;
    while i < ArraySize(this.folded) {
      if Equals(this.folded[i], key) {
        ArrayErase(this.folded, i);
        return false;
      }
      i += 1;
    }
    if ArraySize(this.folded) >= ModSettingsNavigatorMaxFolds() {
      ArrayErase(this.folded, 0);
    }
    ArrayPush(this.folded, key);
    return true;
  }

  public func FoldedCount() -> Int32 {
    return ArraySize(this.folded);
  }

  public func Menu() -> wref<ModStngsMainGameController> {
    return this.menu;
  }

  public func IsMenuPending() -> Bool {
    return this.menuPending;
  }

  public func SetMenuPending(pending: Bool) {
    this.menuPending = pending;
  }

  public func IsRestorePending() -> Bool {
    return this.restorePending;
  }

  public func SetRestorePending(pending: Bool) {
    this.restorePending = pending;
  }

  public func PositionMod() -> String {
    return this.positionMod;
  }

  public func PositionRow() -> String {
    return this.hasPosition ? this.positionRow : "";
  }

  // Returns true when this menu was not the one seen before: Mod Settings has just been opened.
  public func SeeMenu(menu: wref<ModStngsMainGameController>) -> Bool {
    let known: ref<ModStngsMainGameController> = this.menu;
    let seen: ref<ModStngsMainGameController> = menu;
    if known == seen {
      return false;
    }
    this.menu = menu;
    return true;
  }

  // Logged only when the mod changes: a line for each row the cursor went over made two thirds of the log, up to 42
  // lines a second (essai 5).
  public func SavePosition(mod: String, scroll: Float, row: String) {
    if !this.hasPosition || !Equals(mod, this.positionMod) {
      ModSettingsNavigatorLog("position mod=" + mod);
    }
    this.hasPosition = true;
    this.positionMod = mod;
    this.positionScroll = scroll;
    this.positionRow = row;
  }

  // The player switched "remember where I was" off: nothing is kept, so switching it back on does not restore an old
  // place.
  public func ForgetPosition() {
    this.hasPosition = false;
  }

  // Copies the saved place as the one to go back to. Returns false when there is none.
  public func TakeTarget() -> Bool {
    if !this.hasPosition {
      return false;
    }
    this.targetMod = this.positionMod;
    this.targetScroll = this.positionScroll;
    this.targetRow = this.positionRow;
    return true;
  }

  public func TargetMod() -> String {
    return this.targetMod;
  }

  public func TargetScroll() -> Float {
    return this.targetScroll;
  }

  public func TargetRow() -> String {
    return this.targetRow;
  }
}
