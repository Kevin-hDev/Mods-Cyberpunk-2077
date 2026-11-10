// Texts of the field of view settings (Settings.reds, FovFrame.reds) in English, French and Simplified Chinese, through
// Codeware's translation system as in Localization.reds, with a provider of their own: added there, they would take
// that file past its length. "Field of View" is the game's own name for its setting in each language (onscreens.json,
// 2.5: UI-Settings-Video-Basic-FieldOfView).

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleFovLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new ApexGrappleFovFrench();
    }
    if Equals(language, n"zh-cn") {
      return new ApexGrappleFovChinese();
    }
    return new ApexGrappleFovEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleFovEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-DynamicFov", "Dynamic Field of View");
    this.Text("ApexGrapple-DynamicFov-Description", "While the rope pulls V, the field of view widens, then comes back when the pull stops. First person only, and not while aiming a weapon. Off: the field of view stays as set in the game's settings.");
    this.Text("ApexGrapple-FovWidening", "Field of View widening");
    this.Text("ApexGrapple-FovWidening-Description", "Added to the game's Field of View setting, in the same degrees: 10 makes 100 into 110. The total stops at 140.");
    this.Text("ApexGrapple-FovTransition", "Field of View transition");
    this.Text("ApexGrapple-FovTransition-Description", "In seconds: the time the field of view takes to widen when the pull starts, and to come back when it stops.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleFovFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-DynamicFov", "Champ de vision dynamique");
    this.Text("ApexGrapple-DynamicFov-Description", "Pendant que la corde tire V, le champ de vision s'élargit, puis revient quand la traction s'arrête. En première personne seulement, et pas pendant la visée avec une arme. Éteint : le champ de vision reste celui des options du jeu.");
    this.Text("ApexGrapple-FovWidening", "Élargissement du champ de vision");
    this.Text("ApexGrapple-FovWidening-Description", "Ajouté au réglage Champ de vision du jeu, dans les mêmes degrés : 10 fait passer 100 à 110. Le total s'arrête à 140.");
    this.Text("ApexGrapple-FovTransition", "Transition du champ de vision");
    this.Text("ApexGrapple-FovTransition-Description", "En secondes : le temps que met le champ de vision à s'élargir quand la traction commence, et à revenir quand elle s'arrête.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleFovChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-DynamicFov", "动态视野");
    this.Text("ApexGrapple-DynamicFov-Description", "绳索牵引 V 时，视野会变宽，牵引停止后恢复。仅限第一人称，用武器瞄准时不生效。关闭：视野保持游戏设置中的数值。");
    this.Text("ApexGrapple-FovWidening", "视野扩大");
    this.Text("ApexGrapple-FovWidening-Description", "加在游戏的“视野”设置之上，单位相同：10 会让 100 变为 110。总和最高为 140。");
    this.Text("ApexGrapple-FovTransition", "视野过渡时间");
    this.Text("ApexGrapple-FovTransition-Description", "单位为秒：牵引开始时视野变宽、牵引停止时视野恢复所需的时间。");
  }
}
