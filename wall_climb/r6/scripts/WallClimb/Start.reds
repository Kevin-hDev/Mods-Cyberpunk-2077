// Starting a climb: forward held in the air, facing a wall within reach. One climb between two contacts with the
// ground, as in Apex Legends, unless "Grab the wall again" lets V grab a wall again after a wait (Regrab.reds).

@addField(LocomotionAirEvents)
public let wallClimbNextReport: Float;

@addMethod(LocomotionAirEvents)
private final func WallClimbTryStart(system: ref<WallClimbSystem>, settings: ref<WallClimbSettings>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, timeDelta: Float) -> Void {
  if !WallClimbPushesForward(scriptInterface) {
    return;
  }
  let now: Float = WallClimbGameTime(scriptInterface.executionOwner.GetGame());
  let regrab: Bool = stateContext.GetBoolParameter(n"wallClimbUsed", true);
  if regrab {
    let refusal: CName = WallClimbRegrabRefusal(system.climb, settings, now);
    if NotEquals(refusal, n"None") {
      if WallClimbRefusalIsNew(system, refusal) {
        WallClimbLog(NameToString(this.GetClassName()) + " no climb: " + NameToString(refusal));
      }
      return;
    }
  }
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let forward: Vector4 = WallClimbFlat(scriptInterface.GetOwnerForward());
  let wall: WallClimbWall = WallClimbFindWall(scriptInterface, feet, forward, WallClimbReach(), forward);
  if !wall.found || wall.facing > WallClimbMostFacing() {
    if regrab && !wall.hit && WallClimbRefusalIsNew(system, n"no wall to grab again") {
      WallClimbLog(NameToString(this.GetClassName()) + " no climb: no wall within " + ToString(WallClimbReach()) + " m to grab again");
    }
    this.WallClimbRefuseWall(system, wall, feet);
    return;
  }
  let ledge: ref<PlayerClimbInfo> = WallClimbGameLedge(scriptInterface);
  // A ledge already within reach is the game's climb's. Not from the fall of an edge walked off, which cannot go to
  // it (unsecureFootingFall in the locomotion tweak): there V climbs, and tops the wall with the climb's speed.
  if WallClimbLedgeInReach(ledge) && !IsDefined(this as UnsecureFootingFallEvents) {
    WallClimbOpenLedgeWindow(stateContext, now, WallClimbAirLedgeWindow(timeDelta));
    if now >= this.wallClimbNextReport {
      WallClimbLog(NameToString(this.GetClassName()) + " ledge within the game's climb: " + WallClimbWallText(wall, feet) + ", " + WallClimbLedgeShortText(ledge, feet) + ", vertical speed " + ToString(this.GetVerticalSpeed(scriptInterface)));
      this.wallClimbNextReport = now + WallClimbReportGap();
    }
    return;
  }
  let again: String = regrab ? WallClimbRegrabText(system.climb, now) : "";
  let climb: ref<WallClimbClimb> = WallClimbBegin(this.GetClassName(), now, feet, wall, settings.maxHeight);
  system.climb = climb;
  ArrayClear(system.refusalsLogged);
  stateContext.SetPermanentBoolParameter(n"wallClimbUsed", true, true);
  WallClimbRegainJumps(stateContext);
  WallClimbHolster(stateContext, climb);
  WallClimbLog(NameToString(this.GetClassName()) + " climb started: " + WallClimbWallText(wall, feet) + ", " + WallClimbLedgeShortText(ledge, feet) + ", vertical speed " + ToString(this.GetVerticalSpeed(scriptInterface)) + ", " + WallClimbSettingsText(settings) + ", weapon put away " + ToString(climb.holstered) + again);
  this.WallClimbClimbFrame(climb, settings, stateContext, scriptInterface, timeDelta);
}

// No wall within reach writes nothing: most jumps with forward held meet none. Something there that V cannot catch
// is written once per kind (Report.reds).
@addMethod(LocomotionAirEvents)
private final func WallClimbRefuseWall(system: ref<WallClimbSystem>, wall: WallClimbWall, feet: Vector4) -> Void {
  if !wall.hit {
    return;
  }
  if WallClimbRefusalIsNew(system, wall.found ? n"turned away" : n"not upright") {
    WallClimbLog(NameToString(this.GetClassName()) + " no climb: " + WallClimbWallText(wall, feet) + (wall.found ? ", turned away from it" : ""));
  }
}
