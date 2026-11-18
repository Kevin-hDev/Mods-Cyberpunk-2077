// Texts of the impact effect settings (impactEffect, impactKind in Settings.reds; Impact.reds) in English, French and
// Simplified Chinese, through Codeware's translation system as in Localization.reds, with a provider of their own:
// added there, they would take that file past its length.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleImpactLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new ApexGrappleImpactFrench();
    }
    if Equals(language, n"zh-cn") {
      return new ApexGrappleImpactChinese();
    }
    return new ApexGrappleImpactEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleImpactEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-ImpactEffect", "Impact effect");
    this.Text("ApexGrapple-ImpactEffect-Description", "Shows one of the game's impact effects where the hook bites into a surface or a vehicle. Never on a person.");
    this.Text("ApexGrapple-ImpactKind", "Impact effect type");
    this.Text("ApexGrapple-ImpactKind-Description", "The game's impact effect shown where the hook bites, while Impact effect is on.");
    this.Text("ApexGrapple-ImpactKind-ConcreteBullet", "Bullet on concrete");
    this.Text("ApexGrapple-ImpactKind-ConcreteLargeCalibre", "Large calibre on concrete");
    this.Text("ApexGrapple-ImpactKind-ConcreteHammer", "Hammer on concrete");
    this.Text("ApexGrapple-ImpactKind-MetalHammer", "Hammer on metal");
    this.Text("ApexGrapple-ImpactKind-Monowire", "Monowire impact");
    this.Text("ApexGrapple-ImpactKind-DefaultBullet", "Bullet impact");
    this.Text("ApexGrapple-ImpactLost", "Apex Grapple: the hook impact effect is off, because a game file it uses is missing. It needs an update of the mod for this version of the game. Your save is not affected.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleImpactFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-ImpactEffect", "Effet d'impact");
    this.Text("ApexGrapple-ImpactEffect-Description", "Affiche un des effets d'impact du jeu là où le crochet mord une surface ou un véhicule. Jamais sur une personne.");
    this.Text("ApexGrapple-ImpactKind", "Type d'effet d'impact");
    this.Text("ApexGrapple-ImpactKind-Description", "L'effet d'impact du jeu affiché là où le crochet mord, quand Effet d'impact est allumé.");
    this.Text("ApexGrapple-ImpactKind-ConcreteBullet", "Balle sur du béton");
    this.Text("ApexGrapple-ImpactKind-ConcreteLargeCalibre", "Gros calibre sur du béton");
    this.Text("ApexGrapple-ImpactKind-ConcreteHammer", "Marteau sur du béton");
    this.Text("ApexGrapple-ImpactKind-MetalHammer", "Marteau sur du métal");
    this.Text("ApexGrapple-ImpactKind-Monowire", "Impact du monofil");
    this.Text("ApexGrapple-ImpactKind-DefaultBullet", "Impact de balle");
    this.Text("ApexGrapple-ImpactLost", "Apex Grapple : l'effet d'impact du crochet est coupé, car un fichier du jeu qu'il utilise manque. Il attend une mise à jour du mod pour cette version du jeu. Votre partie n'est pas touchée.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleImpactChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-ImpactEffect", "命中特效");
    this.Text("ApexGrapple-ImpactEffect-Description", "在钩爪钩住表面或载具的位置显示游戏中的一种命中特效。不会出现在人物身上。");
    this.Text("ApexGrapple-ImpactKind", "命中特效类型");
    this.Text("ApexGrapple-ImpactKind-Description", "开启“命中特效”时，在钩爪钩住的位置显示的游戏命中特效。");
    this.Text("ApexGrapple-ImpactKind-ConcreteBullet", "子弹击中混凝土");
    this.Text("ApexGrapple-ImpactKind-ConcreteLargeCalibre", "大口径击中混凝土");
    this.Text("ApexGrapple-ImpactKind-ConcreteHammer", "重锤击中混凝土");
    this.Text("ApexGrapple-ImpactKind-MetalHammer", "重锤击中金属");
    this.Text("ApexGrapple-ImpactKind-Monowire", "单分子线命中");
    this.Text("ApexGrapple-ImpactKind-DefaultBullet", "子弹命中");
    this.Text("ApexGrapple-ImpactLost", "Apex Grapple：钩爪命中特效已关闭，因为它使用的一个游戏文件缺失。需要为此游戏版本更新本模组。你的存档不受影响。");
  }
}
