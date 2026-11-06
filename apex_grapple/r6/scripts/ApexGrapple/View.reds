// Whether V is seen from the eyes (first person) or from outside (third person): the camera that draws the frame is
// V's own eye camera, or another one away from it. Seen in game: 0 m from the eyes in first person, 1.44 to 2.21 m in
// third. A third-person camera pushed against a wall or under a low ceiling comes within half a metre of the head.
// ponytail: a third-person view made by moving V's eye camera itself reads 0 m and is taken for the eyes; add a check
// of that camera's own offset if that case is ever seen.

// Farther than this from the eyes, the camera is outside V's head.
public func ApexGrappleEyesReach() -> Float {
  return 0.2;
}

// How far the camera drawing the frame is from V's eyes; -1 when either cannot be read.
public func ApexGrappleCameraFromEyes(scriptInterface: ref<StateGameScriptInterface>) -> Float {
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if !IsDefined(player) {
    return -1.0;
  }
  let eyes: ref<FPPCameraComponent> = player.GetFPPCameraComponent();
  let drawing: Transform;
  if !IsDefined(eyes) || !GameInstance.GetCameraSystem(scriptInterface.GetGame()).GetActiveCameraWorldTransform(drawing) {
    return -1.0;
  }
  return Vector4.Distance(Transform.GetPosition(drawing), Matrix.GetTranslation(eyes.GetLocalToWorld()));
}

// What cannot be read changes nothing: the arm's signals stay as they are, down for a shot from rest. Up while V is
// seen from outside, they hide V's left arm; down in first person, only the gesture is lost.
public func ApexGrappleNearEyes(distance: Float, before: Bool) -> Bool {
  if distance < 0.0 {
    return before;
  }
  return distance <= ApexGrappleEyesReach();
}
