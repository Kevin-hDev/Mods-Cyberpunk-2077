// The implant's card in the game's own item cards: a ripperdoc's shop, the upgrade screen, the inventory. Our records
// keep the item type of the game's projectile launcher, the only thing the Glamdoc reads
// (docs/cyber-grapple/conception.md), so the game draws the launcher's card: its two bars, attack speed and damage per
// hit, and "Projectile Launch System" for the type. Kevin, 16 November 2026: "on voit cyberware projectile launch
// system avec attack speed et damage per hit alors que ce c'est pas ça qui augmente pour le grapin".
// For our records only, the two bars show what a tier changes, the range and the top speed (Tiers.reds), against the
// worn implant's as the game compares two items, and the type line carries the implant's own name. Any other item,
// and ours while its texts are missing, keeps the game's card untouched.
// The cards have two families of scripts in the game (itemTooltipController.script, newItemTooltip.script), which
// share the bar itself: both are wrapped.

// What the journal last told of a card: its tier and the worn tier it was compared with.
@addField(CyberGrappleSystem)
public let cardTold: Int32;

// The tier of the record a card shows, 1 to 11; 0 for a record that is not ours.
public func CyberGrappleCardTier(record: TweakDBID) -> Int32 {
  return CyberGrappleTier(ItemID.FromTDBID(record));
}

// A number whole when it is whole, else with one decimal after a point, as the log writes it.
public func CyberGrappleCardNumber(value: Float) -> String {
  if AbsF(value - Cast<Float>(RoundF(value))) < 0.05 {
    return ToString(RoundF(value));
  }
  return FloatToStringPrec(value, 1);
}

// A value as the card shows it, in the player's language: `unit` holds {n} where the number goes, `mark` is the
// decimal mark (Texts.reds).
public func CyberGrappleCardValue(value: Float, unit: String, mark: String) -> String {
  return StrReplace(unit, "{n}", StrReplace(CyberGrappleCardNumber(value), ".", mark));
}

// One bar: the value of the card's tier, full at the last tier's, against the worn tier's when the card is compared
// (worn: 0 for none). The game's bar does the drawing, the gain in green and the arrow; `kind` only tells its two
// bars apart, the label and the unit are ours.
public func CyberGrappleCardBar(widget: inkWidgetRef, separators: Bool, itemType: gamedataItemType, kind: WeaponBarType, values: array<Float>, tier: Int32, worn: Int32, label: String, unit: String, mark: String) -> Void {
  let controller: wref<NewItemTooltipStatBarController> = inkWidgetRef.GetController(widget) as NewItemTooltipStatBarController;
  if !IsDefined(controller) {
    return;
  }
  let most: Float = values[ArraySize(values) - 1];
  let value: Float = CyberGrappleTierValue(values, tier);
  let bar: ref<UIInventoryItemWeaponBar> = UIInventoryItemWeaponBar.Make(itemType, kind, value, most);
  let compared: ref<UIInventoryItemWeaponBar>;
  if worn > 0 {
    compared = UIInventoryItemWeaponBar.Make(itemType, kind, CyberGrappleTierValue(values, worn), most);
  }
  inkWidgetRef.SetVisible(widget, true);
  controller.SetSeparatorsVisibility(separators);
  controller.Setup(itemType, bar, compared);
  controller.CyberGrappleWrite(label, CyberGrappleCardValue(value, unit, mark));
}

// Draws our two bars on a card's bars. False when they cannot be drawn: the game's own are drawn instead.
public func CyberGrappleCardBars(bars: array<inkWidgetRef>, separators: Bool, itemType: gamedataItemType, tier: Int32, compare: Bool) -> Bool {
  if !CyberGrappleTextsThere() || ArraySize(bars) < 2 {
    return false;
  }
  let range: String = GetLocalizedTextByKey(n"CyberGrapple-Card-Range");
  let speed: String = GetLocalizedTextByKey(n"CyberGrapple-Card-TopSpeed");
  let metres: String = GetLocalizedTextByKey(n"CyberGrapple-Card-Distance");
  let metresASecond: String = GetLocalizedTextByKey(n"CyberGrapple-Card-Speed");
  let mark: String = GetLocalizedTextByKey(n"CyberGrapple-Card-DecimalMark");
  if StrLen(range) == 0 || StrLen(speed) == 0 || StrLen(metres) == 0 || StrLen(metresASecond) == 0 || StrLen(mark) == 0 {
    return false;
  }
  let game: GameInstance = GetGameInstance();
  let worn: Int32 = 0;
  if compare {
    worn = CyberGrappleTier(CyberGrappleWornArm(GetPlayer(game)));
  }
  CyberGrappleCardBar(bars[0], separators, itemType, WeaponBarType.Range, CyberGrappleRanges(), tier, worn, range, metres, mark);
  CyberGrappleCardBar(bars[1], separators, itemType, WeaponBarType.AttackSpeed, CyberGrappleTopSpeeds(), tier, worn, speed, metresASecond, mark);
  let i: Int32 = 2;
  while i < ArraySize(bars) {
    let unused: wref<NewItemTooltipStatBarController> = inkWidgetRef.GetController(bars[i]) as NewItemTooltipStatBarController;
    inkWidgetRef.SetVisible(bars[i], false);
    if IsDefined(unused) {
      unused.ResetPercentage();
    }
    i += 1;
  }
  // Written when the card or what it is compared with changes, never by frames: a card is redrawn on each hover.
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(game);
  let told: Int32 = tier * 100 + worn;
  if IsDefined(system) && system.cardTold != told {
    system.cardTold = told;
    CyberGrappleLog("card drawn: tier " + ToString(tier) + " of " + ToString(CyberGrappleTierCount()) + ", range " + CyberGrappleCardNumber(CyberGrappleTierValue(CyberGrappleRanges(), tier)) + " m, top speed " + CyberGrappleCardNumber(CyberGrappleTierValue(CyberGrappleTopSpeeds(), tier)) + " m/s, " + (worn > 0 ? "compared with the worn tier " + ToString(worn) : "not compared") + ", " + ToString(ArraySize(bars)) + " bars on the card");
  }
  return true;
}

