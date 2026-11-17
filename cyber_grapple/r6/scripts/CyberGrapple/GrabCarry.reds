// Made by fabrique/grapple.py from Apex Grapple's GrabCarry.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// A person brought standing to V for the game's grab (Grab.reds). Kevin, 11 November 2026, after the eighth trial:
// "faudrait que la personne tiree arrive en position droite vers V et de dos je pense et qu'il enchaine sur
// l'animation de saisie". The game's grab is an animation V and the person play together, V behind the person
// (locomotionTakedown.script:707-756): it shows only on a person who stands in front of V, and it takes the person
// from the place the game holds for them. So the game itself moves the person, by its slide (GrabSlide.reds):
//   - stunned at the hook's bite, their own locomotion stops within 1 to 3 frames and no longer ends a leg
//     (seventeenth trial); the status is taken back at every end of the carry, before the grab's event;
//   - leg after leg to V herself, wherever V runs (nineteenth trial, Kevin: "c'est Z le bon, les autres tremblent");
//   - a carry that does not bring them hands over to the plain pull: Kevin, 11 November 2026, too late for the
//     grab, the pull ends as usual. With "Pull people to V" off, or no spot by V to throw them to, there is no plain
//     pull to hand over to: the carry ends and the person is left to fall where they are.
// Twenty-third trial, the real function's first, 10 carries: 8 brought and grabbed at 24 and 16 m/s asked; 2 at
// 16 m/s handed over to the plain pull after 5 s, V running away from the person over 60 m.

// The person is brought this close in front of V, and counts as brought this close to that spot along the ground
// (the tenth trial's).
public func CyberGrappleGrabStop() -> Float {
  return 1.0;
}

public func CyberGrappleGrabNear() -> Float {
  return 0.5;
}

// The carry has this long after the time the way takes at its pace; then the plain pull takes over.
public func CyberGrappleGrabLate() -> Float {
  return 0.6;
}

// A carry's limit follows V's own run up to twice the time the way took at the bite, and no less than this (the
// nineteenth trial's 5 s, V backing away at 11 to 15 m/s).
public func CyberGrappleGrabLongest() -> Float {
  return 5.0;
}

// Legs of the slide for one way, at most (36 at the fifteenth trial); then the plain pull takes over.
public func CyberGrappleGrabMostLegs() -> Int32 {
  return 80;
}

// The pull's end that sends the grab's event (YankFrame.reds): one text, for the log and for what reads it.
public func CyberGrappleGrabBrought() -> String {
  return "brought to V for a grab";
}

// A carry found again this long after its last frame (V drove away meanwhile, Frame.reds) no longer drops the person.
public func CyberGrappleGrabStale() -> Float {
  return 1.0;
}

// stands: where V is, read once a frame by the caller.
public func CyberGrappleGrabAim(grab: ref<CyberGrappleGrab>, player: ref<GameObject>, stands: Vector4) -> Void {
  let forward: Vector4 = CyberGrappleFlat(player.GetWorldForward());
  let length: Float = Vector4.Length(forward);
  if length > CyberGrappleTiny() {
    grab.spot = stands + forward / length * CyberGrappleGrabStop();
  }
}

// The hook has bitten. The slide's first leg goes at the carry's first frame.
public func CyberGrappleGrabCarryStart(grab: ref<CyberGrappleGrab>, person: ref<GameObject>, player: ref<GameObject>, canThrow: Bool, speed: Float, now: Float) -> Void {
  let place: Vector4 = person.GetWorldPosition();
  let stands: Vector4 = player.GetWorldPosition();
  let time: Float;
  // No slide is left from the carry before: its end let go of it. Asked again here, the one place that would tell.
  CyberGrappleGrabSlideEnd(grab, "a new carry found a slide still held");
  grab.count += 1;
  grab.carried = true;
  grab.canThrow = canThrow;
  grab.pace = MaxF(speed, 1.0);
  grab.legs = 0;
  grab.clearedLeg = 0;
  grab.byV = false;
  grab.from = place;
  grab.vAt = stands;
  grab.spot = stands;
  CyberGrappleGrabAim(grab, player, stands);
  time = Vector4.Distance(place, grab.spot) / grab.pace;
  grab.startedAt = now;
  grab.frameAt = now;
  grab.until = now + time + CyberGrappleGrabLate();
  grab.longest = now + MaxF(CyberGrappleGrabLongest(), 2.0 * time + CyberGrappleGrabLate());
  StatusEffectHelper.ApplyStatusEffect(person, t"BaseStatusEffect.Stun");
  grab.stunned = true;
  CyberGrappleLog("grab " + ToString(grab.count) + ": the person is brought standing over " + ToString(Vector4.Distance(place, grab.spot)) + " m at " + ToString(grab.pace) + " m/s, their place " + ToString(place.Z - stands.Z) + " m above V's feet, a plain pull may take over " + ToString(canThrow));
}

