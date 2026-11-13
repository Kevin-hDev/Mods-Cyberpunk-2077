// "Damage when pulling people" off: the person thrown to V takes no blow from the fall or from what the body hits,
// until it has got up. Only those blows: V's shots still hurt, and nothing is put on the person, so no save can keep
// it. Until the audit of 2 November 2026 an invulnerability value did it for 5 s: it stopped V's shots too, and ended
// while a body still flew (fifth test, a person dead 6 s after with damage off). The game counts a falling body's blow
// in DamageSystem.ProcessRagdollHit (damageSystem.script:588-633), and makes it harmless for a friend by an attack
// value of 0 (lines 610-613), as here.

public struct ApexGrappleShielded {
  public let id: EntityID;
  public let from: Float;
  // Since when the body has been seen up, at the checks; 0 while it lies.
  public let upSince: Float;
}

// People shielded at once, at most: an older one is dropped first. A pull lasts under a second and a body lies still
// within a few, so more would only come from a fault.
public func ApexGrappleShieldMost() -> Int32 {
  return 8;
}

// The body is looked at this often, by the game's delay system: it runs whatever the grapple does, in scenes too.
public func ApexGrappleShieldCheckEvery() -> Float {
  return 0.5;
}

// Not before this, as the fall starts a little after the bite; never longer than the limit, for a body that never
// gets up.
public func ApexGrappleShieldAtLeast() -> Float {
  return 1.0;
}

public func ApexGrappleShieldLimit() -> Float {
  return 30.0;
}

// Up this long before the shield ends: the game deals a blow 0.3 s after it (StartRagdollDamageEvent,
// NPCPuppet.script:2149), and a body may fall again as it gets up. Ended at the first check that saw it up, a policeman
// died 0.3 s later with damage off, and his body vanished (Kevin, 2 November 2026).
public func ApexGrappleShieldStoodFor() -> Float {
  return 0.4;
}

public func ApexGrappleIsShielded(system: ref<ApexGrappleSystem>, id: EntityID) -> Bool {
  let i: Int32 = 0;
  while i < ArraySize(system.shielded) {
    if Equals(system.shielded[i].id, id) {
      return true;
    }
    i += 1;
  }
  return false;
}

public func ApexGrappleShield(system: ref<ApexGrappleSystem>, person: ref<GameObject>, now: Float, game: GameInstance) -> Void {
  let id: EntityID = person.GetEntityID();
  let i: Int32 = ArraySize(system.shielded) - 1;
  while i >= 0 {
    if Equals(system.shielded[i].id, id) {
      ArrayErase(system.shielded, i);
    }
    i -= 1;
  }
  if ArraySize(system.shielded) >= ApexGrappleShieldMost() {
    ArrayErase(system.shielded, 0);
  }
  let entry: ApexGrappleShielded;
  entry.id = id;
  entry.from = now;
  ArrayPush(system.shielded, entry);
  if ArraySize(system.shielded) == 1 {
    ApexGrappleShieldCheckLater(system, game);
  }
}

public func ApexGrappleShieldCheckLater(system: ref<ApexGrappleSystem>, game: GameInstance) -> Void {
  let check: ref<ApexGrappleShieldCheck> = new ApexGrappleShieldCheck();
  check.system = system;
  check.game = game;
  GameInstance.GetDelaySystem(game).DelayCallback(check, ApexGrappleShieldCheckEvery(), false);
}

// Why this shield ends now, or empty.
public func ApexGrappleShieldOver(entry: ApexGrappleShielded, npc: ref<NPCPuppet>, now: Float) -> String {
  if !IsDefined(npc) {
    return "the person is gone";
  }
  if now - entry.from >= ApexGrappleShieldLimit() {
    return "the limit";
  }
  if now - entry.from >= ApexGrappleShieldAtLeast() && entry.upSince > 0.0 && now - entry.upSince >= ApexGrappleShieldStoodFor() {
    return "up for " + ToString(now - entry.upSince) + " s";
  }
  return "";
}

public class ApexGrappleShieldCheck extends DelayCallback {
  public let system: wref<ApexGrappleSystem>;
  public let game: GameInstance;

  public func Call() -> Void {
    let system: ref<ApexGrappleSystem> = this.system;
    if !IsDefined(system) {
      return;
    }
    let now: Float = ApexGrappleTime(this.game);
    let i: Int32 = ArraySize(system.shielded) - 1;
    while i >= 0 {
      let entry: ApexGrappleShielded = system.shielded[i];
      let npc: ref<NPCPuppet> = GameInstance.FindEntityByID(this.game, entry.id) as NPCPuppet;
      if IsDefined(npc) && !npc.IsRagdolling() {
        if entry.upSince <= 0.0 {
          entry.upSince = now;
        }
      } else {
        entry.upSince = 0.0;
      }
      system.shielded[i] = entry;
      let over: String = ApexGrappleShieldOver(entry, npc, now);
      if StrLen(over) > 0 {
        ApexGrappleLog("person pulled to V: shield off after " + ToString(now - system.shielded[i].from) + " s, " + over);
        ArrayErase(system.shielded, i);
      }
      i -= 1;
    }
    if ArraySize(system.shielded) > 0 {
      ApexGrappleShieldCheckLater(system, this.game);
    }
  }
}

// The game runs this for every hit and acts on a falling body's blow only (damageSystem.script:596-599): every other
// hit, V's shots among them, goes on untouched.
@wrapMethod(DamageSystem)
private final func ProcessRagdollHit(hitEvent: ref<gameHitEvent>) -> Void {
  if IsDefined(hitEvent as gameRagdollHitEvent) && IsDefined(hitEvent.target) {
    let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(hitEvent.target.GetGame());
    if IsDefined(system) {
      if ArraySize(system.shielded) > 0 {
        if ApexGrappleIsShielded(system, hitEvent.target.GetEntityID()) {
          hitEvent.attackComputed.SetAttackValue(0.0);
          return;
        }
      }
    }
  }
  wrappedMethod(hitEvent);
}

// A shielded person getting up where the AI cannot stand, with no place found near: the game then kills them. Fifth
// height trial (13 November 2026): 3 people brought up to a roof with no navigation mesh died the frame they got up,
// shielded, damage off (Kevin: "ils ne doivent pas mourir s'ils arrivent sur le toit"). The game's own test
// (aiStatusEffectTask.script:280-342) is told they are where they can stand: they get up where they lie. Trial: what
// the AI does of them there is not known.
@wrapMethod(CheckRagdollOutOfNavmeshTask)
protected func Activate(context: ScriptExecutionContext) -> Void {
  wrappedMethod(context);
  let owner: ref<NPCPuppet> = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
  if !IsDefined(owner) {
    return;
  }
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(owner.GetGame());
  if !IsDefined(system) || ArraySize(system.shielded) == 0 || !ApexGrappleIsShielded(system, owner.GetEntityID()) {
    return;
  }
  let out: Bool = FromVariant<Bool>(ScriptExecutionContext.GetMappingValue(context, this.m_outStatusArgument));
  let found: Bool = FromVariant<Bool>(ScriptExecutionContext.GetMappingValue(context, this.m_outPositionStatusArgument));
  if out && !found {
    ScriptExecutionContext.SetMappingValue(context, this.m_outStatusArgument, ToVariant(false));
    ApexGrappleLog("person pulled to V: getting up where the AI cannot stand, no place found near; the game told they can stand there, not to be killed");
  }
}
