// The state of one load. The game makes a new system at each load ("re-created on each load", the modding community's
// NativeDB page of gameScriptableSystem, not the game's scripts), so nothing here, the voice read included, carries
// over from one game to the next. The fields live in this class, never added by @addField from another file (the redscript error of 31 October
// 2026). No game object is kept here: the last person counted is kept by their EntityID alone.

public class ExecutionLinesSystem extends ScriptableSystem {
  // The series of ten (Bag.reds), made at its first use.
  public let bag: ref<ExecutionLinesBag>;
  // How often each phrase and each take was said, by key (Choice.reds): at most 9 counts for the phrases and as many as
  // the table has lines for the takes. The last phrase said, and for each phrase the key of its last take plus one.
  public let phraseCounts: array<Int32>;
  public let takeCounts: array<Int32>;
  public let lastPhrase: ExecutionLinesPhrase;
  public let lastTakes: array<Int32>;
  // The last person counted for an occasion and when (Occasion.reds, step 2). `victimCounted` says whether there is
  // one: an EntityID left without a value is not read as "nobody".
  public let victimCounted: Bool;
  public let lastVictim: EntityID;
  public let lastVictimAt: Float;
  // Log lines written this load, one count per kind (Log.reds).
  public let askedLines: Int32;
  public let nobodyLines: Int32;
  public let replacerLines: Int32;
  public let noAudiowareLines: Int32;
  public let noLineAllowedLines: Int32;
  public let samePersonLines: Int32;
  public let silentLines: Int32;
  // The counts of the listeners' own lines: a takedown action without an effect; a kill or knock-out in V's name that
  // is not an execution, the ordinary case (V neither in a workspot nor within reach) apart from all the others, so
  // that thirty rifle kills do not use up the lines that tell the refusals that matter; a kill in V's name that the
  // game refuses because the person is invulnerable; and one on a person already dead.
  public let noEffectLines: Int32;
  public let notExecutionLines: Int32;
  public let ordinaryNotExecutionLines: Int32;
  public let invulnerableLines: Int32;
  public let alreadyDeadLines: Int32;
  // Said once a load: the voice read (Voice.reds), and the on-screen notice that Audioware is missing (Notice.reds).
  public let voiceTold: Bool;
  public let noticeTold: Bool;
}

public func ExecutionLinesSystemOf(game: GameInstance) -> ref<ExecutionLinesSystem> {
  return GameInstance.GetScriptableSystemsContainer(game).Get(n"ExecutionLinesSystem") as ExecutionLinesSystem;
}
