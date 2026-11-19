// What the listeners share: whether the mod is on, and the rule that tells an execution among the kills and
// knock-outs made in V's name (E2 and E3, conception, section 5).

// Arm's reach: the person an execution animation holds is next to V.
public func ExecutionLinesReach() -> Float {
  return 3.0;
}

// Read anew each time, as Occasion.reds does. A listener asks it right after its exits that cost nothing, before any
// other read, so that with the mod off it writes no line and reads nothing more from the game.
public func ExecutionLinesListening() -> Bool {
  let settings: ref<ExecutionLinesSettings> = new ExecutionLinesSettings();
  return settings.enabled;
}

// A kill or a knock-out in V's name is an execution when V plays a workspot animation without being mounted to a
// vehicle, and the person is within reach. The game draws the same line for an animation shared by two
// (meleeTransitions.script:887): a seat in a vehicle is a workspot too, and a kill from a car must leave V silent
// (conception, section 10, point 5). This describes an execution without knowing the mod that plays it, so that a gun
// kill, a hack or an ordinary non-lethal blow does not make V speak. Callers have checked that V and the person are
// there and that the mod is on.
public func ExecutionLinesIsExecution(game: GameInstance, player: ref<GameObject>, victim: ref<GameObject>, heardBy: String) -> Bool {
  let inWorkspot: Bool = GameInstance.GetWorkspotSystem(game).IsActorInWorkspot(player);
  // What the first trial reads to tell a listener that hears nothing from a rule that turns the execution away. Once
  // both kinds of refusal are past their bound, a kill outside a workspot reads nothing more from the game
  // (optimisation.md, section 9.1).
  let system: ref<ExecutionLinesSystem> = ExecutionLinesSystemOf(game);
  let most: Int32 = ExecutionLinesLogMost();
  let tellOrdinary: Bool = IsDefined(system) && system.ordinaryNotExecutionLines <= most;
  let tellOther: Bool = IsDefined(system) && system.notExecutionLines <= most;
  if !inWorkspot && !tellOrdinary && !tellOther {
    return false;
  }
  let distance: Float = Vector4.Distance(player.GetWorldPosition(), victim.GetWorldPosition());
  let inReach: Bool = distance <= ExecutionLinesReach();
  if !inWorkspot && !inReach {
    if tellOrdinary {
      let inVehicleThen: Bool = VehicleComponent.IsMountedToVehicle(game, player);
      system.ordinaryNotExecutionLines = ExecutionLinesLogUpTo(system.ordinaryNotExecutionLines, most, "ordinary kills and knock-outs in V's name, neither in a workspot nor within reach", ExecutionLinesNotExecutionText(inWorkspot, inVehicleThen, distance, heardBy));
    }
    return false;
  }
  let inVehicle: Bool = VehicleComponent.IsMountedToVehicle(game, player);
  if inWorkspot && inReach && !inVehicle {
    return true;
  }
  if tellOther {
    system.notExecutionLines = ExecutionLinesLogUpTo(system.notExecutionLines, most, "other kills and knock-outs in V's name that are not executions", ExecutionLinesNotExecutionText(inWorkspot, inVehicle, distance, heardBy));
  }
  return false;
}

// The plan's text, then the listener: E2 is a kill, E3 a knock-out, and the first trial must tell them apart.
public func ExecutionLinesNotExecutionText(inWorkspot: Bool, inVehicle: Bool, distance: Float, heardBy: String) -> String {
  return "in V's name but not an execution: V in a workspot " + (inWorkspot ? "true" : "false") + ", in a vehicle " + (inVehicle ? "true" : "false") + ", " + FloatToStringPrec(distance, 1) + " m away, heard by " + heardBy;
}
