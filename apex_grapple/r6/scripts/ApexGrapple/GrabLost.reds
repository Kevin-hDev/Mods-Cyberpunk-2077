// A held person who stops existing. Eleventh trial, 11 November 2026: 1.6 s after the event the person's references
// died while V held them. V went back to standing, but what the grab had set on V stayed for good: climbing and
// jumping forbidden, and a body dragged at V's feet (Kevin's capture). Why the references died is not known; it
// happened again at the twelfth trial, and this net left V free. The grab is ended as the game ends one whose prey
// is gone (locomotionTakedown.script:105-117 and 1231-1238, 540, 1279-1283, 1346-1348).

// V is looked at once more this long after: the game may take its own grab down after the cleaning.
public func ApexGrappleGrabLostAgainAfter() -> Float {
  return 1.0;
}

// What a grab sets on V and its end takes off.
public func ApexGrappleGrabStillOnV(player: ref<GameObject>, game: GameInstance) -> Bool {
  return ApexGrappleTakedownOf(player, game) != 0 || StatusEffectSystem.ObjectHasStatusEffect(player, t"BaseStatusEffect.HumanShield");
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleGrabClean(id: EntityID, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let player: ref<GameObject> = scriptInterface.executionOwner;
  let defs: ref<AllBlackboardDefinitions> = GetAllBlackboardDefs();
  let none: EntityID;
  let mounting: MountingInfo;
  let unmount: ref<UnmountingRequest> = new UnmountingRequest();
  TakedownUtils.ExitWorkspot(scriptInterface, player);
  TakedownUtils.CleanUpGrappleState(this, stateContext, scriptInterface, id);
  mounting.childId = id;
  unmount.lowLevelMountingInfo = mounting;
  scriptInterface.GetMountingFacility().Unmount(unmount);
  this.SetBlackboardIntVariable(scriptInterface, defs.PlayerStateMachine.Takedown, 0);
  this.SetBlackboardEntityID(scriptInterface, defs.PlayerStateMachine.TakedownTargetID, none);
  // The weapon the grab put away (locomotionTakedown.script:200-202).
  stateContext.SetPermanentBoolParameter(n"forcedTemporaryUnequip", false, true);
  ApexGrappleLog("grab: V's grab ended as the game ends one whose prey is gone; still on V " + ToString(ApexGrappleGrabStillOnV(player, scriptInterface.GetGame())));
}

// The person's reference died after the event (GrabHold.reds). Never begun: the game left nothing of it on V yet,
// but its grab may still begin on the person who is gone (the event is taken a frame or two later), so V is looked
// at again in both cases.
@addMethod(LocomotionEventsTransition)
private final func ApexGrappleGrabLost(grab: ref<ApexGrappleGrab>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  ApexGrappleLog("grab " + ToString(grab.count) + ": the person stopped existing " + ToString(now - grab.sentAt) + " s after the event, the game's grab had begun " + ToString(grab.begun));
  grab.lostAt = now;
  grab.lostID = grab.personID;
  if grab.begun {
    this.ApexGrappleGrabClean(grab.lostID, stateContext, scriptInterface);
  }
  grab.sentAt = 0.0;
}

// V holds someone else by now: another grab of the mod's sent since, or the game's own grab on another person
// (the game writes whom at its grab's first frame, locomotionTakedown.script:568-569). Cleaning then would take V
// out of a sound grab.
public func ApexGrappleGrabOnAnother(grab: ref<ApexGrappleGrab>, player: ref<GameObject>, game: GameInstance) -> Bool {
  let defs: ref<AllBlackboardDefinitions> = GetAllBlackboardDefs();
  let boards: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(game);
  let board: ref<IBlackboard> = boards.GetLocalInstanced(player.GetEntityID(), defs.PlayerStateMachine);
  let held: EntityID;
  if grab.sentAt > 0.0 {
    return true;
  }
  if !IsDefined(board) {
    return false;
  }
  held = board.GetEntityID(defs.PlayerStateMachine.TakedownTargetID);
  return EntityID.IsDefined(held) && NotEquals(held, grab.lostID);
}

@addMethod(LocomotionEventsTransition)
private final func ApexGrappleGrabLostAgain(grab: ref<ApexGrappleGrab>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let player: ref<GameObject> = scriptInterface.executionOwner;
  if now - grab.lostAt < ApexGrappleGrabLostAgainAfter() {
    return;
  }
  grab.lostAt = 0.0;
  if ApexGrappleGrabOnAnother(grab, player, scriptInterface.GetGame()) {
    ApexGrappleLog("grab: V holds someone else by now, nothing is cleaned");
    return;
  }
  if ApexGrappleGrabStillOnV(player, scriptInterface.GetGame()) {
    this.ApexGrappleGrabClean(grab.lostID, stateContext, scriptInterface);
  }
}
