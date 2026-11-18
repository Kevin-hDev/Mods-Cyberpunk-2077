// One copy of the settings for the whole mod, kept in the grapple's system (Hook.reds), under the names the
// grapple's code calls (made from Apex Grapple's, fabrique/grapple.py). One profile here: the menu's values (switch,
// key, view), and on top of them what the tier of the worn implant allows (Tiers.reds).
// The copy is made as the system attaches, each time Mod Settings tells of a change, and when the tier worn has
// changed: each time as new objects, never changed in place, so a grapple keeps the settings of its shot through its
// landing and the next shot reads the new tier.

// The tier worn at the last copy, -1 while there was no player to read it from, and the charges it holds
// (Recharge.reds).
@addField(CyberGrappleSystem)
public let wornTier: Int32;

@addField(CyberGrappleSystem)
public let wornCharges: Int32;

// When the tier was last read, and the grapple's frame (system.frames, counted by Frame.reds) it was last asked in.
@addField(CyberGrappleSystem)
public let wornTierReadAt: Float;

@addField(CyberGrappleSystem)
public let wornTierAskedIn: Int32;

// Whether the gadget key is to be looked at for an implant of ours a save kept there (GadgetQuickslot.reds), and the
// lines the log has told of a key given back.
@addField(CyberGrappleSystem)
public let gadgetKeyBackDue: Bool;

@addField(CyberGrappleSystem)
public let gadgetKeyBackLines: Int32;

// The worn implant and the other launcher-type arm last written to the log (CyberGrappleWornTell), and its lines.
@addField(CyberGrappleSystem)
public let wornTold: Bool;

@addField(CyberGrappleSystem)
public let wornToldID: ItemID;

@addField(CyberGrappleSystem)
public let wornToldOther: Bool;

@addField(CyberGrappleSystem)
public let wornLines: Int32;

public func CyberGrappleWornMostLines() -> Int32 {
  return 20;
}

// The tier is read again at most this often, in seconds: an implant changes hands in a ripperdoc's screen, never
// between two frames.
public func CyberGrappleTierEvery() -> Float {
  return 0.5;
}

public class CyberGrappleSettingsWatch extends IScriptable {
  public let system: wref<CyberGrappleSystem>;

  public cb func OnModSettingsChange() -> Void {
    let system: ref<CyberGrappleSystem> = this.system;
    if IsDefined(system) {
      CyberGrappleSettingsChanged(system);
    }
  }
}

@if(ModuleExists("ModSettingsModule"))
public func CyberGrappleSettingsWatchStart(watch: ref<CyberGrappleSettingsWatch>) -> Void {
  ModSettings.RegisterListenerToModifications(watch);
}

@if(ModuleExists("ModSettingsModule"))
public func CyberGrappleSettingsWatchStop(watch: ref<CyberGrappleSettingsWatch>) -> Void {
  if IsDefined(watch) {
    ModSettings.UnregisterListenerToModifications(watch);
  }
}

@if(!ModuleExists("ModSettingsModule"))
public func CyberGrappleSettingsWatchStart(watch: ref<CyberGrappleSettingsWatch>) -> Void {}

@if(!ModuleExists("ModSettingsModule"))
public func CyberGrappleSettingsWatchStop(watch: ref<CyberGrappleSettingsWatch>) -> Void {}

// A new copy, then the crosshair told to look again at whether it shows (CrosshairEvents.reds) and the gadget slots
// whether to show the key's hint (SlotCharges.reds): after a change in the menu, and after a change of the tier worn,
// which no event of the game tells them.
public func CyberGrappleSettingsChanged(system: ref<CyberGrappleSystem>) -> Void {
  CyberGrappleCopySettings(system);
  let controller: ref<CrosshairGameControllerPersistentDot> = system.crosshairHost;
  if IsDefined(controller) {
    controller.CyberGrappleCrosshairRefresh();
  }
  CyberGrappleSlotHints(system);
}

