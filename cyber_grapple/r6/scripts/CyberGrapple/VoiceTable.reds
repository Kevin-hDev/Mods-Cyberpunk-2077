// V's recordings (Kevin, 18 and 19 November 2026), each line written here once: the phrase it says, whether it is
// whispered, and who says it. voices.yml declares the same names, written with the sounds from one table
// (releves/cyber-grapple/2026-11-18-repliques/scripts/niveaux.py); test_source.py checks this table, voices.yml and
// the sound files against each other. Voice.reds draws among these lines.

enum CyberGrappleVoicePhrase {
  GetOverHere = 0,
  Death = 1,
  Soul = 2
}

// Each line is one recording of one voice: the scripts pick a V's lines, Audioware never picks a recording by the
// gender it holds (VoicePlay.reds says why).
enum CyberGrappleVoiceSpeaker {
  Female = 0,
  Male = 1
}

public struct CyberGrappleVoiceLine {
  let name: CName;
  let phrase: CyberGrappleVoicePhrase;
  let whispered: Bool;
  let speaker: CyberGrappleVoiceSpeaker;
}

public func CyberGrappleVoiceLineOf(name: CName, phrase: CyberGrappleVoicePhrase, whispered: Bool, speaker: CyberGrappleVoiceSpeaker) -> CyberGrappleVoiceLine {
  let line: CyberGrappleVoiceLine;
  line.name = name;
  line.phrase = phrase;
  line.whispered = whispered;
  line.speaker = speaker;
  return line;
}

// Name, phrase, whispered, who says it. Every name says its voice (f_, m_), which is the folder of its recording.
public func CyberGrappleVoiceTable() -> array<CyberGrappleVoiceLine> {
  return [
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_get_over_here", CyberGrappleVoicePhrase.GetOverHere, false, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_get_over_here_2", CyberGrappleVoicePhrase.GetOverHere, false, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_get_over_here", CyberGrappleVoicePhrase.GetOverHere, false, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_get_over_here_2", CyberGrappleVoicePhrase.GetOverHere, false, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_get_over_here_3", CyberGrappleVoicePhrase.GetOverHere, false, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_your_death_will_be_swift", CyberGrappleVoicePhrase.Death, false, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_your_death_will_be_swift_angry", CyberGrappleVoicePhrase.Death, false, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_your_death_will_be_swift_menacing", CyberGrappleVoicePhrase.Death, false, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_your_death_will_be_swift_bored", CyberGrappleVoicePhrase.Death, false, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_your_death_will_be_swift", CyberGrappleVoicePhrase.Death, false, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_your_death_will_be_swift_angry", CyberGrappleVoicePhrase.Death, false, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_your_death_will_be_swift_menacing", CyberGrappleVoicePhrase.Death, false, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_your_death_will_be_swift_bored", CyberGrappleVoicePhrase.Death, false, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_whisper_your_death_will_be_swift", CyberGrappleVoicePhrase.Death, true, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_whisper_your_death_will_be_swift_angry", CyberGrappleVoicePhrase.Death, true, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_whisper_your_death_will_be_swift", CyberGrappleVoicePhrase.Death, true, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_whisper_your_death_will_be_swift_angry", CyberGrappleVoicePhrase.Death, true, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_whisper_your_death_will_be_swift_menacing", CyberGrappleVoicePhrase.Death, true, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_your_soul_is_weak", CyberGrappleVoicePhrase.Soul, false, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_your_soul_is_weak_angry", CyberGrappleVoicePhrase.Soul, false, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_your_soul_is_weak_menacing", CyberGrappleVoicePhrase.Soul, false, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_your_soul_is_weak", CyberGrappleVoicePhrase.Soul, false, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_your_soul_is_weak_bored", CyberGrappleVoicePhrase.Soul, false, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_your_soul_is_weak_menacing", CyberGrappleVoicePhrase.Soul, false, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_your_soul_is_weak_pause", CyberGrappleVoicePhrase.Soul, false, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_whisper_your_soul_is_weak", CyberGrappleVoicePhrase.Soul, true, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_whisper_your_soul_is_weak_angry", CyberGrappleVoicePhrase.Soul, true, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_f_whisper_your_soul_is_weak_menacing", CyberGrappleVoicePhrase.Soul, true, CyberGrappleVoiceSpeaker.Female),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_whisper_your_soul_is_weak", CyberGrappleVoicePhrase.Soul, true, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_whisper_your_soul_is_weak_angry", CyberGrappleVoicePhrase.Soul, true, CyberGrappleVoiceSpeaker.Male),
    CyberGrappleVoiceLineOf(n"cyber_grapple_m_whisper_your_soul_is_weak_menacing", CyberGrappleVoicePhrase.Soul, true, CyberGrappleVoiceSpeaker.Male)
  ];
}

// The lines of this phrase a V of this voice says, out loud and whispered as asked.
public func CyberGrappleVoiceLinesOf(table: array<CyberGrappleVoiceLine>, phrase: CyberGrappleVoicePhrase, female: Bool, spoken: Bool, whispered: Bool) -> array<CName> {
  let speaker: CyberGrappleVoiceSpeaker = female ? CyberGrappleVoiceSpeaker.Female : CyberGrappleVoiceSpeaker.Male;
  let lines: array<CName>;
  for line in table {
    let style: Bool = line.whispered ? whispered : spoken;
    if Equals(line.phrase, phrase) && Equals(line.speaker, speaker) && style {
      ArrayPush(lines, line.name);
    }
  }
  return lines;
}

// Whether the line named says this phrase, whoever says it and however: false for a name the table does not hold, as
// the last line at a load, which is none.
public func CyberGrappleVoiceSays(table: array<CyberGrappleVoiceLine>, name: CName, phrase: CyberGrappleVoicePhrase) -> Bool {
  for line in table {
    if Equals(line.name, name) {
      return Equals(line.phrase, phrase);
    }
  }
  return false;
}
