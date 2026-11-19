// The player's settings, shown by Mod Settings in Options > Mods when it is installed; without it the fields keep the
// values written here. Mod Settings keeps a choice under the name of its field and of its enum member: a name is never
// changed once a version is published, and a phrase added later gets a field of its own.
//
// The menu is the one Kevin chose on drawings on 19 November 2026: a "Custom" switch at the head of each voice's
// section, not one for both, because Mod Settings keeps a section's title on the page even when all its lines are
// hidden. The phrases of a section hide behind its own Custom, the one condition Mod Settings takes per line, so none
// depends on Enabled: the lines above would hide with it and the phrases would stand alone on the page, mod off.
// Male V is section 1 and Female V section 2, below the four lines that have no section. The voice that speaks
// decides which section is read (ExecutionLinesChoiceOf, SettingsChoice.reds).

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

  @runtimeProperty("ModSettings.mod", "Execution Lines")
  @runtimeProperty("ModSettings.displayName", "ExecutionLines-Style")
  @runtimeProperty("ModSettings.description", "ExecutionLines-Style-Description")
  @runtimeProperty("ModSettings.displayValues.Normal", "ExecutionLines-Style-Normal")
  @runtimeProperty("ModSettings.displayValues.Whisper", "ExecutionLines-Style-Whisper")
  @runtimeProperty("ModSettings.displayValues.Both", "ExecutionLines-Style-Both")
  public let style: ExecutionLinesStyle = ExecutionLinesStyle.Both;

  // Off: only Execution line style counts, and the choices below are ignored even if they were changed before.
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
}
