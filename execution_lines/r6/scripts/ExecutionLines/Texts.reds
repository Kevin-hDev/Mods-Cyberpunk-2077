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
    this.Text("ExecutionLines-Voice-Description", "Whose voice says the lines. Automatic: the voice of your V. Feminine or Masculine: always that voice, and the sections of that voice below (execution lines and grab lines) are the ones that count.");
    this.Text("ExecutionLines-Voice-Auto", "Automatic");
    this.Text("ExecutionLines-Voice-Female", "Feminine");
    this.Text("ExecutionLines-Voice-Male", "Masculine");
    this.Text("ExecutionLines-Chance", "Execution line frequency");
    this.Text("ExecutionLines-Chance-Description", "How often V says a line at an execution: 50 means exactly five times in every ten, in a random order. 100: every time. Kills and knock-outs count in the same ten.");
    this.Text("ExecutionLines-GrabChance", "Grab line frequency");
    this.Text("ExecutionLines-GrabChance-Description", "V can say a line while holding an enemy, a few seconds into the grab: 50 means exactly five times in every ten grabs that last that long, in a random order. 100: every time. 0: never. After a grab line, V says its closing line at the execution, whatever the frequency, once the grab line is over and as long as the execution follows soon after.");
    this.Text("ExecutionLines-Style", "Line style");
    this.Text("ExecutionLines-Style-Description", "How V says the lines, all of them: execution lines, grab lines and their closing lines. Normal: out loud. Whisper: V whispers them. Normal + Whisper: both, mixed at random. A Custom section can only narrow this down: a line is said only when both allow it. A closing line is said the way its grab line was.");
    this.Text("ExecutionLines-Style-Normal", "Normal");
    this.Text("ExecutionLines-Style-Whisper", "Whisper");
    this.Text("ExecutionLines-Style-Both", "Normal + Whisper");
    this.Text("ExecutionLines-Choice-Both", "Normal + Whisper");
    this.Text("ExecutionLines-Choice-Normal", "Normal");
    this.Text("ExecutionLines-Choice-Whisper", "Whisper");
    this.Text("ExecutionLines-Choice-None", "None");
    this.Text("ExecutionLines-NoAudioware", "Execution Lines: Audioware is not installed, V's lines cannot be heard. Install Audioware to hear them.");

    this.Text("ExecutionLines-Male", "Male V, execution lines");
    this.Text("ExecutionLines-CustomMale", "Custom");
    this.Text("ExecutionLines-CustomMale-Description", "Choose, line by line, how male V says each one: out loud, whispered, both or never. A line is said only when this choice and Line style both allow it. Off: only Line style counts, and the choices below are ignored, even if you changed them before. These choices count when the masculine voice speaks.");
    this.Text("ExecutionLines-MaleChooses", "A man chooses…");
    this.Text("ExecutionLines-MaleChooses-Description", "V says: \"A man chooses, a slave obeys.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-MaleInsanity", "Did I ever tell you…");
    this.Text("ExecutionLines-MaleInsanity-Description", "V says: \"Did I ever tell you what the definition of insanity is?\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-MaleImpunity", "Executed with impunity");
    this.Text("ExecutionLines-MaleImpunity-Description", "V says: \"Executed with impunity!\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-MaleExitLight", "Exit light, enter night");
    this.Text("ExecutionLines-MaleExitLight-Description", "V says: \"Exit light, enter night.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-MaleKillOrBeKilled", "In this world…");
    this.Text("ExecutionLines-MaleKillOrBeKilled-Description", "V says: \"In this world, it's kill or be killed.\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-MaleNotPersonal", "It's not personal…");
    this.Text("ExecutionLines-MaleNotPersonal-Description", "V says: \"It's not personal. You were just in my way.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-MaleOneOfUs", "One of us must die");
    this.Text("ExecutionLines-MaleOneOfUs-Description", "V says: \"One of us must die.\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-MaleSweetDreams", "Sweet dreams");
    this.Text("ExecutionLines-MaleSweetDreams-Description", "V says: \"Sweet dreams.\" Said only at a knock-out, never at a kill. As the closing line of \"I'm not locked in here…\", V says it whatever you choose here. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it at an execution. Line style must allow it too.");
    this.Text("ExecutionLines-MaleDeath", "Your death will be swift");
    this.Text("ExecutionLines-MaleDeath-Description", "V says: \"Your death will be swift.\" Said only at a kill, never at a knock-out. As the closing line of \"I'm not locked in here…\", V says it whatever you choose here. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it at an execution. Line style must allow it too.");
    this.Text("ExecutionLines-MaleSoul", "Your soul is weak");
    this.Text("ExecutionLines-MaleSoul-Description", "V says: \"Your soul is weak.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");

    this.Text("ExecutionLines-MaleGrab", "Male V, grab lines");
    this.Text("ExecutionLines-CustomMaleGrab", "Custom");
    this.Text("ExecutionLines-CustomMaleGrab-Description", "Choose, line by line, how male V says each grab line: out loud, whispered, both or never. A line is said only when this choice and Line style both allow it. Off: only Line style counts, and the choices below are ignored, even if you changed them before. These choices count when the masculine voice speaks. A closing line has no choice of its own: it is said the way its grab line was.");
    this.Text("ExecutionLines-MaleTicket", "A ticket to heaven…");
    this.Text("ExecutionLines-MaleTicket-Description", "While holding an enemy, V says: \"A ticket to heaven, or a lullaby?\" After a kill: \"See you up there.\" After a knock-out: \"Go to sleep!\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-MaleLockedIn", "I'm not locked in here…");
    this.Text("ExecutionLines-MaleLockedIn-Description", "While holding an enemy, V says: \"I'm not locked in here with you. You're locked in here with me.\" After a kill: \"Your death will be swift.\" After a knock-out: \"Sweet dreams.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-MaleLetYouGo", "Say my name…");
    this.Text("ExecutionLines-MaleLetYouGo-Description", "While holding an enemy, V says: \"Say my name and I'll let you go.\" After a kill: \"You had your chance.\" After a knock-out: \"You had your chance.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-MaleScars", "Wanna know how…");
    this.Text("ExecutionLines-MaleScars-Description", "While holding an enemy, V says: \"Wanna know how I got these scars?\" After a kill: \"Now you'll have your own.\" After a knock-out: \"Another time, maybe.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-MaleSerious", "Why so serious?");
    this.Text("ExecutionLines-MaleSerious-Description", "While holding an enemy, V says: \"Why so serious?\" After a kill: \"Let's put a smile on that face.\" After a knock-out: \"Let's put a smile on that face.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");

    this.Text("ExecutionLines-Female", "Female V, execution lines");
    this.Text("ExecutionLines-CustomFemale", "Custom");
    this.Text("ExecutionLines-CustomFemale-Description", "Choose, line by line, how female V says each one: out loud, whispered, both or never. A line is said only when this choice and Line style both allow it. Off: only Line style counts, and the choices below are ignored, even if you changed them before. These choices count when the feminine voice speaks.");
    this.Text("ExecutionLines-FemaleInsanity", "Did I ever tell you…");
    this.Text("ExecutionLines-FemaleInsanity-Description", "V says: \"Did I ever tell you what the definition of insanity is?\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleImpunity", "Executed with impunity");
    this.Text("ExecutionLines-FemaleImpunity-Description", "V says: \"Executed with impunity!\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleExitLight", "Exit light, enter night");
    this.Text("ExecutionLines-FemaleExitLight-Description", "V says: \"Exit light, enter night.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleKillOrBeKilled", "In this world…");
    this.Text("ExecutionLines-FemaleKillOrBeKilled-Description", "V says: \"In this world, it's kill or be killed.\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleNotPersonal", "It's not personal…");
    this.Text("ExecutionLines-FemaleNotPersonal-Description", "V says: \"It's not personal. You were just in my way.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleRespect", "Nothing is more badass…");
    this.Text("ExecutionLines-FemaleRespect-Description", "V says: \"Nothing is more badass than treating a woman with respect.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleOneOfUs", "One of us must die");
    this.Text("ExecutionLines-FemaleOneOfUs-Description", "V says: \"One of us must die.\" Said only at a kill, never at a knock-out. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleSweetDreams", "Sweet dreams");
    this.Text("ExecutionLines-FemaleSweetDreams-Description", "V says: \"Sweet dreams. And don't forget to dream of me.\" Said only at a knock-out, never at a kill. As the closing line of \"I'm not locked in here…\", V says it whatever you choose here. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it at an execution. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleDeath", "Your death will be swift");
    this.Text("ExecutionLines-FemaleDeath-Description", "V says: \"Your death will be swift.\" Said only at a kill, never at a knock-out. As the closing line of \"I'm not locked in here…\", V says it whatever you choose here. Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it at an execution. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleSoul", "Your soul is weak");
    this.Text("ExecutionLines-FemaleSoul-Description", "V says: \"Your soul is weak.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");

    this.Text("ExecutionLines-FemaleGrab", "Female V, grab lines");
    this.Text("ExecutionLines-CustomFemaleGrab", "Custom");
    this.Text("ExecutionLines-CustomFemaleGrab-Description", "Choose, line by line, how female V says each grab line: out loud, whispered, both or never. A line is said only when this choice and Line style both allow it. Off: only Line style counts, and the choices below are ignored, even if you changed them before. These choices count when the feminine voice speaks. A closing line has no choice of its own: it is said the way its grab line was.");
    this.Text("ExecutionLines-FemaleTicket", "A ticket to heaven…");
    this.Text("ExecutionLines-FemaleTicket-Description", "While holding an enemy, V says: \"A ticket to heaven, or a lullaby?\" After a kill: \"See you up there.\" After a knock-out: \"Go to sleep!\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleLockedIn", "I'm not locked in here…");
    this.Text("ExecutionLines-FemaleLockedIn-Description", "While holding an enemy, V says: \"I'm not locked in here with you. You're locked in here with me.\" After a kill: \"Your death will be swift.\" After a knock-out: \"Sweet dreams. And don't forget to dream of me.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleLetYouGo", "Say my name…");
    this.Text("ExecutionLines-FemaleLetYouGo-Description", "While holding an enemy, V says: \"Say my name and I'll let you go.\" After a kill: \"You had your chance.\" After a knock-out: \"You had your chance.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleScars", "Wanna know how…");
    this.Text("ExecutionLines-FemaleScars-Description", "While holding an enemy, V says: \"Wanna know how I got these scars?\" After a kill: \"Now you'll have your own.\" After a knock-out: \"Another time, maybe.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
    this.Text("ExecutionLines-FemaleSerious", "Why so serious?");
    this.Text("ExecutionLines-FemaleSerious-Description", "While holding an enemy, V says: \"Why so serious?\" After a kill: \"Let's put a smile on that face.\" After a knock-out: \"Let's put a smile on that face.\" Normal + Whisper: out loud or whispered, at random. Normal: out loud only. Whisper: whispered only. None: V never says it. Line style must allow it too.");
  }
}
