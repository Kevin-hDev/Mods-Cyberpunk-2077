// The one point our other mods may lean on, which never changes name nor form (conception, section 7): they ask it
// behind @if(ModuleExists("ExecutionLines")) and cite nothing else of this mod, so that they still compile without it.
// The only file of this mod in a module: ModuleExists sees a mod by a module it declares.
module ExecutionLines

// True when this mod takes care of the executions at this instant: "Enabled" on and Audioware there. Read anew at each
// call, from the player's settings as they stand. `game` is part of the fixed form, kept for what may need it later.
public func HandlesExecutions(game: GameInstance) -> Bool {
  if !ExecutionLinesAudioThere() {
    return false;
  }
  return ExecutionLinesListening();
}
