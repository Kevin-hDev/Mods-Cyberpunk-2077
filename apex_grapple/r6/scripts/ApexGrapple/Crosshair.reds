// The crosshair shown with empty hands or fists (docs/apex-grapple/reticule/conception.md). It hangs in the game's
// accessibility dot (CrosshairGameControllerPersistentDot, persistent_center_dot.inkwidget): its frame fills the screen
// and shows at the centre in third person too, where the grapple lands (Kevin, 9 November 2026). The game sets that
// frame's visibility in UpdateRootVisibility, which every change of its own goes through: the mod's rule
// (CrosshairRule.reds) is applied right after it. While the crosshair shows, the frame is made visible and the game's
// dot hidden; once it hides, both go back to the game's rule. Updated on events only: right-hand weapon, vehicle,
// scene tier, scanner, the aim the game listens to, and Mod Settings (CrosshairWatch.reds).

public class ApexGrappleCrosshairState extends IScriptable {
  public let player: wref<GameObject>;
  public let weapons: ref<IBlackboard>;
  public let psm: ref<IBlackboard>;
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
  public let watch: ref<ApexGrappleCrosshairWatch>;
}

@addField(CrosshairGameControllerPersistentDot)
private let apexGrapple: ref<ApexGrappleCrosshairState>;

@wrapMethod(CrosshairGameControllerPersistentDot)
protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
  let result: Bool = wrappedMethod(player);
  this.ApexGrappleCrosshairAttach(player);
  return result;
}

@wrapMethod(CrosshairGameControllerPersistentDot)
protected cb func OnPlayerDetach(player: ref<GameObject>) -> Bool {
  this.ApexGrappleCrosshairDetach();
  return wrappedMethod(player);
}

@wrapMethod(CrosshairGameControllerPersistentDot)
private final func UpdateRootVisibility() -> Void {
  wrappedMethod();
  this.ApexGrappleCrosshairApply();
}

@addMethod(CrosshairGameControllerPersistentDot)
private func ApexGrappleCrosshairAttach(player: ref<GameObject>) -> Void {
  this.ApexGrappleCrosshairDetach();
  let state: ref<ApexGrappleCrosshairState> = new ApexGrappleCrosshairState();
  this.apexGrapple = state;
  state.player = player;
  let defs: ref<AllBlackboardDefinitions> = GetAllBlackboardDefs();
  let boards: ref<BlackboardSystem> = this.GetBlackboardSystem();
  // The right hand's weapon as the game's crosshairs read it (crosshairContainerController.script, OnWeaponSwap).
  state.weapons = boards.Get(defs.UI_ActiveWeaponData);
  if IsDefined(state.weapons) {
    state.weaponCallback = state.weapons.RegisterListenerVariant(defs.UI_ActiveWeaponData.RightWeaponRecordID, this, n"OnApexGrappleCrosshairWeapon");
    state.armed = ApexGrappleCrosshairIsArmed(FromVariant<TweakDBID>(state.weapons.GetVariant(defs.UI_ActiveWeaponData.RightWeaponRecordID)));
  }
  state.psm = this.GetPSMBlackboard(player);
  if IsDefined(state.psm) {
    state.vehicleCallback = state.psm.RegisterListenerInt(defs.PlayerStateMachine.Vehicle, this, n"OnApexGrappleCrosshairVehicle");
    state.sceneCallback = state.psm.RegisterListenerInt(defs.PlayerStateMachine.SceneTier, this, n"OnApexGrappleCrosshairSceneTier");
    state.visionCallback = state.psm.RegisterListenerInt(defs.PlayerStateMachine.Vision, this, n"OnApexGrappleCrosshairVision");
    state.vehicle = state.psm.GetInt(defs.PlayerStateMachine.Vehicle);
    state.sceneTier = state.psm.GetInt(defs.PlayerStateMachine.SceneTier);
    state.vision = state.psm.GetInt(defs.PlayerStateMachine.Vision);
  }
  state.watch = new ApexGrappleCrosshairWatch();
  state.watch.host = this;
  ApexGrappleCrosshairWatchStart(state.watch);
  let option: ref<ConfigVarBool> = this.m_settings.GetVar(this.m_groupPath, n"PersistentCenterDot") as ConfigVarBool;
  let root: wref<inkCompoundWidget> = this.GetRootWidget() as inkCompoundWidget;
  let dot: wref<inkWidget>;
  if IsDefined(root) {
    dot = root.GetWidgetByPathName(n"dot");
  }
  ApexGrappleLog("crosshair host found: the game's dot " + (IsDefined(dot) ? "found" : "not found") + ", its option " + (IsDefined(option) && option.GetValue() ? "on" : "off") + ", weapons " + ToString(IsDefined(state.weapons)) + ", player states " + ToString(IsDefined(state.psm)));
  this.UpdateRootVisibility();
}

