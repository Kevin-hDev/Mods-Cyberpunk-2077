// "Stay hooked" (docs/apex-grapple/balancement/conception.md, decision 14): where a pull would end in the air, at the
// arrival, past the anchor or against something, the hook stays in and the rope goes through three stages
// (SwingFrame.reds). V's own flight: the rope does nothing and the game flies V as after any pull, while V rises
// or comes toward the anchor. The rope pays out: it takes what carries V away from the anchor, softly, until V no
// longer goes away. The rope comes back in to the length V hangs on, holds V at its end and damps the swing. Kevin,
// 18 November 2026: "le but, c'est pas de forcer V en le bloquant". A rope kept short at once, with a brake, stopped
// V in the air (up to 106 m/s2 in a frame in his trial), and a pull that ended past the anchor let go by itself. In
// the air only the player lets go (decision 15). Its lines in the log: SwingFrame.reds (each stage's start) and
// SwingLog.reds (the pull's last line).

public func ApexGrappleSwingFlies() -> Int32 {
  return 0;
}

public func ApexGrappleSwingPaysOut() -> Int32 {
  return 1;
}

public func ApexGrappleSwingComesBack() -> Int32 {
  return 2;
}

// What the rope takes, each second, of the speed that carries V away from the anchor while it pays out. 24 m/s2 is a
// little over half the default pull strength (33.3): at the 19 arrivals of Kevin's trial of 18 November 2026,
// replayed off the game, the rope takes 15 m/s from V in half a second at most, against up to 36 with the brake.
public func ApexGrappleSwingSoft() -> Float {
  return 24.0;
}

// How fast the rope's length comes back in to the one V hangs on, in m/s.
public func ApexGrappleSwingComesIn() -> Float {
  return 10.0;
}

// The share of its speed V loses each second at the end of the rope. At 0.1, V still swung at 2.4 m/s after 12.7 s on
// a 4.4 m rope (Kevin, 17 November 2026: an endless swing, V "devrait se stabiliser un minimum à la fin"). At 1, the
// rope sets of that trial replayed off the game come to a still hang in 4 to 7 s.
public func ApexGrappleSwingDamping() -> Float {
  return 1.0;
}

// Past the rope's length, each second takes back this share of the stretch, at most ApexGrappleSwingReelMost m/s:
// above ApexGrappleSwingComesIn, or V could not follow the rope coming in.
public func ApexGrappleSwingReel() -> Float {
  return 4.0;
}

public func ApexGrappleSwingReelMost() -> Float {
  return 13.0;
}

// At its end the rope holds V as hard as the pull pulls, and never under this many times gravity: held only as hard
// as a "Pull strength" set under gravity, it could not carry V, who slid down it to the ground (audit of 17 November
// 2026, R2). At 2 (32 m/s²), the default pull strength (33.3) and above keep the hold tried in game.
public func ApexGrappleSwingHoldShare() -> Float {
  return 2.0;
}

public func ApexGrappleSwingHold(pull: Float, gravity: Float) -> Float {
  return MaxF(pull, gravity * ApexGrappleSwingHoldShare());
}

// Why the hook cannot stay in, 0 when it can: only with V in the air, on a surface (a rope tied to a moving vehicle or
// person would drag V). Everywhere else the pull ends as without the setting. In game, a rope kept with V on the
// ground left V walking with the rope on the arm (Kevin, 17 November 2026). A number, not a text: asked at each end.
public func ApexGrappleNoHang(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, onGround: Bool) -> Int32 {
  if !settings.stayHooked {
    return 1;
  }
  if system.onTarget {
    return 2;
  }
  if onGround {
    return 3;
  }
  return 0;
}

// For the pull's last line: why the rope was not kept. Empty when it could be, and with the setting off.
public func ApexGrappleNoHangText(why: Int32) -> String {
  if why == 2 {
    return " (rope not kept: the hook is on a vehicle or a person)";
  }
  if why == 3 {
    return " (rope not kept: V is on the ground)";
  }
  if why == ApexGrappleNoHangBehind() {
    return " (rope not kept: something stands between V and the anchor)";
  }
  return "";
}

// After a blow only (Pulling.reds): the anchor is behind what stopped V. Its ray is cast once, at the blow, so it is
// not one of ApexGrappleNoHang's answers.
public func ApexGrappleNoHangBehind() -> Int32 {
  return 5;
}

// The velocity to write this frame while the rope pays out: gravity in full, then what carries V away from the anchor
// goes at `soft` m/s² at most, never at once. Under the anchor the rope also carries the share of V's weight that
// pulls along it: without it, a V falling straight under the anchor lost 8 m/s² only (24 less the game's 16) and
// reached the ground. `took`: the speed V lost this frame, against its speed before the frame's gravity, so that the
// share which only carries V's weight is not told as slowing (review of 18 November 2026); `away`: V still goes away.
public func ApexGrappleSwingPayOut(velocity: Vector4, middle: Vector4, anchor: Vector4, gravity: Float, soft: Float, frame: Float, out took: Float, out away: Bool) -> Vector4 {
  took = 0.0;
  away = false;
  let step: Float = ClampF(frame, 0.0, ApexGrappleLongestFrame());
  let result: Vector4 = velocity;
  result.Z = result.Z - gravity * step;
  let from: Vector4 = middle - anchor;
  let gap: Float = Vector4.Length(from);
  if gap <= ApexGrappleTiny() {
    return result;
  }
  let radial: Vector4 = from * (1.0 / gap);
  let outward: Float = Vector4.Dot(result, radial);
  if outward <= 0.0 {
    return result;
  }
  let pulled: Float = MinF(outward, (soft + MaxF(-gravity * radial.Z, 0.0)) * step);
  away = outward > pulled;
  result = result - radial * pulled;
  took = MaxF(Vector4.Length(velocity) - Vector4.Length(result), 0.0);
  return result;
}

// The velocity to write this frame once the rope comes back in: gravity in full, then the rope. Slack while the next
// step stays within its length; at its end it takes what carries V away from the anchor, ApexGrappleSwingHold m/s² at
// most, reels the stretch back in, and damps the swing. `held`: the speed lost at the rope's end, against V's speed
// before the frame's gravity (a V hanging still loses none); `taut`: the rope held V this frame.
public func ApexGrappleSwingStep(velocity: Vector4, middle: Vector4, anchor: Vector4, rope: Float, gravity: Float, pull: Float, frame: Float, out held: Float, out taut: Bool) -> Vector4 {
  held = 0.0;
  taut = false;
  let step: Float = ClampF(frame, 0.0, ApexGrappleLongestFrame());
  if step <= 0.0 {
    return velocity;
  }
  let result: Vector4 = velocity;
  result.Z = result.Z - gravity * step;
  let from: Vector4 = middle - anchor;
  let gap: Float = Vector4.Length(from);
  if gap <= ApexGrappleTiny() {
    return result;
  }
  let radial: Vector4 = from * (1.0 / gap);
  let outward: Float = Vector4.Dot(result, radial);
  if gap + outward * step <= rope {
    return result;
  }
  taut = true;
  let before: Float = Vector4.Length(velocity);
  let wanted: Float = -MinF(MaxF(gap - rope, 0.0) * ApexGrappleSwingReel(), ApexGrappleSwingReelMost());
  if outward > wanted {
    result = result - radial * MinF(outward - wanted, ApexGrappleSwingHold(pull, gravity) * step);
  }
  result = result * MaxF(1.0 - ApexGrappleSwingDamping() * step, 0.0);
  held = MaxF(before - Vector4.Length(result), 0.0);
  return result;
}