// Taken back at every end of a carry, before the grab's event: nothing asked of the person is left behind a grab
// (eleventh trial).
public func CyberGrappleGrabStunOff(grab: ref<CyberGrappleGrab>, person: ref<GameObject>) -> Void {
  if !grab.stunned {
    return;
  }
  grab.stunned = false;
  if IsDefined(person) && StatusEffectSystem.ObjectHasStatusEffect(person, t"BaseStatusEffect.Stun") {
    StatusEffectHelper.RemoveStatusEffect(person, t"BaseStatusEffect.Stun");
  }
}

// 0, not brought. 1, brought and no leg going: by the spot in front of V, or within the carry's stop of V herself.
// 2, within that stop of V with a leg still going: the leg is then stopped a frame before the grab's event, so that
// nothing of ours moves the person under the game's grab (nineteenth trial, grab 12).
public func CyberGrappleGrabIsBrought(grab: ref<CyberGrappleGrab>, person: ref<GameObject>, stands: Vector4, runs: Bool) -> Int32 {
  let place: Vector4 = person.GetWorldPosition();
  let toV: Vector4 = place - stands;
  if !runs && Vector4.Length(CyberGrappleFlat(place - grab.spot)) <= CyberGrappleGrabNear() {
    return 1;
  }
  if Vector4.Length(CyberGrappleFlat(toV)) <= CyberGrappleGrabStop() && AbsF(toV.Z) <= CyberGrappleYankAtGoalHeight() {
    return runs ? 2 : 1;
  }
  return 0;
}

// One line for the whole way, when it ends or changes hands.
public func CyberGrappleGrabCarryTold(grab: ref<CyberGrappleGrab>, person: ref<GameObject>, player: ref<GameObject>, how: String, now: Float) -> Void {
  let place: Vector4 = person.GetWorldPosition();
  let went: Float = Vector4.Distance(place, grab.from);
  let time: Float = now - grab.startedAt;
  CyberGrappleLog("grab " + ToString(grab.count) + ": " + how + " after " + ToString(time) + " s and " + ToString(grab.legs) + " legs of the slide, the person " + ToString(went) + " m from where the hook found them (" + ToString(went / MaxF(time, CyberGrappleTiny())) + " m/s), " + ToString(Vector4.Length(CyberGrappleFlat(place - player.GetWorldPosition()))) + " m from V and " + ToString(Vector4.Length(CyberGrappleFlat(place - grab.spot))) + " m from the spot in front of V");
}

// The slide did not bring the person: the pull goes on as a plain one from this frame, the person falls and is
// pushed to V after the plain pull's own delay (YankFrame.reds, YankDrive.reds). No grab at its end. The spot by V
// is looked for again by where V is now: the one of the bite is where V was (twenty-third trial, V 60 m away
// from it by then). False when the person already stands by V: nothing was done, the carry ends and the person is
// left to fall.
public func CyberGrappleGrabCarryToPull(grab: ref<CyberGrappleGrab>, yank: ref<CyberGrappleYank>, person: ref<GameObject>, why: String, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let player: ref<GameObject> = scriptInterface.executionOwner;
  let feet: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
  let spot: Vector4;
  if !CyberGrappleYankSpot(person, feet, false, scriptInterface, spot) {
    return false;
  }
  CyberGrappleDriveSet(yank.drive, spot + DefaultTransition.GetUpVector() * CyberGrappleYankChestUp(), CyberGrappleYankChestUp(), feet, yank.drive.aimFrom, yank.drive.steers, yank.drive.speed);
  CyberGrappleGrabCarryTold(grab, person, player, why + ", the plain pull takes over", now);
  CyberGrappleGrabSlideEnd(grab, why);
  CyberGrappleGrabStunOff(grab, person);
  grab.carried = false;
  yank.startedAt = now;
  CyberGrappleYankFall(person, player);
  return true;
}

