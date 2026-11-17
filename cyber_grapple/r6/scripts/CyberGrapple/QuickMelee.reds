// Made by fabrique/grapple.py from Apex Grapple's QuickMelee.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The game strikes its quick melee on the release of a short press. When that press is the grapple's, the release must
// not strike too: the mod answers no while it holds the quick melee back (CyberGrappleTakeKey sets the time, and
// CyberGrappleEndHoldBack shortens it at the release, both in Key.reds; for a button the scanner shares, the time is set
// at the press, CyberGrappleSharedPress in Shot.reds). The game's quick melee goes two ways (scripts 2.5): with a gun,
// three decisions ask CanQuickMelee (QuickMeleeDecisions, NoAmmoDecisions, ReloadDecisions); with fists or a melee
// weapon, every decision reads the tap through QuickMeleeTapped. Only the first decision was held back until 30
// October 2026: with fists, the punch struck with a grapple fired at a tap's release (Kevin).

public func CyberGrappleHoldsQuickMelee(game: GameInstance) -> Bool {
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(game);
  if IsDefined(system) && CyberGrappleTime(game) < system.holdBackUntil {
    // One line a hold-back, where two were written at each press until the audit of 10 November 2026 (A9).
    if system.holdBackSaid != system.holdBacks {
      system.holdBackSaid = system.holdBacks;
      CyberGrappleLog("quick melee held back: its press is the grapple's");
    }
    return true;
  }
  return false;
}

@wrapMethod(WeaponTransition)
protected final const func CanQuickMelee(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !wrappedMethod(stateContext, scriptInterface) {
    return false;
  }
  return !CyberGrappleHoldsQuickMelee(scriptInterface.executionOwner.GetGame());
}

// Asked by several melee decisions each frame: the hold-back is read only on the frame of a tap.
@wrapMethod(MeleeTransition)
protected final static func QuickMeleeTapped(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !wrappedMethod(scriptInterface) {
    return false;
  }
  return !CyberGrappleHoldsQuickMelee(scriptInterface.executionOwner.GetGame());
}
