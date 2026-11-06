// The game strikes its quick melee on the release of a short press. When that press is the grapple's, the release must
// not strike too: the mod answers no while it holds the quick melee back (ApexGrappleTakeKey sets the time, and
// ApexGrappleEndHoldBack shortens it at the release, both in Key.reds; for a button the scanner shares, the time is set
// at the press, ApexGrappleSharedPress in Shot.reds). The game's quick melee goes two ways (scripts 2.5): with a gun,
// three decisions ask CanQuickMelee (QuickMeleeDecisions, NoAmmoDecisions, ReloadDecisions); with fists or a melee
// weapon, every decision reads the tap through QuickMeleeTapped. Only the first decision was held back until 30
// October 2026: with fists, the punch struck with a grapple fired at a tap's release (Kevin).

public func ApexGrappleHoldsQuickMelee(game: GameInstance) -> Bool {
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(game);
  if IsDefined(system) && ApexGrappleTime(game) < system.holdBackUntil {
    ApexGrappleLog("quick melee held back: its press is the grapple's");
    return true;
  }
  return false;
}

@wrapMethod(WeaponTransition)
protected final const func CanQuickMelee(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !wrappedMethod(stateContext, scriptInterface) {
    return false;
  }
  return !ApexGrappleHoldsQuickMelee(scriptInterface.executionOwner.GetGame());
}

// Asked by several melee decisions each frame: the hold-back is read only on the frame of a tap.
@wrapMethod(MeleeTransition)
protected final static func QuickMeleeTapped(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if !wrappedMethod(scriptInterface) {
    return false;
  }
  return !ApexGrappleHoldsQuickMelee(scriptInterface.executionOwner.GetGame());
}
