// The grab V holds (conception-saisies, section 3.1, points 1 and 5, and section 3.3): heard by S1 as V holds a person,
// its moment drawn 3 to 5 s after the grab's start, and its end without an execution. Called once per grab state the
// game enters and once per takedown action, never each frame.

// A grab line said, kept for its conclusion: its phrase, its voice, whether it is whispered, and the instant it ends.
// It belongs to the grab held, whose person is its person.
public struct ExecutionLinesGrabLine {
  let phrase: ExecutionLinesPhrase;
  let female: Bool;
  let whispered: Bool;
  let until: Float;
}

// The window the moment is drawn in, counted from the grab's start, where the player counts from: an ordinary enemy
// does not struggle yet within it, and a fixed delay would always fall at the same instant (README, Kevin's choice of 3
// to 5 s on 20 November 2026: 7 s, the end of the first window, was too long in game).
public func ExecutionLinesGrabWindowFrom() -> Float {
  return 3.0;
}

public func ExecutionLinesGrabWindowTo() -> Float {
  return 5.0;
}

// How long the game takes from the grab's start to S1, left out of the delay asked after S1: 0.94 to 1.00 s over 17
// grabs in game on 20 November 2026 (releves/repliques-executions/2026-11-20-essai-saisies/). Without it, with the
// first window of 3 to 7 s, the player heard the moment 4 to 8 s after he grabbed.
public func ExecutionLinesGrabLeadSeconds() -> Float {
  return 1.0;
}

// The window cut into equal slices of half a second, drawn from the system's bag of slices (System.reds): over this
// many grabs running from a full bag, each slice of the window serves once, whatever the draws.
public func ExecutionLinesGrabSlices() -> Int32 {
  return 4;
}

// The delay after S1 for a slice (0 to slices - 1) and a part within it (0.0 to 1.0), both bounded so that the delay
// always stays within the window, the lead left out.
public func ExecutionLinesGrabDelay(slice: Int32, part: Float) -> Float {
  let slices: Int32 = ExecutionLinesGrabSlices();
  let low: Float = ExecutionLinesGrabWindowFrom();
  let at: Float = Cast<Float>(Clamp(slice, 0, slices - 1)) + ClampF(part, 0.0, 1.0);
  return low - ExecutionLinesGrabLeadSeconds() + at * (ExecutionLinesGrabWindowTo() - low) / Cast<Float>(slices);
}

// Draws a slice from the system's bag and takes it out, the bag filled first when empty. The bag is worked on in the
// system itself, never through a local variable: if the array were copied there (not verified), a slice erased from
// the copy would stay in the bag.
public func ExecutionLinesGrabSliceDrawn(system: ref<ExecutionLinesSystem>) -> Int32 {
  if ArraySize(system.grabSlices) == 0 {
    let slices: Int32 = ExecutionLinesGrabSlices();
    let slice: Int32 = 0;
    while slice < slices {
      ArrayPush(system.grabSlices, slice);
      slice += 1;
    }
  }
  let at: Int32 = RandRange(0, ArraySize(system.grabSlices));
  let drawn: Int32 = system.grabSlices[at];
  ArrayErase(system.grabSlices, at);
  return drawn;
}

// How long a grab stays held after S1 last heard it (conception-saisies, 3.4, point 5). The game can end a grab with no
// takedown action this mod hears (a forced exit of the grab's state, locomotionTakedown.script:539-542, or V raised by
// his second chance): without a bound, holding the same person again, minutes later, would be taken for the same grab
// and stay silent. An ordinary grab is heard again within seconds (a fall, the choice to kill or knock out), and each
// pass renews the instant. Not tried in game: a grab held longer than this without S1 heard again would be taken for a
// new one when S1 next comes, its grab line forgotten.
public func ExecutionLinesGrabHeldSeconds() -> Float {
  return 60.0;
}

