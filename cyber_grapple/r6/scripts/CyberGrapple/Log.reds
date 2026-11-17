// Made by fabrique/grapple.py from Apex Grapple's Log.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Our lines go to CET's game log (bin/x64/plugins/cyber_engine_tweaks/gamelog.log). Lines of the ASSERT channel are
// written to the file at once, so a crash keeps them. Other mods declare the same native function; two declarations
// compile together (redscript-cli 0.5.31).
native func LogChannel(channel: CName, const text: script_ref<String>)

public func CyberGrappleLog(const text: String) -> Void {
  LogChannel(n"ASSERT", "[CyberGrapple] " + text);
}

// A journal of ours bounded per load (optimisation.md, section 9.1): returns the count once this line is dealt with.
// Past `most` lines nothing more is written, and the line at `most` says so once.
public func CyberGrappleLogUpTo(lines: Int32, most: Int32, what: String, const text: String) -> Int32 {
  if lines < most {
    CyberGrappleLog(text);
    return lines + 1;
  }
  if lines == most {
    CyberGrappleLog(what + ": " + ToString(most) + " lines written this load, the next ones are not");
    return lines + 1;
  }
  return lines;
}

public func CyberGrappleTime(game: GameInstance) -> Float {
  return EngineTime.ToFloat(GameInstance.GetSimTime(game));
}
