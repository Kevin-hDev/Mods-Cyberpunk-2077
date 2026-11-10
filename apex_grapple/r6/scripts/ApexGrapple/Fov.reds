// The field of view widens while a pull moves V and comes back when it stops (docs/apex-grapple/fov/conception.md),
// through the first-person camera's SetFOV, the only way that showed in game. What the camera does with it, read in game
// on 10 November 2026 (releves/apex-grapple/2026-11-10-fov-sonde and 2026-11-10-fov-sonde-2): each SetFOV starts the
// game's own 1 s smoothing again from where the camera is, so a value written every frame is shown half a second late.
// Each frame therefore writes the value that brings the camera onto the wanted curve one frame later, and the camera
// shows the curve itself. This file holds the numbers; FovFrame.reds writes them.

public class ApexGrappleFov {
  // The camera is off the player's field of view because of us: widening, widened, or coming back.
  public let on: Bool;
  // Heading for the widened field of view, or back to the player's.
  public let wide: Bool;
  // Where the camera was when the current transition started, and when.
  public let from: Float;
  public let since: Float;
  // The transition's end has been written to the log.
  public let reached: Bool;
  // Game time of the last frame the effect ran, and the last value written: once the curve has reached its end, the
  // same value is not written again.
  public let lastAt: Float;
  public let written: Float;
  // The player's field of view as the camera holds it, read from the game's setting each frame the effect is on.
  public let home: Float;
  // The settings of the profile whose pull widened it: the way back keeps them once that pull has let go.
  public let widening: Float;
  public let transition: Float;
  // Why the current pull does not widen the view, as last written to the log.
  public let refused: String;
  // Lines written this load (ApexGrappleLogUpTo): the grapple's system is made again at each load.
  public let lines: Int32;
}

// Lines a load: Kevin's trial of 10 November 2026 wrote about 3 a pull, 125 for 41 pulls.
public func ApexGrappleFovMostLines() -> Int32 {
  return 300;
}

public func ApexGrappleFovLog(fov: ref<ApexGrappleFov>, const text: String) -> Void {
  fov.lines = ApexGrappleLogUpTo(fov.lines, ApexGrappleFovMostLines(), "field of view", text);
}

// Kevin's upper bound for the widened field of view, in the degrees of the game's setting.
public func ApexGrappleFovHighest() -> Float {
  return 140.0;
}

// The game's smoothing, in seconds (fovSmoothingDuration of the game's first-person camera data).
public func ApexGrappleFovSmoothing() -> Float {
  return 1.0;
}

// The part of the way to the value written that the camera covers in dt seconds: the game's smoothing is the ease-out
// 1 - (1 - t)², started again by each SetFOV (second probe: 19 % of the way at 0.1 s; written every frame, a time
// constant of 0.5 s, up and down alike).
public func ApexGrappleFovPart(dt: Float) -> Float {
  let left: Float = 1.0 - ClampF(dt / ApexGrappleFovSmoothing(), 0.0, 1.0);
  return 1.0 - left * left;
}

// The game's Field of View setting, in its menu's degrees; 0 when it cannot be read.
public func ApexGrappleFovSetting(game: GameInstance) -> Float {
  let settings: ref<UserSettings> = GameInstance.GetSettingsSystem(game);
  if !IsDefined(settings) {
    return 0.0;
  }
  let fov: ref<ConfigVarFloat> = settings.GetVar(n"/graphics/basic", n"FieldOfView") as ConfigVarFloat;
  return IsDefined(fov) ? fov.GetValue() : 0.0;
}

// The setting is not the number the camera holds: 100 in the menu gave the camera 68.237984 (first probe). The other
// values follow a horizontal angle turned into a vertical one, set on that point; this falls within 0.3 degrees of a
// table measured by hand from 0 to 175, which gives the same 68.238 for 100.
public func ApexGrappleFovCameraOf(setting: Float) -> Float {
  let k: Float = TanF(Deg2Rad(68.237984 * 0.5)) / TanF(Deg2Rad(50.0));
  return 2.0 * Rad2Deg(AtanF(k * TanF(Deg2Rad(setting * 0.5)), 1.0));
}

// The widened field of view as the camera holds it. A setting already past 140 (raised by another mod) is never
// narrowed.
public func ApexGrappleFovWideOf(setting: Float, widening: Float) -> Float {
  return ApexGrappleFovCameraOf(MaxF(setting, MinF(setting + widening, ApexGrappleFovHighest())));
}

// A settings file edited by hand keeps the menu's bounds.
public func ApexGrappleFovWideningOf(settings: ref<ApexGrappleSettings>) -> Float {
  return ClampF(settings.fovWidening, 0.0, 40.0);
}

public func ApexGrappleFovTransitionOf(settings: ref<ApexGrappleSettings>) -> Float {
  return ClampF(settings.fovTransition, 0.5, 3.0);
}

// The wanted field of view t seconds into a transition from `from` to `to`, slow at both ends.
public func ApexGrappleFovCurve(from: Float, to: Float, length: Float, t: Float) -> Float {
  let u: Float = ClampF(t / length, 0.0, 1.0);
  return from + (to - from) * u * u * (3.0 - 2.0 * u);
}

// The value to write now so that the camera, on the curve now, is on it again a frame later: that frame's step divided
// by the part of the way the camera covers in a frame. This frame's time stands for the next one's. From the curve's
// end on, `to` itself. Simulated on the camera read in game: within 0.2 degrees of the curve at 30 frames a second
// with frame times 30 % apart.
public func ApexGrappleFovWritten(from: Float, to: Float, length: Float, t: Float, frame: Float) -> Float {
  let now: Float = ApexGrappleFovCurve(from, to, length, t);
  let next: Float = ApexGrappleFovCurve(from, to, length, t + frame);
  return now + (next - now) / MaxF(ApexGrappleFovPart(frame), 0.001);
}

// Ahead of the curve, the value written leaves the range between the two ends: from 18 to 165 at 0.5 s and +40,
// simulated. It is kept within what a camera can show.
public func ApexGrappleFovSafe(value: Float) -> Float {
  return ClampF(value, 10.0, 170.0);
}
