// When the crosshair shows (conception, « Ce que voit le joueur »): only with empty hands or fists, nowhere the game
// hides its crosshairs (vehicle, scanner, scenes), and only while a grapple key would fire.

// The last scene tier the game shows its crosshair without a weapon in (CrosshairGameController_NoWeapon.OnState_Safe:
// Default, SceneTier1, SceneTier2).
public func ApexGrappleCrosshairLastSceneTier() -> Int32 {
  return 2;
}

// Anything in V's right hand but the fists (item type Wea_Fists). Arm cyberware draws a crosshair of its own (Kevin,
// 10 November 2026, in game), and Kevin keeps ours to empty hands and fists, the only ones without one.
public func ApexGrappleCrosshairIsArmed(record: TweakDBID) -> Bool {
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
// every profile that is on asks for it. Installing a launcher changes nothing until the next event the crosshair
// listens to (Crosshair.reds): none tells of it.
// The settings are the mod's copy (SettingsCopy.reds); without the grapple's system no grapple fires.
public func ApexGrappleCrosshairCanFire(player: ref<GameObject>) -> Bool {
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(player.GetGame());
  if !IsDefined(system) {
    return false;
  }
  let base: ref<ApexGrappleSettings> = ApexGrappleProfileSettings(system, 1);
  if !base.enabled {
    return false;
  }
  if !base.requireLauncher {
    return true;
  }
  let p: Int32 = 2;
  while p <= ApexGrappleProfileCount() {
    let settings: ref<ApexGrappleSettings> = ApexGrappleProfileSettings(system, p);
    if system.profilesOn[p - 1] && !settings.requireLauncher {
      return true;
    }
    p += 1;
  }
  return ApexGrappleHasLauncher(player);
}

// Why the crosshair is hidden, for the log, or "" when it shows. The cheapest reads first.
public func ApexGrappleCrosshairHiddenWhy(state: ref<ApexGrappleCrosshairState>, settings: ref<ApexGrappleCrosshairSettings>) -> String {
  if Equals(settings.shape, ApexGrappleCrosshairShape.Off) {
    return "its setting is off";
  }
  if state.armed {
    return "V holds a weapon or arm cyberware";
  }
  if state.vehicle != 0 {
    return "V is in a vehicle (state " + ToString(state.vehicle) + ")";
  }
  if state.sceneTier > ApexGrappleCrosshairLastSceneTier() {
    return "scene tier " + ToString(state.sceneTier);
  }
  if state.vision != 0 {
    return "the scanner is open";
  }
  let player: ref<GameObject> = state.player;
  if !IsDefined(player) {
    return "no player";
  }
  if !ApexGrappleCrosshairCanFire(player) {
    return "no profile can fire";
  }
  return "";
}
