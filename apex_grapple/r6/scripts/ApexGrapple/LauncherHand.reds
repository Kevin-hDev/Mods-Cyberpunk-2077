// V's own left hand hidden while the launcher is lent (Launcher.reds): the holstered arms add their pieces to V and the
// launcher adds its own arm, hand lowered, so both hands showed (capture 69, 31 October 2026). The holstered arms'
// left-arm pieces are switched off, found by the rendering plane the game draws V's left arm with, and switched back on
// when the launcher is taken back.
// The plane alone finds them, whatever the arm implant (lists of 1 November): bare hands, Monowire, Mantis Blades,
// Gorilla Arms, the launcher's holstered pieces, the personal link; none of the lent launcher's pieces is drawn on that
// plane. Holstered arms put away with a drawn arm implant come back during the loan, half a second after the shot: the
// pieces are looked for again each frame.

// Without Codeware V's hand cannot be hidden, and the rope is not drawn (Pieces.reds): the launcher would show over V's
// own hand for nothing, so it is not lent (Launcher.reds).
@if(ModuleExists("Codeware"))
public func ApexGrappleLauncherCanShow() -> Bool {
  return true;
}

@if(!ModuleExists("Codeware"))
public func ApexGrappleLauncherCanShow() -> Bool {
  return false;
}

@if(ModuleExists("Codeware"))
public func ApexGrappleLauncherIsOwnLeftArm(component: ref<IComponent>) -> Bool {
  let skinned: ref<entSkinnedMeshComponent> = component as entSkinnedMeshComponent;
  return IsDefined(skinned) && Equals(skinned.renderingPlaneAnimationParam, n"renderPlaneLeftArm");
}

// `first`: as the launcher comes into the hand, written even when nothing is found; afterwards only what came back.
// The plane is read before asking the engine whether the piece is on: a field against a call for each of V's pieces,
// of which two or three are on that plane (audit of 10 November 2026, A4). A piece that comes back is switched off
// again but listed once (A17).
@if(ModuleExists("Codeware"))
public func ApexGrappleLauncherHideHand(loan: ref<ApexGrappleLauncherLoan>, first: Bool, now: Float, player: ref<GameObject>) -> Void {
  let found: array<wref<IComponent>>;
  let names: String = "";
  let components: array<ref<IComponent>> = player.GetComponents();
  for component in components {
    if ApexGrappleLauncherIsOwnLeftArm(component) && component.IsEnabled() {
      ArrayPush(found, component);
      names += " " + NameToString(component.GetName());
    }
  }
  if ArraySize(found) == 0 && !first {
    return;
  }
  ApexGrappleLog((first ? "launcher in the left hand " + ToString(now - loan.shotAt) + " s after the shot, " : "") + ToString(ArraySize(found)) + " pieces of V's own left arm switched off" + (first ? "" : ", come back during the loan") + ":" + names);
  for held in found {
    let component: ref<IComponent> = held;
    if IsDefined(component) {
      component.Toggle(false);
      if !ArrayContains(loan.hiddenHand, held) {
        ArrayPush(loan.hiddenHand, held);
      }
    }
  }
}

@if(!ModuleExists("Codeware"))
public func ApexGrappleLauncherHideHand(loan: ref<ApexGrappleLauncherLoan>, first: Bool, now: Float, player: ref<GameObject>) -> Void {}

// How many pieces were switched back on.
public func ApexGrappleLauncherShowHand(loan: ref<ApexGrappleLauncherLoan>) -> Int32 {
  let back: Int32 = 0;
  for held in loan.hiddenHand {
    let component: ref<IComponent> = held;
    if IsDefined(component) {
      component.Toggle(true);
      back += 1;
    }
  }
  ArrayClear(loan.hiddenHand);
  return back;
}
