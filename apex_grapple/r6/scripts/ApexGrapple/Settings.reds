// The player's settings, shown by Mod Settings in Options > Mods when it is installed. Without Mod Settings the fields
// keep the values written here. Mod Settings updates the class's default values when a setting changes, so a new
// instance reads the current value: the mod makes its copy that way at each change (SettingsCopy.reds). This class is profile 1;
// profiles 2 to 5 are made from it by fabrique/profiles.py, so a setting is written here only.
//
// Profile 1's settings are in sections by theme, each of which Mod Settings Navigator folds on its own (Kevin, 11
// November 2026: one long list was hard to find one's way in); "Show settings" stays, for players without it. Profiles 2
// to 5 stay one folded block each, in the same field order: Mod Settings shows a section's title even when all its lines
// are hidden, so split they would leave 28 empty titles on the page. Every field gives its section's order, whichever
// field Mod Settings reads it from. The orders follow on: crosshair 0, profile 1 from 1 to 8, then profiles 2 to 5.
//
// Defaults: the author's, set by hand over an hour and 380 pulls of the Borderlands 4 version, converted to metres
// (1 unit = 1 cm). Its forces were multiples of a doubled gravity (19.6 m/s²); here they are in m/s², the force felt,
// because Cyberpunk's gravity changes from one state to another. Range, steering, take-off time, arrival, let go past
// the point and longest pull: set in Cyberpunk over some 350 pulls.
public class ApexGrappleSettings {
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-Enabled")
  @runtimeProperty("ModSettings.description", "ApexGrapple-Enabled-Description")
  public let enabled: Bool = true;

  // Profile 1's fold line (Profiles.reds): open by default, so that a player who updates finds the settings in view.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-ShowSettings")
  @runtimeProperty("ModSettings.description", "ApexGrapple-ShowSettings-Description")
  public let showSettings: Bool = true;

