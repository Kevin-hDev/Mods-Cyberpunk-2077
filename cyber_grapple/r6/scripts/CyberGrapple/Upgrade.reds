// The game upgrades an arm implant for components alone, whatever V's level (rpgManager.script,
// CanUpgradeCyberware). Each tier of ours unlocks a function meant for a level of V, so for our implant only, a
// full tier also asks for the level at which the game starts selling that quality at ripperdocs. That level is read
// from the game's own sale rule: one authority, and a mod that moves those levels moves ours with them. The plus
// tiers stay free. The game answers first: this only ever turns its yes into a no, and leaves every other item alone.
// A rule that can no longer be read, after an update of the game, turns this off for its quality, never guessed
// (conception.md, rule 14): the log names the rule and the player is told once a load.

// The sale rules found unreadable this load, each written to the log once: four at most, one a quality.
@addField(CyberGrappleSystem)
public let rulesUnread: array<TweakDBID>;

// The player is still to be told of a rule found unreadable (CyberGrappleUpgradeTell).
@addField(CyberGrappleSystem)
public let upgradeToTell: Bool;

// The game's sale rule that names the lowest level of V a quality is sold from; none for Common, sold at any level,
// and none for the plus tiers. "None" is TDBID.None(), never a local left without a value: in game such a local is
// not empty, it held an id of the game's own scripts that TDBID.IsValid takes for a real one (seen 17 November 2026),
// so each plus tier was told to the player as a rule that could not be read.
public func CyberGrappleSaleRule(quality: gamedataQuality) -> TweakDBID {
  switch quality {
    case gamedataQuality.Uncommon:
      return t"LootPrereqs.UncommonCWLevelAvailabilityAtVendor";
    case gamedataQuality.Rare:
      return t"LootPrereqs.RareCWLevelAvailabilityAtVendor";
    case gamedataQuality.Epic:
      return t"LootPrereqs.EpicCWLevelAvailabilityAtVendor";
    case gamedataQuality.Legendary:
      return t"LootPrereqs.LegendaryCWLevelAvailabilityAtVendor";
    default:
      return TDBID.None();
  }
}

// The lowest level of V a sale rule names, as its part "Level, GreaterOrEqual"; -1 when the rule is missing or has no
// such part.
public func CyberGrappleLevelAsked(rule: TweakDBID) -> Float {
  let whole: ref<MultiPrereq_Record> = TweakDBInterface.GetIPrereqRecord(rule) as MultiPrereq_Record;
  if !IsDefined(whole) {
    return -1.0;
  }
  let parts: array<wref<IPrereq_Record>>;
  whole.NestedPrereqs(parts);
  let i: Int32 = 0;
  while i < ArraySize(parts) {
    let part: wref<StatPrereq_Record> = parts[i] as StatPrereq_Record;
    if IsDefined(part) && Equals(part.StatType(), n"Level") && Equals(part.ComparisonType(), n"GreaterOrEqual") {
      return part.ValueToCheck();
    }
    i += 1;
  }
  return -1.0;
}

// A sale rule that cannot be read: its name to the log once a load, and the player to be told once a load.
public func CyberGrappleRuleUnread(owner: ref<GameObject>, rule: TweakDBID) -> Void {
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(owner.GetGame());
  if !IsDefined(system) || ArrayContains(system.rulesUnread, rule) {
    return;
  }
  if ArraySize(system.rulesUnread) == 0 {
    system.upgradeToTell = true;
  }
  ArrayPush(system.rulesUnread, rule);
  CyberGrappleLog("upgrade: the game's sale rule " + TDBID.ToStringDEBUG(rule) + " is missing or names no level of V (no part Level, GreaterOrEqual): this upgrade asks for no level");
}

// Called from the place that reads the worn tier (SettingsCopy.reds), which runs only while the game's clock moves:
// the game asks about an upgrade with a ripperdoc's screen or the inventory open, and its on-screen message belongs
// to the display of play (onscreenMessage.script), so the message waits for the screen to close. By the texts of
// Texts.reds; without Codeware, the message that it is missing says enough (Silence.reds).
public func CyberGrappleUpgradeTell(system: ref<CyberGrappleSystem>) -> Void {
  if !system.upgradeToTell {
    return;
  }
  system.upgradeToTell = false;
  if CyberGrappleTextsThere() {
    CyberGrappleTellOnScreen(system.GetGameInstance(), GetLocalizedTextByKey(n"CyberGrapple-Upgrade-Waiting"));
  }
}

// The level the game's rules read (a stat on V), as the sale rules do.
public func CyberGrappleLevelStat(owner: ref<GameObject>) -> Float {
  return GameInstance.GetStatsSystem(owner.GetGame()).GetStatValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatType.Level);
}

// The level the menus show (hubMenuGameController.script). In an untouched game the two are equal. They were seen
// apart, 60 on screen with a stat of 30 (in game, 16 November 2026); the cause is supposed, not established: a save
// changed by an editor or a console command.
public func CyberGrappleLevelShown(owner: ref<GameObject>) -> Float {
  let system: ref<PlayerDevelopmentSystem> = PlayerDevelopmentSystem.GetInstance(owner);
  if !IsDefined(system) {
    return 0.0;
  }
  return Cast<Float>(system.GetProficiencyLevel(owner, gamedataProficiencyType.Level));
}

// The higher of the two: the player is never refused below the level the screen shows.
public func CyberGrappleLevelOf(owner: ref<GameObject>) -> Float {
  return MaxF(CyberGrappleLevelStat(owner), CyberGrappleLevelShown(owner));
}

@wrapMethod(RPGManager)
public final static func CanUpgradeCyberware(owner: ref<GameObject>, itemID: ItemID, isEquipped: Bool, selectedQuality: gamedataQuality, out upgradeItemQuality: gamedataQuality, out upgradeItemRecord: ref<Item_Record>, out costData: CyberwareUpgradeCostData, opt updateOutputOnFailure: Bool) -> Bool {
  let can: Bool = wrappedMethod(owner, itemID, isEquipped, selectedQuality, upgradeItemQuality, upgradeItemRecord, costData, updateOutputOnFailure);
  if !CyberGrappleIsImplant(itemID) {
    return can;
  }
  if !can {
    return false;
  }
  // The quality judged is the one written in the record V would get, as the game reads it for the cost
  // (CanAffordAndPerformCyberwareUpgrade), not the one counted up from the worn item.
  let rule: TweakDBID = CyberGrappleSaleRule(upgradeItemRecord.QualityHandle().Type());
  if !TDBID.IsValid(rule) {
    return true;
  }
  let asked: Float = CyberGrappleLevelAsked(rule);
  if asked < 0.0 {
    CyberGrappleRuleUnread(owner, rule);
    return true;
  }
  if CyberGrappleLevelOf(owner) >= asked {
    return true;
  }
  // A refusal leaves the three results as the game leaves them when it refuses by itself.
  if !updateOutputOnFailure {
    let noQuality: gamedataQuality;
    let noRecord: ref<Item_Record>;
    let noCost: CyberwareUpgradeCostData;
    upgradeItemQuality = noQuality;
    upgradeItemRecord = noRecord;
    costData = noCost;
  }
  return false;
}
