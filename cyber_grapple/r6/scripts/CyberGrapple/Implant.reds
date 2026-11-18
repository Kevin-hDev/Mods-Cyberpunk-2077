// Our implant among the game's items. Its records keep the item type of the game's projectile launcher, the only
// thing the Glamdoc reads (glamdoc.script). Their family is their own (implants.yaml), but the gadget slot is told the
// launcher's for ours (SlotCharges.reds): our code tells the two apart by this tag of ours alone (r6/tweaks/CyberGrapple).

public func CyberGrappleTag() -> CName {
  return n"CyberGrapple";
}

public func CyberGrappleIsImplant(id: ItemID) -> Bool {
  if !ItemID.IsValid(id) {
    return false;
  }
  let record: ref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(id));
  return IsDefined(record) && record.TagsContains(CyberGrappleTag());
}

// The tier of an implant of ours, 1 to 11, read from the tier tag of its own record; 0 for anything else. Read from
// the item and not from a stat laid on V: the game does not take back what a launcher-type record laid on V when the
// item leaves the active arm slot (equipmentSystem.script:2109-2114), the only slot the game has, so such a stat
// outlives the implant (tried in game, 16 November 2026).
public func CyberGrappleTier(id: ItemID) -> Int32 {
  if !ItemID.IsValid(id) {
    return 0;
  }
  let record: ref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(id));
  if !IsDefined(record) || !record.TagsContains(CyberGrappleTag()) {
    return 0;
  }
  let tier: Int32 = CyberGrappleTierCount();
  while tier > 0 {
    if record.TagsContains(StringToName("CyberGrappleTier" + ToString(tier))) {
      return tier;
    }
    tier -= 1;
  }
  return 0;
}

// What V wears as arm cyberware, or an invalid ID: our implant when an arm slot holds it, else the active slot's item.
// The game has one arm slot. With more of them (mods add some), the active slot is the arm drawn last, which may be
// another arm while ours sits in the next slot: every slot is asked, the locked ones too, since an empty one costs
// nothing. The active slot first: with ours active nothing more is read, with one slot only their number. With
// several slots and another arm active, the crosshair's question (CyberGrappleImplantRefusalNow) reads each slot's
// record each frame it judges.
public func CyberGrappleWornArm(player: ref<GameObject>) -> ItemID {
  let none: ItemID;
  let puppet: ref<PlayerPuppet> = player as PlayerPuppet;
  if !IsDefined(puppet) {
    return none;
  }
  let data: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(puppet);
  if !IsDefined(data) {
    return none;
  }
  let active: ItemID = data.GetActiveItem(gamedataEquipmentArea.ArmsCW);
  if CyberGrappleIsImplant(active) {
    return active;
  }
  let slots: Int32 = data.GetNumberOfSlots(gamedataEquipmentArea.ArmsCW, true);
  if slots < 2 {
    return active;
  }
  let i: Int32 = 0;
  while i < slots {
    let held: ItemID = data.GetItemInEquipSlot(gamedataEquipmentArea.ArmsCW, i);
    if CyberGrappleIsImplant(held) {
      return held;
    }
    i += 1;
  }
  return active;
}

// Whether an arm of the launcher's item type that is not ours is worn too: possible only with more arm slots than the
// game's one, since our implant has a family of its own (implants.yaml). Asked once ours is worn, live: a menu lists
// an implant fitted a moment ago. With one slot nothing is read past the count.
public func CyberGrappleOtherLauncherWorn(player: ref<GameObject>) -> Bool {
  let puppet: ref<PlayerPuppet> = player as PlayerPuppet;
  if !IsDefined(puppet) {
    return false;
  }
  let data: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(puppet);
  if !IsDefined(data) {
    return false;
  }
  let slots: Int32 = data.GetNumberOfSlots(gamedataEquipmentArea.ArmsCW, true);
  if slots < 2 {
    return false;
  }
  let i: Int32 = 0;
  while i < slots {
    let held: ItemID = data.GetItemInEquipSlot(gamedataEquipmentArea.ArmsCW, i);
    if ItemID.IsValid(held) && !CyberGrappleIsImplant(held) && Equals(RPGManager.GetItemType(held), gamedataItemType.Cyb_Launcher) {
      return true;
    }
    i += 1;
  }
  return false;
}

