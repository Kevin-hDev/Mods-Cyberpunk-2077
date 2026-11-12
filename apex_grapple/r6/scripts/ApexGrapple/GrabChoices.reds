// The game's two execution choices, kill and non-lethal, on a held person the game gives none. Kevin, 12 November
// 2026 (twentieth trial): passers-by are grabbed and held, "les deux touche pour kill et non letal execution
// n'apparaissent pas pour les passents, faudrais les ajouter", and the police's robots too: "faudrais qu'on puisse
// les executer et les tuer en pleine saisie".
// Read in the game's data on 12 November 2026 (tweakdb_ep1.bin of 2.5, releves/apex-grapple/2026-11-11-saisie/
// donnees-du-jeu): the two choices are the object actions Takedown.LethalTakedown and Takedown.NonLethalTakedown,
// with no condition on the person and one on V. The police's officers carry them in their record; its androids and
// passers-by carry neither. And for a civilian tied to no security system the game leaves before it makes any choice
// (scriptedPuppet.script:2688-2691).
// The game's own function is handed those two records in place of the person's (scriptedPuppetPS.script:630), and
// what it returns is set on the layer the game uses while V holds (scriptedPuppet.script:2693-2703,
// scriptedPuppetPS.script:921). The game then shows the choices, reads the buttons and runs the execution by itself
// (scriptedPuppet.script:2728-2745 and 2939-2970). A person the game gave its own choices is left alone.
// The game's direct context is not added to the person: with it the game works the choices out again from the
// person's record at every change (scriptedPuppet.script:4376-4392) and would wipe these.
// Twenty-first and twenty-second trials, 29 grabs: the two choices made at the first try on passers-by set by a
// shop and on an android of the police, then used: four passers-by knocked out, four killed, the android killed
// (Kevin: "ca fonctionne bien sur les robot de la police"). The game's mark was down on 3 officers of 13 when it was
// looked at: their choices were made again, the same, with nothing to see.

// Once V holds, the time left to the game to make its own choices before ours are made.
public func ApexGrappleGrabChoicesWait() -> Float {
  return 0.3;
}

// The choices are made again whenever the game has dropped them, this many times a grab at most.
public func ApexGrappleGrabMostChoiceTries() -> Int32 {
  return 40;
}

// After a try that made no choice, the next one waits this long, in seconds.
public func ApexGrappleGrabChoicesEvery() -> Float {
  return 0.25;
}

// The layer of the game's choices while V holds a person (default_puppet_interaction and
// mechanical_puppet_interaction, both read on 12 November 2026).
public func ApexGrappleGrabHeldLayer() -> CName {
  return n"TakedownLayer";
}

// The game's own mark of choices set on the person for V.
@addMethod(ScriptedPuppet)
public func ApexGrappleGrabChoicesOn() -> Bool {
  let state: ref<ScriptedPuppetPS> = this.GetPS();
  return IsDefined(state) && state.HasDirectInteractionChoicesActive();
}

// The two choices, made by the game's own function from the game's own two records and set on the held layer. How
// many it made; -1 when a record, the person's state or their interactions are missing.
@addMethod(ScriptedPuppet)
public func ApexGrappleGrabChoicesMake(player: ref<GameObject>) -> Int32 {
  let actions: array<wref<ObjectAction_Record>>;
  let choices: array<InteractionChoice>;
  let context: GetActionsContext;
  let kill: wref<ObjectAction_Record> = TweakDBInterface.GetObjectActionRecord(t"Takedown.LethalTakedown");
  let soft: wref<ObjectAction_Record> = TweakDBInterface.GetObjectActionRecord(t"Takedown.NonLethalTakedown");
  let state: ref<ScriptedPuppetPS> = this.GetPS();
  let count: Int32;
  if !IsDefined(kill) || !IsDefined(soft) || !IsDefined(state) || !IsDefined(this.m_interactionComponent) {
    return -1;
  }
  ArrayPush(actions, kill);
  ArrayPush(actions, soft);
  // The game's listener of the choices' conditions, as the game creates it when a layer wakes; the game lets go of
  // it when the layer sleeps (scriptedPuppet.script:2694 and 2714).
  if !IsDefined(this.m_objectActionsCallbackCtrl) {
    this.CreateObjectActionsCallbackController(player);
  }
  context.requestType = gamedeviceRequestType.Direct;
  context.processInitiatorObject = player;
  context.interactionLayerTag = ApexGrappleGrabHeldLayer();
  state.GetValidChoices(actions, context, this.m_objectActionsCallbackCtrl, true, choices);
  count = ArraySize(choices);
  if count <= 0 {
    return 0;
  }
  this.m_interactionComponent.SetChoices(choices, ApexGrappleGrabHeldLayer());
  state.SetHasDirectInteractionChoicesActive(true);
  return count;
}

// Each frame V holds the person (GrabHold.reds): for a person the game holds no choice for once its time has
// passed, the two are made, and made again the frame the game has dropped them. A try that made none is followed by
// a wait: without it the tries were all spent within a second on a person the game's function makes none for yet.
// The log has one line, at the first try.
public func ApexGrappleGrabChoices(grab: ref<ApexGrappleGrab>, npc: ref<NPCPuppet>, player: ref<GameObject>, now: Float) -> Void {
  let on: Bool;
  if now - grab.heldAt < ApexGrappleGrabChoicesWait() || (grab.choicesChecked && !grab.choicesOurs) {
    return;
  }
  if grab.choiceTries >= ApexGrappleGrabMostChoiceTries() || now - grab.choiceAt < ApexGrappleGrabChoicesEvery() {
    return;
  }
  on = npc.ApexGrappleGrabChoicesOn();
  if !grab.choicesChecked {
    grab.choicesChecked = true;
    grab.choicesOurs = !on;
  }
  if on {
    return;
  }
  grab.choiceTries += 1;
  grab.choicesMade = npc.ApexGrappleGrabChoicesMake(player);
  if grab.choicesMade <= 0 {
    grab.choiceAt = now;
  }
  if grab.choiceTries == 1 {
    ApexGrappleLog("grab " + ToString(grab.count) + ": the game gave this person no execution choice " + ToString(now - grab.heldAt) + " s after V held, the game's function made " + ToString(grab.choicesMade) + " from its two records");
  }
}
