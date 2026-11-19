// The execution line (Voice.reds): when V kills or knocks out the person the grapple brought and the game's grab holds
// (Grab.reds), never on a grab made without the grapple. The knock-out has its line since Kevin, 19 November 2026 ("ce
// serasi bien que les execution non letal ai aussi les replique"). The game enters this state once an execution
// from its grab (locomotionTakedown.script:1177-1206): there it settles lethal or not, the player's choice or a
// knock-out it forces (ShouldForceTakedown), kills on ETakedownActionType.Takedown and knocks out on TakedownNonLethal
// (SelectSyncedAnimationAndExecuteAction, locomotionTakedown.script:469-481). Its other actions have no line, nor a
// body put away in a container, which goes by another state.
@wrapMethod(TakedownExecuteTakedownEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(scriptInterface.GetGame());
  if !IsDefined(system) {
    return;
  }
  // The settings of the grapple that brought the person, set at its shot and kept until the next one, the master
  // switch kept live in them (KeyProfile.reds); profile 1's before any shot this load.
  let settings: ref<ApexGrappleSettings> = ApexGrappleGrappleSettings(system);
  // Without Audioware nothing is read either: the log said it at the load (VoicePlay.reds).
  if !ApexGrappleVoiceOn(settings) || !ApexGrappleVoiceThere() {
    return;
  }
  let action: ETakedownActionType = this.GetTakedownAction(stateContext);
  let data: wref<LocomotionTakedownInitData> = this.stateMachineInitData;
  let target: ref<GameObject>;
  if IsDefined(data) {
    target = data.target;
  }
  ApexGrappleVoiceExecution(system, settings, scriptInterface.executionOwner, target, action);
}

// Ours: our grab under way (Grab.reds: sentAt from the event to the grab's end) and the same person. Any other
// execution is told, bounded, with the game's action and whether the person was ours, so a trial shows why an
// execution had no line.
public func ApexGrappleVoiceExecution(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, player: ref<GameObject>, target: ref<GameObject>, action: ETakedownActionType) -> Void {
  let grab: ref<ApexGrappleGrab> = system.grab;
  let ours: Bool = IsDefined(grab) && grab.sentAt > 0.0 && IsDefined(target) && Equals(target.GetEntityID(), grab.personID);
  let kill: Bool = Equals(action, ETakedownActionType.Takedown);
  let knockOut: Bool = Equals(action, ETakedownActionType.TakedownNonLethal);
  if ours && (kill || knockOut) {
    // Execution Lines says it: no draw, so that the bag's series and the last line are left as they were.
    if IsDefined(player) && ApexGrappleExecutionLinesHandle(player.GetGame()) {
      ApexGrappleVoiceHandedOver(system, knockOut ? "a knock-out" : "an execution");
      return;
    }
    ApexGrappleVoiceKill(system, settings, player, knockOut);
    return;
  }
  if system.voiceNoneLines <= ApexGrappleVoiceMostLines() {
    ApexGrappleVoiceNone(system, "an execution", "the game's action " + NameToString(EnumValueToName(n"ETakedownActionType", Cast<Int64>(EnumInt(action)))) + ", the person the grapple brought " + ToString(ours));
  }
}
