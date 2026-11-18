// The implant the grapple shows on V's left arm in first person (setting implant), and whether the grapple needs V to
// have the projectile launcher installed (setting requireLauncher, Settings.reds). Only the game's projectile launcher
// so far; the Monowire's cable may join it as another choice (Kevin, 1 November 2026: "on fera la même chose, Visible
// et Exiger").
// Shown by default (Kevin, 1 November 2026, after that day's tests: "c'est beaucoup plus propre"). The switch answers
// about ten players who asked for an implant behind the grapple; off by default, so that players of earlier versions
// lose nothing (decision of 31 October 2026).
// One choice of implant and one switch, rather than a switch per implant: two switches "shown" and "required" would
// contradict each other when only the second is on. The switch names the launcher (Kevin, after testing it as "Require
// the implant": "quel implant ?") and asks for it whether it shows or not, so its name stays true with "None". When a
// second implant joins, it becomes a switch for the chosen implant, under a name that says so.

enum ApexGrappleImplant {
  None = 0,
  ProjectileLauncher = 1
}

public func ApexGrappleImplantName(implant: ApexGrappleImplant) -> String {
  return Equals(implant, ApexGrappleImplant.ProjectileLauncher) ? "projectile launcher" : "none";
}

// Every projectile launcher, iconic ones included, has the item type Cyb_Launcher, as the game reads it for its launcher
// wheel (quickSlotsManager.script, GetLauncher).
public func ApexGrappleIsLauncherRecord(record: TweakDBID) -> Bool {
  let item: ref<Item_Record> = TweakDBInterface.GetItemRecord(record);
  return IsDefined(item) && Equals(item.ItemType().Type(), gamedataItemType.Cyb_Launcher);
}

public func ApexGrappleIsLauncher(id: ItemID) -> Bool {
  return ItemID.IsValid(id) && ApexGrappleIsLauncherRecord(ItemID.GetTDBID(id));
}

public func ApexGrappleArmData(player: ref<GameObject>) -> ref<EquipmentSystemPlayerData> {
  let puppet: ref<PlayerPuppet> = player as PlayerPuppet;
  if !IsDefined(puppet) {
    return null;
  }
  return EquipmentSystem.GetData(puppet);
}

// V's projectile launcher installed in an arm cyberware slot, or an invalid ID. The game has one arm slot. With more
// of them (mods add some) the active slot is the arm drawn last, and the launcher sits in another: the grapple was
// refused with the launcher required while V had one installed (Kevin, 18 November 2026, 18 shots refused in game).
// Every slot is asked, as the game does to draw the launcher (equipmentSystem.script, GetActiveCyberware), the locked
// ones too, since an empty one costs nothing. The active slot first: with one slot, or the launcher active, nothing
// more is read.
public func ApexGrappleInstalledLauncher(player: ref<GameObject>) -> ItemID {
  let none: ItemID;
  let data: ref<EquipmentSystemPlayerData> = ApexGrappleArmData(player);
  if !IsDefined(data) {
    return none;
  }
  let active: ItemID = data.GetActiveItem(gamedataEquipmentArea.ArmsCW);
  if ApexGrappleIsLauncher(active) {
    return active;
  }
  let slots: Int32 = data.GetNumberOfSlots(gamedataEquipmentArea.ArmsCW, true);
  if slots < 2 {
    return none;
  }
  let i: Int32 = 0;
  while i < slots {
    let held: ItemID = data.GetItemInEquipSlot(gamedataEquipmentArea.ArmsCW, i);
    if ApexGrappleIsLauncher(held) {
      return held;
    }
    i += 1;
  }
  return none;
}

// Whether the launcher is the arm V wears now, the active slot's: the only arm a Glamdoc style is known to fit
// (LauncherStyle.reds). With one arm slot, the same as having one installed.
public func ApexGrappleLauncherIsActiveArm(player: ref<GameObject>) -> Bool {
  let data: ref<EquipmentSystemPlayerData> = ApexGrappleArmData(player);
  return IsDefined(data) && ApexGrappleIsLauncher(data.GetActiveItem(gamedataEquipmentArea.ArmsCW));
}

public func ApexGrappleHasLauncher(player: ref<GameObject>) -> Bool {
  return ItemID.IsValid(ApexGrappleInstalledLauncher(player));
}

// Why a shot is refused for the implant, or nothing. Refused, the press is not the grapple's: with the quick melee
// key, the game's quick melee strikes as if the mod were off.
public func ApexGrappleImplantRefusal(settings: ref<ApexGrappleSettings>, player: ref<GameObject>) -> String {
  if !settings.requireLauncher || ApexGrappleHasLauncher(player) {
    return "";
  }
  return "refused: the projectile launcher is required and V has none installed";
}

// As the arm rises (Arm.reds). Not lent, the rope leaves from V's hand, as in version 1.0.2: the rope's start, the
// crosshair and the hand all follow the loan.
public func ApexGrappleImplantShow(system: ref<ApexGrappleSystem>, arm: ref<ApexGrappleArm>, settings: ref<ApexGrappleSettings>, now: Float, player: ref<GameObject>) -> Void {
  if Equals(settings.implant, ApexGrappleImplant.ProjectileLauncher) {
    ApexGrappleLauncherLend(system, arm, now, player);
  }
}
