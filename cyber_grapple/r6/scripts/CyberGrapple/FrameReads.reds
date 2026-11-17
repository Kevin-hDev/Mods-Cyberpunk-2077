// Made by fabrique/grapple.py from Apex Grapple's FrameReads.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// What the grapple's frame (Frame.reds) reads of the game in more than one of its parts, read once a frame and shared:
// the camera and V's velocity, read by the pull and then by our pieces (audit of 10 November 2026, B15), how far the
// camera is from V's eyes, read by the arm and then by the field of view, and the gadget key's press, read by the key's
// profile and then by the key (A8). Each is kept with the number of the frame it was read in and read again in any
// other frame; nothing between two parts of one frame moves the camera or V (the pull's push acts in a later frame,
// Pulling.reds), and a press is the frame's.

public func CyberGrappleGadgetKeyNow(system: ref<CyberGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if system.gadgetKeyReadIn != system.frames {
    system.gadgetKeyRead = scriptInterface.IsActionJustPressed(n"UseCombatGadget");
    system.gadgetKeyReadIn = system.frames;
  }
  return system.gadgetKeyRead;
}

public func CyberGrappleViewNow(system: ref<CyberGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>) -> Transform {
  if system.viewReadIn != system.frames {
    system.viewRead = scriptInterface.GetCameraWorldTransform();
    system.viewReadIn = system.frames;
  }
  return system.viewRead;
}

public func CyberGrappleVelocityNow(system: ref<CyberGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>) -> Vector4 {
  if system.velocityReadIn != system.frames {
    system.velocityRead = DefaultTransition.GetLinearVelocity(scriptInterface);
    system.velocityReadIn = system.frames;
  }
  return system.velocityRead;
}

public func CyberGrappleEyesNow(system: ref<CyberGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>) -> Float {
  if system.eyesReadIn != system.frames {
    system.eyesRead = CyberGrappleCameraFromEyes(scriptInterface);
    system.eyesReadIn = system.frames;
  }
  return system.eyesRead;
}
