// Made by fabrique/grapple.py from Apex Grapple's Crosshair.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The crosshair shown with empty hands or fists (docs/apex-grapple/reticule/conception.md). It hangs in the game's
// accessibility dot (CrosshairGameControllerPersistentDot, persistent_center_dot.inkwidget): its frame fills the screen
// and shows at the centre in third person too, where the grapple lands (Kevin, 9 November 2026). The game sets that
// frame's visibility in UpdateRootVisibility, which every change of its own goes through: the mod's rule
// (CrosshairRule.reds) is applied right after it. While the crosshair shows, the frame is made visible and the game's
// dot hidden; once it hides, both go back to the game's rule. Updated on events only: right-hand weapon, vehicle,
// scene tier, scanner, the aim the game listens to, and Mod Settings (told by the grapple's system, SettingsCopy.reds);
// only the range indicator's colour follows the aim each frame (CrosshairRange.reds), and not while a menu is open.
// The game's boards are kept by weak pointers, checked before each use (optimisation.md, rule 3; A18).

public class CyberGrappleCrosshairState extends IScriptable {
  public let player: wref<GameObject>;
  public let weapons: wref<IBlackboard>;
  public let psm: wref<IBlackboard>;
  public let ui: wref<IBlackboard>;
  public let frame: wref<inkCanvas>;
  // The settings the frame was drawn with (CrosshairDraw.reds), "" before it is drawn.
  public let drawnWith: String;
  public let armed: Bool;
  public let vehicle: Int32;
  public let sceneTier: Int32;
  public let vision: Int32;
  // The last line written to the log: one line at each change of what shows (hidden and why, or the settings it is
  // drawn with), none at each event.
  public let logLine: String;
  public let weaponCallback: ref<CallbackHandle>;
  public let vehicleCallback: ref<CallbackHandle>;
  public let sceneCallback: ref<CallbackHandle>;
  public let visionCallback: ref<CallbackHandle>;
  public let menuCallback: ref<CallbackHandle>;
  // The range indicator (CrosshairRange.reds), driven by the grapple's frame through the link its system keeps.
  public let range: ref<CyberGrappleCrosshairRange>;
}

@addField(CrosshairGameControllerPersistentDot)
private let cyberGrapple: ref<CyberGrappleCrosshairState>;

@wrapMethod(CrosshairGameControllerPersistentDot)
protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
  let result: Bool = wrappedMethod(player);
  this.CyberGrappleCrosshairAttach(player);
  return result;
}

@wrapMethod(CrosshairGameControllerPersistentDot)
protected cb func OnPlayerDetach(player: ref<GameObject>) -> Bool {
  this.CyberGrappleCrosshairDetach();
  return wrappedMethod(player);
}

@wrapMethod(CrosshairGameControllerPersistentDot)
private final func UpdateRootVisibility() -> Void {
  wrappedMethod();
  this.CyberGrappleCrosshairApply();
}

