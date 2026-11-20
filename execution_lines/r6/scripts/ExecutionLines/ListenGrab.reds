// S1: V holds the person, after the animation where he grabs them (conception-saisies, section 5). The grab is kept and
// the game is asked for one callback at the moment drawn (Grab.reds); the callback comes back to GrabLine.reds. Once
// per grab state the game enters, never each frame, and nothing is asked again for the same grab.

// The declaration is the game's own (locomotionTakedown.script:895, scripts 2.5). The game's work comes first: our
// listener never stands before the grab, nor changes it.
@wrapMethod(GrappleStandEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  ExecutionLinesHeardGrab(this, scriptInterface);
}

// Four classes of the game extend GrappleStandEvents: the struggle and breaking-free states redefine OnEnter without
// calling the parent (locomotionTakedown.script:936, :1121), and two decision classes (:947, :1099) do not redefine it
// at all, so they would run this wrapper should the game ever call it on them. Only the grab's start is S1: the exact
// class is tested first, whatever the game does. Should the test turn away the grab's start itself, S1 would be silent
// with no trace: the class turned away goes to the log.
public func ExecutionLinesHeardGrab(state: ref<GrappleStandEvents>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !IsDefined(scriptInterface) {
    return;
  }
  let game: GameInstance = scriptInterface.GetGame();
  if !state.IsExactlyA(n"GrappleStandEvents") {
    let system: ref<ExecutionLinesSystem> = ExecutionLinesSystemOf(game);
    let most: Int32 = ExecutionLinesLogMost();
    if IsDefined(system) && system.grabStateLines <= most && ExecutionLinesListening() {
      system.grabStateLines = ExecutionLinesLogUpTo(system.grabStateLines, most, "grab states that are not the grab's start", "grab state " + NameToString(state.GetClassName()) + " heard by S1: not the grab's start, nothing kept");
    }
    return;
  }
  let initData: ref<LocomotionTakedownInitData> = state.stateMachineInitData;
  let victim: ref<GameObject>;
  if IsDefined(initData) {
    victim = initData.target;
  }
  let delay: Float = ExecutionLinesGrabHeard(game, victim);
  if delay <= 0.0 {
    return;
  }
  let moment: ref<ExecutionLinesGrabMomentCall> = new ExecutionLinesGrabMomentCall();
  moment.system = ExecutionLinesSystemOf(game);
  moment.game = game;
  moment.number = ExecutionLinesGrabNumber(game);
  // Not slowed by time dilation: the line plays in real time, and a slow-motion effect during the grab must not push
  // the moment past the window Kevin chose (3 to 5 s, README).
  GameInstance.GetDelaySystem(game).DelayCallback(moment, delay, false);
}

// The moment's callback: the game, the grab's number, and the system it was asked by, held weakly. The game makes a new
// system at each load (System.reds): a callback that outlives its load finds its system gone, or another one in its
// place, and does nothing; the new system counts its grabs from 1 again, so the number alone would not tell. A callback
// of a grab since replaced is turned away by its number (GrabLine.reds).
public class ExecutionLinesGrabMomentCall extends DelayCallback {
  public let system: wref<ExecutionLinesSystem>;
  public let game: GameInstance;
  public let number: Int32;

  public func Call() -> Void {
    let system: ref<ExecutionLinesSystem> = this.system;
    if !IsDefined(system) {
      return;
    }
    let current: ref<ExecutionLinesSystem> = ExecutionLinesSystemOf(this.game);
    if system != current {
      // Told in the system of this load, so that a comparison wrongly turning away the right system leaves a trace.
      let most: Int32 = ExecutionLinesLogMost();
      if IsDefined(current) && current.grabCallLines <= most && ExecutionLinesListening() {
        current.grabCallLines = ExecutionLinesLogUpTo(current.grabCallLines, most, "grab moments asked before this load", "moment of grab " + ToString(this.number) + ": asked before this load, nothing said");
      }
      return;
    }
    ExecutionLinesGrabMoment(this.game, this.number);
  }
}
