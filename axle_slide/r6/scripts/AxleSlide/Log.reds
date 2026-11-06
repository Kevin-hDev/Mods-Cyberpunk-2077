// Our lines go to CET's game log (bin/x64/plugins/cyber_engine_tweaks/gamelog.log). CET keeps ordinary lines in
// memory and writes them out only now and then, so a crash loses the last minute. Lines of the ASSERT channel are
// written at CET's error level, which writes the whole log to the file at once. The game does nothing else with
// this channel. Other mods declare the same native function; two declarations compile together (redscript-cli 0.5.31).
native func LogChannel(channel: CName, const text: script_ref<String>)

public func AxleSlideLog(const text: String) -> Void {
  LogChannel(n"ASSERT", "[AxleSlide] " + text);
}
