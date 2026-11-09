// The loot of a person killed after a pull. The game shows the "Loot" choice once the person's AI state is Dead or
// Unconscious (NPCIncapacitatedPrereq, prereqs.script:233-246, scripts 2.5), and a death by a thrown body's blow never
// reaches that state: on 9 November 2026, 15 people killed by "Damage when pulling people" stayed Alerted or Relaxed and
// none could be looted (Kevin; releves/apex-grapple/2026-11-09-windows-butin-motos). Setting Dead as the game's death
// task does held on 1 body out of 11: the AI, still running, put its own state back within 3 s (same day,
// releves/apex-grapple/2026-11-09-windows-police-butin). The choice's condition cannot be wrapped either: it overrides a
// native method, under a name redscript 0.5.31 does not find. So the loot is left by the body in a bag, as the game does
// for a body put in a container or a trunk (DisposalDevice, disposalDevice.script:179-184; vehicleComponent.script:3300).

// Long enough for the body to come to rest, so the bag lies by it.
public func ApexGrappleLootDropAfter() -> Float {
  return 3.0;
}

public func ApexGrappleLootLater(person: ref<GameObject>) -> Void {
  let drop: ref<ApexGrappleLootDrop> = new ApexGrappleLootDrop();
  drop.person = person;
  GameInstance.GetDelaySystem(person.GetGame()).DelayCallback(drop, ApexGrappleLootDropAfter(), false);
}

// Why the body keeps its loot; empty when it is dropped in a bag.
public func ApexGrappleLootKept(npc: ref<NPCPuppet>) -> String {
  if !IsDefined(npc) {
    return "gone";
  }
  if ScriptedPuppet.IsAlive(npc) || ScriptedPuppet.IsUnconscious(npc) {
    return "not dead";
  }
  let state: gamedataNPCHighLevelState = npc.GetHighLevelStateFromBlackboard();
  if Equals(state, gamedataNPCHighLevelState.Dead) || Equals(state, gamedataNPCHighLevelState.Unconscious) {
    return "the game's Loot choice shows";
  }
  if npc.IsLooted() {
    return "already looted";
  }
  return "";
}

public class ApexGrappleLootDrop extends DelayCallback {
  public let person: wref<GameObject>;

  public func Call() -> Void {
    let npc: ref<NPCPuppet> = this.person as NPCPuppet;
    let kept: String = ApexGrappleLootKept(npc);
    if StrLen(kept) > 0 {
      ApexGrappleLog("person killed after a pull, loot left on the body: " + kept + (IsDefined(npc) ? ", " + ApexGrappleWhoText(npc) : ""));
      return;
    }
    let generated: Bool = npc.WasLootGenerated();
    if !generated {
      npc.ProcessLoot();
    }
    let empty: Bool = RPGManager.IsInventoryEmpty(npc);
    if !empty {
      npc.DropLootBag();
    }
    ApexGrappleLog("person killed after a pull: loot generated before " + ToString(generated) + ", inventory empty " + ToString(empty) + ", bag dropped " + ToString(!empty) + ", " + ApexGrappleWhoText(npc));
  }
}
