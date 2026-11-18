// What makes the crosshair look again (Crosshair.reds): the game's boards it listens to, and Mod Settings (through
// the grapple's system, SettingsCopy.reds). Each keeps the new value and goes through the game's UpdateRootVisibility,
// where the mod's rule is applied: the crosshair has one place where it is shown or hidden. A menu pauses the range
// indicator, whose colour is judged again at the first frame after it, and lets go of the aim key (CrosshairAim.reds,
// decision 5); nothing else of what shows changes.

@addMethod(CrosshairGameControllerPersistentDot)
public func ApexGrappleCrosshairRefresh() -> Void {
  this.UpdateRootVisibility();
}

@addMethod(CrosshairGameControllerPersistentDot)
protected cb func OnApexGrappleCrosshairMenu(value: Bool) -> Bool {
  let state: ref<ApexGrappleCrosshairState> = this.apexGrapple;
  if IsDefined(state) {
    state.range.inMenu = value;
    if value && ApexGrappleCrosshairAimHeld(state) {
      ApexGrappleCrosshairAimLetGo(state);
      this.UpdateRootVisibility();
    }
  }
  return true;
}

@addMethod(CrosshairGameControllerPersistentDot)
protected cb func OnApexGrappleCrosshairWeapon(value: Variant) -> Bool {
  let state: ref<ApexGrappleCrosshairState> = this.apexGrapple;
  if IsDefined(state) {
    state.armed = ApexGrappleCrosshairIsArmed(FromVariant<TweakDBID>(value));
    state.armedByLoan = state.armed && ApexGrappleCrosshairLoanOut(state);
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
