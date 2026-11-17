// Tells the player on screen why the implant does nothing (Prerequisites.reds), once a load, one cause a message:
// - Codeware missing: at every load, whether V wears the implant or not, since the implant is seen in a ripperdoc's
//   list before it is worn;
// - the implant's records missing: TweakXL not installed, or installed and the records not made for this version of
//   the game;
// - Apex Grapple switched on, or its switch unreadable: only while V wears the implant. A player who keeps both
//   grapple mods and plays with the other one is told nothing.
// What was read of Apex Grapple is kept at each copy of the settings (SettingsCopy.reds). This is called from the
// place that reads the worn tier, twice a second at most once V exists. Once it has spoken it stops at its first test;
// while it has nothing to say, each call looks for the player and for one record.

@addField(CyberGrappleSystem)
public let otherGrapple: String;

@addField(CyberGrappleSystem)
public let silentTold: Bool;

// The first tier's record, which TweakXL makes from this mod's file (r6/tweaks/CyberGrapple/implants.yaml).
public func CyberGrappleFirstRecord() -> String {
  return "Items.CyberGrappleCommon";
}

public func CyberGrappleRecordsMade() -> Bool {
  return IsDefined(TweakDBInterface.GetItemRecord(TDBID.Create(CyberGrappleFirstRecord())));
}

// Whether TweakXL is installed, by the module it declares to the scripts (TweakXL.reds, beside its plugin). Without
// RED4ext, which loads TweakXL, the module is missing too.
@if(ModuleExists("TweakXL"))
public func CyberGrappleTweakXLThere() -> Bool {
  return true;
}

@if(!ModuleExists("TweakXL"))
public func CyberGrappleTweakXLThere() -> Bool {
  return false;
}

// made: whether the implant's records exist (CyberGrappleRecordsMade).
@if(ModuleExists("Codeware"))
public func CyberGrappleSilentText(system: ref<CyberGrappleSystem>, made: Bool) -> String {
  if !made {
    if CyberGrappleTweakXLThere() {
      return GetLocalizedTextByKey(n"CyberGrapple-Silent-NoRecords");
    }
    return GetLocalizedTextByKey(n"CyberGrapple-Silent-NoTweakXL");
  }
  if system.wornTier <= 0 {
    return "";
  }
  let other: String = system.otherGrapple;
  if Equals(other, "absent") || Equals(other, "off") {
    return "";
  }
  if Equals(other, "on") {
    return GetLocalizedTextByKey(n"CyberGrapple-Silent-OtherOn");
  }
  return GetLocalizedTextByKey(n"CyberGrapple-Silent-OtherUnread");
}

// Without Codeware nothing of this mod is translated: the one text it can still show is in English, and it is the one
// cause told, whatever else is missing.
@if(!ModuleExists("Codeware"))
public func CyberGrappleSilentText(system: ref<CyberGrappleSystem>, made: Bool) -> String {
  return "The grapple implant needs Codeware, which is not installed. Install Codeware to use the implant.";
}

public func CyberGrappleSilentTell(system: ref<CyberGrappleSystem>) -> Void {
  if system.silentTold {
    return;
  }
  let game: GameInstance = system.GetGameInstance();
  if !IsDefined(GetPlayer(game)) {
    return;
  }
  let made: Bool = CyberGrappleRecordsMade();
  let text: String = CyberGrappleSilentText(system, made);
  if StrLen(text) == 0 {
    return;
  }
  system.silentTold = true;
  if !made {
    CyberGrappleLog("the implant's record " + CyberGrappleFirstRecord() + " does not exist, TweakXL " + (CyberGrappleTweakXLThere() ? "installed" : "not installed"));
  }
  CyberGrappleTellOnScreen(game, text);
  CyberGrappleLog("told on screen why the grapple is silent: " + text);
}
