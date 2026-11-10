// One grapple at a time: its phase and numbers, kept from frame to frame and from one locomotion state to the next.
// A system attaches again at each load, so a grapple never survives a load.

public func ApexGrappleIdle() -> Int32 {
  return 0;
}

public func ApexGrappleFlying() -> Int32 {
  return 1;
}

public func ApexGrapplePulling() -> Int32 {
  return 2;
}

public class ApexGrappleSystem extends ScriptableSystem {
  public let phase: Int32;
  public let shots: Int32;
  // When the grapple's frame last ran (Frame.reds), to see the game stop running it.
  public let lastFrameAt: Float;
  // The shot.
  public let anchor: Vector4;
  public let firedAt: Float;
  public let landsAt: Float;
  // Fired by a hold: pulls all the way.
  public let byHold: Bool;
  // A vehicle or a person the hook follows (Target.reds); a person pulled to V rather than V to them (Yank.reds).
  public let target: wref<GameObject>;
  public let onTarget: Bool;
  public let targetPerson: Bool;
  public let targetLocal: Vector4;
  public let comesToV: Bool;
  public let yank: ref<ApexGrappleYank>;
  // People kept from the blows of their fall after a pull, until they have got up (YankShield.reds).
  public let shielded: array<ApexGrappleShielded>;
  // The pull.
  public let startedAt: Float;
  public let startPosition: Vector4;
  public let lastPosition: Vector4;
  // The nearest V has come to the anchor, for the log.
  public let closest: Float;
  public let near: Float;
  // V has moved toward the anchor during this pull: from then on, once past it, nothing pulls V back (Pull.reds).
  public let cameToward: Bool;
  // How far V has gone round the anchor, in degrees, for the log.
  public let lastRope: Vector4;
  public let turned: Float;
  public let pullCap: Float;
  // The mod's own velocity, written each frame without reading back what the game made of it: read back, the game's
  // air control turned it before the mod could (Borderlands 4).
  public let velocity: Vector4;
  public let topSpeed: Float;
  // Distance asked for and distance gone at the game's speed, over the last stretch of the pull (Release.reds).
  public let stretchTime: Float;
  public let stretchAsked: Float;
  public let stretchWent: Float;
  // The push written this frame and when, written again at the end of a frame in the air (Push.reds).
  public let push: Vector4;
  public let pushAt: Float;
  public let pushesWrittenBack: Int32;
  // The key.
  public let keyDown: Bool;
  public let pressedAt: Float;
  public let releasedAt: Float;
  public let waitingForHold: Bool;
  // One place per profile, profile 1 first (OwnKey.reds).
  public let ownPressesSeen: array<Int32>;
  public let holdBackUntil: Float;
  // The profile whose key is read and its settings (KeyProfile.reds); the profile that fired the last grapple and its
  // settings as they were at the shot (Profiles.reds).
  public let keyProfile: Int32;
  public let keySettings: ref<ApexGrappleSettings>;
  public let profile: Int32;
  public let settings: ref<ApexGrappleSettings>;
  // The last press was of the game's quick melee button, whose strike the grapple may hold back (KeyBindings.reds).
  public let keyIsQuickMelee: Bool;
  // A press of the scanner's button, down until its release, when it began, and the shot decided at the press.
  public let sharedDown: Bool;
  public let sharedPressedAt: Float;
  public let pendingShot: ApexGrappleShotCheck;
  public let jumpLetGoAt: Float;
  // This pull has asked the game to take V off a ladder (LadderExit.reds), for a single log line; it started on one.
  public let ladderLeft: Bool;
  public let fromLadder: Bool;
  // A double jump after a shot, watched for its first moments (Jump.reds): when, V's vertical speed then, the highest.
  public let doubleJumpWatched: Bool;
  public let doubleJumpAt: Float;
  public let doubleJumpBefore: Float;
  public let doubleJumpTop: Float;
  // From the shot until V has stood ApexGrappleSettleTime() on the ground: the soft landing (Landing.reds), the hidden
  // fall effect (FallEffect.reds) and the ladder rule (Ladder.reds) cover it.
  public let trajectory: Bool;
  // The landing the game itself judged this air frame, before the soft landing wrote it back.
  public let gameLanding: Int32;
  // For the line once back on the ground: the hardest landing turned into a regular one, the fastest fall, the frames
  // a ladder entry was refused (Ladder.reds).
  public let landingRewritten: Int32;
  public let fastestFall: Float;
  public let ladderRefusals: Int32;
  // The game's fall effect: let through once in this air state (option on), and how often it was held back.
  public let fallEffectShown: Bool;
  public let fallEffectsHeldBack: Int32;
  // A rise in the fall shown as a jump (Fall.reds), since when, and the pull its rise was told for, by its start.
  public let riseShown: Bool;
  public let riseShownAt: Float;
  public let riseFor: Float;
  // On the ground since then, for ApexGrappleSettleTime().
  public let onGroundBefore: Bool;
  public let groundSince: Float;
  public let speedLimitToRestore: Bool;
  public let speedLimitBefore: Bool;
  public let settingsLogged: String;
  // Our pieces (Pieces.reds), kept as their base class so the field compiles without Codeware.
  public let pieces: ref<IScriptable>;
  // V's left arm (Arm.reds), the right-hand weapon (RightWeapon.reds), the sounds of this shot (Sounds.reds).
  public let arm: ref<ApexGrappleArm>;
  public let weapon: ref<ApexGrappleRightWeapon>;
  public let sounds: ref<ApexGrappleSounds>;
  // The launcher lent to V's left hand (Launcher.reds).
  public let loan: ref<ApexGrappleLauncherLoan>;
  // Where V's left hand is read (Wrist.reds), and whether its fallback was said this load.
  public let handSlots: wref<SlotComponent>;
  public let handMissSaid: Bool;
  // Our crosshair's range indicator (CrosshairRange.reds), owned by the crosshair, which links it here as it attaches.
  public let crosshairRange: wref<ApexGrappleCrosshairRange>;
  // The field of view widened during a pull (Fov.reds), made the first time a pull moves V.
  public let fov: ref<ApexGrappleFov>;

  private func OnAttach() -> Void {
    ArrayResize(this.ownPressesSeen, ApexGrappleProfileCount());
    this.keyProfile = 1;
    this.profile = 1;
    this.settingsLogged = ApexGrappleProfilesText();
    ApexGrappleLog("loaded; settings in use: " + this.settingsLogged);
    ApexGrappleSayWhatCodewareGives();
  }

  // A save made while the launcher is lent would keep it in V's inventory (Launcher.reds).
  private func IsSavingLocked() -> Bool {
    return ApexGrappleLauncherOut(this);
  }
}

// A pull that moves V. While a person is pulled to V, V is left to the game.
public func ApexGrappleMovesV(system: ref<ApexGrappleSystem>) -> Bool {
  return system.phase == ApexGrapplePulling() && !system.comesToV;
}

public func ApexGrappleSystemOf(game: GameInstance) -> ref<ApexGrappleSystem> {
  return GameInstance.GetScriptableSystemsContainer(game).Get(n"ApexGrappleSystem") as ApexGrappleSystem;
}

// Settings change during play: each shot writes them again if they changed since the last line.
public func ApexGrappleLogSettingsIfChanged(system: ref<ApexGrappleSystem>) -> Void {
  let text: String = ApexGrappleProfilesText();
  if !Equals(text, system.settingsLogged) {
    system.settingsLogged = text;
    ApexGrappleLog("settings in use: " + text);
  }
}
