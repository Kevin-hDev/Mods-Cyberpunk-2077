// Made by fabrique/grapple.py from Apex Grapple's CrosshairRule.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// When the crosshair shows (conception, « Ce que voit le joueur »): only with empty hands or fists, nowhere the game
// hides its crosshairs (vehicle, scanner, scenes), and only while a grapple key would fire.

// The last scene tier the game shows its crosshair without a weapon in (CrosshairGameController_NoWeapon.OnState_Safe:
// Default, SceneTier1, SceneTier2).
public func CyberGrappleCrosshairLastSceneTier() -> Int32 {
  return 2;
}

// Anything in V's right hand but the fists (item type Wea_Fists). Arm cyberware draws a crosshair of its own (Kevin,
// 10 November 2026, in game), and Kevin keeps ours to empty hands and fists, the only ones without one.
public func CyberGrappleCrosshairIsArmed(record: TweakDBID) -> Bool {
  if record == TDBID.None() {
    return false;
  }
  let item: ref<Item_Record> = TweakDBInterface.GetItemRecord(record);
  if !IsDefined(item) {
    return true;
  }
  let kind: wref<ItemType_Record> = item.ItemType();
  return !IsDefined(kind) || NotEquals(kind.Type(), gamedataItemType.Wea_Fists);
}

// A profile fires when it is on and, if it asks for the projectile launcher, V has one installed (Implant.reds).
// Profile 1 is always on, and the master switch covers all five (KeyProfile.reds). The launcher is read only when
// every profile that is on asks for it. A change of the implant worn is
// told to the crosshair by the grapple's system (SettingsCopy.reds), since no event of the game tells of it.
// The settings are the mod's copy (SettingsCopy.reds); without the grapple's system no grapple fires.
public func CyberGrappleCrosshairCanFire(player: ref<GameObject>) -> Bool {
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(player.GetGame());
  if !IsDefined(system) {
    return false;
  }
  let base: ref<CyberGrappleSettings> = CyberGrappleProfileSettings(system, 1);
  if !base.enabled {
    return false;
  }
  if !base.requireLauncher {
    return true;
  }
  let p: Int32 = 2;
  while p <= CyberGrappleProfileCount() {
    let settings: ref<CyberGrappleSettings> = CyberGrappleProfileSettings(system, p);
    if system.profilesOn[p - 1] && !settings.requireLauncher {
      return true;
    }
    p += 1;
  }
  return CyberGrappleHasLauncher(player);
}

// Why the crosshair is hidden, for the log, or "" when it shows. The cheapest reads first.
public func CyberGrappleCrosshairHiddenWhy(state: ref<CyberGrappleCrosshairState>, settings: ref<CyberGrappleCrosshairSettings>) -> String {
  if Equals(settings.source, CyberGrappleCrosshairSource.Game) {
    return "its setting is off";
  }
  if state.armed {
    return "V holds a weapon or arm cyberware";
  }
  if state.vehicle != 0 {
    return "V is in a vehicle (state " + ToString(state.vehicle) + ")";
  }
  if state.sceneTier > CyberGrappleCrosshairLastSceneTier() {
    return "scene tier " + ToString(state.sceneTier);
  }
  if state.vision != 0 {
    return "the scanner is open";
  }
  let player: ref<GameObject> = state.player;
  if !IsDefined(player) {
    return "no player";
  }
  if !CyberGrappleCrosshairCanFire(player) {
    return "no profile can fire";
  }
  return "";
}