  // The quick melee key by default: the author's controller bindings had no button free on foot.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Key")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-OwnKey")
  @runtimeProperty("ModSettings.description", "ApexGrapple-OwnKey-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let ownKey: Bool = false;

  // A side mouse button, free on foot in the author's bindings. Not the wheel: Codeware's key events never bring it.
  // Shown with the profile, own key on or not: Mod Settings hides a line behind one switch only, and that is the
  // fold line.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Key")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-Key")
  @runtimeProperty("ModSettings.description", "ApexGrapple-Key-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let key: EInputKey = EInputKey.IK_Mouse4;

  // As in the Borderlands 4 version: hold for the grapple, tap for the quick melee, one switch per device, both off so
  // nothing changes for a player who did not ask.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Key")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-KeyboardHold")
  @runtimeProperty("ModSettings.description", "ApexGrapple-KeyboardHold-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let keyboardHold: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Key")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-ControllerHold")
  @runtimeProperty("ModSettings.description", "ApexGrapple-ControllerHold-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let controllerHold: Bool = false;

  // Not under 0.2 s: an ordinary click can last that long.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Key")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-HoldTime")
  @runtimeProperty("ModSettings.description", "ApexGrapple-HoldTime-Description")
  @runtimeProperty("ModSettings.step", "0.05")
  @runtimeProperty("ModSettings.min", "0.2")
  @runtimeProperty("ModSettings.max", "1.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let holdTime: Float = 0.4;

  // Why these two and their defaults: Implant.reds.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Hook")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-Implant")
  @runtimeProperty("ModSettings.description", "ApexGrapple-Implant-Description")
  @runtimeProperty("ModSettings.displayValues.None", "ApexGrapple-Implant-None")
  @runtimeProperty("ModSettings.displayValues.ProjectileLauncher", "ApexGrapple-Implant-ProjectileLauncher")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let implant: ApexGrappleImplant = ApexGrappleImplant.ProjectileLauncher;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Hook")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-RequireLauncher")
  @runtimeProperty("ModSettings.description", "ApexGrapple-RequireLauncher-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let requireLauncher: Bool = false;

  // 150 m since 2 November 2026 (Kevin: "augmenter la distance du grappin, passer de 100 à 150 max"); the rope's
  // pieces stretch to cover it (ApexGrappleRopePieceFor, RopeShape.reds).
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Hook")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-Range")
  @runtimeProperty("ModSettings.description", "ApexGrapple-Range-Description")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "5.0")
  @runtimeProperty("ModSettings.max", "150.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let range: Float = 150.0;

  // A starting point in Borderlands 4, measured nowhere.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Hook")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-HookSpeed")
  @runtimeProperty("ModSettings.description", "ApexGrapple-HookSpeed-Description")
  @runtimeProperty("ModSettings.step", "5.0")
  @runtimeProperty("ModSettings.min", "10.0")
  @runtimeProperty("ModSettings.max", "300.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let hookSpeed: Float = 50.0;

  // Times the hook speed, on its way back: a new shot waits for the hook home, and at 40 m/s a 150 m rope took 3.75 s.
  // 2.5 by default: twice asked first (Kevin, 2 November 2026), then "on va mettre le réglage à 2,5 par défaut" once
  // tried (3 November). A multiple rather than a speed, so that the default keeps to the way out whatever the hook
  // speed set.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Hook")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-HookReturn")
  @runtimeProperty("ModSettings.description", "ApexGrapple-HookReturn-Description")
  @runtimeProperty("ModSettings.step", "0.5")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "5.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let hookReturn: Float = 2.5;

  // 1.7 times 19.6 m/s². Titanfall 2 measures 1.8 times its own gravity; a little softer felt better.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Pull")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PullStrength")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PullStrength-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "2.0")
  @runtimeProperty("ModSettings.max", "80.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let pullStrength: Float = 33.3;

  // At 20 too much speed was lost. Up to 50: the engine holds V to the extended limits of speed_cap.yaml, 50 m/s, and
  // a higher cap would not show.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Pull")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PullSpeedCap")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PullSpeedCap-Description")
  @runtimeProperty("ModSettings.step", "0.5")
  @runtimeProperty("ModSettings.min", "2.0")
  @runtimeProperty("ModSettings.max", "50.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let pullSpeedCap: Float = 25.0;

  // Borderlands 4 had 39.2 for the stick (2.0 times 19.6 m/s²); with the aim, 120 felt right: at 25 m/s, looking
  // square across the motion turns it about 275 degrees a second (120 / 25 radians), with no speed cap (Pull.reds).
  // Up to 200: the view alone makes the circles round the anchor.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Pull")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-SteerStrength")
  @runtimeProperty("ModSettings.description", "ApexGrapple-SteerStrength-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "200.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let steerStrength: Float = 120.0;

  // At 0, a shot level with the eyes met the floor a third of the way there (Borderlands 4).
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Pull")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-RopeCarry")
  @runtimeProperty("ModSettings.description", "ApexGrapple-RopeCarry-Description")
  @runtimeProperty("ModSettings.step", "5.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "100.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let ropeCarry: Float = 100.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Pull")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-TakeOffLift")
  @runtimeProperty("ModSettings.description", "ApexGrapple-TakeOffLift-Description")
  @runtimeProperty("ModSettings.step", "0.25")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "15.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let takeOffLift: Float = 2.5;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Pull")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-TakeOffTime")
  @runtimeProperty("ModSettings.description", "ApexGrapple-TakeOffTime-Description")
  @runtimeProperty("ModSettings.step", "0.05")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "2.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let takeOffTime: Float = 0.3;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Pull")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-HoldToKeepPulling")
  @runtimeProperty("ModSettings.description", "ApexGrapple-HoldToKeepPulling-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let holdToKeepPulling: Bool = true;

  // At 1.5, 39 % of the pulls ran into the ground; at 6, 73 % ended at the anchor (380 pulls, Borderlands 4). 8 felt
  // right in Cyberpunk.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-LetGo")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-ArrivalDistance")
  @runtimeProperty("ModSettings.description", "ApexGrapple-ArrivalDistance-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.2")
  @runtimeProperty("ModSettings.max", "20.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let arrivalDistance: Float = 8.0;

  // Simulated with the steering at 120: at 3 m a circle made with the view broke after half a turn, at 6 it lasted. In
  // game 6, 8, 10, 15.5, 19.5 and 30 were tried, and 20 kept.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-LetGo")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-LetGoPastAnchor")
  @runtimeProperty("ModSettings.description", "ApexGrapple-LetGoPastAnchor-Description")
  @runtimeProperty("ModSettings.step", "0.5")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "30.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let letGoPastAnchor: Float = 20.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-LetGo")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-LongestPull")
  @runtimeProperty("ModSettings.description", "ApexGrapple-LongestPull-Description")
  @runtimeProperty("ModSettings.step", "0.5")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "15.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let longestPull: Float = 8.5;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-LetGo")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-LetGoOnLanding")
  @runtimeProperty("ModSettings.description", "ApexGrapple-LetGoOnLanding-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let letGoOnLanding: Bool = true;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-LetGo")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PreserveJump")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PreserveJump-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let preserveJump: Bool = true;

  // Off by default: Kevin wanted it "activable", and 1.0.3 gave no jump back (docs/apex-grapple/double-saut).
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-LetGo")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-RegainDoubleJump")
  @runtimeProperty("ModSettings.description", "ApexGrapple-RegainDoubleJump-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let regainDoubleJump: Bool = false;

  // Off by default: up to 1.0.4 a person or a vehicle in the way took the quick melee (docs/apex-grapple/
  // vehicules-et-personnes).
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Targets")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-HookTargets")
  @runtimeProperty("ModSettings.description", "ApexGrapple-HookTargets-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let hookTargets: Bool = false;

  // Behind the fold line, not behind hookTargets: Mod Settings hides a line behind one switch only.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Targets")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PullPeople")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PullPeople-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let pullPeople: Bool = false;

  // Kevin, 2 November 2026: "grappin qui fait dégâts au pull ou pas avec un toggle", a way to move about but also a
  // weapon. Off by default, as every setting added since 1.0.4: the person lands unhurt (YankShield.reds).
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Targets")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PullDamage")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PullDamage-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let pullDamage: Bool = false;

  // Kevin, 2 November 2026: the person pulled to V steered with the aim, as V's pull is ("oui part là-dessus"). Off by
  // default, as every setting added since 1.0.4: a person aimed at loosely keeps coming straight to V (YankSteer.reds).
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Targets")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-SteerPeople")
  @runtimeProperty("ModSettings.description", "ApexGrapple-SteerPeople-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let steerPeople: Bool = false;

  // Kevin, 11 November 2026: the game's own grab on a pulled person, by hand, with the game's grab key (Grab.reds).
  // Off by default, as every setting added since 1.0.4: on a pad that key also reloads, and a reload during the
  // hook's flight would turn a pull into a grab for a player who never asked for one.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Targets")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-GrabPeople")
  @runtimeProperty("ModSettings.description", "ApexGrapple-GrabPeople-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let grabPeople: Bool = false;

  // Kevin, 12 November 2026: "la vitesse de 24 m/s est valider c'est bon", of 20, 24 and 28 tried in game (what is
  // asked of the game's slide; 19.6 to 22.6 m/s over a whole way at 24).
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Targets")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-GrabSpeed")
  @runtimeProperty("ModSettings.description", "ApexGrapple-GrabSpeed-Description")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "16.0")
  @runtimeProperty("ModSettings.max", "32.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let grabSpeed: Float = 24.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Targets")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PunchWins")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PunchWins-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let punchWins: Bool = true;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Targets")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PunchRange")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PunchRange-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let punchRange: Float = 2.0;

  // No damage on the landing after a grapple, as in Apex Legends (Landing.reds).
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Landing")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-SoftLanding")
  @runtimeProperty("ModSettings.description", "ApexGrapple-SoftLanding-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let softLanding: Bool = true;

  // Off by default: the darkening grew through every long grapple. Can be put back (FallEffect.reds).
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Landing")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-FallEffect")
  @runtimeProperty("ModSettings.description", "ApexGrapple-FallEffect-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let fallEffect: Bool = false;

  // Kevin, 10 November 2026: "on peut ajouter une FOV dynamic pendant qu'on est en grapin ?". On by default, and added
  // to the player's own field of view rather than set to a fixed value: "passer a 120 d'un coup c'est violent"
  // (docs/apex-grapple/fov/conception.md).
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Fov")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-DynamicFov")
  @runtimeProperty("ModSettings.description", "ApexGrapple-DynamicFov-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let dynamicFov: Bool = true;

  // In the degrees of the game's Field of View setting; the total stops at 140 (Fov.reds). +15 and 2 s below: Kevin's
  // choice after his trial of 10 November 2026 ("par defaut on va changer les reglage, on va mettre 15 de fov pour 2 de
  // temp de transition").
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Fov")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-FovWidening")
  @runtimeProperty("ModSettings.description", "ApexGrapple-FovWidening-Description")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "40.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let fovWidening: Float = 15.0;

  // The same both ways.
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile1-Fov")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-FovTransition")
  @runtimeProperty("ModSettings.description", "ApexGrapple-FovTransition-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.5")
  @runtimeProperty("ModSettings.max", "3.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let fovTransition: Float = 2.0;
}