// Our implant while a launcher-type arm of the game's is worn beside it, else ItemID.None().
public func CyberGrappleWornBesideLauncher(player: ref<GameObject>) -> ItemID {
  let worn: ItemID = CyberGrappleWornArm(player);
  if !CyberGrappleIsImplant(worn) {
    return ItemID.None();
  }
  return CyberGrappleOtherLauncherWorn(player) ? worn : ItemID.None();
}

// What follows answers the grapple's code, made from Apex Grapple's (fabrique/grapple.py), under the names it calls.
// There the arm shown and the launcher asked for are two settings; here the implant is always shown and always
// asked for, and "the launcher" is our implant alone: the game's projectile launcher gives no grapple (D2).

enum CyberGrappleImplant {
  None = 0,
  ProjectileLauncher = 1
}

public func CyberGrappleImplantName(implant: CyberGrappleImplant) -> String {
  return "ours";
}

public func CyberGrappleIsLauncherRecord(record: TweakDBID) -> Bool {
  let item: ref<Item_Record> = TweakDBInterface.GetItemRecord(record);
  return IsDefined(item) && item.TagsContains(CyberGrappleTag());
}

// Our implant worn in an arm cyberware slot, or an invalid ID.
public func CyberGrappleInstalledLauncher(player: ref<GameObject>) -> ItemID {
  let none: ItemID;
  let worn: ItemID = CyberGrappleWornArm(player);
  return CyberGrappleIsImplant(worn) ? worn : none;
}

public func CyberGrappleHasLauncher(player: ref<GameObject>) -> Bool {
  return ItemID.IsValid(CyberGrappleInstalledLauncher(player));
}

// Why the implant refuses a shot now, or nothing: not worn; then, with Own key off, not the item on the game's gadget
// key; then no charge left. Refused, the press is not the grapple's: on the gadget key the game does nothing with our
// implant (GadgetQuickslot.reds), and an own key on the quick melee button strikes the game's quick melee.
// The crosshair's range indicator asks this each frame it judges the aim (CrosshairRange.reds), with the system and
// the time its frame already holds: fixed texts, nothing built, and the item on the gadget key as the system keeps it
// (read at each press and at each reading of the worn tier, GadgetQuickslot.reds). A shot from the gadget key always
// finds our implant there: its press counts only then (Key.reds).
// Not told here, so the crosshair does not show it: V carrying a body, whose press the gadget key leaves to the game
// (GadgetQuickslot.reds). Knowing it would take a reading each frame, or one up to half a second late, and the
// crosshair's description in the menu lists its cases without this one.
// One profile: whether any own key is set is whether its own key is (SettingsCopy.reds).
public func CyberGrappleImplantRefusalNow(system: ref<CyberGrappleSystem>, now: Float, player: ref<GameObject>) -> String {
  if !CyberGrappleHasLauncher(player) {
    return "refused: V does not wear the grapple implant";
  }
  if IsDefined(system) && !system.anyOwnKey && !system.gadgetKeyOurs {
    return "refused: the implant is not in the Combat Gadget quickslot";
  }
  if IsDefined(system) && CyberGrappleChargesLeft(system, now) < 1 {
    return "refused: no charge left";
  }
  return "";
}

// The same question as asked by a shot (Shot.reds), under the name and arguments the grapple's code calls.
public func CyberGrappleImplantRefusal(settings: ref<CyberGrappleSettings>, player: ref<GameObject>) -> String {
  let game: GameInstance = player.GetGame();
  return CyberGrappleImplantRefusalNow(CyberGrappleSystemOf(game), CyberGrappleTime(game), player);
}

// As the arm rises (Arm.reds): the arm of the implant is lent for the shot, as a copy of V's own.
public func CyberGrappleImplantShow(system: ref<CyberGrappleSystem>, arm: ref<CyberGrappleArm>, settings: ref<CyberGrappleSettings>, now: Float, player: ref<GameObject>) -> Void {
  CyberGrappleLauncherLend(system, arm, now, player);
}
