// Our lines go to CET's game log (bin/x64/plugins/cyber_engine_tweaks/gamelog.log). Lines of the ASSERT channel are
// written to the file at once, so a crash keeps them. Other mods declare the same native function; two declarations
// compile together (redscript-cli 0.5.31).
native func LogChannel(channel: CName, const text: script_ref<String>)

public func WallClimbLog(const text: String) -> Void {
  LogChannel(n"ASSERT", "[WallClimb] " + text);
}
