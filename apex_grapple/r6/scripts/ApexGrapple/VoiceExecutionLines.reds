// Whether our mod Execution Lines says the execution lines at this instant: then the grapple leaves them to it and keeps
// Get over here alone (Kevin, 19 November 2026, conception.md rule 10 and docs/repliques-executions/conception.md
// section 7). The one file that cites it, through the one point it offers, so that this mod compiles and works the
// same without it.

@if(ModuleExists("ExecutionLines"))
import ExecutionLines.*

@if(ModuleExists("ExecutionLines"))
public func ApexGrappleExecutionLinesHandle(game: GameInstance) -> Bool {
  return HandlesExecutions(game);
}

@if(!ModuleExists("ExecutionLines"))
public func ApexGrappleExecutionLinesHandle(game: GameInstance) -> Bool {
  return false;
}
