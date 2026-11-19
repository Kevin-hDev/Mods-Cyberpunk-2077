// The hook's impact effect, asked by a player on Nexus (18 November 2026): one of the game's own effects, shown once
// where the hook bites a wall or a car, turned toward V. The six effects, their order and the default are Kevin's pick
// in game (releves/cyber-grapple/2026-11-18-effet-d-impact). Asked from the bite alone (CyberGrappleAttach in
// Shot.reds, a line patched in by fabrique/grapple_spec.py): once a bite, nothing here runs each frame.

// The menu's list of the effects is made from this enum (fabrique/grapple_settings.py), and Mod Settings keeps the
// player's choice under a member's name: a member is never renamed. Each is named after the effect's file.
enum CyberGrappleImpactStyle {
  ConcreteBullet = 0,
  ConcreteLargeCaliber = 1,
  ConcreteHammer = 2,
  MetalHammer = 3,
  Monowire = 4,
  DefaultBullet = 5
}

public func CyberGrappleImpactMostLines() -> Int32 {
  return 20;
}

// The effects were picked on walls and are wanted on walls and cars only: none where the hook bit a person, pulled to V
// or not, nor a motorcycle. The way of making an effect by its file and turning it to face V's middle is the probe's,
// seen in game on 34 shots.
@if(ModuleExists("Codeware"))
public func CyberGrappleImpact(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, middle: Vector4) -> Void {
  if !settings.enabled || !settings.impactEffect {
    return;
  }
  let target: ref<GameObject> = system.target;
  if system.targetPerson || IsDefined(target as BikeObject) {
    system.impactNoneLines = CyberGrappleLogUpTo(system.impactNoneLines, CyberGrappleImpactMostLines(), "impact effect left out", "impact effect: none, the hook bit a person or a motorcycle");
    return;
  }
  let toV: Vector4 = middle - system.anchor;
  let gap: Float = Vector4.Length(toV);
  // V's middle on the anchor gives no way to face: the effect then faces up rather than normalise nothing.
  let facing: Vector4 = new Vector4(0.0, 0.0, 1.0, 0.0);
  if gap > CyberGrappleTiny() {
    facing = Vector4.Normalize(toV);
  }
  let transform: WorldTransform;
  WorldTransform.SetPosition(transform, system.anchor);
  WorldTransform.SetOrientationFromDir(transform, facing);
  let fx: FxResource = CyberGrappleImpactEffect(settings.impactStyle);
  let shown: ref<FxInstance> = GameInstance.GetFxSystem(system.GetGameInstance()).SpawnEffect(fx, transform);
  if system.impactLines <= CyberGrappleImpactMostLines() {
    system.impactLines = CyberGrappleLogUpTo(system.impactLines, CyberGrappleImpactMostLines(), "impact effect", "impact effect " + NameToString(EnumValueToName(n"CyberGrappleImpactStyle", Cast<Int64>(EnumInt(settings.impactStyle)))) + " at the anchor, " + ToString(gap) + " m from V's middle, instance " + (IsDefined(shown) ? "made" : "none"));
  }
}

// The effect named by its file, through the field Codeware gives FxResource. A member this function does not know
// shows the menu's default (grapple_spec.MENU_ADDED), the hammer on metal, whose file comes last.
@if(ModuleExists("Codeware"))
public func CyberGrappleImpactEffect(style: CyberGrappleImpactStyle) -> FxResource {
  let fx: FxResource;
  if Equals(style, CyberGrappleImpactStyle.ConcreteBullet) {
    fx.effect *= r"base\\fx\\weapons\\impacts\\concrete\\imp_concrete_refl.effect";
    return fx;
  }
  if Equals(style, CyberGrappleImpactStyle.ConcreteLargeCaliber) {
    fx.effect *= r"base\\fx\\weapons\\impacts\\concrete\\large_cal\\imp_concrete_refl_lc.effect";
    return fx;
  }
  if Equals(style, CyberGrappleImpactStyle.ConcreteHammer) {
    fx.effect *= r"base\\fx\\weapons\\impacts\\concrete\\melee\\imp_concrete_refl_hammer.effect";
    return fx;
  }
  if Equals(style, CyberGrappleImpactStyle.Monowire) {
    fx.effect *= r"base\\fx\\weapons\\cyberware\\monowire\\w_monowire_impact_default.effect";
    return fx;
  }
  if Equals(style, CyberGrappleImpactStyle.DefaultBullet) {
    fx.effect *= r"base\\fx\\weapons\\impacts\\default\\imp_default_norm.effect";
    return fx;
  }
  fx.effect *= r"base\\fx\\weapons\\impacts\\metal\\melee\\imp_metal_refl_hammer.effect";
  return fx;
}

@if(!ModuleExists("Codeware"))
public func CyberGrappleImpact(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, middle: Vector4) -> Void {}
