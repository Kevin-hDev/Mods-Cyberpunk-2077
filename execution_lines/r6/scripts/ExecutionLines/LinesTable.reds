// V's lines, each recording once: its name, the phrase it says, whether it is whispered, whether the female voice says
// it, and how long its sound lasts. Written by fabrique/table_script.py from the table of fabrique/lines.py, which makes
// the sounds and r6/audioware/ExecutionLines/voices.yml too: change that table, never this file. fabrique/test_lines.py
// reads each line of this file back against that table and each length against its sound. The enum's members never
// change: Mod Settings keeps a player's choices under their names.

enum ExecutionLinesPhrase {
  None = 0,
  Chooses = 1,
  Insanity = 2,
  Impunity = 3,
  KillOrBeKilled = 4,
  Respect = 5,
  OneOfUs = 6,
  Death = 7,
  Soul = 8,
  SweetDreams = 9,
  ExitLight = 10,
  NotPersonal = 11,
  Ticket = 12,
  LetYouGo = 13,
  Scars = 14,
  Serious = 15,
  LockedIn = 16,
  UpThere = 17,
  GoToSleep = 18,
  HadYourChance = 19,
  YourOwn = 20,
  AnotherTime = 21,
  Smile = 22
}

public struct ExecutionLinesLine {
  let name: CName;
  let phrase: ExecutionLinesPhrase;
  let whispered: Bool;
  let female: Bool;
  let milliseconds: Int32;
}

