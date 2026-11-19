// The execution line (Voice.reds): when V kills or knocks out the person the grapple brought and the game's grab holds
// (Grab.reds), never on a grab made without the grapple. The knock-out has its line since Kevin, 19 November 2026: in
// game, putting a person down without killing them was met with silence. The game enters this state once an execution
// from its grab (locomotionTakedown.script:1177-1206): there it settles lethal or not, the player's choice or a
// knock-out it forces (ShouldForceTakedown), kills on ETakedownActionType.Takedown and knocks out on TakedownNonLethal
// (SelectSyncedAnimationAndExecuteAction, locomotionTakedown.script:469-481). Its other actions have no line, nor a
// body put away in a container, which goes by another state. Where Execution Lines takes the executions
// (VoiceExecutionLines.reds) the grapple says nothing on them, whatever the draw would have been (Kevin, 19 November
// 2026: an execution line has one authority).
@wrapMethod(TakedownExecuteTakedownEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(scriptInterface.GetGame());
  if !IsDefined(system) || ArraySize(system.profiles) == 0 {
    return;
  }
  let settings: ref<CyberGrappleSettings> = system.profiles[0];
  if !IsDefined(settings) {
    return;
  }
  // Without Audioware nothing is read either: the start of a pull already tells it is missing.
  if !CyberGrappleVoiceOn(settings) || !CyberGrappleVoiceThere() {
    return;
  }
  let action: ETakedownActionType = this.GetTakedownAction(stateContext);
  let data: wref<LocomotionTakedownInitData> = this.stateMachineInitData;
  let target: ref<GameObject>;
  if IsDefined(data) {
    target = data.target;
  }
  CyberGrappleVoiceExecution(system, settings, scriptInterface.executionOwner, target, action);
}

// Ours: our grab under way (Grab.reds: sentAt from the event to the grab's end) and the same person. Any other
// execution is told, bounded, with the game's action and whether the person was ours, so a trial shows why an
// execution had no line.
public func CyberGrappleVoiceExecution(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, player: ref<GameObject>, target: ref<GameObject>, action: ETakedownActionType) -> Void {
  let grab: ref<CyberGrappleGrab> = system.grab;
  let ours: Bool = IsDefined(grab) && grab.sentAt > 0.0 && IsDefined(target) && Equals(target.GetEntityID(), grab.personID);
  let kill: Bool = Equals(action, ETakedownActionType.Takedown);
  let knockOut: Bool = Equals(action, ETakedownActionType.TakedownNonLethal);
  if ours && (kill || knockOut) {
    if CyberGrappleExecutionLinesHandle(system.GetGameInstance()) {
      CyberGrappleVoiceHandedOver(system, CyberGrappleVoiceOccasion(knockOut));
      return;
    }
    CyberGrappleVoiceKill(system, settings, player, knockOut);
    return;
  }
  if system.voiceNoneLines <= CyberGrappleVoiceMostLines() {
    CyberGrappleVoiceNone(system, "an execution", "the game's action " + NameToString(EnumValueToName(n"ETakedownActionType", Cast<Int64>(EnumInt(action)))) + ", the person the grapple brought " + ToString(ours));
  }
}
