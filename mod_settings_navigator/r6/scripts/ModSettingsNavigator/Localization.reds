// Menu texts in English, French and Simplified Chinese (LocalizationChinese.reds), through Codeware's translation system.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class ModSettingsNavigatorLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new ModSettingsNavigatorFrench();
    }
    if Equals(language, n"zh-cn") {
      return new ModSettingsNavigatorChinese();
    }
    return new ModSettingsNavigatorEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ModSettingsNavigatorEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ModSettingsNavigator-Sections", "Collapsible sections");
    this.Text("ModSettingsNavigator-Sections-Description", "Click a section title, or select it and press the confirm button on a controller, to fold or unfold it. Folded sections stay folded until the game closes.");
    this.Text("ModSettingsNavigator-Position", "Reopen where you left off");
    this.Text("ModSettingsNavigator-Position-Description", "Mod Settings reopens on the mod and the line you were on. Forgotten when a save is loaded and when the game restarts.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ModSettingsNavigatorFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ModSettingsNavigator-Sections", "Sections repliables");
    this.Text("ModSettingsNavigator-Sections-Description", "Clique sur le titre d'une section, ou sélectionne-le et appuie sur le bouton de validation à la manette, pour la replier ou la déplier. Les sections repliées le restent jusqu'à la fermeture du jeu.");
    this.Text("ModSettingsNavigator-Position", "Rouvrir là où tu étais");
    this.Text("ModSettingsNavigator-Position-Description", "Mod Settings se rouvre sur le mod et la ligne où tu étais. Oublié au chargement d'une partie et au redémarrage du jeu.");
  }
}