// A new copy at once when the arm V wears is not the tier kept: for an answer that cannot wait for the next reading
// (LauncherCharges.reds). Never during a grapple, whose tier is not read again before it ends (below).
public func CyberGrappleKeepTierOf(system: ref<CyberGrappleSystem>, worn: ItemID) -> Void {
  if system.phase == CyberGrappleIdle() && CyberGrappleTier(worn) != system.wornTier {
    CyberGrappleSettingsChanged(system);
  }
}

// The tier V wears; -1 with no player to read it from, as when the system attaches at a load, before V exists. During
// a grapple the tier kept is given back, never read: a tier of 0 turns the master switch off, which the hook in flight
// and the pull read live (KeyProfile.reds).
public func CyberGrappleWornTier(system: ref<CyberGrappleSystem>) -> Int32 {
  if system.phase != CyberGrappleIdle() {
    return system.wornTier;
  }
  let player: ref<PlayerPuppet> = GetPlayer(system.GetGameInstance());
  if !IsDefined(player) {
    return -1;
  }
  return CyberGrappleTier(CyberGrappleWornArm(player));
}

public func CyberGrappleCopySettings(system: ref<CyberGrappleSystem>) -> Void {
  let base: ref<CyberGrappleSettings> = new CyberGrappleSettings();
  let tier: Int32 = CyberGrappleWornTier(system);
  CyberGrappleApplyTier(base, tier);
  let charges: Int32 = tier > 0 ? RoundF(CyberGrappleTierValue(CyberGrappleCharges(), tier)) : 0;
  // The reasons the mod stays silent, and no implant of ours worn, are read as the master switch off: every path of
  // the grapple already stops on it. Without the implant nothing is told on screen: a player who has not bought it
  // has the game as it is.
  let other: String = CyberGrappleOtherGrapple();
  let silent: String = CyberGrappleSilentWhy(other);
  let wanted: Bool = base.enabled;
  if StrLen(silent) > 0 || tier <= 0 {
    base.enabled = false;
  }
  let profiles: array<ref<CyberGrappleSettings>>;
  ArrayPush(profiles, base);
  let on: array<Bool>;
  ArrayPush(on, true);
  let keys: array<EInputKey>;
  ArrayPush(keys, base.ownKey ? base.key : EInputKey.IK_None);
  system.profiles = profiles;
  system.profilesOn = on;
  system.ownKeys = keys;
  system.anyOwnKey = base.ownKey;
  system.settingsVersion = system.settingsVersion + 1;
  // The first reading of a load, with V there to read: no player before it, or the first copy. A removal later is
  // caught as it happens (GadgetQuickslot.reds).
  if tier >= 0 && (system.wornTier < 0 || system.settingsVersion == 1) {
    system.gadgetKeyBackDue = true;
  }
  system.wornTier = tier;
  system.wornCharges = charges;
  system.otherGrapple = other;
  system.wornTierReadAt = CyberGrappleTime(system.GetGameInstance());
  // Every copy is written: they come at a load, at a change in the menu and at a change of implant, never by frames.
  CyberGrappleLog("settings copied: implant tier " + ToString(tier) + " of " + ToString(CyberGrappleTierCount()) + ", range " + ToString(RoundF(base.range)) + " m, top speed " + FloatToStringPrec(base.pullSpeedCap, 1) + ", pulls within " + ToString(RoundF(base.pullRange)) + " m, " + ToString(charges) + " charges of " + ToString(RoundF(CyberGrappleRechargeTime())) + " s, switch " + ToString(wanted) + ", Apex Grapple " + other + CyberGrappleLiveText(silent, tier, wanted));
}

// The end of the copy's line in the log: whether the grapple is live, and if not why.
public func CyberGrappleLiveText(silent: String, tier: Int32, wanted: Bool) -> String {
  if StrLen(silent) > 0 {
    return ", silent: " + silent;
  }
  if tier < 0 {
    return ", grapple off: no player yet to read the implant from";
  }
  if tier == 0 {
    return ", grapple off: V wears no implant of ours (tier 0)";
  }
  return ", grapple " + (wanted ? "live" : "off");
}

