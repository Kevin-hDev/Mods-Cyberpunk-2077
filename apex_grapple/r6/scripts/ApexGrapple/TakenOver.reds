// Locomotion states whose own OnUpdate does not call LocomotionEventsTransition's (scripts 2.31): the grapple's frame
// (Frame.reds) did not run in them. A ledge caught in the middle of a pull (state climb) left V standing on a bridge,
// then the frozen pull went on and threw V off at 50 m/s. The frame runs in them too, and the grapple lets go there
// (ApexGrappleBlockedHere). Left out, never met during a grapple: braindance flight, the low gravity slide
// and dodge, breaking free of a grab; there, and wherever else the frame stops, ApexGrappleLongestGap ends the
// grapple once the frame runs again.

@wrapMethod(ClimbEvents)
public func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  this.ApexGrappleFrame(timeDelta, stateContext, scriptInterface);
}

@wrapMethod(SuperheroLandEvents)
public func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  this.ApexGrappleFrame(timeDelta, stateContext, scriptInterface);
}
