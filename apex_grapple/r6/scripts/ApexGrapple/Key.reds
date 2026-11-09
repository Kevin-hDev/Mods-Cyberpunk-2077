// What the grapple key does this frame: the game's quick melee action (QuickMelee), or the player's own key. A press
// made while the scanner is in use stays the game's, and a button the scanner shares grapples on a tap only. Keeps the
// press and release times on the system: a pull's end needs the length of the last press (a tap pulls all the way),
// and the quick melee is held back until just after the release.

public struct ApexGrappleKey {
  let pressed: Bool;
  let held: Bool;
  // Hold to grapple, for the device used last.
  let holdMode: Bool;
  // The press of a quick melee button the scanner shares: what a tap would do is decided now (Shot.reds).
  let sharedPress: Bool;
  // This press is a tap of that button, seen at its release.
  let sharedTap: Bool;
}

// After the release of a press that fired the grapple, the quick melee stays held back this long: the game's decision
// may read the release a frame later (QuickMelee.reds).
public func ApexGrappleQuickMeleeMargin() -> Float {
  return 0.3;
}

// Longer than any press: the hold-back lasts until the release brings it down to the margin.
public func ApexGrappleUntilRelease() -> Float {
  return 1000.0;
}

// The press belongs to the grapple (a shot, or a second press that calls it off, as in Borderlands 4): the game's
// quick melee must not strike at its release. Held back until the release, or for the margin when the press is
// already over (a tap seen at its release). An own key that is not the quick melee button has nothing to hold back.
public func ApexGrappleTakeKey(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, now: Float) -> Void {
  if system.keyIsQuickMelee {
    system.holdBackUntil = now + (system.keyDown ? ApexGrappleUntilRelease() : ApexGrappleQuickMeleeMargin());
  }
}

// An own key on the scanner's button grapples on a press shorter than this: the scanner's button came 0.297 s into a
// hold of L1 and the scanner opened at 0.316 s (probe of 30 October 2026, Alternative scheme).
public func ApexGrappleTapLongest() -> Float {
  return 0.3;
}

public func ApexGrappleEndHoldBack(system: ref<ApexGrappleSystem>, now: Float) -> Void {
  if system.holdBackUntil > now + ApexGrappleQuickMeleeMargin() {
    system.holdBackUntil = now + ApexGrappleQuickMeleeMargin();
  }
}

// The quick melee button is the scanner's too: L1 on a controller in the Alternative and Switch Legacy schemes, where
// the game skips the scanner's pulse on a press of it (hudManager.script, scripts 2.5). There the game tells a tap
// (quick melee) from a hold (scanner) only at the release: the scanner's button comes 0.3 s into a hold, nothing marks
// the press (probe of 30 October 2026, Alternative scheme, controller).
public func ApexGrappleScannerShares(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  return !scriptInterface.executionOwner.PlayerLastUsedKBM() && ApexGrappleSchemeSharesL1(scriptInterface.GetGame());
}

// Why a press now belongs to the scanner; empty when it does not: the scanner's own button held (Tab, or L1 where it
// is the scanner's alone), or the scanner open. The game makes the same test before drawing a grenade
// (combatGadgetTransitions, scripts 2.5).
@addMethod(LocomotionEventsTransition)
private final func ApexGrappleScannerInUse(scriptInterface: ref<StateGameScriptInterface>) -> String {
  if scriptInterface.GetActionValue(n"VisionHold") > 0.0 {
    return "the scanner's button is held";
  }
  if this.IsInFocusMode(scriptInterface) {
    return "the scanner is open";
  }
  return "";
}

