// The player's settings, shown by Mod Settings in Options > Mods when it is installed; without it the fields keep the
// values written here. Mod Settings keeps a choice under the name of its field and of its enum member: a name is never
// changed once a version is published, and a phrase added later gets a field of its own.
//
// The menu is the one Kevin chose on drawings on 19 November 2026: a "Custom" switch at the head of each section, not
// one for several, because Mod Settings keeps a section's title on the page even when all its lines are hidden. The
// phrases of a section hide behind its own Custom, the one condition Mod Settings takes per line, so none depends on
// Enabled: the lines above would hide with it and the phrases would stand alone on the page, mod off. Below the seven
// lines that have no section (since 1.0.2, the two volumes right after Line style) come Male V's execution lines
// (section 1) and Female V's (section 2), then, since 1.0.1,
// Male V's grab lines (section 3) and Female V's (section 4), each section's phrases in the alphabetical order of their
// labels. The voice that speaks and the kind of the phrase decide which section is read (ExecutionLinesChoiceOf,
// SettingsChoice.reds). A phrase that is only a conclusion has no field, and Death and SweetDreams, which also end
// LockedIn, ignore theirs then: a conclusion follows its grab line, chosen or not (conception-saisies, 3.2).
//
// All the fields live in this one class although Mod Settings takes several classes for one mod: the 20 fields of
// 1.0.0 were published here, and a field players keep never moves; the new ones follow them so that the code reads
// one settings object.

// The menu shows these three as Automatic, Feminine and Masculine, the words of the grapples' menus.
enum ExecutionLinesVoice {
  Auto = 0,
  Female = 1,
  Male = 2
}

enum ExecutionLinesStyle {
  Normal = 0,
  Whisper = 1,
  Both = 2
}

// Both comes first: the game gives an enum variable nobody set its first member, and Both is the default.
enum ExecutionLinesChoice {
  Both = 0,
  Normal = 1,
  Whisper = 2,
  None = 3
}

public class ExecutionLinesSettings {
  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-Enabled")
  @runtimeProperty("ModSettings.description", "ExecutionLines-Enabled-Description")
  public let enabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-Voice")
  @runtimeProperty("ModSettings.description", "ExecutionLines-Voice-Description")
  @runtimeProperty("ModSettings.displayValues.Auto", "ExecutionLines-Voice-Auto")
  @runtimeProperty("ModSettings.displayValues.Female", "ExecutionLines-Voice-Female")
  @runtimeProperty("ModSettings.displayValues.Male", "ExecutionLines-Voice-Male")
  public let voice: ExecutionLinesVoice = ExecutionLinesVoice.Auto;

  // Kevin, 18 November 2026, for the grapples' lines: 50 %, in series of ten so that 50 means five in ten.
  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-Chance")
  @runtimeProperty("ModSettings.description", "ExecutionLines-Chance-Description")
  @runtimeProperty("ModSettings.step", "10.0")
  @runtimeProperty("ModSettings.min", "10.0")
  @runtimeProperty("ModSettings.max", "100.0")
  public let chance: Float = 50.0;

  // Its own series of ten. 0 is allowed here and not for the executions: it is the one simple way to keep the
  // execution lines without any grab line, while Enabled cuts the executions (conception-saisies, section 3.1,
  // accepted by Kevin on 19 November 2026).
  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-GrabChance")
  @runtimeProperty("ModSettings.description", "ExecutionLines-GrabChance-Description")
  @runtimeProperty("ModSettings.step", "10.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "100.0")
  public let grabChance: Float = 50.0;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-Style")
  @runtimeProperty("ModSettings.description", "ExecutionLines-Style-Description")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Style-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Style-Whisper")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Style-Both")
  public let style: ExecutionLinesStyle = ExecutionLinesStyle.Both;

