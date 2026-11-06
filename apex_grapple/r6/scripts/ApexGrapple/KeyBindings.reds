// What the game itself does with a profile's own key: open the scanner, or strike the quick melee. An own key on the
// scanner's button is read as the quick melee button the scanner shares (Key.reds): a tap grapples at its release, a
// hold stays the scanner's. An own key on the quick melee button holds the game's quick melee back, as the quick melee
// key does. Until 2 November 2026 an own key was neither: with L1 as profile 1's own key, holding L1 for the scanner
// fired the grapple (Kevin), the scanner fix of 30 October covering the quick melee key only.
// Bindings (r6/config/inputUserMappings.xml, game 2.5): on a controller the scanner is L1 in every scheme
// (Vision_Hold_Button), the quick melee R3, or L1 in the Alternative and Switch Legacy schemes; on a keyboard both are
// the player's own, kept in the settings (/key_bindings/SettingsLocomotion: visionHold Tab, visionToggle Caps Lock,
// quickmelee Q by default, UserSettings.json).

public func ApexGrappleKeyId(key: EInputKey) -> CName {
  return EnumValueToName(n"EInputKey", Cast<Int64>(EnumInt(key)));
}

// The key the player bound to one of the game's on-foot actions, or None.
public func ApexGrappleBoundKey(game: GameInstance, action: CName) -> CName {
  let bound: ref<ConfigVarName> = GameInstance.GetSettingsSystem(game).GetVar(n"/key_bindings/SettingsLocomotion", action) as ConfigVarName;
  if !IsDefined(bound) {
    return n"None";
  }
  return bound.GetValue();
}

// The controller scheme puts the quick melee on L1, the scanner's button (hudManager.script, scripts 2.5).
public func ApexGrappleSchemeSharesL1(game: GameInstance) -> Bool {
  let schemes: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).Get(GetAllBlackboardDefs().InputSchemes);
  let scheme: InputScheme = ConvertIntValueToInputScheme(schemes.GetUint(GetAllBlackboardDefs().InputSchemes.Scheme));
  return Equals(scheme, InputScheme.ALTERNATIVE) || Equals(scheme, InputScheme.SWITCH_LEGACY);
}

// The scanner's held button only. Its toggle key (Caps Lock by default) opens or closes the scanner at each press
// (playerVisionModeController.script:261-271): read as a tap at the release, closing the scanner fired the grapple
// (the audit of 2 November 2026). It is read as any key, at the press, and a press with the scanner open is left to
// the game (Key.reds).
public func ApexGrappleKeyOpensScanner(game: GameInstance, key: EInputKey) -> Bool {
  if Equals(key, EInputKey.IK_Pad_LeftShoulder) {
    return true;
  }
  return Equals(ApexGrappleKeyId(key), ApexGrappleBoundKey(game, n"visionHold"));
}

public func ApexGrappleKeyStrikesQuickMelee(game: GameInstance, key: EInputKey) -> Bool {
  if Equals(key, EInputKey.IK_Pad_LeftShoulder) {
    return ApexGrappleSchemeSharesL1(game);
  }
  if Equals(key, EInputKey.IK_Pad_RightThumb) {
    return !ApexGrappleSchemeSharesL1(game);
  }
  return Equals(ApexGrappleKeyId(key), ApexGrappleBoundKey(game, n"quickmelee"));
}
