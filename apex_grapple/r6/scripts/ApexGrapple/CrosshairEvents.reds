// What makes the crosshair look again (Crosshair.reds): the game's boards it listens to, and Mod Settings
// (CrosshairWatch.reds). Each keeps the new value and goes through the game's UpdateRootVisibility, where the
// mod's rule is applied: the crosshair has one place where it is shown or hidden.

@addMethod(CrosshairGameControllerPersistentDot)
public func ApexGrappleCrosshairRefresh() -> Void {
  this.UpdateRootVisibility();
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
