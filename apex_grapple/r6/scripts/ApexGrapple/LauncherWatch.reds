// The lent launcher (Launcher.reds) is taken back by the grapple's frame, which the game stops running while V drives,
// in some scenes, and wherever the locomotion states do not update (Frame.reds). While it is lent, a callback of the
// game's delay system, which runs apart from that frame, takes it back once the frame has gone ApexGrappleLongestGap
// without running: the launcher never stays in V's hand, nor saving refused, for the length of a drive.
// One callback at a time, and none once the launcher is back.

public class ApexGrappleLauncherWatchCall extends DelayCallback {
  public let game: GameInstance;

  public func Call() -> Void {
    let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(this.game);
    if !IsDefined(system) || !IsDefined(system.loan) {
      return;
    }
    if !ApexGrappleLauncherOut(system) {
      system.loan.watched = false;
      return;
    }
    let now: Float = ApexGrappleTime(this.game);
    if now - system.lastFrameAt <= ApexGrappleLongestGap() {
      GameInstance.GetDelaySystem(this.game).DelayCallback(this, ApexGrappleLauncherWatchEvery(), false);
      return;
    }
    let player: ref<GameObject> = GetPlayer(this.game);
    if !IsDefined(player) {
      GameInstance.GetDelaySystem(this.game).DelayCallback(this, ApexGrappleLauncherWatchEvery(), false);
      return;
    }
    system.loan.watched = false;
    ApexGrappleLauncherTakeBack(system, now, player, "the grapple's frame stopped " + ToString(now - system.lastFrameAt) + " s ago");
  }
}

public func ApexGrappleLauncherWatchEvery() -> Float {
  return 0.5;
}

public func ApexGrappleLauncherWatch(system: ref<ApexGrappleSystem>, game: GameInstance) -> Void {
  let loan: ref<ApexGrappleLauncherLoan> = ApexGrappleLoanOf(system);
  if loan.watched {
    return;
  }
  loan.watched = true;
  let call: ref<ApexGrappleLauncherWatchCall> = new ApexGrappleLauncherWatchCall();
  call.game = game;
  GameInstance.GetDelaySystem(game).DelayCallback(call, ApexGrappleLauncherWatchEvery(), false);
}
