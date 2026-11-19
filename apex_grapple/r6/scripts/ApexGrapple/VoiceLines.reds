// The names of V's voice lines, written here alone: voices.yml declares the same names, and fabrique/test_voices.py
// checks that each name a voice draws has a recording in that voice. A name says what its recording holds, which
// Voice.reds reads: its voice (f_, m_), the phrase (_death_ or _soul_) and whether it is whispered (whisper). One name
// per recording, each declared without a gender: the voice is chosen here, by the menu's choice else V's own voice
// (VoiceGender.reds), never by Audioware's gender of V. Kevin, 19 November 2026, a female V loaded after a male one in
// the same session: "elle a des replique de V homme", exactly the lines then declared in both voices for Audioware to
// pick, while the log showed this code asking the female names. Kevin's recordings of 18 and 19 November 2026, all of
// them in ("il nous faut les trois pour Vhomme et femme"), the same files and names as Cyber Grapple's.

enum ApexGrappleVoicePhrase {
  None = 0,
  Death = 1,
  Soul = 2
}

public func ApexGrappleVoiceIsPhrase(line: CName, phrase: ApexGrappleVoicePhrase) -> Bool {
  let name: String = NameToString(line);
  if Equals(phrase, ApexGrappleVoicePhrase.Death) {
    return StrContains(name, "_death_");
  }
  if Equals(phrase, ApexGrappleVoicePhrase.Soul) {
    return StrContains(name, "_soul_");
  }
  return false;
}

public func ApexGrappleVoiceIsWhispered(line: CName) -> Bool {
  return StrContains(NameToString(line), "whisper");
}

public func ApexGrappleVoicePullLines(female: Bool) -> array<CName> {
  return female ? ApexGrappleVoiceFemalePullLines() : ApexGrappleVoiceMalePullLines();
}

public func ApexGrappleVoiceKillLines(female: Bool) -> array<CName> {
  return female ? ApexGrappleVoiceFemaleKillLines() : ApexGrappleVoiceMaleKillLines();
}

public func ApexGrappleVoiceFemalePullLines() -> array<CName> {
  let lines: array<CName>;
  ArrayPush(lines, n"apex_grapple_f_get_over_here");
  ArrayPush(lines, n"apex_grapple_f_get_over_here_2");
  return lines;
}

public func ApexGrappleVoiceMalePullLines() -> array<CName> {
  let lines: array<CName>;
  ArrayPush(lines, n"apex_grapple_m_get_over_here");
  ArrayPush(lines, n"apex_grapple_m_get_over_here_2");
  ArrayPush(lines, n"apex_grapple_m_get_over_here_3");
  return lines;
}

public func ApexGrappleVoiceFemaleKillLines() -> array<CName> {
  let lines: array<CName>;
  ArrayPush(lines, n"apex_grapple_f_your_death_will_be_swift");
  ArrayPush(lines, n"apex_grapple_f_your_death_will_be_swift_angry");
  ArrayPush(lines, n"apex_grapple_f_your_death_will_be_swift_bored");
  ArrayPush(lines, n"apex_grapple_f_your_death_will_be_swift_menacing");
  ArrayPush(lines, n"apex_grapple_f_your_soul_is_weak");
  ArrayPush(lines, n"apex_grapple_f_your_soul_is_weak_angry");
  ArrayPush(lines, n"apex_grapple_f_your_soul_is_weak_menacing");
  ArrayPush(lines, n"apex_grapple_f_whisper_your_death_will_be_swift");
  ArrayPush(lines, n"apex_grapple_f_whisper_your_death_will_be_swift_angry");
  ArrayPush(lines, n"apex_grapple_f_whisper_your_soul_is_weak");
  ArrayPush(lines, n"apex_grapple_f_whisper_your_soul_is_weak_angry");
  ArrayPush(lines, n"apex_grapple_f_whisper_your_soul_is_weak_menacing");
  return lines;
}

public func ApexGrappleVoiceMaleKillLines() -> array<CName> {
  let lines: array<CName>;
  ArrayPush(lines, n"apex_grapple_m_your_death_will_be_swift");
  ArrayPush(lines, n"apex_grapple_m_your_death_will_be_swift_angry");
  ArrayPush(lines, n"apex_grapple_m_your_death_will_be_swift_bored");
  ArrayPush(lines, n"apex_grapple_m_your_death_will_be_swift_menacing");
  ArrayPush(lines, n"apex_grapple_m_your_soul_is_weak");
  ArrayPush(lines, n"apex_grapple_m_your_soul_is_weak_bored");
  ArrayPush(lines, n"apex_grapple_m_your_soul_is_weak_menacing");
  ArrayPush(lines, n"apex_grapple_m_your_soul_is_weak_pause");
  ArrayPush(lines, n"apex_grapple_m_whisper_your_death_will_be_swift");
  ArrayPush(lines, n"apex_grapple_m_whisper_your_death_will_be_swift_angry");
  ArrayPush(lines, n"apex_grapple_m_whisper_your_death_will_be_swift_menacing");
  ArrayPush(lines, n"apex_grapple_m_whisper_your_soul_is_weak");
  ArrayPush(lines, n"apex_grapple_m_whisper_your_soul_is_weak_angry");
  ArrayPush(lines, n"apex_grapple_m_whisper_your_soul_is_weak_menacing");
  return lines;
}