@addMethod(CrosshairGameControllerPersistentDot)
private func CyberGrappleCrosshairAttach(player: ref<GameObject>) -> Void {
  this.CyberGrappleCrosshairDetach();
  let state: ref<CyberGrappleCrosshairState> = new CyberGrappleCrosshairState();
  this.cyberGrapple = state;
  state.player = player;
  // The grapple's system is made before the crosshair attaches: "loaded" comes before "crosshair host found" at each
  // load (releves/apex-grapple/2026-11-10-reticule/gamelog-reticule.log).
  state.range = new CyberGrappleCrosshairRange();
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(player.GetGame());
  if IsDefined(system) {
    system.crosshairRange = state.range;
    system.crosshairHost = this;
    state.range.system = system;
  }
  let defs: ref<AllBlackboardDefinitions> = GetAllBlackboardDefs();
  let boards: ref<BlackboardSystem> = this.GetBlackboardSystem();
  // The right hand's weapon as the game's crosshairs read it (crosshairContainerController.script, OnWeaponSwap).
  let weapons: ref<IBlackboard> = boards.Get(defs.UI_ActiveWeaponData);
  state.weapons = weapons;
  if IsDefined(weapons) {
    state.weaponCallback = weapons.RegisterListenerVariant(defs.UI_ActiveWeaponData.RightWeaponRecordID, this, n"OnCyberGrappleCrosshairWeapon");
    state.armed = CyberGrappleCrosshairIsArmed(FromVariant<TweakDBID>(weapons.GetVariant(defs.UI_ActiveWeaponData.RightWeaponRecordID)));
  }
  let psm: ref<IBlackboard> = this.GetPSMBlackboard(player);
  state.psm = psm;
  if IsDefined(psm) {
    state.vehicleCallback = psm.RegisterListenerInt(defs.PlayerStateMachine.Vehicle, this, n"OnCyberGrappleCrosshairVehicle");
    state.sceneCallback = psm.RegisterListenerInt(defs.PlayerStateMachine.SceneTier, this, n"OnCyberGrappleCrosshairSceneTier");
    state.visionCallback = psm.RegisterListenerInt(defs.PlayerStateMachine.Vision, this, n"OnCyberGrappleCrosshairVision");
    state.vehicle = psm.GetInt(defs.PlayerStateMachine.Vehicle);
    state.sceneTier = psm.GetInt(defs.PlayerStateMachine.SceneTier);
    state.vision = psm.GetInt(defs.PlayerStateMachine.Vision);
  }
  // Any menu (inventory, crafting, map...), as the game's IsPlayerInAnyMenu reads it (defaultTransition.script:1688).
  let ui: ref<IBlackboard> = boards.Get(defs.UI_System);
  state.ui = ui;
  if IsDefined(ui) {
    state.menuCallback = ui.RegisterListenerBool(defs.UI_System.IsInMenu, this, n"OnCyberGrappleCrosshairMenu");
    state.range.inMenu = ui.GetBool(defs.UI_System.IsInMenu);
  }
  let option: ref<ConfigVarBool> = this.m_settings.GetVar(this.m_groupPath, n"PersistentCenterDot") as ConfigVarBool;
  let root: wref<inkCompoundWidget> = this.GetRootWidget() as inkCompoundWidget;
  let dot: wref<inkWidget>;
  if IsDefined(root) {
    dot = root.GetWidgetByPathName(n"dot");
  }
  CyberGrappleLog("crosshair host found: the game's dot " + (IsDefined(dot) ? "found" : "not found") + ", its option " + (IsDefined(option) && option.GetValue() ? "on" : "off") + ", weapons " + ToString(IsDefined(weapons)) + ", player states " + ToString(IsDefined(psm)) + ", menus " + ToString(IsDefined(ui)) + ", range indicator linked " + ToString(IsDefined(system)));
  this.UpdateRootVisibility();
  CyberGrappleVoiceTell(system, player);
}

// Gives the frame and the game's dot back to the game's rule.
@addMethod(CrosshairGameControllerPersistentDot)
private func CyberGrappleCrosshairDetach() -> Void {
  let state: ref<CyberGrappleCrosshairState> = this.cyberGrapple;
  if !IsDefined(state) {
    return;
  }
  let defs: ref<AllBlackboardDefinitions> = GetAllBlackboardDefs();
  let weapons: ref<IBlackboard> = state.weapons;
  if IsDefined(weapons) && IsDefined(state.weaponCallback) {
    weapons.UnregisterListenerVariant(defs.UI_ActiveWeaponData.RightWeaponRecordID, state.weaponCallback);
  }
  let psm: ref<IBlackboard> = state.psm;
  if IsDefined(psm) {
    if IsDefined(state.vehicleCallback) {
      psm.UnregisterListenerInt(defs.PlayerStateMachine.Vehicle, state.vehicleCallback);
    }
    if IsDefined(state.sceneCallback) {
      psm.UnregisterListenerInt(defs.PlayerStateMachine.SceneTier, state.sceneCallback);
    }
    if IsDefined(state.visionCallback) {
      psm.UnregisterListenerInt(defs.PlayerStateMachine.Vision, state.visionCallback);
    }
  }
  let ui: ref<IBlackboard> = state.ui;
  if IsDefined(ui) && IsDefined(state.menuCallback) {
    ui.UnregisterListenerBool(defs.UI_System.IsInMenu, state.menuCallback);
  }
  CyberGrappleCrosshairRangeStop(state.range);
  this.cyberGrapple = null;
  let frame: wref<inkCanvas> = state.frame;
  if IsDefined(frame) {
    frame.SetVisible(false);
  }
  this.CyberGrappleCrosshairGameDot(true);
  this.UpdateRootVisibility();
}