// Whether the person carries the effect the game puts on them as V grabs them and takes off when they break free or the
// grab ends (scriptedPuppet.script:2921-2933, NPCPuppet.script:3763, :3777, locomotionTakedown.script:90, :1131), read
// as the game reads it (scriptedPuppet.script:1637).
public func ExecutionLinesHeld(game: GameInstance, id: EntityID) -> Bool {
  return GameInstance.GetStatusEffectSystem(game).HasStatusEffect(id, t"BaseStatusEffect.Grappled");
}

// S1 heard for the person V already holds is the same grab: the game enters this state again after a fall
// (locomotionTakedown.script:960-965), and the choice to kill or knock out starts the grab's machine again
// (scriptedPuppet.script:2939-2944). Taken for a new grab, it would forget the grab line just before the execution, and
// the conclusion would never come. The occasion counted says the execution has begun: the person still carries the
// effect during its animation. Past ExecutionLinesGrabHeldSeconds after the last S1, the grab is no longer held.
public func ExecutionLinesSameGrab(system: ref<ExecutionLinesSystem>, game: GameInstance, id: EntityID, now: Float) -> Bool {
  return system.grabHeld && id == system.grabVictim && now - system.grabHeardAt < ExecutionLinesGrabHeldSeconds() && ExecutionLinesHeld(game, id) && !ExecutionLinesCounted(system, id, now);
}

// S1 heard V hold this person: the delay of the moment's callback to ask for, in seconds, or a negative value when none
// is to be asked (the same grab, the mod switched off).
public func ExecutionLinesGrabHeard(game: GameInstance, victim: ref<GameObject>) -> Float {
  let system: ref<ExecutionLinesSystem> = ExecutionLinesSystemOf(game);
  if !IsDefined(system) {
    return -1.0;
  }
  let settings: ref<ExecutionLinesSettings> = new ExecutionLinesSettings();
  if !settings.enabled {
    return -1.0;
  }
  let most: Int32 = ExecutionLinesLogMost();
  if !IsDefined(victim) {
    if system.grabRefusedLines <= most {
      system.grabRefusedLines = ExecutionLinesLogUpTo(system.grabRefusedLines, most, "grabs without a grab line", "grab heard without the person held: no moment drawn");
    }
    return -1.0;
  }
  let id: EntityID = victim.GetEntityID();
  let now: Float = ExecutionLinesNow(game);
  if ExecutionLinesSameGrab(system, game, id, now) {
    system.grabPasses += 1;
    system.grabHeardAt = now;
    if system.grabPassLines <= most {
      system.grabPassLines = ExecutionLinesLogUpTo(system.grabPassLines, most, "grabs heard again", "grab " + ToString(system.grabNumber) + " heard again for the same person, pass " + ToString(system.grabPasses) + ": its moment and its line kept");
    }
    return -1.0;
  }
  system.grabNumber += 1;
  system.grabHeld = true;
  system.grabVictim = id;
  system.grabPasses = 1;
  system.grabHeardAt = now;
  system.grabLineSaid = false;
  let slice: Int32 = ExecutionLinesGrabSliceDrawn(system);
  let part: Float = RandRangeF(0.0, 1.0);
  let delay: Float = ExecutionLinesGrabDelay(slice, part);
  if system.grabHeardLines <= most {
    system.grabHeardLines = ExecutionLinesLogUpTo(system.grabHeardLines, most, "grabs heard", "grab " + ToString(system.grabNumber) + " heard: V holds a person, its moment in " + FloatToStringPrec(delay, 1) + " s, slice " + ToString(slice + 1) + " of " + ToString(ExecutionLinesGrabSlices()) + ", " + FloatToStringPrec(delay + ExecutionLinesGrabLeadSeconds(), 1) + " s after the grab's start");
  }
  return delay;
}

// The number of the grab held, which the moment's callback carries: 0 before the load's first grab.
public func ExecutionLinesGrabNumber(game: GameInstance) -> Int32 {
  let system: ref<ExecutionLinesSystem> = ExecutionLinesSystemOf(game);
  if !IsDefined(system) {
    return 0;
  }
  return system.grabNumber;
}

