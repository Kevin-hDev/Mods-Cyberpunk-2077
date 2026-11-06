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

// True when V has a projectile launcher installed in the arm cyberware slot, as the game reads it for its launcher
// wheel (quickSlotsManager.script, GetLauncher): every launcher, iconic ones included, has the item type Cyb_Launcher.
public func ApexGrappleHasLauncher(player: ref<GameObject>) -> Bool {
  let puppet: ref<PlayerPuppet> = player as PlayerPuppet;
  if !IsDefined(puppet) {
    return false;
  }
  let data: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(puppet);
  if !IsDefined(data) {
    return false;
  }
  let installed: ItemID = data.GetActiveItem(gamedataEquipmentArea.ArmsCW);
  if !ItemID.IsValid(installed) {
    return false;
  }
  let record: ref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(installed));
  return IsDefined(record) && Equals(record.ItemType().Type(), gamedataItemType.Cyb_Launcher);
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
