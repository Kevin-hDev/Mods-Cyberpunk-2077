// Climbing a wall in the air. V stays in the game's air states; at every frame of the climb the mod sets V's speed
// along the wall from the stick: up, and to the side for the diagonals. The climb starts in Start.reds; the game's
// climb takes the ledge at the top (Ledge.reds). Every air state of the game derives from LocomotionAirEvents and
// calls its OnUpdate (scripts 2.5).

public func WallClimbClimbSpeed() -> Float {
  return 5.0;
}

// Facing further from the wall than this ends the climb: V has turned away from it.
public func WallClimbMostTurn() -> Float {
  return 90.0;
}

// The wall or the stick lost for WallClimbReleaseGrace counts only after this many frames: one long frame would use up
// the grace at once.
public func WallClimbLeastFramesLost() -> Int32 {
  return 2;
}

// Thrusters, hovering, the superhero fall, the body slam and the fall while holding someone in a takedown
// (GrappleFallEvents, scripts 2.5) move V their own way.
@addMethod(LocomotionAirEvents)
private final func WallClimbMovesHere() -> Bool {
  return !IsDefined(this as AirThrustersEvents) && !IsDefined(this as AirHoverEvents) && !IsDefined(this as SuperheroFallEvents) && !IsDefined(this as BodySlamJumpEvents) && !IsDefined(this as GrappleFallEvents);
}

@wrapMethod(LocomotionAirEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  let system: ref<WallClimbSystem> = WallClimbSystemOf(scriptInterface);
  if !IsDefined(system) {
    return;
  }
  let climb: ref<WallClimbClimb> = system.climb;
  let onWall: Bool = IsDefined(climb) && climb.onWall;
  if IsDefined(climb) && !onWall {
    this.WallClimbJumpPressed(climb, stateContext, scriptInterface);
  }
  // Most air frames: no climb, and forward not held.
  if !IsDefined(climb) && !WallClimbPushesForward(scriptInterface) {
    return;
  }
  let settings: ref<WallClimbSettings> = WallClimbCurrentSettings();
  if onWall {
    this.WallClimbClimbFrame(climb, settings, stateContext, scriptInterface, timeDelta);
  } else {
    if !settings.enabled {
      // Switched off in the fall after a climb: the fall is the game's again, damage included, and the darkening unless
      // V already falls faster than a hard landing's speed (the game starts it on reaching that speed).
      if IsDefined(climb) {
        system.climb = null;
        WallClimbLog("the mod was switched off: the fall after the climb is the game's");
      }
      return;
    }
    // The ladder jumps leave a ladder: a real one, or ours when V lets go of it.
    if this.WallClimbMovesHere() && !IsDefined(this as LadderJumpEvents) && !this.IsTouchingGround(scriptInterface) {
      this.WallClimbTryStart(system, settings, stateContext, scriptInterface, timeDelta);
    }
  }
  climb = system.climb;
  if IsDefined(climb) && settings.softLanding {
    this.WallClimbSoftenLanding(climb, stateContext, scriptInterface);
  }
}