public func ExecutionLinesTable() -> array<ExecutionLinesLine> {
  return [
    new ExecutionLinesLine(n"execution_lines_f_the_definition_of_insanity_angry", ExecutionLinesPhrase.Insanity, false, true, 3358),
    new ExecutionLinesLine(n"execution_lines_f_the_definition_of_insanity_eager", ExecutionLinesPhrase.Insanity, false, true, 3358),
    new ExecutionLinesLine(n"execution_lines_f_whisper_the_definition_of_insanity_angry", ExecutionLinesPhrase.Insanity, true, true, 4000),
    new ExecutionLinesLine(n"execution_lines_f_whisper_the_definition_of_insanity_menacing", ExecutionLinesPhrase.Insanity, true, true, 3518),
    new ExecutionLinesLine(n"execution_lines_f_executed_with_impunity_angry", ExecutionLinesPhrase.Impunity, false, true, 2792),
    new ExecutionLinesLine(n"execution_lines_f_executed_with_impunity_menacing", ExecutionLinesPhrase.Impunity, false, true, 3504),
    new ExecutionLinesLine(n"execution_lines_f_whisper_executed_with_impunity_angry", ExecutionLinesPhrase.Impunity, true, true, 3023),
    new ExecutionLinesLine(n"execution_lines_f_whisper_executed_with_impunity_menacing", ExecutionLinesPhrase.Impunity, true, true, 3263),
    new ExecutionLinesLine(n"execution_lines_f_kill_or_be_killed_menacing_angry", ExecutionLinesPhrase.KillOrBeKilled, false, true, 3359),
    new ExecutionLinesLine(n"execution_lines_f_kill_or_be_killed_menacing", ExecutionLinesPhrase.KillOrBeKilled, false, true, 3196),
    new ExecutionLinesLine(n"execution_lines_f_whisper_kill_or_be_killed_angry", ExecutionLinesPhrase.KillOrBeKilled, true, true, 3120),
    new ExecutionLinesLine(n"execution_lines_f_whisper_kill_or_be_killed_menacing", ExecutionLinesPhrase.KillOrBeKilled, true, true, 3166),
    new ExecutionLinesLine(n"execution_lines_f_treating_a_woman_with_respect", ExecutionLinesPhrase.Respect, false, true, 3807),
    new ExecutionLinesLine(n"execution_lines_f_treating_a_woman_with_respect_eager", ExecutionLinesPhrase.Respect, false, true, 4152),
    new ExecutionLinesLine(n"execution_lines_f_whisper_treating_a_woman_with_respect", ExecutionLinesPhrase.Respect, true, true, 3580),
    new ExecutionLinesLine(n"execution_lines_f_whisper_treating_a_woman_with_respect_eager", ExecutionLinesPhrase.Respect, true, true, 4080),
    new ExecutionLinesLine(n"execution_lines_f_one_of_us_must_die", ExecutionLinesPhrase.OneOfUs, false, true, 2315),
    new ExecutionLinesLine(n"execution_lines_f_one_of_us_must_die_bored", ExecutionLinesPhrase.OneOfUs, false, true, 2800),
    new ExecutionLinesLine(n"execution_lines_f_one_of_us_must_die_menacing", ExecutionLinesPhrase.OneOfUs, false, true, 2870),
    new ExecutionLinesLine(n"execution_lines_f_one_of_us_must_die_no_pause", ExecutionLinesPhrase.OneOfUs, false, true, 2278),
    new ExecutionLinesLine(n"execution_lines_f_whisper_one_of_us_must_die", ExecutionLinesPhrase.OneOfUs, true, true, 2720),
    new ExecutionLinesLine(n"execution_lines_f_whisper_one_of_us_must_die_bored_no_pause", ExecutionLinesPhrase.OneOfUs, true, true, 2080),
    new ExecutionLinesLine(n"execution_lines_f_whisper_one_of_us_must_die_menacing", ExecutionLinesPhrase.OneOfUs, true, true, 2800),
    new ExecutionLinesLine(n"execution_lines_f_whisper_one_of_us_must_die_angry", ExecutionLinesPhrase.OneOfUs, true, true, 2880),
    new ExecutionLinesLine(n"execution_lines_f_your_death_will_be_swift", ExecutionLinesPhrase.Death, false, true, 2062),
    new ExecutionLinesLine(n"execution_lines_f_your_death_will_be_swift_angry", ExecutionLinesPhrase.Death, false, true, 2557),
    new ExecutionLinesLine(n"execution_lines_f_your_death_will_be_swift_menacing", ExecutionLinesPhrase.Death, false, true, 2871),
    new ExecutionLinesLine(n"execution_lines_f_whisper_your_death_will_be_swift", ExecutionLinesPhrase.Death, true, true, 2720),
    new ExecutionLinesLine(n"execution_lines_f_whisper_your_death_will_be_swift_angry", ExecutionLinesPhrase.Death, true, true, 2837),
    new ExecutionLinesLine(n"execution_lines_f_your_soul_is_weak", ExecutionLinesPhrase.Soul, false, true, 1898),
    new ExecutionLinesLine(n"execution_lines_f_your_soul_is_weak_angry", ExecutionLinesPhrase.Soul, false, true, 2503),
    new ExecutionLinesLine(n"execution_lines_f_your_soul_is_weak_menacing", ExecutionLinesPhrase.Soul, false, true, 2640),
    new ExecutionLinesLine(n"execution_lines_f_whisper_your_soul_is_weak", ExecutionLinesPhrase.Soul, true, true, 2767),
    new ExecutionLinesLine(n"execution_lines_f_whisper_your_soul_is_weak_angry", ExecutionLinesPhrase.Soul, true, true, 2684),
    new ExecutionLinesLine(n"execution_lines_f_whisper_your_soul_is_weak_menacing", ExecutionLinesPhrase.Soul, true, true, 2720),
    new ExecutionLinesLine(n"execution_lines_m_a_man_chooses_a_slave_obeys", ExecutionLinesPhrase.Chooses, false, false, 3423),
    new ExecutionLinesLine(n"execution_lines_m_a_man_chooses_a_slave_obeys_angry", ExecutionLinesPhrase.Chooses, false, false, 3119),
    new ExecutionLinesLine(n"execution_lines_m_whisper_a_man_chooses_a_slave_obeys", ExecutionLinesPhrase.Chooses, true, false, 3171),
    new ExecutionLinesLine(n"execution_lines_m_whisper_a_man_chooses_a_slave_obeys_angry", ExecutionLinesPhrase.Chooses, true, false, 3241),
    new ExecutionLinesLine(n"execution_lines_m_the_definition_of_insanity", ExecutionLinesPhrase.Insanity, false, false, 3181),
    new ExecutionLinesLine(n"execution_lines_m_the_definition_of_insanity_menacing", ExecutionLinesPhrase.Insanity, false, false, 3069),
    new ExecutionLinesLine(n"execution_lines_m_whisper_the_definition_of_insanity", ExecutionLinesPhrase.Insanity, true, false, 3425),
    new ExecutionLinesLine(n"execution_lines_m_executed_with_impunity", ExecutionLinesPhrase.Impunity, false, false, 3265),
    new ExecutionLinesLine(n"execution_lines_m_whisper_executed_with_impunity", ExecutionLinesPhrase.Impunity, true, false, 3199),
    new ExecutionLinesLine(n"execution_lines_m_whisper_executed_with_impunity_angry", ExecutionLinesPhrase.Impunity, true, false, 3344),
    new ExecutionLinesLine(n"execution_lines_m_kill_or_be_killed", ExecutionLinesPhrase.KillOrBeKilled, false, false, 2798),
    new ExecutionLinesLine(n"execution_lines_m_whisper_kill_or_be_killed_angry", ExecutionLinesPhrase.KillOrBeKilled, true, false, 3051),
    new ExecutionLinesLine(n"execution_lines_m_whisper_kill_or_be_killed_menacing", ExecutionLinesPhrase.KillOrBeKilled, true, false, 2926),
    new ExecutionLinesLine(n"execution_lines_m_one_of_us_must_die", ExecutionLinesPhrase.OneOfUs, false, false, 2318),
    new ExecutionLinesLine(n"execution_lines_m_one_of_us_must_die_angry_no_pause", ExecutionLinesPhrase.OneOfUs, false, false, 1995),
    new ExecutionLinesLine(n"execution_lines_m_one_of_us_must_die_bored", ExecutionLinesPhrase.OneOfUs, false, false, 2643),
    new ExecutionLinesLine(n"execution_lines_m_one_of_us_must_die_menacing", ExecutionLinesPhrase.OneOfUs, false, false, 2872),
    new ExecutionLinesLine(n"execution_lines_m_whisper_one_of_us_must_die", ExecutionLinesPhrase.OneOfUs, true, false, 2337),
    new ExecutionLinesLine(n"execution_lines_m_whisper_one_of_us_must_die_angry", ExecutionLinesPhrase.OneOfUs, true, false, 2593),
    new ExecutionLinesLine(n"execution_lines_m_whisper_one_of_us_must_die_angry_no_pause", ExecutionLinesPhrase.OneOfUs, true, false, 1920),
    new ExecutionLinesLine(n"execution_lines_m_whisper_one_of_us_must_die_menacing", ExecutionLinesPhrase.OneOfUs, true, false, 2470),
    new ExecutionLinesLine(n"execution_lines_m_your_death_will_be_swift", ExecutionLinesPhrase.Death, false, false, 1796),
    new ExecutionLinesLine(n"execution_lines_m_your_death_will_be_swift_angry", ExecutionLinesPhrase.Death, false, false, 2535),
    new ExecutionLinesLine(n"execution_lines_m_your_death_will_be_swift_menacing", ExecutionLinesPhrase.Death, false, false, 2395),
    new ExecutionLinesLine(n"execution_lines_m_whisper_your_death_will_be_swift", ExecutionLinesPhrase.Death, true, false, 2614),
    new ExecutionLinesLine(n"execution_lines_m_whisper_your_death_will_be_swift_angry", ExecutionLinesPhrase.Death, true, false, 2634),
    new ExecutionLinesLine(n"execution_lines_m_your_soul_is_weak", ExecutionLinesPhrase.Soul, false, false, 1482),
    new ExecutionLinesLine(n"execution_lines_m_your_soul_is_weak_angry", ExecutionLinesPhrase.Soul, false, false, 2538),
    new ExecutionLinesLine(n"execution_lines_m_your_soul_is_weak_bored", ExecutionLinesPhrase.Soul, false, false, 2456),
    new ExecutionLinesLine(n"execution_lines_m_your_soul_is_weak_menacing", ExecutionLinesPhrase.Soul, false, false, 2305),
    new ExecutionLinesLine(n"execution_lines_m_whisper_your_soul_is_weak", ExecutionLinesPhrase.Soul, true, false, 2441),
    new ExecutionLinesLine(n"execution_lines_m_whisper_your_soul_is_weak_angry", ExecutionLinesPhrase.Soul, true, false, 2371),
    new ExecutionLinesLine(n"execution_lines_f_sweet_dreams", ExecutionLinesPhrase.SweetDreams, false, true, 4069),
    new ExecutionLinesLine(n"execution_lines_f_whisper_sweet_dreams", ExecutionLinesPhrase.SweetDreams, true, true, 3920),
    new ExecutionLinesLine(n"execution_lines_f_exit_light_enter_night", ExecutionLinesPhrase.ExitLight, false, true, 3440),
    new ExecutionLinesLine(n"execution_lines_f_whisper_exit_light_enter_night", ExecutionLinesPhrase.ExitLight, true, true, 3360),
    new ExecutionLinesLine(n"execution_lines_f_its_not_personal", ExecutionLinesPhrase.NotPersonal, false, true, 3760),
    new ExecutionLinesLine(n"execution_lines_f_whisper_its_not_personal", ExecutionLinesPhrase.NotPersonal, true, true, 3600),
    new ExecutionLinesLine(n"execution_lines_f_a_ticket_to_heaven", ExecutionLinesPhrase.Ticket, false, true, 2880),
    new ExecutionLinesLine(n"execution_lines_f_whisper_a_ticket_to_heaven", ExecutionLinesPhrase.Ticket, true, true, 2961),
    new ExecutionLinesLine(n"execution_lines_f_say_my_name", ExecutionLinesPhrase.LetYouGo, false, true, 2536),
    new ExecutionLinesLine(n"execution_lines_f_whisper_say_my_name", ExecutionLinesPhrase.LetYouGo, true, true, 2720),
    new ExecutionLinesLine(n"execution_lines_f_how_i_got_these_scars", ExecutionLinesPhrase.Scars, false, true, 2904),
    new ExecutionLinesLine(n"execution_lines_f_whisper_how_i_got_these_scars", ExecutionLinesPhrase.Scars, true, true, 2618),
    new ExecutionLinesLine(n"execution_lines_f_why_so_serious", ExecutionLinesPhrase.Serious, false, true, 2560),
    new ExecutionLinesLine(n"execution_lines_f_whisper_why_so_serious", ExecutionLinesPhrase.Serious, true, true, 2360),
    new ExecutionLinesLine(n"execution_lines_f_locked_in_here_with_me_playful", ExecutionLinesPhrase.LockedIn, false, true, 4049),
    new ExecutionLinesLine(n"execution_lines_f_locked_in_here_with_me_menacing", ExecutionLinesPhrase.LockedIn, false, true, 4240),
    new ExecutionLinesLine(n"execution_lines_f_whisper_locked_in_here_with_me", ExecutionLinesPhrase.LockedIn, true, true, 4174),
    new ExecutionLinesLine(n"execution_lines_f_see_you_up_there_playful", ExecutionLinesPhrase.UpThere, false, true, 2240),
    new ExecutionLinesLine(n"execution_lines_f_see_you_up_there_menacing", ExecutionLinesPhrase.UpThere, false, true, 1715),
    new ExecutionLinesLine(n"execution_lines_f_whisper_see_you_up_there_playful", ExecutionLinesPhrase.UpThere, true, true, 1920),
    new ExecutionLinesLine(n"execution_lines_f_whisper_see_you_up_there_menacing", ExecutionLinesPhrase.UpThere, true, true, 2160),
    new ExecutionLinesLine(n"execution_lines_f_go_to_sleep", ExecutionLinesPhrase.GoToSleep, false, true, 2095),
    new ExecutionLinesLine(n"execution_lines_f_whisper_go_to_sleep", ExecutionLinesPhrase.GoToSleep, true, true, 2072),
    new ExecutionLinesLine(n"execution_lines_f_you_had_your_chance", ExecutionLinesPhrase.HadYourChance, false, true, 1906),
    new ExecutionLinesLine(n"execution_lines_f_whisper_you_had_your_chance", ExecutionLinesPhrase.HadYourChance, true, true, 1930),
    new ExecutionLinesLine(n"execution_lines_f_now_youll_have_your_own", ExecutionLinesPhrase.YourOwn, false, true, 2480),
    new ExecutionLinesLine(n"execution_lines_f_whisper_now_youll_have_your_own", ExecutionLinesPhrase.YourOwn, true, true, 2171),
    new ExecutionLinesLine(n"execution_lines_f_another_time_maybe_angry", ExecutionLinesPhrase.AnotherTime, false, true, 2720),
    new ExecutionLinesLine(n"execution_lines_f_another_time_maybe_menacing", ExecutionLinesPhrase.AnotherTime, false, true, 2675),
    new ExecutionLinesLine(n"execution_lines_f_whisper_another_time_maybe_playful", ExecutionLinesPhrase.AnotherTime, true, true, 2392),
    new ExecutionLinesLine(n"execution_lines_f_whisper_another_time_maybe_menacing", ExecutionLinesPhrase.AnotherTime, true, true, 2177),
    new ExecutionLinesLine(n"execution_lines_f_put_a_smile_on_that_face_menacing", ExecutionLinesPhrase.Smile, false, true, 3440),
    new ExecutionLinesLine(n"execution_lines_f_put_a_smile_on_that_face_laughing_loud", ExecutionLinesPhrase.Smile, false, true, 5632),
    new ExecutionLinesLine(n"execution_lines_f_put_a_smile_on_that_face_laughing", ExecutionLinesPhrase.Smile, false, true, 3851),
    new ExecutionLinesLine(n"execution_lines_f_whisper_put_a_smile_on_that_face_menacing", ExecutionLinesPhrase.Smile, true, true, 2929),
    new ExecutionLinesLine(n"execution_lines_f_whisper_put_a_smile_on_that_face_laughing", ExecutionLinesPhrase.Smile, true, true, 5198),
    new ExecutionLinesLine(n"execution_lines_m_sweet_dreams", ExecutionLinesPhrase.SweetDreams, false, false, 1793),
    new ExecutionLinesLine(n"execution_lines_m_whisper_sweet_dreams", ExecutionLinesPhrase.SweetDreams, true, false, 1818),
    new ExecutionLinesLine(n"execution_lines_m_exit_light_enter_night", ExecutionLinesPhrase.ExitLight, false, false, 3005),
    new ExecutionLinesLine(n"execution_lines_m_whisper_exit_light_enter_night", ExecutionLinesPhrase.ExitLight, true, false, 2705),
    new ExecutionLinesLine(n"execution_lines_m_its_not_personal", ExecutionLinesPhrase.NotPersonal, false, false, 3169),
    new ExecutionLinesLine(n"execution_lines_m_whisper_its_not_personal", ExecutionLinesPhrase.NotPersonal, true, false, 3376),
    new ExecutionLinesLine(n"execution_lines_m_a_ticket_to_heaven", ExecutionLinesPhrase.Ticket, false, false, 2792),
    new ExecutionLinesLine(n"execution_lines_m_whisper_a_ticket_to_heaven", ExecutionLinesPhrase.Ticket, true, false, 2825),
    new ExecutionLinesLine(n"execution_lines_m_say_my_name", ExecutionLinesPhrase.LetYouGo, false, false, 3171),
    new ExecutionLinesLine(n"execution_lines_m_whisper_say_my_name", ExecutionLinesPhrase.LetYouGo, true, false, 3073),
    new ExecutionLinesLine(n"execution_lines_m_how_i_got_these_scars", ExecutionLinesPhrase.Scars, false, false, 2452),
    new ExecutionLinesLine(n"execution_lines_m_whisper_how_i_got_these_scars", ExecutionLinesPhrase.Scars, true, false, 2155),
    new ExecutionLinesLine(n"execution_lines_m_why_so_serious", ExecutionLinesPhrase.Serious, false, false, 2315),
    new ExecutionLinesLine(n"execution_lines_m_whisper_why_so_serious", ExecutionLinesPhrase.Serious, true, false, 1977),
    new ExecutionLinesLine(n"execution_lines_m_locked_in_here_with_me_playful", ExecutionLinesPhrase.LockedIn, false, false, 3545),
    new ExecutionLinesLine(n"execution_lines_m_locked_in_here_with_me_menacing", ExecutionLinesPhrase.LockedIn, false, false, 3515),
    new ExecutionLinesLine(n"execution_lines_m_whisper_locked_in_here_with_me", ExecutionLinesPhrase.LockedIn, true, false, 3680),
    new ExecutionLinesLine(n"execution_lines_m_see_you_up_there", ExecutionLinesPhrase.UpThere, false, false, 1797),
    new ExecutionLinesLine(n"execution_lines_m_whisper_see_you_up_there", ExecutionLinesPhrase.UpThere, true, false, 1747),
    new ExecutionLinesLine(n"execution_lines_m_go_to_sleep", ExecutionLinesPhrase.GoToSleep, false, false, 2144),
    new ExecutionLinesLine(n"execution_lines_m_whisper_go_to_sleep", ExecutionLinesPhrase.GoToSleep, true, false, 1836),
    new ExecutionLinesLine(n"execution_lines_m_you_had_your_chance", ExecutionLinesPhrase.HadYourChance, false, false, 1593),
    new ExecutionLinesLine(n"execution_lines_m_whisper_you_had_your_chance", ExecutionLinesPhrase.HadYourChance, true, false, 1578),
    new ExecutionLinesLine(n"execution_lines_m_now_youll_have_your_own", ExecutionLinesPhrase.YourOwn, false, false, 1988),
    new ExecutionLinesLine(n"execution_lines_m_whisper_now_youll_have_your_own", ExecutionLinesPhrase.YourOwn, true, false, 1838),
    new ExecutionLinesLine(n"execution_lines_m_another_time_maybe_angry", ExecutionLinesPhrase.AnotherTime, false, false, 2540),
    new ExecutionLinesLine(n"execution_lines_m_another_time_maybe_menacing", ExecutionLinesPhrase.AnotherTime, false, false, 2447),
    new ExecutionLinesLine(n"execution_lines_m_whisper_another_time_maybe_playful", ExecutionLinesPhrase.AnotherTime, true, false, 2417),
    new ExecutionLinesLine(n"execution_lines_m_whisper_another_time_maybe_menacing", ExecutionLinesPhrase.AnotherTime, true, false, 2365),
    new ExecutionLinesLine(n"execution_lines_m_put_a_smile_on_that_face_menacing", ExecutionLinesPhrase.Smile, false, false, 2786),
    new ExecutionLinesLine(n"execution_lines_m_put_a_smile_on_that_face_laughing", ExecutionLinesPhrase.Smile, false, false, 4937),
    new ExecutionLinesLine(n"execution_lines_m_whisper_put_a_smile_on_that_face_playful", ExecutionLinesPhrase.Smile, true, false, 2642),
    new ExecutionLinesLine(n"execution_lines_m_whisper_put_a_smile_on_that_face_laughing", ExecutionLinesPhrase.Smile, true, false, 5345)
  ];
}

