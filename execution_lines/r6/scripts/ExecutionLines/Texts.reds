// Menu texts in English, French (TextsFrench.reds) and Simplified Chinese (TextsChinese.reds), through Codeware's
// translation system. They compile only when Codeware is installed: without it, one unknown name would stop every
// redscript mod of the player from loading, and the menu shows the keys instead. The label of a phrase is its English
// words in every language, since that is what the player hears; only its help is translated.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class ExecutionLinesLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new ExecutionLinesFrench();
    }
    if Equals(language, n"zh-cn") {
      return new ExecutionLinesChinese();
    }
    return new ExecutionLinesEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ExecutionLinesEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ExecutionLines-Enabled", "Enabled");
    this.Text("ExecutionLines-Enabled-Description", "V says a line when V executes a person: a kill or a knock-out made by an execution, never by a shot. Requires Audioware, which plays the lines. Off: this mod says nothing.");
    this.Text("ExecutionLines-Voice", "Voice");
    this.Text("ExecutionLines-Voice-Description", "Whose voice says the lines. Automatic: the voice of your V. Feminine or Masculine: always that voice, and the Female V or Male V section below is the one that counts.");
    this.Text("ExecutionLines-Voice-Auto", "Automatic");
    this.Text("ExecutionLines-Voice-Female", "Feminine");
    this.Text("ExecutionLines-Voice-Male", "Masculine");
    this.Text("ExecutionLines-Chance", "Execution line frequency");
    this.Text("ExecutionLines-Chance-Description", "How often V says a line at an execution: 50 means exactly five times in every ten, in a random order. 100: every time. Kills and knock-outs count in the same ten.");
    this.Text("ExecutionLines-Style", "Execution line style");
    this.Text("ExecutionLines-Style-Description", "How V says the lines, all of them. Normal: out loud. Whisper: V whispers them. Normal + Whisper: both, mixed at random. A Custom section can only narrow this down: a line is said only when both allow it.");
    this.Text("ExecutionLines-Style-Normal", "Normal");
    this.Text("ExecutionLines-Style-Whisper", "Whisper");
    this.Text("ExecutionLines-Style-Both", "Normal + Whisper");
    this.Text("ExecutionLines-Choice-Both", "Normal + Whisper");
    this.Text("ExecutionLines-Choice-Normal", "Normal");
    this.Text("ExecutionLines-Choice-Whisper", "Whisper");
    this.Text("ExecutionLines-Choice-None", "None");
    this.Text("ExecutionLines-NoAudioware", "Execution Lines: Audioware is not installed, V's lines cannot be heard. Install Audioware to hear them.");

    this.Text("ExecutionLines-Male", "Male V");
    this.Text("ExecutionLines-CustomMale", "Custom");
    this.Text("ExecutionLines-CustomMale-Description", "Choose, line by line, how male V says each one: out loud, whispered, both or never. A line is said only when this choice and Execution line style both allow it. Off: only Execution line style counts, and the choices below are ignored, even if you changed them before. These choices count when the masculine voice speaks.");
    this.Text("ExecutionLines-MaleChooses", "A man chooses…");
    this.Text("ExecutionLines-MaleChooses-Description", "V says: \"A man chooses, a slave obeys.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
    this.Text("ExecutionLines-MaleInsanity", "Did I ever tell you…");
    this.Text("ExecutionLines-MaleInsanity-Description", "V says: \"Did I ever tell you what the definition of insanity is?\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
    this.Text("ExecutionLines-MaleImpunity", "Executed with impunity");
    this.Text("ExecutionLines-MaleImpunity-Description", "V says: \"Executed with impunity!\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
    this.Text("ExecutionLines-MaleKillOrBeKilled", "In this world…");
    this.Text("ExecutionLines-MaleKillOrBeKilled-Description", "V says: \"In this world, it's kill or be killed.\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
    this.Text("ExecutionLines-MaleOneOfUs", "One of us must die");
    this.Text("ExecutionLines-MaleOneOfUs-Description", "V says: \"One of us must die.\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
    this.Text("ExecutionLines-MaleDeath", "Your death will be swift");
    this.Text("ExecutionLines-MaleDeath-Description", "V says: \"Your death will be swift.\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
    this.Text("ExecutionLines-MaleSoul", "Your soul is weak");
    this.Text("ExecutionLines-MaleSoul-Description", "V says: \"Your soul is weak.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");

    this.Text("ExecutionLines-Female", "Female V");
    this.Text("ExecutionLines-CustomFemale", "Custom");
    this.Text("ExecutionLines-CustomFemale-Description", "Choose, line by line, how female V says each one: out loud, whispered, both or never. A line is said only when this choice and Execution line style both allow it. Off: only Execution line style counts, and the choices below are ignored, even if you changed them before. These choices count when the feminine voice speaks.");
    this.Text("ExecutionLines-FemaleInsanity", "Did I ever tell you…");
    this.Text("ExecutionLines-FemaleInsanity-Description", "V says: \"Did I ever tell you what the definition of insanity is?\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
    this.Text("ExecutionLines-FemaleImpunity", "Executed with impunity");
    this.Text("ExecutionLines-FemaleImpunity-Description", "V says: \"Executed with impunity!\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
    this.Text("ExecutionLines-FemaleKillOrBeKilled", "In this world…");
    this.Text("ExecutionLines-FemaleKillOrBeKilled-Description", "V says: \"In this world, it's kill or be killed.\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
    this.Text("ExecutionLines-FemaleRespect", "Nothing is more badass…");
    this.Text("ExecutionLines-FemaleRespect-Description", "V says: \"Nothing is more badass than treating a woman with respect.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
    this.Text("ExecutionLines-FemaleOneOfUs", "One of us must die");
    this.Text("ExecutionLines-FemaleOneOfUs-Description", "V says: \"One of us must die.\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
    this.Text("ExecutionLines-FemaleDeath", "Your death will be swift");
    this.Text("ExecutionLines-FemaleDeath-Description", "V says: \"Your death will be swift.\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
    this.Text("ExecutionLines-FemaleSoul", "Your soul is weak");
    this.Text("ExecutionLines-FemaleSoul-Description", "V says: \"Your soul is weak.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Execution line style must allow it too.");
  }
}