@addMethod(CrosshairGameControllerPersistentDot)
private func CyberGrappleCrosshairGameDot(visible: Bool) -> Void {
  let root: wref<inkCompoundWidget> = this.GetRootWidget() as inkCompoundWidget;
  if !IsDefined(root) {
    return;
  }
  let dot: wref<inkWidget> = root.GetWidgetByPathName(n"dot");
  if IsDefined(dot) {
    dot.SetVisible(visible);
  }
}

@addMethod(CrosshairGameControllerPersistentDot)
private func CyberGrappleCrosshairApply() -> Void {
  let state: ref<CyberGrappleCrosshairState> = this.cyberGrapple;
  let root: wref<inkCompoundWidget> = this.GetRootWidget() as inkCompoundWidget;
  if !IsDefined(state) || !IsDefined(root) {
    return;
  }
  let settings: ref<CyberGrappleCrosshairSettings> = new CyberGrappleCrosshairSettings();
  let why: String = CyberGrappleCrosshairHiddenWhy(state, settings);
  if Equals(why, "") {
    let shown: ref<inkCanvas> = CyberGrappleCrosshairFrameOf(state, root);
    let wanted: String = CyberGrappleCrosshairSettingsText(settings);
    let redrawn: Bool = NotEquals(wanted, state.drawnWith);
    if redrawn {
      CyberGrappleCrosshairDraw(shown, settings);
      state.drawnWith = wanted;
    }
    CyberGrappleCrosshairRangeStart(state.range, shown, settings, redrawn);
    shown.SetVisible(true);
    root.SetVisible(true);
    this.CyberGrappleCrosshairGameDot(false);
  } else {
    CyberGrappleCrosshairRangeStop(state.range);
    let hidden: wref<inkCanvas> = state.frame;
    if IsDefined(hidden) {
      hidden.SetVisible(false);
    }
    this.CyberGrappleCrosshairGameDot(true);
  }
  let line: String = Equals(why, "") ? "crosshair shown: " + state.drawnWith : "crosshair hidden: " + why;
  if NotEquals(line, state.logLine) {
    state.logLine = line;
    CyberGrappleLog(line);
  }
}

// Our frame, made the first time it shows: centred, of no size, so that each crosshair's pieces sit around the
// centre of the screen as in the game's files.
public func CyberGrappleCrosshairFrameOf(state: ref<CyberGrappleCrosshairState>, root: wref<inkCompoundWidget>) -> ref<inkCanvas> {
  let kept: ref<inkCanvas> = state.frame;
  if IsDefined(kept) {
    return kept;
  }
  let frame: ref<inkCanvas> = new inkCanvas();
  frame.SetName(n"cyberGrappleCrosshair");
  frame.SetAnchor(inkEAnchor.Centered);
  frame.SetAnchorPoint(new Vector2(0.5, 0.5));
  frame.SetSize(new Vector2(0.0, 0.0));
  frame.SetRenderTransformPivot(new Vector2(0.5, 0.5));
  frame.Reparent(root);
  state.frame = frame;
  state.drawnWith = "";
  return frame;
}