@addMethod(LocomotionAirEvents)
private final func WallClimbClimbFrame(climb: ref<WallClimbClimb>, settings: ref<WallClimbSettings>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, timeDelta: Float) -> Void {
  if !settings.enabled {
    this.WallClimbLetGo(climb, stateContext, scriptInterface, "the mod was switched off", true);
    return;
  }
  if !this.WallClimbMovesHere() {
    this.WallClimbLetGo(climb, stateContext, scriptInterface, NameToString(this.GetClassName()) + " moves V its own way", false);
    return;
  }
  let now: Float = WallClimbGameTime(scriptInterface.executionOwner.GetGame());
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  // As V will face once the view has turned with the corners passed.
  let forward: Vector4 = WallClimbTurned(WallClimbFlat(scriptInterface.GetOwnerForward()), climb.viewTurnLeft);
  let lost: String = "the wall ended";
  if climb.rounding {
    WallClimbRound(climb, scriptInterface, feet, now);
  } else {
    let wall: WallClimbWall = WallClimbFindWall(scriptInterface, feet, climb.normal * -1.0, WallClimbFollowReach(climb, feet), forward);
    let sameWall: Bool = wall.found && Vector4.Dot(wall.normal, climb.normal) >= WallClimbLeastSameWall();
    if sameWall && wall.facing <= WallClimbMostTurn() {
      climb.normal = wall.normal;
      climb.slant = wall.slant;
      climb.wallPoint = wall.face;
      climb.wallSeenAt = now;
      WallClimbTakeInsideCorner(climb, scriptInterface, feet, now);
      WallClimbWatchOverhang(climb, scriptInterface, feet, now);
    } else {
      if sameWall {
        lost = "turned away from the wall";
      } else {
        if !WallClimbStepIn(climb, scriptInterface, feet, forward, now) {
          WallClimbFindEdge(climb, scriptInterface, feet, now);
        }
      }
    }
  }
  climb.framesLost = climb.wallSeenAt == now ? 0 : climb.framesLost + 1;
  // At the top the climb's speed carries V over the edge, so it is kept.
  if now - climb.wallSeenAt > WallClimbReleaseGrace() && climb.framesLost >= WallClimbLeastFramesLost() {
    this.WallClimbLetGo(climb, stateContext, scriptInterface, lost, false);
    return;
  }
  WallClimbTurnView(climb, stateContext, scriptInterface, timeDelta);
  let keys: Vector4 = WallClimbMoveKeys(scriptInterface);
  if WallClimbPushesBack(keys) {
    this.WallClimbLetGo(climb, stateContext, scriptInterface, "back pushed", true);
    return;
  }
  if feet.Z >= climb.letGoZ {
    this.WallClimbLetGo(climb, stateContext, scriptInterface, "highest climb reached", true);
    return;
  }
  if WallClimbLedgeInReach(WallClimbGameLedge(scriptInterface)) {
    WallClimbOpenLedgeWindow(stateContext, now, WallClimbAirLedgeWindow(timeDelta));
  }
  let stick: Vector4 = WallClimbStickOnWall(keys);
  if !Vector4.IsZero(stick) {
    climb.stickAt = now;
    climb.stickFramesLost = 0;
    climb.up = stick.Y * WallClimbClimbSpeed() * settings.climbSpeed;
    climb.side = WallClimbCornerSide(climb, stick.X * WallClimbClimbSpeed() * settings.climbSpeed);
    if climb.stopping {
      WallClimbResume(climb, stateContext, scriptInterface, now, "before our ladder was taken");
    }
  } else {
    climb.stickFramesLost = climb.stickFramesLost + 1;
    if now - climb.stickAt > WallClimbReleaseGrace() && climb.stickFramesLost >= WallClimbLeastFramesLost() {
      if !settings.holdOn {
        this.WallClimbLetGo(climb, stateContext, scriptInterface, "stick released", true);
        return;
      }
      this.WallClimbStop(climb, stateContext, scriptInterface, feet, now);
      return;
    }
  }
  WallClimbPush(climb, stateContext, scriptInterface, feet, climb.up, climb.side, timeDelta);
  WallClimbSwapHands(climb, scriptInterface, now, settings.climbSpeed);
  WallClimbReportClimbing(climb, scriptInterface, this.GetClassName(), now, feet, stick);
}

// `stop`: V falls from where it is (Kevin's choice at the 25 October audit); else V keeps its speed, as over the top.
@addMethod(LocomotionAirEvents)
private final func WallClimbLetGo(climb: ref<WallClimbClimb>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, reason: String, stop: Bool) -> Void {
  if stop {
    WallClimbStopPush(climb, stateContext, scriptInterface);
  }
  WallClimbEnd(climb, stateContext, scriptInterface, reason);
}
