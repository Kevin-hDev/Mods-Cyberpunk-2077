// Made by fabrique/grapple.py from Apex Grapple's YankSeen.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// A person pulled to V kept updated off screen. The game stops updating a body out of view: thrown out of it, the person
// froze where last seen, then jumped to their place when looked at again (Kevin's test of 2 November 2026: chest read
// at 0.03 m/s at the throw, then 449 m/s). The game keeps enemies revealed through walls updated the same way
// (ScriptedPuppet.OnRevealStateChanged), by a named request to its AnimationSystemForcedVisibilityManager.

public func CyberGrappleYankSeenSource() -> CName {
  return n"CyberGrapple";
}

// After the pull's end: the body has landed and mostly settled (the shield ended 1 to 4 s after the hook in game).
public func CyberGrappleYankSeenAfter() -> Float {
  return 5.0;
}

// Sent to the manager by the person's id, not through the person: the game's own helper also sets a flag on the person
// that every source overwrites, and the manager forgets a despawned person's requests only while that flag is set
// (GameObject.OnDetach, ToggleForcedVisibilityInAnimSystem): our "off" would have cleared it under the game's own
// reveal, and a person gone before the end could not have been sent the "off" at all. `after`: the delay before "off".
public func CyberGrappleKeepSeen(game: GameInstance, id: EntityID, keep: Bool, after: Float) -> Void {
  let manager: ref<AnimationSystemForcedVisibilityManager> = GameInstance.GetScriptableSystemsContainer(game).Get(n"AnimationSystemForcedVisibilityManager") as AnimationSystemForcedVisibilityManager;
  if !IsDefined(manager) || !EntityID.IsDefined(id) {
    return;
  }
  let request: ref<ToggleVisibilityInAnimSystemRequest> = new ToggleVisibilityInAnimSystemRequest();
  request.entityID = id;
  request.isVisible = keep;
  request.sourceName = CyberGrappleYankSeenSource();
  request.transitionTime = after;
  manager.QueueRequest(request);
}
