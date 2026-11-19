// V's execution lines, each recording once: its name, the phrase it says, whether it is whispered, and whether the
// female voice says it. Written by fabrique/table_script.py from the table of fabrique/lines.py, which makes the sounds
// and r6/audioware/ExecutionLines/voices.yml too: change that table, never this file. fabrique/test_lines.py reads
// each line of this file back against that table. The enum's members never change: Mod Settings keeps a player's
// choices under their names.

enum ExecutionLinesPhrase {
  None = 0,
  Chooses = 1,
  Insanity = 2,
  Impunity = 3,
  KillOrBeKilled = 4,
  Respect = 5,
  OneOfUs = 6,
  Death = 7,
  Soul = 8
}

public struct ExecutionLinesLine {
  let name: CName;
  let phrase: ExecutionLinesPhrase;
  let whispered: Bool;
  let female: Bool;
}

public func ExecutionLinesTable() -> array<ExecutionLinesLine> {
  return [
    new ExecutionLinesLine(n"execution_lines_f_the_definition_of_insanity_angry", ExecutionLinesPhrase.Insanity, false, true),
    new ExecutionLinesLine(n"execution_lines_f_the_definition_of_insanity_eager", ExecutionLinesPhrase.Insanity, false, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_the_definition_of_insanity_angry", ExecutionLinesPhrase.Insanity, true, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_the_definition_of_insanity_menacing", ExecutionLinesPhrase.Insanity, true, true),
    new ExecutionLinesLine(n"execution_lines_f_executed_with_impunity_angry", ExecutionLinesPhrase.Impunity, false, true),
    new ExecutionLinesLine(n"execution_lines_f_executed_with_impunity_menacing", ExecutionLinesPhrase.Impunity, false, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_executed_with_impunity_angry", ExecutionLinesPhrase.Impunity, true, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_executed_with_impunity_menacing", ExecutionLinesPhrase.Impunity, true, true),
    new ExecutionLinesLine(n"execution_lines_f_kill_or_be_killed_menacing_angry", ExecutionLinesPhrase.KillOrBeKilled, false, true),
    new ExecutionLinesLine(n"execution_lines_f_kill_or_be_killed_menacing", ExecutionLinesPhrase.KillOrBeKilled, false, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_kill_or_be_killed_angry", ExecutionLinesPhrase.KillOrBeKilled, true, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_kill_or_be_killed_menacing", ExecutionLinesPhrase.KillOrBeKilled, true, true),
    new ExecutionLinesLine(n"execution_lines_f_treating_a_woman_with_respect", ExecutionLinesPhrase.Respect, false, true),
    new ExecutionLinesLine(n"execution_lines_f_treating_a_woman_with_respect_eager", ExecutionLinesPhrase.Respect, false, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_treating_a_woman_with_respect", ExecutionLinesPhrase.Respect, true, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_treating_a_woman_with_respect_eager", ExecutionLinesPhrase.Respect, true, true),
    new ExecutionLinesLine(n"execution_lines_f_one_of_us_must_die", ExecutionLinesPhrase.OneOfUs, false, true),
    new ExecutionLinesLine(n"execution_lines_f_one_of_us_must_die_bored", ExecutionLinesPhrase.OneOfUs, false, true),
    new ExecutionLinesLine(n"execution_lines_f_one_of_us_must_die_menacing", ExecutionLinesPhrase.OneOfUs, false, true),
    new ExecutionLinesLine(n"execution_lines_f_one_of_us_must_die_no_pause", ExecutionLinesPhrase.OneOfUs, false, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_one_of_us_must_die", ExecutionLinesPhrase.OneOfUs, true, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_one_of_us_must_die_bored_no_pause", ExecutionLinesPhrase.OneOfUs, true, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_one_of_us_must_die_menacing", ExecutionLinesPhrase.OneOfUs, true, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_one_of_us_must_die_angry", ExecutionLinesPhrase.OneOfUs, true, true),
    new ExecutionLinesLine(n"execution_lines_f_your_death_will_be_swift", ExecutionLinesPhrase.Death, false, true),
    new ExecutionLinesLine(n"execution_lines_f_your_death_will_be_swift_angry", ExecutionLinesPhrase.Death, false, true),
    new ExecutionLinesLine(n"execution_lines_f_your_death_will_be_swift_menacing", ExecutionLinesPhrase.Death, false, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_your_death_will_be_swift", ExecutionLinesPhrase.Death, true, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_your_death_will_be_swift_angry", ExecutionLinesPhrase.Death, true, true),
    new ExecutionLinesLine(n"execution_lines_f_your_soul_is_weak", ExecutionLinesPhrase.Soul, false, true),
    new ExecutionLinesLine(n"execution_lines_f_your_soul_is_weak_angry", ExecutionLinesPhrase.Soul, false, true),
    new ExecutionLinesLine(n"execution_lines_f_your_soul_is_weak_menacing", ExecutionLinesPhrase.Soul, false, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_your_soul_is_weak", ExecutionLinesPhrase.Soul, true, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_your_soul_is_weak_angry", ExecutionLinesPhrase.Soul, true, true),
    new ExecutionLinesLine(n"execution_lines_f_whisper_your_soul_is_weak_menacing", ExecutionLinesPhrase.Soul, true, true),
    new ExecutionLinesLine(n"execution_lines_m_a_man_chooses_a_slave_obeys", ExecutionLinesPhrase.Chooses, false, false),
    new ExecutionLinesLine(n"execution_lines_m_a_man_chooses_a_slave_obeys_angry", ExecutionLinesPhrase.Chooses, false, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_a_man_chooses_a_slave_obeys", ExecutionLinesPhrase.Chooses, true, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_a_man_chooses_a_slave_obeys_angry", ExecutionLinesPhrase.Chooses, true, false),
    new ExecutionLinesLine(n"execution_lines_m_the_definition_of_insanity", ExecutionLinesPhrase.Insanity, false, false),
    new ExecutionLinesLine(n"execution_lines_m_the_definition_of_insanity_menacing", ExecutionLinesPhrase.Insanity, false, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_the_definition_of_insanity", ExecutionLinesPhrase.Insanity, true, false),
    new ExecutionLinesLine(n"execution_lines_m_executed_with_impunity", ExecutionLinesPhrase.Impunity, false, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_executed_with_impunity", ExecutionLinesPhrase.Impunity, true, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_executed_with_impunity_angry", ExecutionLinesPhrase.Impunity, true, false),
    new ExecutionLinesLine(n"execution_lines_m_kill_or_be_killed", ExecutionLinesPhrase.KillOrBeKilled, false, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_kill_or_be_killed_angry", ExecutionLinesPhrase.KillOrBeKilled, true, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_kill_or_be_killed_menacing", ExecutionLinesPhrase.KillOrBeKilled, true, false),
    new ExecutionLinesLine(n"execution_lines_m_one_of_us_must_die", ExecutionLinesPhrase.OneOfUs, false, false),
    new ExecutionLinesLine(n"execution_lines_m_one_of_us_must_die_angry_no_pause", ExecutionLinesPhrase.OneOfUs, false, false),
    new ExecutionLinesLine(n"execution_lines_m_one_of_us_must_die_bored", ExecutionLinesPhrase.OneOfUs, false, false),
    new ExecutionLinesLine(n"execution_lines_m_one_of_us_must_die_menacing", ExecutionLinesPhrase.OneOfUs, false, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_one_of_us_must_die", ExecutionLinesPhrase.OneOfUs, true, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_one_of_us_must_die_angry", ExecutionLinesPhrase.OneOfUs, true, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_one_of_us_must_die_angry_no_pause", ExecutionLinesPhrase.OneOfUs, true, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_one_of_us_must_die_menacing", ExecutionLinesPhrase.OneOfUs, true, false),
    new ExecutionLinesLine(n"execution_lines_m_your_death_will_be_swift", ExecutionLinesPhrase.Death, false, false),
    new ExecutionLinesLine(n"execution_lines_m_your_death_will_be_swift_angry", ExecutionLinesPhrase.Death, false, false),
    new ExecutionLinesLine(n"execution_lines_m_your_death_will_be_swift_menacing", ExecutionLinesPhrase.Death, false, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_your_death_will_be_swift", ExecutionLinesPhrase.Death, true, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_your_death_will_be_swift_angry", ExecutionLinesPhrase.Death, true, false),
    new ExecutionLinesLine(n"execution_lines_m_your_soul_is_weak", ExecutionLinesPhrase.Soul, false, false),
    new ExecutionLinesLine(n"execution_lines_m_your_soul_is_weak_angry", ExecutionLinesPhrase.Soul, false, false),
    new ExecutionLinesLine(n"execution_lines_m_your_soul_is_weak_bored", ExecutionLinesPhrase.Soul, false, false),
    new ExecutionLinesLine(n"execution_lines_m_your_soul_is_weak_menacing", ExecutionLinesPhrase.Soul, false, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_your_soul_is_weak", ExecutionLinesPhrase.Soul, true, false),
    new ExecutionLinesLine(n"execution_lines_m_whisper_your_soul_is_weak_angry", ExecutionLinesPhrase.Soul, true, false)
  ];
}

// The phrases heard on a knock-out as well as on a kill.
public func ExecutionLinesFitsNonLethal(phrase: ExecutionLinesPhrase) -> Bool {
  return Equals(phrase, ExecutionLinesPhrase.Chooses)
    || Equals(phrase, ExecutionLinesPhrase.Insanity)
    || Equals(phrase, ExecutionLinesPhrase.Respect)
    || Equals(phrase, ExecutionLinesPhrase.Soul);
}
