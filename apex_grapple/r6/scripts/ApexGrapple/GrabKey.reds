// The game's grab key, seen down between the shot and the hook's bite (Grab.reds). The game's "Grab" is its first
// interaction choice, the action Choice1: F on a keyboard, Square or X on a pad (inputUserMappings.xml), the button a
// pad also reloads with. The game takes that action's release only (inputContexts.xml, acceptedEvents); the action
// Choice1_Release is the same button with every event, and its value tells the button is down.
// Twenty-third trial, 12 November 2026, three readings side by side: that value saw the key in 10 grabs of 10, the
// button held as the grapple fired; Choice1's own release and its value saw nothing in any of the 20 shots.

// One frame from the shot to the bite. Nothing is read unless the hook flies to a person who may be grabbed
// (Target.reds), nor once the key was seen.
public func ApexGrappleGrabKeyRead(system: ref<ApexGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !system.mayGrab || system.grabKeySeen {
    return;
  }
  system.grabKeySeen = scriptInterface.GetActionValue(n"Choice1_Release") > 0.0;
}
