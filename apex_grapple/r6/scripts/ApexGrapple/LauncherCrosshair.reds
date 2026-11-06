// The lent launcher (Launcher.reds) brings its crosshair, which the grapple has no use for. Its controller is made at
// load, so hidden at its attach it showed all the same during a grapple (third test, 31 October 2026): it is kept from
// its attach and from its intro, which plays as a launcher comes into V's hand, hidden every frame of the loan, and
// put back as it was when the launcher is taken back.

public func ApexGrappleLauncherCrosshairKeep(controller: ref<inkGameController>, owner: ref<GameObject>) -> Void {
  if !IsDefined(owner) {
    return;
  }
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(owner.GetGame());
  if IsDefined(system) {
    ApexGrappleLoanOf(system).crosshair = controller;
  }
}

public func ApexGrappleLauncherCrosshairHide(loan: ref<ApexGrappleLauncherLoan>) -> Void {
  let root: wref<inkWidget>;
  if IsDefined(loan.crosshair) {
    root = loan.crosshair.GetRootWidget();
  }
  if !IsDefined(root) {
    if !loan.noCrosshairSaid {
      loan.noCrosshairSaid = true;
      ApexGrappleLog("the launcher's crosshair was not found: it may show during the grapple");
    }
    return;
  }
  if !loan.crosshairHidden {
    loan.crosshairHidden = true;
    loan.crosshairWasVisible = root.IsVisible();
  }
  root.SetVisible(false);
}

public func ApexGrappleLauncherCrosshairRestore(loan: ref<ApexGrappleLauncherLoan>) -> Void {
  if loan.crosshairHidden && IsDefined(loan.crosshair) {
    let root: wref<inkWidget> = loan.crosshair.GetRootWidget();
    if IsDefined(root) {
      root.SetVisible(loan.crosshairWasVisible);
    }
  }
  loan.crosshairHidden = false;
}

@wrapMethod(CrosshairGameController_Launcher)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  let result: Bool = wrappedMethod(playerPuppet);
  ApexGrappleLauncherCrosshairKeep(this, playerPuppet);
  return result;
}

@wrapMethod(CrosshairGameController_Launcher)
public func GetIntroAnimation(firstEquip: Bool) -> ref<inkAnimProxy> {
  let result: ref<inkAnimProxy> = wrappedMethod(firstEquip);
  ApexGrappleLauncherCrosshairKeep(this, this.GetPlayerControlledObject());
  return result;
}