@addMethod(NewItemTooltipStatBarController)
public func CyberGrappleWrite(label: String, value: String) -> Void {
  inkTextRef.SetText(this.m_statName, label);
  inkTextRef.SetText(this.m_statValue, value);
}

@wrapMethod(ItemTooltipCyberwareWeaponModule)
public func Update(data: ref<MinimalItemTooltipData>) -> Void {
  let tier: Int32 = CyberGrappleCardTier(data.itemTweakID);
  if tier <= 0 || !CyberGrappleCardBars(this.m_bars, data.GetStatsManager().IsSeparatorBarsEnabled(), data.itemType, tier, !data.isEquipped) {
    wrappedMethod(data);
  }
}

@wrapMethod(ItemTooltipCyberwareWeaponModule)
public final func NEW_Update(data: wref<UIInventoryItem>, comparisonData: wref<UIInventoryItemComparisonManager>) -> Void {
  let tier: Int32 = CyberGrappleCardTier(data.GetTweakDBID());
  if tier <= 0 || !CyberGrappleCardBars(this.m_bars, data.GetStatsManager().IsSeparatorBarsEnabled(), data.GetItemType(), tier, !data.IsEquipped()) {
    wrappedMethod(data, comparisonData);
  }
}

@wrapMethod(NewItemTooltipWeaponBarsModule)
public func Update(data: ref<MinimalItemTooltipData>) -> Void {
  let tier: Int32 = CyberGrappleCardTier(data.itemTweakID);
  if tier <= 0 || !CyberGrappleCardBars(this.m_bars, data.GetStatsManager().IsSeparatorBarsEnabled(), data.itemType, tier, !data.isEquipped) {
    wrappedMethod(data);
  }
}

@wrapMethod(NewItemTooltipWeaponBarsModule)
public final func NEW_Update(data: wref<UIInventoryItem>, comparisonData: wref<UIInventoryItemComparisonManager>) -> Void {
  let tier: Int32 = CyberGrappleCardTier(data.GetTweakDBID());
  if tier <= 0 || !CyberGrappleCardBars(this.m_bars, data.GetStatsManager().IsSeparatorBarsEnabled(), data.GetItemType(), tier, !data.IsEquipped()) {
    wrappedMethod(data, comparisonData);
  }
}

// The type line under the tier: "Cyberware - " then the implant's own name, as the game writes "Cyberware - Mantis
// Blades" under the Mantis Blades. The second family of cards writes "Cyberware" alone, which is true: left as it is.
@addMethod(ItemTooltipHeaderController)
private func CyberGrappleWriteType(record: TweakDBID) -> Void {
  if !CyberGrappleTextsThere() || CyberGrappleCardTier(record) <= 0 {
    return;
  }
  let name: String = GetLocalizedTextByKey(n"CyberGrapple-Card-Name");
  if StrLen(name) > 0 {
    inkTextRef.SetText(this.m_itemTypeText, GetLocalizedText("UI-Inventory-Tooltips-CyberwareDescription") + " - " + name);
  }
}

@wrapMethod(ItemTooltipHeaderController)
public func Update(data: ref<MinimalItemTooltipData>) -> Void {
  wrappedMethod(data);
  this.CyberGrappleWriteType(data.itemTweakID);
}

@wrapMethod(ItemTooltipHeaderController)
public func NEW_Update(data: wref<UIInventoryItem>) -> Void {
  wrappedMethod(data);
  this.CyberGrappleWriteType(data.GetTweakDBID());
}