// A press made with a menu open (inventory, crafting, map...) belongs to the menu. The player's states go on running
// there: the game's own equipment and gadget decisions refuse in any menu (IsPlayerInAnyMenu, equipment.script:565,
// combatGadgetTransitions.script:286, scripts 2.5). Without this test, a player holding an own key on E to craft the
// most of an item fired the grapple behind the crafting screen (report of 9 November 2026). The press is used up: the
// key, still down once the menu is closed, needs a new press.
@addMethod(LocomotionEventsTransition)
private final func ApexGrappleMenuTakes(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if this.IsPlayerInAnyMenu(scriptInterface) {
    ApexGrappleLog("press left to the game: a menu is open");
    return true;
  }
  return false;
}

// A method of the locomotion states, for the game's IsInFocusMode. states: the own keys' places this frame.
@addMethod(LocomotionEventsTransition)
private final func ApexGrappleReadKey(scriptInterface: ref<StateGameScriptInterface>, system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, states: array<ApexGrappleOwnKey>, now: Float) -> ApexGrappleKey {
  let key: ApexGrappleKey;
  let game: GameInstance = scriptInterface.GetGame();
  let shared: Bool;
  if settings.ownKey {
    // The place of the profile whose key is read (KeyProfile.reds).
    let slot: Int32 = system.keyProfile - 1;
    let own: ApexGrappleOwnKey = states[slot];
    // The own key is heard in menus too (ApexGrappleMenuTakes).
    key.pressed = own.presses != system.ownPressesSeen[slot] && own.held;
    system.ownPressesSeen[slot] = own.presses;
    key.held = own.held;
    if key.pressed && this.ApexGrappleMenuTakes(scriptInterface) {
      key.pressed = false;
    }
    if key.pressed {
      system.keyIsQuickMelee = ApexGrappleKeyStrikesQuickMelee(game, settings.key);
      shared = ApexGrappleKeyOpensScanner(game, settings.key);
    }
  } else {
    key.pressed = scriptInterface.IsActionJustPressed(n"QuickMelee");
    key.held = key.pressed || scriptInterface.GetActionValue(n"QuickMelee") > 0.0;
    if key.pressed && this.ApexGrappleMenuTakes(scriptInterface) {
      key.pressed = false;
    }
    if key.pressed {
      system.keyIsQuickMelee = true;
      shared = ApexGrappleScannerShares(scriptInterface);
    }
  }
  if shared {
    system.sharedDown = true;
    system.sharedPressedAt = now;
    key.sharedPress = true;
  }
  // The scanner's button is seen pressed at the release of a tap, as the game's quick melee, and never held: a hold
  // is the scanner's. The game tells the quick melee's tap; an own key's is told by its length.
  if system.sharedDown {
    let released: Bool = !key.held;
    let tapped: Bool = settings.ownKey ? now - system.sharedPressedAt < ApexGrappleTapLongest() : scriptInterface.IsActionJustTapped(n"QuickMelee");
    key.pressed = released && tapped;
    key.held = false;
    if released {
      system.sharedDown = false;
      key.sharedTap = key.pressed;
      ApexGrappleEndHoldBack(system, now);
      if !key.pressed {
        ApexGrappleLog("press left to the scanner: not a tap (" + ToString(now - system.sharedPressedAt) + " s)");
      }
    }
  }
  // Read on a press only: the scanner costs nothing between presses. Left to the game, the press neither fires nor
  // calls off a grapple, and the quick melee is not held back.
  if key.pressed {
    let scanner: String = this.ApexGrappleScannerInUse(scriptInterface);
    if StrLen(scanner) > 0 {
      key.pressed = false;
      ApexGrappleLog("press left to the game: " + scanner);
    }
  }
  if key.pressed {
    system.keyDown = true;
    system.pressedAt = now;
  }
  if system.keyDown && !key.held {
    system.keyDown = false;
    system.releasedAt = now;
    ApexGrappleEndHoldBack(system, now);
  }
  // A hold of the shared button is the scanner's: no hold to grapple on it.
  key.holdMode = !key.sharedTap && (scriptInterface.executionOwner.PlayerLastUsedKBM() ? settings.keyboardHold : settings.controllerHold);
  return key;
}
