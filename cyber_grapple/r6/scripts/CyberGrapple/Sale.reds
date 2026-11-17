// One line to the log each time a ripperdoc's menu opens: which ripperdoc, the two levels of V the sale rules and the
// upgrades read (Upgrade.reds), and which records of the implant it sells (implants.yaml), so that a player's log
// tells why a sale was missing. Written once the game has listed the ripperdoc's items, once a menu, a bounded number
// of lines a load.

@addField(CyberGrappleSystem)
public let saleLines: Int32;

public func CyberGrappleSaleMostLines() -> Int32 {
  return 20;
}

@addField(RipperDocGameController)
private let cyberGrappleSaleTold: Bool;

// Called when the menu opens with the ripperdoc already there, and when it arrives (ripperdoc.script): the game has
// listed its items (PrepareVendorItems) when it returns.
@wrapMethod(RipperDocGameController)
protected cb func OnUIVendorAttachedEvent(evt: ref<UIVendorAttachedEvent>) -> Bool {
  let done: Bool = wrappedMethod(evt);
  if !this.cyberGrappleSaleTold && IsDefined(this.m_VendorDataManager) && IsDefined(this.m_vendorItems) {
    this.cyberGrappleSaleTold = true;
    this.CyberGrappleTellSale();
  }
  return done;
}

@addMethod(RipperDocGameController)
private final func CyberGrappleTellSale() -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  if !IsDefined(player) {
    return;
  }
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(player.GetGame());
  // Past the last line, which says that the log stops (CyberGrappleLogUpTo), nothing is read for a line never written.
  if !IsDefined(system) || system.saleLines > CyberGrappleSaleMostLines() {
    return;
  }
  let items: array<wref<IScriptable>>;
  this.m_vendorItems.GetValues(items);
  let sold: String = "";
  let i: Int32 = 0;
  while i < ArraySize(items) {
    let item: wref<UIInventoryItem> = items[i] as UIInventoryItem;
    if IsDefined(item) && CyberGrappleIsImplant(item.GetID()) {
      sold = sold + (StrLen(sold) > 0 ? ", " : "") + TDBID.ToStringDEBUG(item.GetTweakDBID());
    }
    i += 1;
  }
  let vendor: TweakDBID = this.m_VendorDataManager.GetVendorID();
  system.saleLines = CyberGrappleLogUpTo(system.saleLines, CyberGrappleSaleMostLines(), "ripperdoc sales", "ripperdoc " + TDBID.ToStringDEBUG(vendor) + " opened: V's level stat " + ToString(CyberGrappleLevelStat(player)) + ", level shown " + ToString(CyberGrappleLevelShown(player)) + ", implant records sold: " + (StrLen(sold) > 0 ? sold : "none"));
}
