// V's speed on the wall, set again at every frame of the climb by the push the game adds to V's velocity once the
// frame's scripts are done ("impulse"). Pushed this way at every frame in the air, the push acts once: measured on
// the pull of another of our mods, the game's vertical speed then followed the wanted one to a frame of gravity, which
// the push here makes up for. Up and along the wall are set. Toward the wall, the game's own air control presses V
// against it while forward is held; the push pulls V back when V drifts farther than WallClimbHoldDistance (round a
// corner, where air control no longer points at the wall, or up a wall that leans back), and holds V out from the wall
// while leaning round an overhang or a step (Overhang.reds, Step.reds).
//
// The last write of the frame wins: during a climb the climb owns V's motion, so our push replaces any other push
// written in the air.

// V's centre from the face, in m: air control pressing the game's capsule against the wall kept it at 0.40 to 0.50 in
// game. Also the radius round an edge (Corner.reds).
public func WallClimbHoldDistance() -> Float {
  return 0.5;
}

// The pull closes the gap in about this time, and is never faster than WallClimbMostPull, in m/s.
public func WallClimbPullTime() -> Float {
  return 0.1;
}

public func WallClimbMostPull() -> Float {
  return 3.0;
}

// The game's gravity acts on V after the push, in the same frame: V climbed at 4.73 m/s for 5 at 60 frames a second in
// game, and climbs slower at fewer. What the last frames fell short of is added to the push, up to this, in m/s: a
// frame of gravity at 20 frames a second, with room.
public func WallClimbMostLag() -> Float {
  return 1.0;
}

// A push given once, as at the let-go, acts twice: half of it is given. Taking all the climb's speed away at once sent
// V down at the climbing speed in game (26 October 2026, and again in the log of 31 October); half of it, V fell from
// rest (3.60 m in 0.672 s, 26 October).
public func WallClimbOneOffShare() -> Float {
  return 0.5;
}

// `up` and `side` in m/s: up the wall, and to the right along it. V stays on the wall, pulled back to it.
public func WallClimbPush(climb: ref<WallClimbClimb>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, feet: Vector4, up: Float, side: Float, timeDelta: Float) -> Void {
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  let right: Vector4 = WallClimbAlongWall(climb.normal);
  let inward: Vector4 = climb.normal * -1.0;
  // Round an edge the move along the wall bends toward it by half the frame's turn: a chord of the arc, so V stays
  // at the same distance from the edge.
  let bend: Float = climb.rounding ? AbsF(side) * timeDelta / (2.0 * WallClimbHoldDistance()) : 0.0;
  let push: Vector4 = right * (side * CosF(bend) - Vector4.Dot(velocity, right));
  let goingIn: Float = Vector4.Dot(velocity, inward);
  if climb.overhang {
    // Away from the wall until V is clear of the overhang's or step's face, then no nearer (Overhang, Step.reds).
    let wantOut: Float = ClampF(WallClimbLeanLeft(climb, feet) / WallClimbPullTime(), 0.0, WallClimbMostPull());
    push = push - inward * (wantOut + goingIn);
  } else {
    let distance: Float = Vector4.Dot(feet - climb.wallPoint, climb.normal);
    // A wall that leans back moves away from V climbing it, by the climb's speed times the tangent of the lean: up to
    // 1.9 m/s at 20 degrees at the normal speed, past the pull's limit at three times the speed.
    let recede: Float = up * climb.slant / SqrtF(1.0 - climb.slant * climb.slant);
    let wantIn: Float = AbsF(side) * SinF(bend) + ClampF((distance - WallClimbHoldDistance()) / WallClimbPullTime(), 0.0, WallClimbMostPull()) + recede;
    if goingIn < wantIn {
      push = push + inward * (wantIn - goingIn);
    }
  }
  if climb.pushed {
    climb.upLag = ClampF(climb.upLag + climb.upAsked - velocity.Z, 0.0, WallClimbMostLag());
  }
  climb.pushed = true;
  climb.upAsked = up;
  push.Z = up + climb.upLag - velocity.Z;
  stateContext.SetTemporaryVectorParameter(n"impulse", push, true);
}

// The let-go: the speed the climb gave V, up and along the wall, is taken away (WallClimbOneOffShare).
public func WallClimbStopPush(climb: ref<WallClimbClimb>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let velocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
  let right: Vector4 = WallClimbAlongWall(climb.normal);
  let push: Vector4 = right * (-Vector4.Dot(velocity, right) * WallClimbOneOffShare());
  push.Z = -velocity.Z * WallClimbOneOffShare();
  stateContext.SetTemporaryVectorParameter(n"impulse", push, true);
}
