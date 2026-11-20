// The line V says now, whichever of this mod's lines it is (conception-saisies, section 3.4, point 3): its sound's name
// and the instant it ends, so that V never starts a line while one plays (section 3.2) and a line can be stopped when V
// loses the person he holds, is knocked down or dies (sections 3.3 and 3.4). ExecutionLinesSay is the one call that
// asks Audioware for a sound. Called once per line or per event, never each frame.

// The mod's one clock. The sound plays in real time, so the clock wanted is one that time dilation does not slow. Both
// of the engine's clocks are native (orphans.script:11669-11671, scripts 2.5) and no line of the game's scripts says
// which one dilation slows, so this is the clock the occasion counted a person with in 1.0.0, as the plan asks then.
// Should dilation slow it, V would seem to speak longer than he does under a slow-motion effect: a line refused, never
// two at once. Not tried in game.
public func ExecutionLinesNow(game: GameInstance) -> Float {
  return EngineTime.ToFloat(GameInstance.GetSimTime(game));
}

// A line stopped fades out this fast: heard as V breaking off, without the click of a cut (conception-saisies, 3.3,
// point 2).
public func ExecutionLinesStopFadeSeconds() -> Float {
  return 0.1;
}

public func ExecutionLinesSpeaking(system: ref<ExecutionLinesSystem>, now: Float) -> Bool {
  return system.saying && now < system.sayingUntil;
}

// The volume Audioware is given for a take, from 0 to 1: the player's percentage for its kind, whispered or out loud,
// clamped so that a settings file edited by hand never plays a line louder than its recording.
public func ExecutionLinesVolumeOf(settings: ref<ExecutionLinesSettings>, whispered: Bool) -> Float {
  let percent: Float = whispered ? settings.whisperVolume : settings.volume;
  return ClampF(percent / 100.0, 0.0, 1.0);
}

// The line ends at its start plus its sound's length, which the table gives (fabrique/table_script.py measures it on the
// sound). Kept before Audioware is asked, so that a line that fails to play still keeps V from talking over it. The
// volume is read here, for every line of the mod, and changes nothing else: at 0 the line plays unheard and V still
// speaks until its end.
public func ExecutionLinesSay(system: ref<ExecutionLinesSystem>, game: GameInstance, player: ref<GameObject>, line: ExecutionLinesLine) -> Void {
  system.saying = true;
  system.sayingName = line.name;
  system.sayingUntil = ExecutionLinesNow(game) + Cast<Float>(line.milliseconds) / 1000.0;
  let settings: ref<ExecutionLinesSettings> = new ExecutionLinesSettings();
  ExecutionLinesPlay(player, line.name, ExecutionLinesVolumeOf(settings, line.whispered));
}

// Both of the engine's clocks, in seconds, for the log lines of a line asked and a line stopped. Disposable: it goes
// once a try in game has told which clock follows the sound under a slow-motion effect and the pause, and
// ExecutionLinesNow reads that one.
public func ExecutionLinesClocksText(game: GameInstance) -> String {
  return "sim time " + ToString(EngineTime.ToFloat(GameInstance.GetSimTime(game))) + " s, engine time " + ToString(EngineTime.ToFloat(GameInstance.GetEngineTime(game))) + " s";
}

// Stops the line V says, if any: past its end there is nothing to stop. The counts and the series stay as they are, the
// line was said (conception-saisies, 3.4, point 1). A grab line stopped takes its grab with it: no conclusion follows a
// sentence cut short, and the person's occasion is an ordinary one. `why` goes to the log.
public func ExecutionLinesHush(game: GameInstance, player: ref<GameObject>, why: String) -> Void {
  let system: ref<ExecutionLinesSystem> = ExecutionLinesSystemOf(game);
  if !IsDefined(system) || !IsDefined(player) {
    return;
  }
  let now: Float = ExecutionLinesNow(game);
  if !ExecutionLinesSpeaking(system, now) {
    return;
  }
  let grabLine: Bool = ExecutionLinesSayingGrabLine(system, now);
  ExecutionLinesStop(player, system.sayingName, ExecutionLinesStopFadeSeconds());
  system.saying = false;
  if grabLine {
    ExecutionLinesForgetGrabOf(system, system.grabVictim);
  }
  let most: Int32 = ExecutionLinesLogMost();
  if system.hushLines <= most {
    system.hushLines = ExecutionLinesLogUpTo(system.hushLines, most, "voice lines stopped", "voice line " + NameToString(system.sayingName) + " stopped: " + why + (grabLine ? "; grab " + ToString(system.grabNumber) + " forgotten, no conclusion will follow" : "") + ", " + ExecutionLinesClocksText(game));
  }
}
