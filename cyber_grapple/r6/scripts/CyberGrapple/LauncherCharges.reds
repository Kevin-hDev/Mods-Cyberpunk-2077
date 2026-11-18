// The game's launcher count, and whom it is about. The game keeps one count for V's launcher
// (PlayerPuppet.GetProjectileLauncherCharges, player.script:6425) and shows it on any launcher-type item: on the gadget
// slot, in the inventory and in the quick wheel; the launcher's shot asks it too before it starts. Our implant is such
// an item. With the game's one arm slot V wears one of them, and the count is ours while our implant is worn. A mod
// that adds arm slots lets V wear the game's launcher beside ours (implants.yaml): the count is then about the item on
// the gadget key, and each launcher-type entry of the game's lists is given its own.

// Whom the game's launcher questions are about: our implant when it is, else ItemID.None() for the game's own answer.
// A launcher-type item of the game's on the gadget key is the one the slot shows and the key fires, worn or not: the
// game puts one there unworn when the key was empty as it came into the inventory (player.script:2261-2266,
// equipmentSystem.script:1958-1962), and keeps one taken off a slot that is not the active one (:2123-2145). Else, with
// no other launcher-type arm worn they are about ours, as since D24; with both worn, about the item on the gadget key.
// Read live, as the arm worn: a menu may list an implant fitted a moment ago.
public func CyberGrappleLauncherAsked(player: ref<GameObject>) -> ItemID {
  let worn: ItemID = CyberGrappleWornArm(player);
  if !CyberGrappleIsImplant(worn) {
    return ItemID.None();
  }
  let held: ItemID = CyberGrappleGadgetKeyItem(player);
  if held != worn && ItemID.IsValid(held) && !CyberGrappleIsImplant(held) && Equals(RPGManager.GetItemType(held), gamedataItemType.Cyb_Launcher) {
    return ItemID.None();
  }
  if !CyberGrappleOtherLauncherWorn(player) {
    return worn;
  }
  return held == worn ? worn : ItemID.None();
}

// Our charges for the worn implant, as the game is told them; -1 without the grapple's system. The tier kept is read
// from the grapple's frame, twice a second of the game's clock at most: it is checked first against the implant worn.
public func CyberGrappleWornCharges(player: ref<GameObject>, worn: ItemID) -> Int32 {
  let game: GameInstance = player.GetGame();
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(game);
  if !IsDefined(system) {
    return -1;
  }
  CyberGrappleKeepTierOf(system, worn);
  return CyberGrappleChargesLeft(system, CyberGrappleTime(game));
}

// Set while the game's own count is asked for (CyberGrappleGameLauncherCharges).
@addField(PlayerPuppet)
private let cyberGrappleGameCount: Bool;

@wrapMethod(PlayerPuppet)
public final func GetProjectileLauncherCharges() -> Int32 {
  if this.cyberGrappleGameCount {
    return wrappedMethod();
  }
  let worn: ItemID = CyberGrappleLauncherAsked(this);
  if ItemID.IsValid(worn) {
    let charges: Int32 = CyberGrappleWornCharges(this, worn);
    if charges >= 0 {
      return charges;
    }
  }
  return wrappedMethod();
}

// The game's own launcher count, whoever the question would be about: asked of the game's function, so that any other
// mod's answer is kept.
@addMethod(PlayerPuppet)
public func CyberGrappleGameLauncherCharges() -> Int32 {
  this.cyberGrappleGameCount = true;
  let charges: Int32 = this.GetProjectileLauncherCharges();
  this.cyberGrappleGameCount = false;
  return charges;
}

// The launcher's own question before its shot, in four of the five places that read the gadget key
// (upperBodyTransitions.script:652, :836, :1033, :1756), at a press: no when it is about our implant, and the game
// starts nothing. With our implant on the key the game no longer gets this far (GadgetQuickslot.reds); kept behind that
// answer, in lock 2 of "never a projectile" (docs/cyber-grapple/conception.md). The game's own answer asks the count
// above (leftHandCyberwareTransitions.script:5), under the same judge.
@wrapMethod(LeftHandCyberwareHelper)
public final static func ProjectileLauncherHasCharge(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if ItemID.IsValid(CyberGrappleLauncherAsked(scriptInterface.executionOwner)) {
    return false;
  }
  return wrappedMethod(scriptInterface);
}

// The game's lists write the count on each launcher-type entry (inventoryDataManagerV2.script:1055, :1652). The gadget
// slot's own item comes through the second one too (:1449-1451, :869-874, :1466, :1575-1578), and is given the count
// the questions above give for it. Left alone: GetPlayerInventoryData (:424, :447), whose two callers never read an
// entry's number (playerDevelopmentSystem.script:1323-1326 reads its type and ID, itemsQueue.script:111-117 compares
// records and stats).

// The number a launcher-type entry shows while both are worn; `ours` is our worn implant.
public func CyberGrappleLauncherCount(player: ref<PlayerPuppet>, ours: ItemID, id: ItemID, written: Int32) -> Int32 {
  if CyberGrappleIsImplant(id) {
    let charges: Int32 = CyberGrappleWornCharges(player, ours);
    return charges >= 0 ? charges : written;
  }
  return player.CyberGrappleGameLauncherCharges();
}

// Asked for every item an inventory, a vendor's or a loot screen shows: any type but the launcher's is the game's at
// once, its item data never copied again.
@wrapMethod(InventoryDataManagerV2)
private final func GetInventoryItemDataInternal(owner: wref<GameObject>, itemData: wref<gameItemData>, opt itemRecord: wref<Item_Record>) -> InventoryItemData {
  if !IsDefined(itemData) || NotEquals(itemData.GetItemType(), gamedataItemType.Cyb_Launcher) {
    return wrappedMethod(owner, itemData, itemRecord);
  }
  let data: InventoryItemData = wrappedMethod(owner, itemData, itemRecord);
  let player: ref<PlayerPuppet> = GetPlayer(owner.GetGame());
  let ours: ItemID = CyberGrappleWornBesideLauncher(player);
  if !ItemID.IsValid(ours) {
    return data;
  }
  InventoryItemData.SetQuantity(data, CyberGrappleLauncherCount(player, ours, InventoryItemData.GetID(data), InventoryItemData.GetQuantity(data)));
  return data;
}

// The quick wheel's gadget slot and the inventory's choice for the gadget key list the launcher-type arms this way
// (radialWheel.script:1069, inventoryItemMode.script:971). With skipEquippedItems the game writes no count on them.
@wrapMethod(InventoryDataManagerV2)
public final func GetPlayerItemsByType(type: gamedataItemType, opt skipEquippedItems: Bool, opt additionalTagFilters: array<CName>, opt filteredItems: array<ItemModParams>) -> array<InventoryItemData> {
  let items: array<InventoryItemData> = wrappedMethod(type, skipEquippedItems, additionalTagFilters, filteredItems);
  if NotEquals(type, gamedataItemType.Cyb_Launcher) || skipEquippedItems {
    return items;
  }
  let player: ref<PlayerPuppet> = this.m_Player;
  let ours: ItemID = CyberGrappleWornBesideLauncher(player);
  if !ItemID.IsValid(ours) {
    return items;
  }
  let i: Int32 = 0;
  while i < ArraySize(items) {
    let entry: InventoryItemData = items[i];
    InventoryItemData.SetQuantity(entry, CyberGrappleLauncherCount(player, ours, InventoryItemData.GetID(entry), InventoryItemData.GetQuantity(entry)));
    items[i] = entry;
    i += 1;
  }
  return items;
}
