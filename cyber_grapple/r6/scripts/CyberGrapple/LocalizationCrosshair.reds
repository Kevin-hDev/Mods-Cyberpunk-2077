// Made by fabrique/grapple.py from Apex Grapple's LocalizationCrosshair.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Texts of the crosshair settings (CrosshairSettings.reds) in English, French and Simplified Chinese, through
// Codeware's translation system as in Localization.reds, with a provider of their own: added there, they would take
// that file past its length. Codeware merges the texts of every provider (Codeware.Localization.reds, RegisterProvider).
// Names of weapons, colours and settings are the game's own, read in its onscreens.json of each language (2.5).

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleCrosshairLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new CyberGrappleCrosshairFrench();
    }
    if Equals(language, n"zh-cn") {
      return new CyberGrappleCrosshairChinese();
    }
    let other: ref<ModLocalizationPackage> = CyberGrappleTextsIn(language);
    if IsDefined(other) {
      return other;
    }
    return new CyberGrappleCrosshairEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleCrosshairEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Crosshair", "Crosshair for empty hands and Fists");
    this.Text("CyberGrapple-CrosshairShape-Simple", "Simple");
    this.Text("CyberGrapple-CrosshairShape-Basic", "Basic");
    this.Text("CyberGrapple-CrosshairShape-Shotgun", "Shotgun");
    this.Text("CyberGrapple-CrosshairShape-SmartRifle", "Smart");
    this.Text("CyberGrapple-CrosshairShape-TechCircle", "Tech, round");
    this.Text("CyberGrapple-CrosshairShape-TechHex", "Tech, hexagonal");
    this.Text("CyberGrapple-CrosshairShape-Launcher", "Projectile Launch System");
    this.Text("CyberGrapple-CrosshairShape-MantisBlades", "Mantis Blades");
    this.Text("CyberGrapple-CrosshairShape-HeavyMachineGun", "Heavy Machine Gun");
    this.Text("CyberGrapple-CrosshairShape-Dot", "Center of screen dot");
    this.Text("CyberGrapple-CrosshairColor", "Colour");
    this.Text("CyberGrapple-CrosshairColor-Description", "The crosshair's colour. Turquoise is the colour of the game's crosshairs.");
    this.Text("CyberGrapple-CrosshairColor-Yellow", "Yellow");
    this.Text("CyberGrapple-CrosshairColor-White", "White");
    this.Text("CyberGrapple-CrosshairColor-Red", "Red");
    this.Text("CyberGrapple-CrosshairColor-Green", "Green");
    this.Text("CyberGrapple-CrosshairColor-Turquoise", "Turquoise (the game's)");
    this.Text("CyberGrapple-CrosshairSize", "Size");
    this.Text("CyberGrapple-CrosshairSize-Description", "The crosshair's size, in per cent of the game's.");
    this.Text("CyberGrapple-CrosshairRange", "Range indicator");
    this.Text("CyberGrapple-CrosshairRange-Description", "The crosshair takes the out of range colour while a press would not fire the grapple: no charge is left, the implant is not in the Combat Gadget quickslot (with Own key off), nothing is within range, the sky, a person or a vehicle in the way that the implant's Tier cannot take yet, a person or a motorcycle beyond the distance they can be pulled from, someone within quick melee range, or the grapple still out.");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor", "Out of range colour");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor-Description", "The crosshair's colour while the grapple would not fire. Pick one other than the crosshair's colour: with the same colour, the indicator is off.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleCrosshairFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Crosshair", "Réticule mains vides et Poings");
    this.Text("CyberGrapple-CrosshairShape-Simple", "Simple");
    this.Text("CyberGrapple-CrosshairShape-Basic", "De base");
    this.Text("CyberGrapple-CrosshairShape-Shotgun", "Fusil à pompe");
    this.Text("CyberGrapple-CrosshairShape-SmartRifle", "Intelligent");
    this.Text("CyberGrapple-CrosshairShape-TechCircle", "Technique, rond");
    this.Text("CyberGrapple-CrosshairShape-TechHex", "Technique, hexagonal");
    this.Text("CyberGrapple-CrosshairShape-Launcher", "Lance-projectile");
    this.Text("CyberGrapple-CrosshairShape-MantisBlades", "Lames Mantis");
    this.Text("CyberGrapple-CrosshairShape-HeavyMachineGun", "Mitrailleuse lourde");
    this.Text("CyberGrapple-CrosshairShape-Dot", "Point au milieu de l'écran");
    this.Text("CyberGrapple-CrosshairColor", "Couleur");
    this.Text("CyberGrapple-CrosshairColor-Description", "La couleur du réticule. Le turquoise est celle des réticules du jeu.");
    this.Text("CyberGrapple-CrosshairColor-Yellow", "Jaune");
    this.Text("CyberGrapple-CrosshairColor-White", "Blanc");
    this.Text("CyberGrapple-CrosshairColor-Red", "Rouge");
    this.Text("CyberGrapple-CrosshairColor-Green", "Vert");
    this.Text("CyberGrapple-CrosshairColor-Turquoise", "Turquoise (celle du jeu)");
    this.Text("CyberGrapple-CrosshairSize", "Taille");
    this.Text("CyberGrapple-CrosshairSize-Description", "La taille du réticule, en pour cent de celle du jeu.");
    this.Text("CyberGrapple-CrosshairRange", "Indicateur de portée");
    this.Text("CyberGrapple-CrosshairRange-Description", "Le réticule prend la couleur hors de portée quand un appui ne lancerait pas le grappin : plus aucune charge, l'implant n'est pas dans l'emplacement rapide de gadget de combat (« Touche à part » éteinte), rien à portée, le ciel, une personne ou un véhicule devant que le Niveau de l'implant ne peut pas encore prendre, une personne ou une moto au-delà de la distance d'où on peut la tirer, quelqu'un à portée du coup rapide, ou le grappin encore sorti.");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor", "Couleur hors de portée");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor-Description", "La couleur du réticule quand le grappin ne partirait pas. À choisir différente de celle du réticule : avec la même couleur, l'indicateur est éteint.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleCrosshairChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Crosshair", "空手与徒手时的准星");
    this.Text("CyberGrapple-CrosshairShape-Simple", "简单");
    this.Text("CyberGrapple-CrosshairShape-Basic", "基础");
    this.Text("CyberGrapple-CrosshairShape-Shotgun", "霰弹枪");
    this.Text("CyberGrapple-CrosshairShape-SmartRifle", "智能");
    this.Text("CyberGrapple-CrosshairShape-TechCircle", "技术（圆形）");
    this.Text("CyberGrapple-CrosshairShape-TechHex", "技术（六边形）");
    this.Text("CyberGrapple-CrosshairShape-Launcher", "射弹发射系统");
    this.Text("CyberGrapple-CrosshairShape-MantisBlades", "螳螂刀");
    this.Text("CyberGrapple-CrosshairShape-HeavyMachineGun", "重机枪");
    this.Text("CyberGrapple-CrosshairShape-Dot", "画面正中圆点");
    this.Text("CyberGrapple-CrosshairColor", "颜色");
    this.Text("CyberGrapple-CrosshairColor-Description", "准星的颜色。青色是游戏准星的颜色。");
    this.Text("CyberGrapple-CrosshairColor-Yellow", "黄色");
    this.Text("CyberGrapple-CrosshairColor-White", "白色");
    this.Text("CyberGrapple-CrosshairColor-Red", "红色");
    this.Text("CyberGrapple-CrosshairColor-Green", "绿色");
    this.Text("CyberGrapple-CrosshairColor-Turquoise", "青色（游戏原色）");
    this.Text("CyberGrapple-CrosshairSize", "大小");
    this.Text("CyberGrapple-CrosshairSize-Description", "准星的大小，以游戏准星的百分比计。");
    this.Text("CyberGrapple-CrosshairRange", "射程指示");
    this.Text("CyberGrapple-CrosshairRange-Description", "按下按键也不会发射抓钩时，准星变为超出射程颜色：没有剩余的充能、义体不在战斗辅助道具快捷栏上（“独立按键”关闭时）、射程内没有目标、瞄准天空、前方有该义体当前的阶尚无法勾住的人物或载具、人物或摩托车超出可被拉动的距离、有人在敏捷近战范围内，或钩子尚未收回。");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor", "超出射程颜色");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor-Description", "抓钩不会发射时准星的颜色。请选择与准星颜色不同的颜色：颜色相同时，射程指示关闭。");
  }
}
