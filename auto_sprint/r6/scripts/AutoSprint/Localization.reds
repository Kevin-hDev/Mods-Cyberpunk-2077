// Menu texts in English, French and Simplified Chinese (LocalizationChinese.reds), through Codeware's translation system.
// Everything here compiles only when Codeware is installed: without it, one unknown name would stop every
// redscript mod of the player from loading. Without Codeware the menu shows the keys instead.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class AutoSprintLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new AutoSprintFrench();
    }
    if Equals(language, n"zh-cn") {
      return new AutoSprintChinese();
    }
    return new AutoSprintEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class AutoSprintEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("AutoSprint-Enabled", "Auto sprint");
    this.Text("AutoSprint-Enabled-Description", "V sprints on their own when moving forward. Crouching or the slow walk stops the sprint.");
    this.Text("AutoSprint-Speed", "Sprint speed");
    this.Text("AutoSprint-Speed-Description", "Multiplies the speed of the standing sprint, automatic or not. 1.0 is the game's speed. Above 2.0 needs TweakXL.");
    this.Text("AutoSprint-WalkSpeed", "Walk speed");
    this.Text("AutoSprint-WalkSpeed-Description", "Multiplies V's speed when moving upright without sprinting, automatic sprint or not. The slow walk keeps the game's speed. 1.0 is the game's speed. Above 4.0 needs TweakXL.");
    this.Text("AutoSprint-StepUp", "Step up curbs");
    this.Text("AutoSprint-StepUp-Description", "V steps onto curbs and low steps, up to 60 cm, while walking or running, instead of stopping against them.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class AutoSprintFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("AutoSprint-Enabled", "Sprint automatique");
    this.Text("AutoSprint-Enabled-Description", "Le sprint part tout seul quand V avance. S'accroupir ou la marche lente arrête le sprint.");
    this.Text("AutoSprint-Speed", "Vitesse du sprint");
    this.Text("AutoSprint-Speed-Description", "Multiplie la vitesse du sprint debout, automatique ou non. 1.0 est la vitesse du jeu. Au-delà de 2.0, nécessite TweakXL.");
    this.Text("AutoSprint-WalkSpeed", "Vitesse de marche");
    this.Text("AutoSprint-WalkSpeed-Description", "Multiplie la vitesse de V debout, hors sprint, sprint automatique ou non. La marche lente garde la vitesse du jeu. 1.0 est la vitesse du jeu. Au-delà de 4.0, nécessite TweakXL.");
    this.Text("AutoSprint-StepUp", "Monter les trottoirs");
    this.Text("AutoSprint-StepUp-Description", "V monte sur les trottoirs et les petites marches, jusqu'à 60 cm, en marchant ou en courant, au lieu de s'arrêter contre.");
  }
}
