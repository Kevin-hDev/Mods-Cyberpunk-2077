// The state of one load. The game makes a new system at each load ("re-created on each load", the modding community's
// NativeDB page of gameScriptableSystem, not the game's scripts), so nothing here, the voice read included, carries
// over from one game to the next: a grab's callback that comes back after a load finds a new system. The fields live
// in this class, never added by @addField from another file (the redscript error of 31 October 2026). No game object
// is kept here: the people counted and the person held are kept by their EntityID alone.

public class ExecutionLinesSystem extends ScriptableSystem {
  // The series of ten (Bag.reds), made at its first use.
  public let bag: ref<ExecutionLinesBag>;
  // How often each phrase and each take was said, by key (Choice.reds): at most 23 counts for the phrases and as many
  // as the table has lines for the takes. The last phrase said, and for each phrase the key of its last take plus one.
  // A conclusion's take is counted here too (Conclusion.reds).
  public let phraseCounts: array<Int32>;
  public let takeCounts: array<Int32>;
  public let lastPhrase: ExecutionLinesPhrase;
  public let lastTakes: array<Int32>;
  // The last people counted for an occasion, oldest first, and the instant of each, at most ExecutionLinesCountedMost
  // (Occasion.reds, step 2): two arrays of the same length, written by ExecutionLinesCountPerson alone.
  public let countedPeople: array<EntityID>;
  public let countedAt: array<Float>;
  // The line V says now, any of this mod's, and when it ends (Speaking.reds). `saying` says whether there is one.
  public let saying: Bool;
  public let sayingName: CName;
  public let sayingUntil: Float;
  // The grab held (Grab.reds): its number, raised at each new grab and carried by its moment's callback, the person
  // held, how many times S1 heard it, and when S1 last heard it. `grabHeld` says whether there is one.
  public let grabNumber: Int32;
  public let grabHeld: Bool;
  public let grabVictim: EntityID;
  public let grabPasses: Int32;
  public let grabHeardAt: Float;
  // The slices of the moment's window not yet drawn (Grab.reds), at most ExecutionLinesGrabSlices: a bag rather than a
  // plain draw, as fifteen plain draws running fell between 4.1 and 7.0 s, none in the window's first second, in game
  // on 20 November 2026.
  public let grabSlices: array<Int32>;
  // The grab line said for the grab held, kept for its conclusion (GrabLine.reds, Conclusion.reds). `grabLineSaid` says
  // whether there is one.
  public let grabLineSaid: Bool;
  public let grabLine: ExecutionLinesGrabLine;
  // The grab lines' own series of ten and counts, by the same keys and bounds as the executions' above.
  public let grabBag: ref<ExecutionLinesBag>;
  public let grabPhraseCounts: array<Int32>;
  public let grabTakeCounts: array<Int32>;
  public let grabLastPhrase: ExecutionLinesPhrase;
  public let grabLastTakes: array<Int32>;
  // Log lines written this load, one count per kind (Log.reds).
  public let askedLines: Int32;
  public let nobodyLines: Int32;
  public let replacerLines: Int32;
  public let noAudiowareLines: Int32;
  public let noLineAllowedLines: Int32;
  public let samePersonLines: Int32;
  public let silentLines: Int32;
  public let speakingLines: Int32;
  // The grab's and the conclusion's: a grab heard, heard again, refused (mod off, Audioware missing, the player not V,
  // nobody held), its moment after the grab is over, while V speaks, with no grab line allowed, its draw missed, its
  // line asked; a grab ended without an execution, and such an end for a person not held; a line stopped; a conclusion
  // asked, or not said, and a conclusion with no take, the one fault among them, under its own bound.
  public let grabHeardLines: Int32;
  public let grabPassLines: Int32;
  public let grabRefusedLines: Int32;
  public let grabOverLines: Int32;
  public let grabBusyLines: Int32;
  public let grabNoneLines: Int32;
  public let grabMissedLines: Int32;
  public let grabAskedLines: Int32;
  public let grabEndLines: Int32;
  public let grabEndOtherLines: Int32;
  public let hushLines: Int32;
  public let conclusionLines: Int32;
  public let conclusionSilentLines: Int32;
  public let conclusionNoTakeLines: Int32;
  // The counts of the listeners' own lines: a takedown action without an effect; a kill or knock-out in V's name that
  // is not an execution, the ordinary case (V neither in a workspot nor within reach) apart from all the others, so
  // that thirty rifle kills do not use up the lines that tell the refusals that matter; a kill in V's name that the
  // game refuses because the person is invulnerable; and one on a person already dead.
  public let noEffectLines: Int32;
  public let notExecutionLines: Int32;
  public let ordinaryNotExecutionLines: Int32;
  public let invulnerableLines: Int32;
  public let alreadyDeadLines: Int32;
  // S1 heard on a grab state that is not the grab's start (ListenGrab.reds), and V knocked down or dead with no line of
  // this mod playing (ListenPlayer.reds); a grab's moment that comes back to a system other than its own
  // (ListenGrab.reds).
  public let grabStateLines: Int32;
  public let downQuietLines: Int32;
  public let grabCallLines: Int32;
  // Said once a load: the voice read (Voice.reds), and the on-screen notice that Audioware is missing (Notice.reds).
  public let voiceTold: Bool;
  public let noticeTold: Bool;
}

public func ExecutionLinesSystemOf(game: GameInstance) -> ref<ExecutionLinesSystem> {
  return GameInstance.GetScriptableSystemsContainer(game).Get(n"ExecutionLinesSystem") as ExecutionLinesSystem;
}
