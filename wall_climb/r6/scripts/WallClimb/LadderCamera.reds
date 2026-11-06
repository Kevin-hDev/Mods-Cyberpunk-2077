// The game's ladder camera: on a ladder it switches to camera settings of its own (entry, default, reset, exit;
// LadderEvents.UseLadderCameraParams, scripts 2.5). With "Recentre the view on ladders" off and the mod on, every
// switch asks for the default one, on our ladder and on the game's ladders alike, since the game cannot tell them
// apart. Asking for none of them stopped the recentring, but the view no longer turned sideways on a ladder, only up
// and down (Kevin, 31 October 2026): the ladder holds V's body still. Which of the entry and reset settings recentred
// the view is game data unreadable on the Mac; the default one is the ladder's view between the two (not verified).
@wrapMethod(LadderEvents)
private final func UseLadderCameraParams(stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>, const params: LadderCameraParams) -> Void {
  let settings: ref<WallClimbSettings> = WallClimbCurrentSettings();
  if settings.enabled && !settings.ladderCamera && NotEquals(params, LadderCameraParams.None) {
    wrappedMethod(stateContext, scriptInterface, LadderCameraParams.Default);
    return;
  }
  wrappedMethod(stateContext, scriptInterface, params);
}
