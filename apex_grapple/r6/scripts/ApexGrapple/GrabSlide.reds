// The game's own slide of a person (ActionSlideToScriptProxy), which brings them standing to V for a grab
// (GrabCarry.reds): bound to the person, set up to V over a time, navigation ignored, the person not turned.
// This file alone holds a slide, and lets go of it only while its person is still in the world. Fourteenth trial: a
// slide was kept from one carry to the next; its grabbed person stopped existing, and letting go of it ten seconds
// later crashed the game (the last hold on the game's action reads through its owner: read at 0x228,
// Cyberpunk2077.exe+0x234b1d). The game keeps such a proxy on the person's own component and lets go of it when the
// component leaves (aiComponent.script:289-291).

// A leg is never asked shorter than this, in seconds.
public func ApexGrappleGrabShortestLeg() -> Float {
  return 0.02;
}

// Slides whose person left the world while they were held, at most; then no more grab until the game is loaded.
public func ApexGrappleGrabMostKept() -> Int32 {
  return 8;
}

// The slides never let go of. It holds itself, so that nothing ever lets go of it nor of its slides, not even the
// load that takes the mod's system away: letting go of a slide whose person is gone is the fourteenth trial's crash.
// A few small objects are left behind for each such slide, on purpose.
public class ApexGrappleGrabKeeper {
  public let me: ref<ApexGrappleGrabKeeper>;
  public let slides: array<ref<ActionSlideToScriptProxy>>;
}

public func ApexGrappleGrabSlideFree(grab: ref<ApexGrappleGrab>) -> Bool {
  return !IsDefined(grab.keeper) || ArraySize(grab.keeper.slides) < ApexGrappleGrabMostKept();
}

public func ApexGrappleGrabSlideKeep(grab: ref<ApexGrappleGrab>, slide: ref<ActionSlideToScriptProxy>) -> Int32 {
  if !IsDefined(grab.keeper) {
    grab.keeper = new ApexGrappleGrabKeeper();
    grab.keeper.me = grab.keeper;
  }
  ArrayPush(grab.keeper.slides, slide);
  return ArraySize(grab.keeper.slides);
}

// The mod's system leaves (a load, Hook.reds): a slide still held then is kept, never let go of with the system.
public func ApexGrappleGrabSlideLeave(grab: ref<ApexGrappleGrab>) -> Void {
  if IsDefined(grab) && IsDefined(grab.slide) {
    ApexGrappleGrabSlideKeep(grab, grab.slide);
    grab.slide = null;
    grab.slideOf = null;
  }
}

// The action's status: 0 invalid, 1 bound, 2 ready, 3 in progress, 4 complete, 5 failure; -1 with no slide.
public func ApexGrappleGrabSlideStatus(grab: ref<ApexGrappleGrab>) -> Int32 {
  if IsDefined(grab.slide) {
    return EnumInt(grab.slide.GetStatus());
  }
  return -1;
}

public func ApexGrappleGrabSlideRuns(status: Int32) -> Bool {
  return status >= 1 && status <= 3;
}

// Launched and not yet in progress.
public func ApexGrappleGrabSlideWaits(status: Int32) -> Bool {
  return status == 1 || status == 2;
}

// The one place the slide is let go of: stopped first when it still goes, as the game stops its own before it sets
// them up again (tweakAIAction.script:1241). A slide whose person has left the world (asked as the game asks it of its
// own puppets, scriptedPuppet.script:1445) is never let go of: that is the fourteenth trial's crash. It is kept for
// good, and counted.
public func ApexGrappleGrabSlideEnd(grab: ref<ApexGrappleGrab>, why: String) -> Void {
  let slide: ref<ActionSlideToScriptProxy> = grab.slide;
  let person: ref<GameObject> = grab.slideOf;
  let kept: Int32;
  if !IsDefined(slide) {
    return;
  }
  if !IsDefined(person) || !person.IsAttached() {
    kept = ApexGrappleGrabSlideKeep(grab, slide);
    ApexGrappleLog("grab " + ToString(grab.count) + ": the slide's person left the world while it was held (" + why + "), the slide is kept and never let go of, " + ToString(kept) + " kept of " + ToString(ApexGrappleGrabMostKept()) + " at most");
  } else {
    if ApexGrappleGrabSlideRuns(EnumInt(slide.GetStatus())) {
      slide.Stop();
    }
  }
  grab.slide = null;
  grab.slideOf = null;
}

// The AI's own animation action stopped, as the AI stops it itself before each of its animations, whatever its status
// (tweakAIAction.script:1241): a leg does not start while it goes (seventeenth trial, grab 8).
public func ApexGrappleGrabClear(person: ref<GameObject>) -> Void {
  let puppet: ref<ScriptedPuppet> = person as ScriptedPuppet;
  let ai: ref<AIHumanComponent>;
  let action: ref<ActionAnimationScriptProxy>;
  if IsDefined(puppet) {
    ai = puppet.GetAIControllerComponent();
  }
  if !IsDefined(ai) {
    return;
  }
  action = ai.GetActionAnimationScriptProxy();
  if IsDefined(action) {
    action.Stop();
  }
}

// One leg: from where the person is to V herself, at the carry's pace. The game does not follow V with it: the leg
// ends where V stood when it was set up, and another is sent from there (nineteenth trial, the way kept: 3 to 7 legs
// over 30 to 56 m with V backing away fast). The AI's own animation action is stopped first: the leg would wait
// behind it.
public func ApexGrappleGrabSlideLaunch(grab: ref<ApexGrappleGrab>, person: ref<GameObject>, player: ref<GameObject>, now: Float) -> Void {
  let gap: Float = Vector4.Distance(person.GetWorldPosition(), player.GetWorldPosition());
  let time: Float = MaxF(gap / grab.pace, ApexGrappleGrabShortestLeg());
  ApexGrappleGrabSlideEnd(grab, "a new leg");
  grab.legs += 1;
  grab.legAt = now;
  ApexGrappleGrabClear(person);
  grab.slide = new ActionSlideToScriptProxy();
  grab.slideOf = person;
  grab.slide.Bind(person);
  grab.slide.SetupObject(player, time, true, false);
  grab.slide.Launch();
}
