// Made by fabrique/grapple.py from Apex Grapple's GrabHold.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The game's grab on a person brought to V (Grab.reds): the event that starts it, then each frame until it is over.
// The event is the one the game sends on its "Grab" choice (scriptedPuppet.script:2964-2970,
// playerStateMachineComponent.script:12-29), with the game's own values; the game then slides V, plays the grab
// (V holds 0.95 s after the event in every trial), shows the choices, reads the buttons and runs the execution.

// The game's grab never started this long after the event: no longer watched.
public func CyberGrappleGrabWait() -> Float {
  return 3.0;
}

public func CyberGrappleGrabSend(grab: ref<CyberGrappleGrab>, person: ref<GameObject>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let player: ref<GameObject> = scriptInterface.executionOwner;
  let puppet: ref<ScriptedPuppet> = person as ScriptedPuppet;
  let evt: ref<StartTakedownEvent>;
  if !IsDefined(puppet) {
    return;
  }
  evt = new StartTakedownEvent();
  evt.slideTime = 0.8;
  evt.target = person;
  evt.actionName = n"GrappleTarget";
  player.QueueEvent(evt);
  grab.person = person;
  grab.personID = person.GetEntityID();
  grab.sentAt = now;
  grab.begun = false;
  grab.heldAt = 0.0;
  grab.cut = false;
  grab.disposed = false;
  grab.choicesChecked = false;
  grab.choicesOurs = false;
  grab.choiceTries = 0;
  grab.choiceAt = 0.0;
  grab.choicesMade = 0;
  CyberGrappleLog("grab " + ToString(grab.count) + ": the game's grab asked, record " + TDBID.ToStringDEBUG(puppet.GetRecordID()) + ", " + CyberGrappleWhoText(person));
}

// The grab is over. A knocked-out person the game left standing is dropped as the game drops a body V carried
// (carriedObject.script:455-458): fourth trial, and 3 to 9 times a trial since. Not a body the game has taken over:
// one V picks up at the end of the grab, the game's own test (locomotionTakedown.script:1300), which ends the grab
// with the body on V's shoulder, nor one the game put away in a container (disposalDevice.script:211).
public func CyberGrappleGrabOver(grab: ref<CyberGrappleGrab>, npc: ref<NPCPuppet>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let taken: Bool = grab.disposed || (scriptInterface.HasStatFlag(gamedataStatType.CanPickUpBodyAfterTakedown) && scriptInterface.GetActionValue(n"PickUpBodyFromTakedown") > 0.0);
  let dropped: Bool = !taken && CyberGrappleKnockedOut(npc) && !npc.IsRagdolling();
  if dropped {
    npc.SetDisableRagdoll(false, true, true);
    npc.QueueEvent(CreateForceRagdollNoPowerPoseEvent(n"CyberGrapple"));
  }
  CyberGrappleLog("grab " + ToString(grab.count) + ": over " + ToString(now - grab.sentAt) + " s after the event, V held " + ToString(grab.heldAt > 0.0) + ", alive " + ToString(ScriptedPuppet.IsAlive(npc)) + ", knocked out " + ToString(CyberGrappleKnockedOut(npc)) + ", body taken over by the game " + ToString(taken) + ", left standing and dropped " + ToString(dropped) + ", the two choices ours " + ToString(grab.choicesOurs) + ", made " + ToString(grab.choicesMade) + " in " + ToString(grab.choiceTries) + " tries");
  grab.sentAt = 0.0;
}

// Each frame after the event, the person still there (GrabLost.reds otherwise). A held person does not fall: one set
// falling all the same by the time V holds has that fall cut then, once, as the game does before V carries a body
// (carriedObject.script:442-445; second trial: without it V holds nothing).
public func CyberGrappleGrabWatch(grab: ref<CyberGrappleGrab>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let player: ref<GameObject> = scriptInterface.executionOwner;
  let npc: ref<NPCPuppet> = grab.person as NPCPuppet;
  let takedown: Int32;
  if !IsDefined(npc) {
    grab.sentAt = 0.0;
    return;
  }
  takedown = CyberGrappleTakedownOf(player, scriptInterface.GetGame());
  // The game's own value while it puts the held person away in a container (disposalDevice.script:211).
  if takedown == 5 {
    grab.disposed = true;
  }
  if takedown == 2 {
    if grab.heldAt <= 0.0 {
      grab.heldAt = now;
      CyberGrappleLog("grab " + ToString(grab.count) + ": V holds the person " + ToString(now - grab.sentAt) + " s after the event");
    }
    if !grab.cut && npc.IsRagdolling() {
      grab.cut = true;
      StatusEffectHelper.RemoveStatusEffect(npc, t"BaseStatusEffect.UncontrolledMovement_Default");
      npc.QueueEvent(CreateDisableRagdollEvent(n"CyberGrapple"));
      CyberGrappleLog("grab " + ToString(grab.count) + ": the held person was falling, their fall cut");
    }
    CyberGrappleGrabChoices(grab, npc, player, now);
  }
  if takedown > 0 {
    grab.begun = true;
    return;
  }
  if grab.begun {
    CyberGrappleGrabOver(grab, npc, now, scriptInterface);
    return;
  }
  if now - grab.sentAt > CyberGrappleGrabWait() {
    CyberGrappleLog("grab " + ToString(grab.count) + ": the game's grab never started, " + ToString(now - grab.sentAt) + " s after the event");
    grab.sentAt = 0.0;
  }
}

// Each frame (Frame.reds). Nothing is read unless a grab was asked and is not over yet, or a lost one is still to be
// looked at again.
@addMethod(LocomotionEventsTransition)
private final func CyberGrappleGrabFrame(system: ref<CyberGrappleSystem>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let grab: ref<CyberGrappleGrab> = system.grab;
  if !IsDefined(grab) || (grab.sentAt <= 0.0 && grab.lostAt <= 0.0) {
    return;
  }
  if grab.lostAt > 0.0 {
    this.CyberGrappleGrabLostAgain(grab, now, stateContext, scriptInterface);
  }
  if grab.sentAt <= 0.0 {
    return;
  }
  if !IsDefined(grab.person) {
    this.CyberGrappleGrabLost(grab, now, stateContext, scriptInterface);
    return;
  }
  CyberGrappleGrabWatch(grab, now, scriptInterface);
}
