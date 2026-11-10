// Texts of the crosshair settings (CrosshairSettings.reds) in English, French and Simplified Chinese, through
// Codeware's translation system as in Localization.reds, with a provider of their own: added there, they would take
// that file past its length. Codeware merges the texts of every provider (Codeware.Localization.reds, RegisterProvider).
// Names of weapons, colours and settings are the game's own, read in its onscreens.json of each language (2.5).

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleCrosshairLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new ApexGrappleCrosshairFrench();
    }
    if Equals(language, n"zh-cn") {
      return new ApexGrappleCrosshairChinese();
    }
    return new ApexGrappleCrosshairEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleCrosshairEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-Crosshair", "Crosshair for empty hands and Fists");
    this.Text("ApexGrapple-CrosshairShape", "Crosshair");
    this.Text("ApexGrapple-CrosshairShape-Description", "A crosshair at the centre of the screen while V's hands are empty or V fights with Fists, to aim the grapple whenever it can fire. Hidden as soon as V holds a weapon or arm cyberware, which have crosshairs of their own, and in vehicles, with the scanner and in scenes. Off: no crosshair.");
    this.Text("ApexGrapple-CrosshairShape-Off", "Off");
    this.Text("ApexGrapple-CrosshairShape-Simple", "Simple");
    this.Text("ApexGrapple-CrosshairShape-Basic", "Basic");
    this.Text("ApexGrapple-CrosshairShape-Shotgun", "Shotgun");
    this.Text("ApexGrapple-CrosshairShape-SmartRifle", "Smart");
    this.Text("ApexGrapple-CrosshairShape-TechCircle", "Tech, round");
    this.Text("ApexGrapple-CrosshairShape-TechHex", "Tech, hexagonal");
    this.Text("ApexGrapple-CrosshairShape-Launcher", "Projectile Launch System");
    this.Text("ApexGrapple-CrosshairShape-MantisBlades", "Mantis Blades");
    this.Text("ApexGrapple-CrosshairShape-HeavyMachineGun", "Heavy Machine Gun");
    this.Text("ApexGrapple-CrosshairShape-Dot", "Center of screen dot");
    this.Text("ApexGrapple-CrosshairColor", "Colour");
    this.Text("ApexGrapple-CrosshairColor-Description", "The crosshair's colour. Turquoise is the colour of the game's crosshairs.");
    this.Text("ApexGrapple-CrosshairColor-Yellow", "Yellow");
    this.Text("ApexGrapple-CrosshairColor-White", "White");
    this.Text("ApexGrapple-CrosshairColor-Red", "Red");
    this.Text("ApexGrapple-CrosshairColor-Green", "Green");
    this.Text("ApexGrapple-CrosshairColor-Turquoise", "Turquoise (the game's)");
    this.Text("ApexGrapple-CrosshairSize", "Size");
    this.Text("ApexGrapple-CrosshairSize-Description", "The crosshair's size, in per cent of the game's.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleCrosshairFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-Crosshair", "Réticule mains vides et Poings");
    this.Text("ApexGrapple-CrosshairShape", "Réticule");
    this.Text("ApexGrapple-CrosshairShape-Description", "Un réticule au centre de l'écran tant que V a les mains vides ou se bat avec les Poings, pour viser avec le grappin quand il peut tirer. Caché dès que V tient une arme ou du matériel cybernétique des bras, qui ont leur propre réticule, ainsi qu'en véhicule, avec le scanner et pendant les scènes. Désactivé : aucun réticule.");
    this.Text("ApexGrapple-CrosshairShape-Off", "Désactivé");
    this.Text("ApexGrapple-CrosshairShape-Simple", "Simple");
    this.Text("ApexGrapple-CrosshairShape-Basic", "De base");
    this.Text("ApexGrapple-CrosshairShape-Shotgun", "Fusil à pompe");
    this.Text("ApexGrapple-CrosshairShape-SmartRifle", "Intelligent");
    this.Text("ApexGrapple-CrosshairShape-TechCircle", "Technique, rond");
    this.Text("ApexGrapple-CrosshairShape-TechHex", "Technique, hexagonal");
    this.Text("ApexGrapple-CrosshairShape-Launcher", "Lance-projectile");
    this.Text("ApexGrapple-CrosshairShape-MantisBlades", "Lames Mantis");
    this.Text("ApexGrapple-CrosshairShape-HeavyMachineGun", "Mitrailleuse lourde");
    this.Text("ApexGrapple-CrosshairShape-Dot", "Point au milieu de l'écran");
    this.Text("ApexGrapple-CrosshairColor", "Couleur");
    this.Text("ApexGrapple-CrosshairColor-Description", "La couleur du réticule. Le turquoise est celle des réticules du jeu.");
    this.Text("ApexGrapple-CrosshairColor-Yellow", "Jaune");
    this.Text("ApexGrapple-CrosshairColor-White", "Blanc");
    this.Text("ApexGrapple-CrosshairColor-Red", "Rouge");
    this.Text("ApexGrapple-CrosshairColor-Green", "Vert");
    this.Text("ApexGrapple-CrosshairColor-Turquoise", "Turquoise (celle du jeu)");
    this.Text("ApexGrapple-CrosshairSize", "Taille");
    this.Text("ApexGrapple-CrosshairSize-Description", "La taille du réticule, en pour cent de celle du jeu.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleCrosshairChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-Crosshair", "空手与徒手时的准星");
    this.Text("ApexGrapple-CrosshairShape", "准星");
    this.Text("ApexGrapple-CrosshairShape-Description", "V 空手或使用徒手战斗时，在画面正中显示准星，用于在抓钩可以发射时瞄准。V 手持武器或手臂义体时隐藏（它们有自己的准星），在载具中、使用扫描器时和过场中也隐藏。关：不显示准星。");
    this.Text("ApexGrapple-CrosshairShape-Off", "关");
    this.Text("ApexGrapple-CrosshairShape-Simple", "简单");
    this.Text("ApexGrapple-CrosshairShape-Basic", "基础");
    this.Text("ApexGrapple-CrosshairShape-Shotgun", "霰弹枪");
    this.Text("ApexGrapple-CrosshairShape-SmartRifle", "智能");
    this.Text("ApexGrapple-CrosshairShape-TechCircle", "技术（圆形）");
    this.Text("ApexGrapple-CrosshairShape-TechHex", "技术（六边形）");
    this.Text("ApexGrapple-CrosshairShape-Launcher", "射弹发射系统");
    this.Text("ApexGrapple-CrosshairShape-MantisBlades", "螳螂刀");
    this.Text("ApexGrapple-CrosshairShape-HeavyMachineGun", "重机枪");
    this.Text("ApexGrapple-CrosshairShape-Dot", "画面正中圆点");
    this.Text("ApexGrapple-CrosshairColor", "颜色");
    this.Text("ApexGrapple-CrosshairColor-Description", "准星的颜色。青色是游戏准星的颜色。");
    this.Text("ApexGrapple-CrosshairColor-Yellow", "黄色");
    this.Text("ApexGrapple-CrosshairColor-White", "白色");
    this.Text("ApexGrapple-CrosshairColor-Red", "红色");
    this.Text("ApexGrapple-CrosshairColor-Green", "绿色");
    this.Text("ApexGrapple-CrosshairColor-Turquoise", "青色（游戏原色）");
    this.Text("ApexGrapple-CrosshairSize", "大小");
    this.Text("ApexGrapple-CrosshairSize-Description", "准星的大小，以游戏准星的百分比计。");
  }
}
