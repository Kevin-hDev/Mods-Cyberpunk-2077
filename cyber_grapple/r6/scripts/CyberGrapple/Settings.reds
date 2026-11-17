// Made by fabrique/grapple.py from Apex Grapple's Settings.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The grapple's settings as its code reads them. In the menu (Mod Settings): the master switch, the key and the
// view, which change nothing of what the implant does. Every other field is set by the mod itself: by the tier
// of the worn implant (Tiers.reds) or fixed (fabrique/grapple_spec.py).
public class CyberGrappleSettings {
  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-Enabled")
  @runtimeProperty("ModSettings.description", "CyberGrapple-Enabled-Description")
  public let enabled: Bool = true;

  public let showSettings: Bool = true;

  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Profile1-Key")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-OwnKey")
  @runtimeProperty("ModSettings.description", "CyberGrapple-OwnKey-Description")
  public let ownKey: Bool = false;

  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Profile1-Key")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-Key")
  @runtimeProperty("ModSettings.description", "CyberGrapple-Key-Description")
  public let key: EInputKey = EInputKey.IK_Mouse4;

  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Profile1-Key")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-KeyboardHold")
  @runtimeProperty("ModSettings.description", "CyberGrapple-KeyboardHold-Description")
  public let keyboardHold: Bool = false;

  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Profile1-Key")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-ControllerHold")
  @runtimeProperty("ModSettings.description", "CyberGrapple-ControllerHold-Description")
  public let controllerHold: Bool = false;

  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Profile1-Key")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-HoldTime")
  @runtimeProperty("ModSettings.description", "CyberGrapple-HoldTime-Description")
  @runtimeProperty("ModSettings.step", "0.05")
  @runtimeProperty("ModSettings.min", "0.2")
  @runtimeProperty("ModSettings.max", "1.0")
  public let holdTime: Float = 0.4;

  public let implant: CyberGrappleImplant = CyberGrappleImplant.ProjectileLauncher;

  public let requireLauncher: Bool = true;

  public let range: Float = 120.0;

  public let hookSpeed: Float = 50.0;

  public let hookReturn: Float = 4.0;

  public let pullStrength: Float = 33.3;

  public let pullSpeedCap: Float = 35.0;

  public let steerStrength: Float = 120.0;

  public let ropeCarry: Float = 100.0;

  public let takeOffLift: Float = 2.5;

  public let takeOffTime: Float = 0.3;

  public let holdToKeepPulling: Bool = true;

  public let arrivalDistance: Float = 8.0;

  public let letGoPastAnchor: Float = 20.0;

  public let longestPull: Float = 8.5;

  public let letGoOnLanding: Bool = true;

  public let preserveJump: Bool = true;

  public let regainDoubleJump: Bool = true;

  public let hookTargets: Bool = true;

  public let pullPeople: Bool = false;

  public let pulledSpeed: Float = 24.0;

  public let pullDamage: Bool = false;

  public let pullSlam: Bool = false;

  public let steerPeople: Bool = false;

  public let pullBikes: Bool = false;

  public let grabPeople: Bool = false;

  public let grabSpeed: Float = 24.0;

  public let punchWins: Bool = true;

  public let punchRange: Float = 1.0;

  public let softLanding: Bool = true;

  public let fallEffect: Bool = false;

  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Profile1-Fov")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-DynamicFov")
  @runtimeProperty("ModSettings.description", "CyberGrapple-DynamicFov-Description")
  public let dynamicFov: Bool = true;

  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Profile1-Fov")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-FovWidening")
  @runtimeProperty("ModSettings.description", "CyberGrapple-FovWidening-Description")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "40.0")
  public let fovWidening: Float = 10.0;

  @runtimeProperty("ModSettings.mod", "Cyber Grapple")
  @runtimeProperty("ModSettings.category", "CyberGrapple-Profile1-Fov")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "CyberGrapple-FovTransition")
  @runtimeProperty("ModSettings.description", "CyberGrapple-FovTransition-Description")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.5")
  @runtimeProperty("ModSettings.max", "3.0")
  public let fovTransition: Float = 2.0;

  // Added by this mod (ADDED in fabrique/grapple_spec.py): the settings this class is made from have no such field.
  public let pullRange: Float = 0.0;
}
