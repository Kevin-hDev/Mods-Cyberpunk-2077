// Made by fabrique/grapple.py from Apex Grapple's CrosshairEvents.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// What makes the crosshair look again (Crosshair.reds): the game's boards it listens to, and Mod Settings (through
// the grapple's system, SettingsCopy.reds). Each keeps the new value and goes through the game's UpdateRootVisibility,
// where the mod's rule is applied: the crosshair has one place where it is shown or hidden. A menu only pauses the
// range indicator: what shows does not change, and the colour is judged again at the first frame after it.

@addMethod(CrosshairGameControllerPersistentDot)
public func CyberGrappleCrosshairRefresh() -> Void {
  this.UpdateRootVisibility();
}

@addMethod(CrosshairGameControllerPersistentDot)
protected cb func OnCyberGrappleCrosshairMenu(value: Bool) -> Bool {
  if IsDefined(this.cyberGrapple) {
    this.cyberGrapple.range.inMenu = value;
  }
  return true;
}

@addMethod(CrosshairGameControllerPersistentDot)
protected cb func OnCyberGrappleCrosshairWeapon(value: Variant) -> Bool {
  if IsDefined(this.cyberGrapple) {
    this.cyberGrapple.armed = CyberGrappleCrosshairIsArmed(FromVariant<TweakDBID>(value));
    this.UpdateRootVisibility();
  }
  return true;
}

@addMethod(CrosshairGameControllerPersistentDot)
protected cb func OnCyberGrappleCrosshairVehicle(value: Int32) -> Bool {
  if IsDefined(this.cyberGrapple) {
    this.cyberGrapple.vehicle = value;
    this.UpdateRootVisibility();
  }
  return true;
}

@addMethod(CrosshairGameControllerPersistentDot)
protected cb func OnCyberGrappleCrosshairSceneTier(value: Int32) -> Bool {
  if IsDefined(this.cyberGrapple) {
    this.cyberGrapple.sceneTier = value;
    this.UpdateRootVisibility();
  }
  return true;
}

@addMethod(CrosshairGameControllerPersistentDot)
protected cb func OnCyberGrappleCrosshairVision(value: Int32) -> Bool {
  if IsDefined(this.cyberGrapple) {
    this.cyberGrapple.vision = value;
    this.UpdateRootVisibility();
  }
  return true;
}