// Forgets the grab held and its line when this person is the one held.
public func ExecutionLinesForgetGrabOf(system: ref<ExecutionLinesSystem>, id: EntityID) -> Void {
  if system.grabHeld && id == system.grabVictim {
    system.grabHeld = false;
    system.grabLineSaid = false;
  }
}

// Whether this person is the one held.
public func ExecutionLinesHolds(system: ref<ExecutionLinesSystem>, victim: ref<GameObject>) -> Bool {
  if !IsDefined(victim) || !system.grabHeld {
    return false;
  }
  let id: EntityID = victim.GetEntityID();
  return id == system.grabVictim;
}

// Whether the line V says now is the grab line: one line plays at a time (Speaking.reds), so a line that plays before
// the grab line's end is that line.
public func ExecutionLinesSayingGrabLine(system: ref<ExecutionLinesSystem>, now: Float) -> Bool {
  let grabLine: ExecutionLinesGrabLine = system.grabLine;
  return system.grabLineSaid && now < grabLine.until && ExecutionLinesSpeaking(system, now);
}

// The actions the game ends a grab with when there is no execution: the person breaks free, at once for a mini-boss,
// MaxTac or an enemy too strong (locomotionTakedown.script:858-863, :1137-1138), the grab fails (:1134-1135), the
// person held dies of other blows (:982-983), or the game shoves them away after a fall or in water (:1014-1015). In
// each V has lost the person he spoke to.
public func ExecutionLinesGrabLost(action: ETakedownActionType) -> Bool {
  return Equals(action, ETakedownActionType.BreakFree) || Equals(action, ETakedownActionType.GrappleFailed) || Equals(action, ETakedownActionType.TargetDead) || Equals(action, ETakedownActionType.ForceShove);
}

// The action's name as the game declares it (orphans.script:10908), read the way the game names one of its enums
// (tweakAIConditionChecks.script:1459).
public func ExecutionLinesTakedownActionText(action: ETakedownActionType) -> String {
  return EnumValueToString("ETakedownActionType", Cast<Int64>(EnumInt(action)));
}

// The grab ended without an execution: V stops his grab line if he still says it, and the grab is forgotten. No line
// after it in 1.0.1 (conception-saisies, 3.3, point 3).
public func ExecutionLinesGrabEnded(game: GameInstance, player: ref<GameObject>, victim: ref<GameObject>, action: ETakedownActionType) -> Void {
  if !ExecutionLinesGrabLost(action) {
    return;
  }
  let system: ref<ExecutionLinesSystem> = ExecutionLinesSystemOf(game);
  if !IsDefined(system) {
    return;
  }
  let most: Int32 = ExecutionLinesLogMost();
  let actionText: String = ExecutionLinesTakedownActionText(action);
  // A grab that fails at once, or a mini-boss who breaks free at once, may come without S1: under a bound of its own,
  // so that it never uses up the lines of the grabs that did end.
  if !ExecutionLinesHolds(system, victim) {
    if system.grabEndOtherLines <= most {
      system.grabEndOtherLines = ExecutionLinesLogUpTo(system.grabEndOtherLines, most, "grab ends for a person not held", "grab ended without an execution, " + actionText + ": not the person of the grab held, nothing to stop");
    }
    return;
  }
  let saying: Bool = ExecutionLinesSayingGrabLine(system, ExecutionLinesNow(game));
  if system.grabEndLines <= most {
    system.grabEndLines = ExecutionLinesLogUpTo(system.grabEndLines, most, "grabs ended without an execution", "grab " + ToString(system.grabNumber) + " ended without an execution, " + actionText + (saying ? ": its grab line is stopped" : ": V is not saying its grab line"));
  }
  if saying {
    ExecutionLinesHush(game, player, "grab " + ToString(system.grabNumber) + " ended without an execution, " + actionText);
  }
  ExecutionLinesForgetGrabOf(system, system.grabVictim);
}
