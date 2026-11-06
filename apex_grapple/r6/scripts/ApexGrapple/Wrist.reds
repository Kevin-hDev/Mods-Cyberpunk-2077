// Where V's left hand is drawn: the rope starts there. The slot WeaponLeft of the component ItemAttachmentSlots sits on
// the bone WeaponLeft, where the game puts what V holds in the left hand, the launcher among them. Started from the
// slot LeftHand (the wrist joint), the rope lay on the forearm behind the fist and did not look held; LeftHand stays
// for when WeaponLeft cannot be read. Both slots: player_ma_fpp.ent, player_wa_fpp.ent, no offset.
// The arms are drawn on a plane of their own (game data cameraPlaneSettings.weapon: field of view 49, mimicPlayerFov
// true) that takes the player's field of view as it is: moved away from the camera's axis by the share 49/55, the rope
// started off the fist, down and right; drawn from the bone itself and the step below, it leaves the fist (seen in
// game).

public struct ApexGrappleWristRead {
  let found: Bool;
  // False when read at the wrist joint because the hand's slot could not be.
  let inHand: Bool;
  let at: Vector4;
}

// The component is looked up once and kept: a search by name each frame of a shot costs for nothing.
@addMethod(PlayerPuppet)
public final func ApexGrappleHandSlots() -> ref<SlotComponent> {
  return this.FindComponentByName(n"ItemAttachmentSlots") as SlotComponent;
}

public func ApexGrappleLeftHand(system: ref<ApexGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>) -> ApexGrappleWristRead {
  let read: ApexGrappleWristRead;
  let slots: ref<SlotComponent> = system.handSlots;
  if !IsDefined(slots) {
    let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
    if !IsDefined(player) {
      return read;
    }
    slots = player.ApexGrappleHandSlots();
    if !IsDefined(slots) {
      return read;
    }
    system.handSlots = slots;
  }
  let place: WorldTransform;
  if slots.GetSlotTransform(n"WeaponLeft", place) {
    read.inHand = true;
  } else {
    if !slots.GetSlotTransform(n"LeftHand", place) {
      return read;
    }
  }
  let at: Vector4 = WorldPosition.ToVector4(WorldTransform.GetWorldPosition(place));
  at.W = 1.0;
  read.found = true;
  read.at = at;
  return read;
}

// From the bone WeaponLeft to the middle of the fist as drawn, in the camera's frame. Started at the bone, the rope's
// end showed at the fist's bottom right, about 45 px right of and 93 px below the fist's middle; at the hand's 0.555 m,
// with field of view 100 and a 2304 x 1440 window, a pixel there is about 0.57 mm: 2.5 cm to the left, 5.3 cm up,
// rounded to 5.5. From there, the rope comes out of the fist's edge facing the hook (seen in game). The arm held up stays put in
// the camera's frame from shot to shot, hence that frame; while the arm rises (0.3 s) the step is only near.
public func ApexGrappleFistLeft() -> Float {
  return 0.025;
}

public func ApexGrappleFistUp() -> Float {
  return 0.055;
}

public func ApexGrappleFistMiddle(view: Transform, bone: Vector4) -> Vector4 {
  let at: Vector4 = bone - Transform.GetRight(view) * ApexGrappleFistLeft() + Transform.GetUp(view) * ApexGrappleFistUp();
  at.W = 1.0;
  return at;
}
