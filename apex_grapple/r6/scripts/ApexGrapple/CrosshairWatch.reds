// Mod Settings calls OnModSettingsChange on its listeners when the player applies a change (its readme.md, 0.2.29):
// the crosshair is drawn again then, rather than its settings read every frame. Without Mod Settings the settings
// never change in game, and nothing is listened to.

public class ApexGrappleCrosshairWatch extends IScriptable {
  public let host: wref<CrosshairGameControllerPersistentDot>;

  public cb func OnModSettingsChange() -> Void {
    let host: ref<CrosshairGameControllerPersistentDot> = this.host;
    if IsDefined(host) {
      host.ApexGrappleCrosshairRefresh();
    }
  }
}

@if(ModuleExists("ModSettingsModule"))
public func ApexGrappleCrosshairWatchStart(watch: ref<ApexGrappleCrosshairWatch>) -> Void {
  ModSettings.RegisterListenerToModifications(watch);
}

@if(ModuleExists("ModSettingsModule"))
public func ApexGrappleCrosshairWatchStop(watch: ref<ApexGrappleCrosshairWatch>) -> Void {
  if IsDefined(watch) {
    ModSettings.UnregisterListenerToModifications(watch);
  }
}

@if(!ModuleExists("ModSettingsModule"))
public func ApexGrappleCrosshairWatchStart(watch: ref<ApexGrappleCrosshairWatch>) -> Void {}

@if(!ModuleExists("ModSettingsModule"))
public func ApexGrappleCrosshairWatchStop(watch: ref<ApexGrappleCrosshairWatch>) -> Void {}
