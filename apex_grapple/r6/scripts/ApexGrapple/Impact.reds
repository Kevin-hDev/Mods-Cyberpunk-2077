// The game's own impact effect where the hook bites into a surface or a vehicle, as the profile's settings say
// (impactEffect, impactKind in Settings.reds): without it the hook sank into the surface with nothing (a player, 18
// November 2026). Not on a person: metal sparks or concrete dust on a body would look wrong. A person or a motorcycle
// pulled to V bites elsewhere (Yank.reds, YankBike.reds) and shows none. An effect is named by its file through a
// field Codeware gives to FxResource: verified in game in Cyber Grapple, 34 shots and 34 effects made
// (releves/cyber-grapple/2026-11-18-effet-d-impact), and here, 36 bites and 36 effects made on 18 November 2026.
// Without Codeware, none. A value is never renamed: Mod Settings keeps the player's choice under its name.

enum ApexGrappleImpactKind {
  ConcreteBullet = 0,
  ConcreteLargeCalibre = 1,
  ConcreteHammer = 2,
  MetalHammer = 3,
  Monowire = 4,
  DefaultBullet = 5
}

// For the log lines.
public func ApexGrappleImpactName(kind: ApexGrappleImpactKind) -> String {
  if Equals(kind, ApexGrappleImpactKind.ConcreteBullet) {
    return "bullet on concrete";
  }
  if Equals(kind, ApexGrappleImpactKind.ConcreteLargeCalibre) {
    return "large calibre on concrete";
  }
  if Equals(kind, ApexGrappleImpactKind.ConcreteHammer) {
    return "hammer on concrete";
  }
  if Equals(kind, ApexGrappleImpactKind.Monowire) {
    return "monowire";
  }
  if Equals(kind, ApexGrappleImpactKind.DefaultBullet) {
    return "bullet";
  }
  return "hammer on metal";
}

// The chosen effect's file. A ResRef literal needs no library: only naming it in an FxResource does.
public func ApexGrappleImpactPath(kind: ApexGrappleImpactKind) -> ResRef {
  if Equals(kind, ApexGrappleImpactKind.ConcreteBullet) {
    return r"base\\fx\\weapons\\impacts\\concrete\\imp_concrete_refl.effect";
  }
  if Equals(kind, ApexGrappleImpactKind.ConcreteLargeCalibre) {
    return r"base\\fx\\weapons\\impacts\\concrete\\large_cal\\imp_concrete_refl_lc.effect";
  }
  if Equals(kind, ApexGrappleImpactKind.ConcreteHammer) {
    return r"base\\fx\\weapons\\impacts\\concrete\\melee\\imp_concrete_refl_hammer.effect";
  }
  if Equals(kind, ApexGrappleImpactKind.Monowire) {
    return r"base\\fx\\weapons\\cyberware\\monowire\\w_monowire_impact_default.effect";
  }
  if Equals(kind, ApexGrappleImpactKind.DefaultBullet) {
    return r"base\\fx\\weapons\\impacts\\default\\imp_default_norm.effect";
  }
  return r"base\\fx\\weapons\\impacts\\metal\\melee\\imp_metal_refl_hammer.effect";
}

public func ApexGrappleImpactMissing() -> String {
  return "its file is missing";
}

// `fx` names the file once it is checked to be in the game; returns why no effect can be made, empty when it can.
@if(!ModuleExists("Codeware"))
public func ApexGrappleImpactResource(path: ResRef, out fx: FxResource) -> String {
  return "none without Codeware";
}

@if(ModuleExists("Codeware"))
public func ApexGrappleImpactResource(path: ResRef, out fx: FxResource) -> String {
  let depot: ref<ResourceDepot> = GameInstance.GetResourceDepot();
  if IsDefined(depot) && !depot.ResourceExists(path) {
    return ApexGrappleImpactMissing();
  }
  fx.effect *= path;
  return "";
}

// A game update that moves an effect's file switches the effect off, says which file in the log, and tells the
// player once (conception.md, rule 14): no message would read as a bug. The rest of the grapple goes on.
public func ApexGrappleImpactLose(system: ref<ApexGrappleSystem>, kind: ApexGrappleImpactKind, game: GameInstance) -> Void {
  system.impactLost = true;
  ApexGrappleLog("impact effect switched off: the file of " + ApexGrappleImpactName(kind) + " (" + ResRef.ToString(ApexGrappleImpactPath(kind)) + ") is missing from the game, most likely moved by a game update; told on screen");
  ApexGrappleTellOnScreen(game, GetLocalizedTextByKey(n"ApexGrapple-ImpactLost"));
}

// At the bite (Shot.reds): the chosen effect at the anchor, turned toward V, once per grapple. Returns the end of the
// shot's log line.
public func ApexGrappleShowImpact(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, middle: Vector4, game: GameInstance) -> String {
  if system.targetPerson {
    return "";
  }
  if !settings.impactEffect {
    return ", impact effect off";
  }
  if system.impactLost {
    return ", impact effect switched off: a file is missing";
  }
  let fx: FxResource;
  let why: String = ApexGrappleImpactResource(ApexGrappleImpactPath(settings.impactKind), fx);
  if Equals(why, ApexGrappleImpactMissing()) {
    ApexGrappleImpactLose(system, settings.impactKind, game);
  }
  if StrLen(why) > 0 {
    return ", impact effect: " + why;
  }
  let transform: WorldTransform;
  WorldTransform.SetPosition(transform, system.anchor);
  let toV: Vector4 = middle - system.anchor;
  if Vector4.Length(toV) > ApexGrappleTiny() {
    let facing: Vector4 = Vector4.Normalize(toV);
    WorldTransform.SetOrientationFromDir(transform, facing);
  }
  let effects: ref<FxSystem> = GameInstance.GetFxSystem(game);
  if !IsDefined(effects) {
    return ", impact effect: no effect system";
  }
  let shown: ref<FxInstance> = effects.SpawnEffect(fx, transform);
  return ", impact effect " + ApexGrappleImpactName(settings.impactKind) + (IsDefined(shown) ? "" : " (not made)");
}