// The one profile's settings, whatever the number asked. Called each frame by the key's reading (KeyProfile.reds), and
// on the crosshair's events. Between grapples only (CyberGrappleWornTier), the worn implant is looked at again, with
// the item on the gadget key (GadgetQuickslot.reds), which is given back to the game if it holds an implant of ours V
// no longer wears, and the player told why the mod stays silent (Silence.reds) or that an upgrade's level could not be
// read (Upgrade.reds).
public func CyberGrappleProfileSettings(system: ref<CyberGrappleSystem>, profile: Int32) -> ref<CyberGrappleSettings> {
  if ArraySize(system.profiles) != CyberGrappleProfileCount() {
    CyberGrappleCopySettings(system);
    return system.profiles[0];
  }
  if system.phase == CyberGrappleIdle() && CyberGrappleTierToRead(system) {
    if CyberGrappleWornTier(system) != system.wornTier {
      CyberGrappleSettingsChanged(system);
    }
    CyberGrappleGadgetKeyRead(system);
    CyberGrappleGadgetKeyGiveBack(system);
    CyberGrappleWornTell(system);
    CyberGrappleSilentTell(system);
    CyberGrappleUpgradeTell(system);
  }
  return system.profiles[0];
}

// The proof for a trial with several arm slots: the family the game reads on the worn implant's record, which decides
// whether the game's launcher fits beside it (equipmentSystem.script:765-771), and whether one is worn. Written when
// the worn implant is first read in a load, and when it or the other launcher-type arm changes, which may leave the
// tier as it was. Without an implant of ours, the copy's line says so (tier 0).
public func CyberGrappleWornTell(system: ref<CyberGrappleSystem>) -> Void {
  if system.wornTier <= 0 || system.wornLines > CyberGrappleWornMostLines() {
    return;
  }
  let player: ref<PlayerPuppet> = GetPlayer(system.GetGameInstance());
  let worn: ItemID = CyberGrappleWornArm(player);
  if !CyberGrappleIsImplant(worn) {
    return;
  }
  let other: Bool = CyberGrappleOtherLauncherWorn(player);
  if system.wornTold && worn == system.wornToldID && Equals(other, system.wornToldOther) {
    return;
  }
  system.wornTold = true;
  system.wornToldID = worn;
  system.wornToldOther = other;
  let record: TweakDBID = ItemID.GetTDBID(worn);
  system.wornLines = CyberGrappleLogUpTo(system.wornLines, CyberGrappleWornMostLines(), "worn implant", "worn implant read: " + TDBID.ToStringDEBUG(record) + ", tier " + ToString(system.wornTier) + ", family " + NameToString(TweakDBInterface.GetCName(record + t".cyberwareType", n"None")) + ", another launcher-type arm worn " + ToString(other));
}

// Whether the worn tier is to be read now: at once while it could not be read for want of a player; else at most
// twice a second, the clock read once in each of the grapple's frames, never on an event between two frames. Marked
// read before the reading: the crosshair it may refresh asks again (CyberGrappleSettingsChanged).
public func CyberGrappleTierToRead(system: ref<CyberGrappleSystem>) -> Bool {
  if system.wornTier < 0 {
    return true;
  }
  if system.wornTierAskedIn == system.frames {
    return false;
  }
  system.wornTierAskedIn = system.frames;
  let now: Float = CyberGrappleTime(system.GetGameInstance());
  if AbsF(now - system.wornTierReadAt) < CyberGrappleTierEvery() {
    return false;
  }
  system.wornTierReadAt = now;
  return true;
}

// The own key's place this frame. With no own key set and no press or grapple under way, nothing could be pressed or
// held there: the listener is not asked.
public func CyberGrappleOwnKeysFor(system: ref<CyberGrappleSystem>, game: GameInstance) -> array<CyberGrappleOwnKey> {
  if !system.anyOwnKey && CyberGrappleKeyFree(system) {
    return CyberGrappleNoOwnKeys();
  }
  return CyberGrappleOwnKeysNow(game);
}
