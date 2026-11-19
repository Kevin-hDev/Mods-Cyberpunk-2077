// The one script of this mod that names Execution Lines, and only by the single point it keeps fixed, HandlesExecutions.
// Kevin, 19 November 2026: an execution line has one authority. With Execution Lines taking the executions, the
// grapple keeps only its pull line (VoiceKill.reds). The mod compiles and works the same without Execution Lines:
// each function here exists for it and without it, where it answers no.

@if(ModuleExists("ExecutionLines"))
import ExecutionLines.*

@if(ModuleExists("ExecutionLines"))
public func CyberGrappleExecutionLinesHandle(game: GameInstance) -> Bool {
  return HandlesExecutions(game);
}

@if(!ModuleExists("ExecutionLines"))
public func CyberGrappleExecutionLinesHandle(game: GameInstance) -> Bool {
  return false;
}