// The phrases said at a knock-out.
public func ExecutionLinesFitsNonLethal(phrase: ExecutionLinesPhrase) -> Bool {
  return Equals(phrase, ExecutionLinesPhrase.Chooses)
    || Equals(phrase, ExecutionLinesPhrase.Insanity)
    || Equals(phrase, ExecutionLinesPhrase.Respect)
    || Equals(phrase, ExecutionLinesPhrase.Soul)
    || Equals(phrase, ExecutionLinesPhrase.SweetDreams)
    || Equals(phrase, ExecutionLinesPhrase.ExitLight)
    || Equals(phrase, ExecutionLinesPhrase.NotPersonal);
}

// The phrases said at a kill.
public func ExecutionLinesFitsLethal(phrase: ExecutionLinesPhrase) -> Bool {
  return Equals(phrase, ExecutionLinesPhrase.Chooses)
    || Equals(phrase, ExecutionLinesPhrase.Insanity)
    || Equals(phrase, ExecutionLinesPhrase.Impunity)
    || Equals(phrase, ExecutionLinesPhrase.KillOrBeKilled)
    || Equals(phrase, ExecutionLinesPhrase.Respect)
    || Equals(phrase, ExecutionLinesPhrase.OneOfUs)
    || Equals(phrase, ExecutionLinesPhrase.Death)
    || Equals(phrase, ExecutionLinesPhrase.Soul)
    || Equals(phrase, ExecutionLinesPhrase.ExitLight)
    || Equals(phrase, ExecutionLinesPhrase.NotPersonal);
}