  // Kevin, 20 November 2026: one volume for the lines said out loud, one for the whispered ones, which only lower the
  // sound; 100, the default, is the level of 1.0.1 (ExecutionLinesVolumeOf, Speaking.reds).
  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-Volume")
  @runtimeProperty("ModSettings.description", "ExecutionLines-Volume-Description")
  @runtimeProperty("ModSettings.step", "10.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "100.0")
  public let volume: Float = 100.0;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-WhisperVolume")
  @runtimeProperty("ModSettings.description", "ExecutionLines-WhisperVolume-Description")
  @runtimeProperty("ModSettings.step", "10.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "100.0")
  public let whisperVolume: Float = 100.0;

  // Off: only Line style counts, and the choices below are ignored even if they were changed before.
  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Male")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-CustomMale")
  @runtimeProperty("ModSettings.description", "ExecutionLines-CustomMale-Description")
  public let customMale: Bool = false;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Male")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleChooses")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleChooses-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMale")
  public let maleChooses: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Male")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleInsanity")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleInsanity-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMale")
  public let maleInsanity: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Male")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleImpunity")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleImpunity-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMale")
  public let maleImpunity: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Male")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleExitLight")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleExitLight-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMale")
  public let maleExitLight: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Male")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleKillOrBeKilled")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleKillOrBeKilled-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMale")
  public let maleKillOrBeKilled: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Male")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleNotPersonal")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleNotPersonal-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMale")
  public let maleNotPersonal: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Male")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleOneOfUs")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleOneOfUs-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMale")
  public let maleOneOfUs: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Male")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleSweetDreams")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleSweetDreams-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMale")
  public let maleSweetDreams: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Male")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleDeath")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleDeath-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMale")
  public let maleDeath: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Male")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleSoul")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleSoul-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMale")
  public let maleSoul: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Female")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-CustomFemale")
  @runtimeProperty("ModSettings.description", "ExecutionLines-CustomFemale-Description")
  public let customFemale: Bool = false;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Female")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleInsanity")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleInsanity-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemale")
  public let femaleInsanity: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Female")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleImpunity")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleImpunity-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemale")
  public let femaleImpunity: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Female")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleExitLight")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleExitLight-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemale")
  public let femaleExitLight: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Female")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleKillOrBeKilled")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleKillOrBeKilled-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemale")
  public let femaleKillOrBeKilled: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Female")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleNotPersonal")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleNotPersonal-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemale")
  public let femaleNotPersonal: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Female")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleRespect")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleRespect-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemale")
  public let femaleRespect: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Female")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleOneOfUs")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleOneOfUs-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemale")
  public let femaleOneOfUs: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Female")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleSweetDreams")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleSweetDreams-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemale")
  public let femaleSweetDreams: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Female")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleDeath")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleDeath-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemale")
  public let femaleDeath: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-Female")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleSoul")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleSoul-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemale")
  public let femaleSoul: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  // Kevin asked for a Custom at the head of each voice's grab lines, "as for the executions" (conception-saisies, 4).
  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-MaleGrab")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-CustomMaleGrab")
  @runtimeProperty("ModSettings.description", "ExecutionLines-CustomMaleGrab-Description")
  public let customMaleGrab: Bool = false;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-MaleGrab")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleTicket")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleTicket-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMaleGrab")
  public let maleTicket: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-MaleGrab")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleLockedIn")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleLockedIn-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMaleGrab")
  public let maleLockedIn: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-MaleGrab")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleLetYouGo")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleLetYouGo-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMaleGrab")
  public let maleLetYouGo: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-MaleGrab")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleScars")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleScars-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMaleGrab")
  public let maleScars: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-MaleGrab")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-MaleSerious")
  @runtimeProperty("ModSettings.description", "ExecutionLines-MaleSerious-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customMaleGrab")
  public let maleSerious: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-FemaleGrab")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-CustomFemaleGrab")
  @runtimeProperty("ModSettings.description", "ExecutionLines-CustomFemaleGrab-Description")
  public let customFemaleGrab: Bool = false;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-FemaleGrab")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleTicket")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleTicket-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemaleGrab")
  public let femaleTicket: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-FemaleGrab")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleLockedIn")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleLockedIn-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemaleGrab")
  public let femaleLockedIn: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-FemaleGrab")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleLetYouGo")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleLetYouGo-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemaleGrab")
  public let femaleLetYouGo: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-FemaleGrab")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleScars")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleScars-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemaleGrab")
  public let femaleScars: ExecutionLinesChoice = ExecutionLinesChoice.Both;

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.category", "ExecutionLines-FemaleGrab")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-FemaleSerious")
  @runtimeProperty("ModSettings.description", "ExecutionLines-FemaleSerious-Description")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Choice-Both")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Choice-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Choice-Whisper")
  @runtimeProperty("ModSettings.displayValues.None", "ExecutionLines-Choice-None")
  @runtimeProperty("ModSettings.dependency", "customFemaleGrab")
  public let femaleSerious: ExecutionLinesChoice = ExecutionLinesChoice.Both;
}
