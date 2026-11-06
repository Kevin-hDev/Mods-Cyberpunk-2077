// What kept a step from starting, for the log: the last reason, since when, and for how long V has been stopped. Until
// 22 October 2026 the log only showed the steps that started, and could not say why V met most curbs before climbing
// them (Kevin: three times in ten, V still blocked against the same curb). Kept in the state machine's context, so that
// it carries from one state to the next, a walk into a sprint.

// Under this speed toward the push, in m/s, V counts as stopped against the step.
public func AutoSprintStoppedSpeed() -> Float {
  return 0.5;
}

// A refused step is logged once V has stood stopped against it this long, in seconds, and at most this often.
public func AutoSprintBlockedAfter() -> Float {
  return 0.3;
}

public func AutoSprintBlockedEvery() -> Float {
  return 2.0;
}

public class AutoSprintStepWatch extends IScriptable {
  public let reason: String;
  public let refusing: Bool;
  public let refusedSince: Float;
  public let stopped: Bool;
  public let stoppedSince: Float;
  public let reported: Bool;
  public let lastReport: Float;

  // A step in reach that cannot start. A time that goes back means a save was loaded: it starts the count again.
  public final func Refuse(reason: String, details: String, now: Float, progress: Float) -> Void {
    if !this.refusing || now < this.refusedSince {
      this.refusing = true;
      this.refusedSince = now;
    }
    this.reason = reason;
    if progress >= AutoSprintStoppedSpeed() {
      this.stopped = false;
      return;
    }
    if !this.stopped || now < this.stoppedSince {
      this.stopped = true;
      this.stoppedSince = now;
    }
    let stoppedFor: Float = now - this.stoppedSince;
    if stoppedFor >= AutoSprintBlockedAfter() && (!this.reported || now - this.lastReport >= AutoSprintBlockedEvery() || now < this.lastReport) {
      this.reported = true;
      this.lastReport = now;
      AutoSprintLog("blocked for " + ToString(stoppedFor) + " s against a step: " + reason + "; " + details);
    }
  }

  // Nothing to climb in reach.
  public final func Clear() -> Void {
    this.refusing = false;
    this.stopped = false;
  }

  // For the line of a step that starts: how long it waited, and why.
  public final func History(now: Float) -> String {
    if !this.refusing || now < this.refusedSince {
      return "at once";
    }
    let stoppedFor: Float = 0.0;
    if this.stopped && now >= this.stoppedSince {
      stoppedFor = now - this.stoppedSince;
    }
    return "after " + ToString(now - this.refusedSince) + " s refused (" + ToString(stoppedFor) + " s stopped), last: " + this.reason;
  }
}

public func AutoSprintStepWatchOf(stateContext: ref<StateContext>) -> ref<AutoSprintStepWatch> {
  let watch: ref<AutoSprintStepWatch> = stateContext.GetPermanentScriptableParameter(n"AutoSprintStepWatch") as AutoSprintStepWatch;
  if !IsDefined(watch) {
    watch = new AutoSprintStepWatch();
    stateContext.SetPermanentScriptableParameter(n"AutoSprintStepWatch", watch, true);
  }
  return watch;
}
