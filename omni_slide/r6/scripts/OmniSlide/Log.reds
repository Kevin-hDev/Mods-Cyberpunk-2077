// Our lines go to CET's game log (bin/x64/plugins/cyber_engine_tweaks/gamelog.log). CET keeps ordinary lines in
// memory and writes them out only now and then, so a crash loses the last minute: on 21 October 2026, the minute of
// a death was lost in a crash at shutdown. CET writes lines of the ASSERT channel at its error level, and writes the
// whole log to the file at once from the warning level up (flush_on in CET's CreateLogger). The game does nothing else
// with this channel. Other mods declare the same native function; two declarations compile together (checked with
// redscript-cli 0.5.31).
native func LogChannel(channel: CName, const text: script_ref<String>)

public func OmniSlideLog(const text: String) -> Void {
  LogChannel(n"ASSERT", "[OmniSlide] " + text);
}
