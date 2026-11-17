// Our implant among the game's items. Its records keep the item type of the game's projectile launcher, the only
// thing the Glamdoc reads (glamdoc.script), so only this tag of ours tells the two apart (r6/tweaks/CyberGrapple).

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
// the item and not from a stat laid on V: the game never takes back what a launcher-type record lays on V when it
// is fitted, so such a stat outlives the implant (tried in game, 16 November 2026).
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

// What V wears in the arm cyberware slot, or an invalid ID.
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
  return data.GetActiveItem(gamedataEquipmentArea.ArmsCW);
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

// Our implant worn in the arm cyberware slot, or an invalid ID.
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