// The phrases said while V holds an enemy, never at an execution.
public func ExecutionLinesIsGrab(phrase: ExecutionLinesPhrase) -> Bool {
  return Equals(phrase, ExecutionLinesPhrase.Ticket)
    || Equals(phrase, ExecutionLinesPhrase.LetYouGo)
    || Equals(phrase, ExecutionLinesPhrase.Scars)
    || Equals(phrase, ExecutionLinesPhrase.Serious)
    || Equals(phrase, ExecutionLinesPhrase.LockedIn);
}

// A grab line's conclusion at a kill or at a knock-out; None for a phrase that is not a grab line.
public func ExecutionLinesConclusionOf(grab: ExecutionLinesPhrase, lethal: Bool) -> ExecutionLinesPhrase {
  if Equals(grab, ExecutionLinesPhrase.Ticket) {
    return lethal ? ExecutionLinesPhrase.UpThere : ExecutionLinesPhrase.GoToSleep;
  }
  if Equals(grab, ExecutionLinesPhrase.LetYouGo) {
    return lethal ? ExecutionLinesPhrase.HadYourChance : ExecutionLinesPhrase.HadYourChance;
  }
  if Equals(grab, ExecutionLinesPhrase.Scars) {
    return lethal ? ExecutionLinesPhrase.YourOwn : ExecutionLinesPhrase.AnotherTime;
  }
  if Equals(grab, ExecutionLinesPhrase.Serious) {
    return lethal ? ExecutionLinesPhrase.Smile : ExecutionLinesPhrase.Smile;
  }
  if Equals(grab, ExecutionLinesPhrase.LockedIn) {
    return lethal ? ExecutionLinesPhrase.Death : ExecutionLinesPhrase.SweetDreams;
  }
  return ExecutionLinesPhrase.None;
}
