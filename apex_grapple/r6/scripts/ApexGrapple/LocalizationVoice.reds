// Texts of V's voice lines settings (voiceLines, voiceGender, voicePullChance, voiceKillChance, voiceKillStyle in
// Settings.reds; Voice.reds) in English, French and Simplified Chinese, through Codeware's translation system as in
// Localization.reds, with a provider of their own as the impact effect's (LocalizationImpact.reds). The voice lines'
// wording is Cyber Grapple's, so that the two mods say the same.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleVoiceLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new ApexGrappleVoiceFrench();
    }
    if Equals(language, n"zh-cn") {
      return new ApexGrappleVoiceChinese();
    }
    return new ApexGrappleVoiceEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleVoiceEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-VoiceLines", "Voice lines");
    this.Text("ApexGrapple-VoiceLines-Description", "V says a line when the grapple starts pulling a person toward V, and another when V kills or knocks out a person the grapple brought and grabbed. Requires Audioware, which plays the lines. Off: V says nothing.");
    this.Text("ApexGrapple-VoiceGender", "Voice");
    this.Text("ApexGrapple-VoiceGender-Description", "Whose voice says the lines, while Voice lines is on. Automatic: the voice of your V. Feminine or Masculine: always that voice.");
    this.Text("ApexGrapple-VoiceGender-Auto", "Automatic");
    this.Text("ApexGrapple-VoiceGender-Female", "Feminine");
    this.Text("ApexGrapple-VoiceGender-Male", "Masculine");
    this.Text("ApexGrapple-VoicePullChance", "Get over here chance");
    this.Text("ApexGrapple-VoicePullChance-Description", "How often V says \"Get over here\" when the grapple starts pulling a person toward V, while Voice lines is on: 50 means exactly five times in every ten, in a random order. 100: every time.");
    this.Text("ApexGrapple-VoiceKillChance", "Execution line chance");
    this.Text("ApexGrapple-VoiceKillChance-Description", "How often V says a line when V kills or knocks out a person the grapple brought and grabbed, while Voice lines is on: 50 means exactly five times in every ten, in a random order. 100: every time.");
    this.Text("ApexGrapple-VoiceKillStyle", "Execution lines");
    this.Text("ApexGrapple-VoiceKillStyle-Description", "How V says the execution lines, while Voice lines is on. Normal: out loud. Whisper: V whispers them. Normal + Whisper: both, mixed at random.");
    this.Text("ApexGrapple-VoiceKillStyle-Normal", "Normal");
    this.Text("ApexGrapple-VoiceKillStyle-Whisper", "Whisper");
    this.Text("ApexGrapple-VoiceKillStyle-Both", "Normal + Whisper");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleVoiceFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-VoiceLines", "Répliques");
    this.Text("ApexGrapple-VoiceLines-Description", "V dit une réplique quand le grappin commence à tirer une personne vers V, et une autre quand V tue ou neutralise sans tuer une personne que le grappin a ramenée et saisie. Demande Audioware, qui joue les répliques. Éteint : V ne dit rien.");
    this.Text("ApexGrapple-VoiceGender", "Voix");
    this.Text("ApexGrapple-VoiceGender-Description", "La voix qui dit les répliques, quand Répliques est allumé. Automatique : celle de votre V. Féminine ou Masculine : toujours cette voix.");
    this.Text("ApexGrapple-VoiceGender-Auto", "Automatique");
    this.Text("ApexGrapple-VoiceGender-Female", "Féminine");
    this.Text("ApexGrapple-VoiceGender-Male", "Masculine");
    this.Text("ApexGrapple-VoicePullChance", "Fréquence de « Get over here »");
    this.Text("ApexGrapple-VoicePullChance-Description", "À quelle fréquence V dit « Get over here » quand le grappin commence à tirer une personne vers V, quand Répliques est allumé : 50, c'est exactement cinq fois sur dix, dans un ordre au hasard. 100 : à chaque fois.");
    this.Text("ApexGrapple-VoiceKillChance", "Fréquence des répliques d'exécution");
    this.Text("ApexGrapple-VoiceKillChance-Description", "À quelle fréquence V dit une réplique quand V tue ou neutralise sans tuer une personne que le grappin a ramenée et saisie, quand Répliques est allumé : 50, c'est exactement cinq fois sur dix, dans un ordre au hasard. 100 : à chaque fois.");
    this.Text("ApexGrapple-VoiceKillStyle", "Répliques d'exécution");
    this.Text("ApexGrapple-VoiceKillStyle-Description", "La façon dont V dit les répliques d'exécution, quand Répliques est allumé. Normal : à voix haute. Chuchoté : V les chuchote. Normal + chuchoté : les deux, mêlées au hasard.");
    this.Text("ApexGrapple-VoiceKillStyle-Normal", "Normal");
    this.Text("ApexGrapple-VoiceKillStyle-Whisper", "Chuchoté");
    this.Text("ApexGrapple-VoiceKillStyle-Both", "Normal + chuchoté");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleVoiceChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-VoiceLines", "台词");
    this.Text("ApexGrapple-VoiceLines-Description", "抓钩开始将人物拉向 V 时，V 会说一句台词；V 杀死或非致命击倒被抓钩拉来并钳制的人物时，会再说一句。需要 Audioware 来播放台词。关闭：V 什么也不说。");
    this.Text("ApexGrapple-VoiceGender", "声调");
    this.Text("ApexGrapple-VoiceGender-Description", "开启“台词”时说台词的声音。自动：你的 V 的声音。女性化或男性化：始终使用该声音。");
    this.Text("ApexGrapple-VoiceGender-Auto", "自动");
    this.Text("ApexGrapple-VoiceGender-Female", "女性化");
    this.Text("ApexGrapple-VoiceGender-Male", "男性化");
    this.Text("ApexGrapple-VoicePullChance", "“Get over here”几率");
    this.Text("ApexGrapple-VoicePullChance-Description", "抓钩开始将人物拉向 V 时，V 说“Get over here”的几率，开启“台词”时生效：50 表示每十次中恰好五次，顺序随机。100：每次都说。");
    this.Text("ApexGrapple-VoiceKillChance", "处决台词几率");
    this.Text("ApexGrapple-VoiceKillChance-Description", "V 杀死或非致命击倒被抓钩拉来并钳制的人物时说台词的几率，开启“台词”时生效：50 表示每十次中恰好五次，顺序随机。100：每次都说。");
    this.Text("ApexGrapple-VoiceKillStyle", "处决台词");
    this.Text("ApexGrapple-VoiceKillStyle-Description", "开启“台词”时 V 说处决台词的方式。正常：大声说出。耳语：V 低声耳语。正常 + 耳语：两者随机混合。");
    this.Text("ApexGrapple-VoiceKillStyle-Normal", "正常");
    this.Text("ApexGrapple-VoiceKillStyle-Whisper", "耳语");
    this.Text("ApexGrapple-VoiceKillStyle-Both", "正常 + 耳语");
  }
}
