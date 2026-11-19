// How often V speaks, as a series of ten occasions: at 30 %, exactly three lines in each ten occasions, in a random
// order. Kevin, 18 November 2026, read six executions in a row without a line at 50 % with a draw at each occasion as a
// fault (conception, section 2, point 2). One series for kills and knock-outs together. No call to the game here but
// RandRange.

public class ExecutionLinesBag {
  public let left: Int32;
  public let says: Int32;
  public let filledFor: Float;
}

public func ExecutionLinesBagSize() -> Int32 {
  return 10;
}

// The lines a full series holds for this setting, in percent (10 to 100 in the menu).
public func ExecutionLinesBagSays(chance: Float) -> Int32 {
  return Clamp(RoundF(chance * Cast<Float>(ExecutionLinesBagSize()) / 100.0), 0, ExecutionLinesBagSize());
}

// The load's series, made at its first use.
public func ExecutionLinesBagOf(system: ref<ExecutionLinesSystem>) -> ref<ExecutionLinesBag> {
  if !IsDefined(system.bag) {
    system.bag = new ExecutionLinesBag();
  }
  return system.bag;
}

// Whether V speaks at this occasion: one of the occasions left, the lines left among them. The series fills again once
// empty, or when the setting moved since it was filled, the first occasion of a load included. Called only for an
// occasion where a line could be said, so that a silence for another reason takes nothing from the series.
public func ExecutionLinesBagDraw(bag: ref<ExecutionLinesBag>, chance: Float) -> Bool {
  if bag.left <= 0 || bag.filledFor != chance {
    bag.left = ExecutionLinesBagSize();
    bag.says = ExecutionLinesBagSays(chance);
    bag.filledFor = chance;
  }
  let speaks: Bool = RandRange(0, bag.left) < bag.says;
  bag.left = bag.left - 1;
  if speaks {
    bag.says = bag.says - 1;
  }
  return speaks;
}

// Where the series stands, for the log of a draw missed.
public func ExecutionLinesBagText(bag: ref<ExecutionLinesBag>) -> String {
  return "silent this time at " + ToString(bag.filledFor) + " %, " + ToString(bag.says) + " lines left in the " + ToString(bag.left) + " occasions left of this ten";
}
