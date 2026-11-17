// Made by fabrique/grapple.py from Apex Grapple's Key.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// What the grapple key does this frame: the game's gadget key (action UseCombatGadget) while our implant is the item
// on it, or the player's own key. A press made while the scanner is in use stays the game's, and an own key on a
// button the scanner shares grapples on a tap only. Keeps the press and release times on the system: a pull's end
// needs the length of the last press (a tap pulls all the way), and an own key on the quick melee button holds the
// quick melee back until just after the release.

public struct CyberGrappleKey {
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
public func CyberGrappleQuickMeleeMargin() -> Float {
  return 0.3;
}

// Longer than any press: the hold-back lasts until the release brings it down to the margin.
public func CyberGrappleUntilRelease() -> Float {
  return 1000.0;
}

// The press belongs to the grapple (a shot, or a second press that calls it off, as in Borderlands 4): the game's
// quick melee must not strike at its release. Held back until the release, or for the margin when the press is
// already over (a tap seen at its release). Any other key, the game's gadget key included, has nothing to hold back.
public func CyberGrappleTakeKey(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, now: Float) -> Void {
  if system.keyIsQuickMelee {
    system.holdBackUntil = now + (system.keyDown ? CyberGrappleUntilRelease() : CyberGrappleQuickMeleeMargin());
    system.holdBacks = system.holdBacks + 1;
  }
}

// An own key on the scanner's button grapples on a press shorter than this: the scanner's button came 0.297 s into a
// hold of L1 and the scanner opened at 0.316 s (probe of 30 October 2026, Alternative scheme).
public func CyberGrappleTapLongest() -> Float {
  return 0.3;
}

public func CyberGrappleEndHoldBack(system: ref<CyberGrappleSystem>, now: Float) -> Void {
  if system.holdBackUntil > now + CyberGrappleQuickMeleeMargin() {
    system.holdBackUntil = now + CyberGrappleQuickMeleeMargin();
  }
}

// Why a press now belongs to the scanner; empty when it does not: the scanner's own button held (Tab, or L1 where it
// is the scanner's alone), or the scanner open. The game makes the same test before drawing a grenade
// (combatGadgetTransitions, scripts 2.5).
@addMethod(LocomotionEventsTransition)
private final func CyberGrappleScannerInUse(scriptInterface: ref<StateGameScriptInterface>) -> String {
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
private final func CyberGrappleMenuTakes(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if this.IsPlayerInAnyMenu(scriptInterface) {
    CyberGrappleLog("press left to the game: a menu is open");
    return true;
  }
  return false;
}

// A method of the locomotion states, for the game's IsInFocusMode. states: the own keys' places this frame.
@addMethod(LocomotionEventsTransition)
private final func CyberGrappleReadKey(scriptInterface: ref<StateGameScriptInterface>, system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, states: array<CyberGrappleOwnKey>, now: Float) -> CyberGrappleKey {
  let key: CyberGrappleKey;
  let shared: Bool;
  if settings.ownKey {
    // The place of the profile whose key is read (KeyProfile.reds).
    let slot: Int32 = system.keyProfile - 1;
    let own: CyberGrappleOwnKey = states[slot];
    // The own key is heard in menus too (CyberGrappleMenuTakes).
    key.pressed = own.presses != system.ownPressesSeen[slot] && own.held;
    system.ownPressesSeen[slot] = own.presses;
    key.held = own.held;
    if key.pressed && this.CyberGrappleMenuTakes(scriptInterface) {
      key.pressed = false;
    }
    if key.pressed {
      let game: GameInstance = scriptInterface.GetGame();
      system.keyIsQuickMelee = CyberGrappleKeyStrikesQuickMelee(game, settings.key);
      shared = CyberGrappleKeyOpensScanner(game, settings.key);
    }
  } else {
    // The game's gadget key, the grapple's only while our implant is the item on it and V carries no body
    // (GadgetQuickslot.reds): no quick melee to hold back, no scanner on its button.
    key.pressed = CyberGrappleGadgetKeyNow(system, scriptInterface);
    key.held = key.pressed || scriptInterface.GetActionValue(n"UseCombatGadget") > 0.0;
    if key.pressed && (!settings.enabled || !CyberGrappleGadgetKeyPress(system, scriptInterface)) {
      key.pressed = false;
      key.held = false;
    }
    if key.pressed && this.CyberGrappleMenuTakes(scriptInterface) {
      key.pressed = false;
    }
    if key.pressed {
      system.keyIsQuickMelee = false;
    }
  }
  if shared {
    system.sharedDown = true;
    system.sharedPressedAt = now;
    key.sharedPress = true;
  }
  // An own key on the scanner's button is seen pressed at the release of a tap, and never held: a hold is the
  // scanner's. The tap is told by the press's length.
  if system.sharedDown {
    let released: Bool = !key.held;
    let tapped: Bool = now - system.sharedPressedAt < CyberGrappleTapLongest();
    key.pressed = released && tapped;
    key.held = false;
    if released {
      system.sharedDown = false;
      key.sharedTap = key.pressed;
      CyberGrappleEndHoldBack(system, now);
      if !key.pressed {
        CyberGrappleLog("press left to the scanner: not a tap (" + ToString(now - system.sharedPressedAt) + " s)");
      }
    }
  }
  // Read on a press only: the scanner costs nothing between presses. Left to the game, the press neither fires nor
  // calls off a grapple, and the quick melee is not held back.
  if key.pressed {
    let scanner: String = this.CyberGrappleScannerInUse(scriptInterface);
    if StrLen(scanner) > 0 {
      key.pressed = false;
      CyberGrappleLog("press left to the game: " + scanner);
    }
  }
  if key.pressed {
    system.keyDown = true;
    system.pressedAt = now;
  }
  if system.keyDown && !key.held {
    system.keyDown = false;
    system.releasedAt = now;
    CyberGrappleEndHoldBack(system, now);
  }
  // A hold of the shared button is the scanner's: no hold to grapple on it. Read on a press only, the one time it is
  // used (Shot.reds, CyberGrappleIdleFrame): the device used last is not asked each frame (A7).
  if key.pressed {
    key.holdMode = !key.sharedTap && (scriptInterface.executionOwner.PlayerLastUsedKBM() ? settings.keyboardHold : settings.controllerHold);
  }
  return key;
}