// Gives the frame and the game's dot back to the game's rule.
@addMethod(CrosshairGameControllerPersistentDot)
private func ApexGrappleCrosshairDetach() -> Void {
  let state: ref<ApexGrappleCrosshairState> = this.apexGrapple;
  if !IsDefined(state) {
    return;
  }
  let defs: ref<AllBlackboardDefinitions> = GetAllBlackboardDefs();
  if IsDefined(state.weapons) && IsDefined(state.weaponCallback) {
    state.weapons.UnregisterListenerVariant(defs.UI_ActiveWeaponData.RightWeaponRecordID, state.weaponCallback);
  }
  if IsDefined(state.psm) {
    if IsDefined(state.vehicleCallback) {
      state.psm.UnregisterListenerInt(defs.PlayerStateMachine.Vehicle, state.vehicleCallback);
    }
    if IsDefined(state.sceneCallback) {
      state.psm.UnregisterListenerInt(defs.PlayerStateMachine.SceneTier, state.sceneCallback);
    }
    if IsDefined(state.visionCallback) {
      state.psm.UnregisterListenerInt(defs.PlayerStateMachine.Vision, state.visionCallback);
    }
  }
  ApexGrappleCrosshairWatchStop(state.watch);
  this.apexGrapple = null;
  let frame: wref<inkCanvas> = state.frame;
  if IsDefined(frame) {
    frame.SetVisible(false);
  }
  this.ApexGrappleCrosshairGameDot(true);
  this.UpdateRootVisibility();
}

@addMethod(CrosshairGameControllerPersistentDot)
private func ApexGrappleCrosshairGameDot(visible: Bool) -> Void {
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
private func ApexGrappleCrosshairApply() -> Void {
  let state: ref<ApexGrappleCrosshairState> = this.apexGrapple;
  let root: wref<inkCompoundWidget> = this.GetRootWidget() as inkCompoundWidget;
  if !IsDefined(state) || !IsDefined(root) {
    return;
  }
  let settings: ref<ApexGrappleCrosshairSettings> = new ApexGrappleCrosshairSettings();
  let why: String = ApexGrappleCrosshairHiddenWhy(state, settings);
  if Equals(why, "") {
    let shown: ref<inkCanvas> = ApexGrappleCrosshairFrameOf(state, root);
    let wanted: String = ApexGrappleCrosshairSettingsText(settings);
    if NotEquals(wanted, state.drawnWith) {
      ApexGrappleCrosshairDraw(shown, settings);
      state.drawnWith = wanted;
    }
    shown.SetVisible(true);
    root.SetVisible(true);
    this.ApexGrappleCrosshairGameDot(false);
  } else {
    let hidden: wref<inkCanvas> = state.frame;
    if IsDefined(hidden) {
      hidden.SetVisible(false);
    }
    this.ApexGrappleCrosshairGameDot(true);
  }
  let line: String = Equals(why, "") ? "crosshair shown: " + state.drawnWith : "crosshair hidden: " + why;
  if NotEquals(line, state.logLine) {
    state.logLine = line;
    ApexGrappleLog(line);
  }
}

// Our frame, made the first time it shows: centred, of no size, so that each crosshair's pieces sit around the
// centre of the screen as in the game's files.
public func ApexGrappleCrosshairFrameOf(state: ref<ApexGrappleCrosshairState>, root: wref<inkCompoundWidget>) -> ref<inkCanvas> {
  let kept: ref<inkCanvas> = state.frame;
  if IsDefined(kept) {
    return kept;
  }
  let frame: ref<inkCanvas> = new inkCanvas();
  frame.SetName(n"apexGrappleCrosshair");
  frame.SetAnchor(inkEAnchor.Centered);
  frame.SetAnchorPoint(new Vector2(0.5, 0.5));
  frame.SetSize(new Vector2(0.0, 0.0));
  frame.SetRenderTransformPivot(new Vector2(0.5, 0.5));
  frame.Reparent(root);
  state.frame = frame;
  state.drawnWith = "";
  return frame;
}
