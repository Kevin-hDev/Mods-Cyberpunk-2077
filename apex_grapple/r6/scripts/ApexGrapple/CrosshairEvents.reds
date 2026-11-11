// What makes the crosshair look again (Crosshair.reds): the game's boards it listens to, and Mod Settings (through
// the grapple's system, SettingsCopy.reds). Each keeps the new value and goes through the game's UpdateRootVisibility,
// where the mod's rule is applied: the crosshair has one place where it is shown or hidden. A menu only pauses the
// range indicator: what shows does not change, and the colour is judged again at the first frame after it.

@addMethod(CrosshairGameControllerPersistentDot)
public func ApexGrappleCrosshairRefresh() -> Void {
  this.UpdateRootVisibility();
}

@addMethod(CrosshairGameControllerPersistentDot)
protected cb func OnApexGrappleCrosshairMenu(value: Bool) -> Bool {
  if IsDefined(this.apexGrapple) {
    this.apexGrapple.range.inMenu = value;
  }
  return true;
}

@addMethod(CrosshairGameControllerPersistentDot)
protected cb func OnApexGrappleCrosshairWeapon(value: Variant) -> Bool {
  if IsDefined(this.apexGrapple) {
    this.apexGrapple.armed = ApexGrappleCrosshairIsArmed(FromVariant<TweakDBID>(value));
    this.UpdateRootVisibility();
  }
  return true;
}

@addMethod(CrosshairGameControllerPersistentDot)
protected cb func OnApexGrappleCrosshairVehicle(value: Int32) -> Bool {
  if IsDefined(this.apexGrapple) {
    this.apexGrapple.vehicle = value;
    this.UpdateRootVisibility();
  }
  return true;
}

@addMethod(CrosshairGameControllerPersistentDot)
protected cb func OnApexGrappleCrosshairSceneTier(value: Int32) -> Bool {
  if IsDefined(this.apexGrapple) {
    this.apexGrapple.sceneTier = value;
    this.UpdateRootVisibility();
  }
  return true;
}

@addMethod(CrosshairGameControllerPersistentDot)
protected cb func OnApexGrappleCrosshairVision(value: Int32) -> Bool {
  if IsDefined(this.apexGrapple) {
    this.apexGrapple.vision = value;
    this.UpdateRootVisibility();
  }
  return true;
}
