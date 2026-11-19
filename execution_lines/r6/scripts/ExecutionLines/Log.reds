// This mod's lines go to CET's game log (bin/x64/plugins/cyber_engine_tweaks/gamelog.log). Lines of the ASSERT channel
// are written to the file at once, so a crash keeps them. Other mods declare the same native function; two
// declarations compile together (redscript-cli 0.5.31).
native func LogChannel(channel: CName, const text: script_ref<String>)

public func ExecutionLinesLog(const text: String) -> Void {
  LogChannel(n"ASSERT", "[ExecutionLines] " + text);
}

// Each kind of line has its own bound of this many lines per load (optimisation.md, section 9.1), so that a frequent
// kind never uses up the lines that tell the others.
public func ExecutionLinesLogMost() -> Int32 {
  return 30;
}

// A kind of line bounded per load: returns the count once this line is dealt with. Past `most` lines nothing more is
// written, and the line at `most` says so once. Callers test `lines <= most` before building the text, so that a kind
// past its bound costs nothing more.
public func ExecutionLinesLogUpTo(lines: Int32, most: Int32, what: String, const text: String) -> Int32 {
  if lines < most {
    ExecutionLinesLog(text);
    return lines + 1;
  }
  if lines == most {
    ExecutionLinesLog(what + ": " + ToString(most) + " lines written this load, the next ones are not");
    return lines + 1;
  }
  return lines;
}
