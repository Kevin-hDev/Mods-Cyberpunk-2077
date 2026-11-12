// Made by fabrique/profiles.py from Settings.reds, never edited by hand: after a change to Settings.reds, run
// python -I fabrique/profiles.py (fabrique/test_profiles.py fails while this file is out of date).

public class ApexGrappleProfile4 {
  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-ShowSettings")
  @runtimeProperty("ModSettings.description", "ApexGrapple-ShowSettings-Description")
  public let showSettings: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-ProfileActive")
  @runtimeProperty("ModSettings.description", "ApexGrapple-ProfileActive-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let active: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-ProfileKey")
  @runtimeProperty("ModSettings.description", "ApexGrapple-ProfileKey-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let key: EInputKey = EInputKey.IK_None;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-KeyboardHold")
  @runtimeProperty("ModSettings.description", "ApexGrapple-KeyboardHold-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let keyboardHold: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-ControllerHold")
  @runtimeProperty("ModSettings.description", "ApexGrapple-ControllerHold-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let controllerHold: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-HoldTime")
  @runtimeProperty("ModSettings.description", "ApexGrapple-HoldTime-Description")
  @runtimeProperty("ModSettings.step", "0.05")
  @runtimeProperty("ModSettings.min", "0.2")
  @runtimeProperty("ModSettings.max", "1.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let holdTime: Float = 0.4;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-Implant")
  @runtimeProperty("ModSettings.description", "ApexGrapple-Implant-Description")
  @runtimeProperty("ModSettings.displayValues.None", "ApexGrapple-Implant-None")
  @runtimeProperty("ModSettings.displayValues.ProjectileLauncher", "ApexGrapple-Implant-ProjectileLauncher")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let implant: ApexGrappleImplant = ApexGrappleImplant.ProjectileLauncher;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-RequireLauncher")
  @runtimeProperty("ModSettings.description", "ApexGrapple-RequireLauncher-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let requireLauncher: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-Range")
  @runtimeProperty("ModSettings.description", "ApexGrapple-Range-Description")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "5.0")
  @runtimeProperty("ModSettings.max", "150.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let range: Float = 150.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-HookSpeed")
  @runtimeProperty("ModSettings.description", "ApexGrapple-HookSpeed-Description")
  @runtimeProperty("ModSettings.step", "5.0")
  @runtimeProperty("ModSettings.min", "10.0")
  @runtimeProperty("ModSettings.max", "300.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let hookSpeed: Float = 50.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-HookReturn")
  @runtimeProperty("ModSettings.description", "ApexGrapple-HookReturn-Description")
  @runtimeProperty("ModSettings.step", "0.5")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "5.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let hookReturn: Float = 2.5;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PullStrength")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PullStrength-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "2.0")
  @runtimeProperty("ModSettings.max", "80.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let pullStrength: Float = 33.3;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PullSpeedCap")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PullSpeedCap-Description")
  @runtimeProperty("ModSettings.step", "0.5")
  @runtimeProperty("ModSettings.min", "2.0")
  @runtimeProperty("ModSettings.max", "50.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let pullSpeedCap: Float = 25.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-SteerStrength")
  @runtimeProperty("ModSettings.description", "ApexGrapple-SteerStrength-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "200.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let steerStrength: Float = 120.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-RopeCarry")
  @runtimeProperty("ModSettings.description", "ApexGrapple-RopeCarry-Description")
  @runtimeProperty("ModSettings.step", "5.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "100.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let ropeCarry: Float = 100.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-TakeOffLift")
  @runtimeProperty("ModSettings.description", "ApexGrapple-TakeOffLift-Description")
  @runtimeProperty("ModSettings.step", "0.25")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "15.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let takeOffLift: Float = 2.5;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-TakeOffTime")
  @runtimeProperty("ModSettings.description", "ApexGrapple-TakeOffTime-Description")
  @runtimeProperty("ModSettings.step", "0.05")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "2.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let takeOffTime: Float = 0.3;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-HoldToKeepPulling")
  @runtimeProperty("ModSettings.description", "ApexGrapple-HoldToKeepPulling-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let holdToKeepPulling: Bool = true;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-ArrivalDistance")
  @runtimeProperty("ModSettings.description", "ApexGrapple-ArrivalDistance-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.2")
  @runtimeProperty("ModSettings.max", "20.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let arrivalDistance: Float = 8.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-LetGoPastAnchor")
  @runtimeProperty("ModSettings.description", "ApexGrapple-LetGoPastAnchor-Description")
  @runtimeProperty("ModSettings.step", "0.5")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "30.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let letGoPastAnchor: Float = 20.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-LongestPull")
  @runtimeProperty("ModSettings.description", "ApexGrapple-LongestPull-Description")
  @runtimeProperty("ModSettings.step", "0.5")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "15.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let longestPull: Float = 8.5;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-LetGoOnLanding")
  @runtimeProperty("ModSettings.description", "ApexGrapple-LetGoOnLanding-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let letGoOnLanding: Bool = true;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PreserveJump")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PreserveJump-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let preserveJump: Bool = true;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-RegainDoubleJump")
  @runtimeProperty("ModSettings.description", "ApexGrapple-RegainDoubleJump-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let regainDoubleJump: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-HookTargets")
  @runtimeProperty("ModSettings.description", "ApexGrapple-HookTargets-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let hookTargets: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PullPeople")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PullPeople-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let pullPeople: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PullDamage")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PullDamage-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let pullDamage: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-SteerPeople")
  @runtimeProperty("ModSettings.description", "ApexGrapple-SteerPeople-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let steerPeople: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-GrabPeople")
  @runtimeProperty("ModSettings.description", "ApexGrapple-GrabPeople-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let grabPeople: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-GrabSpeed")
  @runtimeProperty("ModSettings.description", "ApexGrapple-GrabSpeed-Description")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "16.0")
  @runtimeProperty("ModSettings.max", "32.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let grabSpeed: Float = 24.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PunchWins")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PunchWins-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let punchWins: Bool = true;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-PunchRange")
  @runtimeProperty("ModSettings.description", "ApexGrapple-PunchRange-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let punchRange: Float = 2.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-SoftLanding")
  @runtimeProperty("ModSettings.description", "ApexGrapple-SoftLanding-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let softLanding: Bool = true;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-FallEffect")
  @runtimeProperty("ModSettings.description", "ApexGrapple-FallEffect-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let fallEffect: Bool = false;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-DynamicFov")
  @runtimeProperty("ModSettings.description", "ApexGrapple-DynamicFov-Description")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let dynamicFov: Bool = true;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-FovWidening")
  @runtimeProperty("ModSettings.description", "ApexGrapple-FovWidening-Description")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "40.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let fovWidening: Float = 15.0;

  @runtimeProperty("ModSettings.mod", "Apex Grapple")
  @runtimeProperty("ModSettings.category", "ApexGrapple-Profile4")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "ApexGrapple-FovTransition")
  @runtimeProperty("ModSettings.description", "ApexGrapple-FovTransition-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.5")
  @runtimeProperty("ModSettings.max", "3.0")
  @runtimeProperty("ModSettings.dependency", "showSettings")
  public let fovTransition: Float = 2.0;

  // Its key, or none while the profile is off.
  public func OwnKey() -> EInputKey {
    return this.active ? this.key : EInputKey.IK_None;
  }

  // Profile 1's settings, master switch included, with this profile's values: the rest of the mod reads an
  // ApexGrappleSettings.
  public func ToSettings() -> ref<ApexGrappleSettings> {
    let s: ref<ApexGrappleSettings> = new ApexGrappleSettings();
    s.ownKey = true;
    s.key = this.key;
    s.keyboardHold = this.keyboardHold;
    s.controllerHold = this.controllerHold;
    s.holdTime = this.holdTime;
    s.implant = this.implant;
    s.requireLauncher = this.requireLauncher;
    s.range = this.range;
    s.hookSpeed = this.hookSpeed;
    s.hookReturn = this.hookReturn;
    s.pullStrength = this.pullStrength;
    s.pullSpeedCap = this.pullSpeedCap;
    s.steerStrength = this.steerStrength;
    s.ropeCarry = this.ropeCarry;
    s.takeOffLift = this.takeOffLift;
    s.takeOffTime = this.takeOffTime;
    s.holdToKeepPulling = this.holdToKeepPulling;
    s.arrivalDistance = this.arrivalDistance;
    s.letGoPastAnchor = this.letGoPastAnchor;
    s.longestPull = this.longestPull;
    s.letGoOnLanding = this.letGoOnLanding;
    s.preserveJump = this.preserveJump;
    s.regainDoubleJump = this.regainDoubleJump;
    s.hookTargets = this.hookTargets;
    s.pullPeople = this.pullPeople;
    s.pullDamage = this.pullDamage;
    s.steerPeople = this.steerPeople;
    s.grabPeople = this.grabPeople;
    s.grabSpeed = this.grabSpeed;
    s.punchWins = this.punchWins;
    s.punchRange = this.punchRange;
    s.softLanding = this.softLanding;
    s.fallEffect = this.fallEffect;
    s.dynamicFov = this.dynamicFov;
    s.fovWidening = this.fovWidening;
    s.fovTransition = this.fovTransition;
    return s;
  }
}
