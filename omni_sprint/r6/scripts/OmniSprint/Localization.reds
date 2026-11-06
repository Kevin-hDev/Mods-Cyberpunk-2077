// Menu texts in English, French and Simplified Chinese (LocalizationChinese.reds), through Codeware's translation system.
// Everything here compiles only when Codeware is installed: without it, one unknown name would stop every
// redscript mod of the player from loading. Without Codeware the menu shows the keys instead.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class OmniSprintLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new OmniSprintFrench();
    }
    if Equals(language, n"zh-cn") {
      return new OmniSprintChinese();
    }
    return new OmniSprintEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class OmniSprintEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("OmniSprint-Enabled", "Sprint in every direction");
    this.Text("OmniSprint-Enabled-Description", "Also sideways, diagonally and backwards. Needs TweakXL.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class OmniSprintFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("OmniSprint-Enabled", "Sprint dans toutes les directions");
    this.Text("OmniSprint-Enabled-Description", "Aussi sur le côté, en diagonale et en arrière. Nécessite TweakXL.");
  }
}
