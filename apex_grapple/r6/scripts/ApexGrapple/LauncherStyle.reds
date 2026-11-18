// The lent launcher looks like V's own: same tier, same Glamdoc style.

// The record the lent launcher copies: V's own launcher's when one is installed, else the game's rare one. Every
// launcher record has the same look in the game's data (entity, appearance, suffixes, visual tags), and yet Kevin's
// launcher showed gold in the game but plain on the rare copy (15 November 2026). The copy of V's record showed right in
// game the same day (35 loans over three implants, each at its implant's tier), with a Glamdoc style laid all along:
// the tier alone, without a style, was never seen. The game copies the tier onto the holstered arms it shows
// (equipmentSystem.script, UpdateArmSlot, ForceQualityAndDuplicateStatsShard).
public func ApexGrappleLauncherRecordFor(installed: ItemID) -> TweakDBID {
  return ItemID.IsValid(installed) ? ItemID.GetTDBID(installed) : ApexGrappleLauncherRecord();
}

public func ApexGrappleItemQuality(player: ref<GameObject>, id: ItemID) -> Float {
  let stats: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
  return stats.GetStatValue(Cast<StatsObjectID>(id), gamedataStatType.Quality);
}

// For the loan's log line: the record copied, and the tier of the copy beside V's own.
public func ApexGrappleLauncherLook(player: ref<GameObject>, installed: ItemID, lent: ItemID) -> String {
  let look: String = "a copy of " + TDBID.ToStringDEBUG(ItemID.GetTDBID(lent)) + ", quality " + ToString(ApexGrappleItemQuality(player, lent));
  if !ItemID.IsValid(installed) {
    return look + ", V has no launcher installed";
  }
  return look + ", V's own quality " + ToString(ApexGrappleItemQuality(player, installed));
}

// The Glamdoc style (game 2.5) bought for V's projectile launcher, laid on the launcher lent for the grapple. The engine
// lays it on V's own implant (no script lays it when an item enters the left hand, player.script:2105-2119), and the
// lent launcher is a copy: it showed without the style (Kevin, 15 November 2026). The game's own call that lays the
// saved style again (cyberwareCustomizationSystem.script, RestoreCyberwareCustomization, forced as after a purchase at
// a Glamdoc), once the copy is seen in the hand, showed it right in game the same day (17 shots). A style only fits the
// arm implant V wears: the Glamdoc sells it for that implant (glamdoc.script, CheckIfCanApply) and the ripperdoc clears
// it when V changes the type of arm implant (ripperdoc.script, UnequipCyberwareStyle). Unless the launcher is the arm
// V wears now, the saved style is another implant's, left alone: with several arm slots too, where the launcher may
// be installed while another arm is worn (Implant.reds), a case never seen with a style.
public func ApexGrappleLauncherStyle(player: ref<GameObject>) -> Void {
  let systems: ref<ScriptableSystemsContainer> = GameInstance.GetScriptableSystemsContainer(player.GetGame());
  let system: ref<CyberwareCustomizationSystem> = systems.Get(n"CyberwareCustomizationSystem") as CyberwareCustomizationSystem;
  if !IsDefined(system) {
    ApexGrappleLog("launcher style: the game's style system not found");
    return;
  }
  let saved: CyberwareCustomizationPersistentData = system.GetSavedData();
  let worn: Bool = ApexGrappleLauncherIsActiveArm(player);
  let laid: Bool = saved.enabled && worn;
  if laid {
    system.RestoreCyberwareCustomization(true);
  }
  ApexGrappleLog("launcher style: saved " + ToString(saved.enabled) + ", switcher " + NameToString(saved.switcherName) + " " + ToString(saved.switcherIndex) + ", V's launcher the arm worn " + ToString(worn) + ", laid again " + ToString(laid));
}
