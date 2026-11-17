// Made by fabrique/grapple.py from Apex Grapple's LauncherWatch.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The lent launcher (Launcher.reds) is taken back by the grapple's frame, which the game stops running while V drives,
// in some scenes, and wherever the locomotion states do not update (Frame.reds). While it is lent, a callback of the
// game's delay system, which runs apart from that frame, takes it back once the frame has gone CyberGrappleLongestGap
// without running: the launcher never stays in V's hand, nor saving refused, for the length of a drive.
// One callback at a time, and none once the launcher is back.

public class CyberGrappleLauncherWatchCall extends DelayCallback {
  public let game: GameInstance;

  public func Call() -> Void {
    let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(this.game);
    if !IsDefined(system) || !IsDefined(system.loan) {
      return;
    }
    if !CyberGrappleLauncherOut(system) {
      system.loan.watched = false;
      return;
    }
    let now: Float = CyberGrappleTime(this.game);
    if now - system.lastFrameAt <= CyberGrappleLongestGap() {
      GameInstance.GetDelaySystem(this.game).DelayCallback(this, CyberGrappleLauncherWatchEvery(), false);
      return;
    }
    let player: ref<GameObject> = GetPlayer(this.game);
    if !IsDefined(player) {
      GameInstance.GetDelaySystem(this.game).DelayCallback(this, CyberGrappleLauncherWatchEvery(), false);
      return;
    }
    system.loan.watched = false;
    CyberGrappleLauncherTakeBack(system, now, player, "the grapple's frame stopped " + ToString(now - system.lastFrameAt) + " s ago");
  }
}

public func CyberGrappleLauncherWatchEvery() -> Float {
  return 0.5;
}

public func CyberGrappleLauncherWatch(system: ref<CyberGrappleSystem>, game: GameInstance) -> Void {
  let loan: ref<CyberGrappleLauncherLoan> = CyberGrappleLoanOf(system);
  if loan.watched {
    return;
  }
  loan.watched = true;
  let call: ref<CyberGrappleLauncherWatchCall> = new CyberGrappleLauncherWatchCall();
  call.game = game;
  GameInstance.GetDelaySystem(game).DelayCallback(call, CyberGrappleLauncherWatchEvery(), false);
}