// What ends a carry on the way, asked each frame before anything is done to the person; empty when it goes on. The
// bite's own tests (Grab.reds) hold for that frame only: the person may leave the world with their reference still
// alive (the slide's own test, GrabSlide.reds), be shot dead or knocked out by V, and V may take a ladder.
public func CyberGrappleGrabCarryCut(person: ref<GameObject>, stateContext: ref<StateContext>) -> String {
  if !person.IsAttached() {
    return "the person left the world";
  }
  if !ScriptedPuppet.IsAlive(person) || CyberGrappleKnockedOut(person) {
    return "the person died or was knocked out on the way";
  }
  if CyberGrappleOnLadder(stateContext) {
    return "V took a ladder";
  }
  return "";
}

// One frame of the carry (YankFrame.reds). Empty while it goes on or once the plain pull took over;
// CyberGrappleGrabBrought() when the event may go; any other text ends the pull with it.
public func CyberGrappleGrabCarry(grab: ref<CyberGrappleGrab>, yank: ref<CyberGrappleYank>, person: ref<GameObject>, now: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> String {
  let player: ref<GameObject> = scriptInterface.executionOwner;
  let status: Int32;
  let runs: Bool;
  let stands: Vector4;
  let brought: Int32;
  let failed: String = CyberGrappleGrabCarryCut(person, stateContext);
  if StrLen(failed) > 0 {
    return failed;
  }
  grab.frameAt = now;
  if grab.legs == 0 {
    CyberGrappleGrabSlideLaunch(grab, person, player, now);
    return "";
  }
  status = CyberGrappleGrabSlideStatus(grab);
  runs = CyberGrappleGrabSlideRuns(status);
  // The spot is in front of where V is now, and the carry is given the time V's own run costs it (what V moved, at
  // the carry's pace): the limit worked out at the bite alone would end the carry of a person who comes after V.
  stands = player.GetWorldPosition();
  grab.until = MinF(grab.until + Vector4.Distance(stands, grab.vAt) / grab.pace, grab.longest);
  grab.vAt = stands;
  CyberGrappleGrabAim(grab, player, stands);
  brought = grab.byV ? 1 : CyberGrappleGrabIsBrought(grab, person, stands, runs);
  if brought == 2 {
    grab.byV = true;
    CyberGrappleGrabSlideEnd(grab, "the person is by V");
    return "";
  }
  if brought == 1 {
    CyberGrappleGrabCarryTold(grab, person, player, "brought", now);
    return CyberGrappleGrabBrought();
  }
  if now > grab.until || (!runs && grab.legs >= CyberGrappleGrabMostLegs()) {
    failed = now > grab.until ? "the slide did not bring the person in time" : "the slide's legs are spent";
    // No plain pull to hand over to: the carry ends there, the person left to fall (CyberGrappleGrabCarryEnd).
    if !grab.canThrow || !CyberGrappleGrabCarryToPull(grab, yank, person, failed, now, scriptInterface) {
      CyberGrappleGrabCarryTold(grab, person, player, failed + ", and no plain pull to take over", now);
      return failed + ", no plain pull to take over";
    }
    return "";
  }
  // A leg that waits is behind the AI's own animation action: stopped once a leg, the leg then goes the frame after.
  if CyberGrappleGrabSlideWaits(status) && now > grab.legAt && grab.clearedLeg != grab.legs {
    grab.clearedLeg = grab.legs;
    CyberGrappleGrabClear(person);
  }
  if !runs {
    CyberGrappleGrabSlideLaunch(grab, person, player, now);
  }
  return "";
}

// Every end of a pull whose carry still goes (CyberGrappleEndYank): the slide is let go of first, whatever the end
// and whether the person is still there. A carry that ended before the grab (second press, jump...) leaves the
// person to fall: one still in the world, and whose carry went on until now.
public func CyberGrappleGrabCarryEnd(grab: ref<CyberGrappleGrab>, person: ref<GameObject>, why: String, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  grab.carried = false;
  CyberGrappleGrabSlideEnd(grab, why);
  CyberGrappleGrabStunOff(grab, person);
  if IsDefined(person) && person.IsAttached() && now - grab.frameAt < CyberGrappleGrabStale() && NotEquals(why, CyberGrappleGrabBrought()) {
    CyberGrappleLog("grab " + ToString(grab.count) + ": ended before the grab (" + why + "), the person is left to fall");
    CyberGrappleYankFall(person, scriptInterface.executionOwner);
  }
}
