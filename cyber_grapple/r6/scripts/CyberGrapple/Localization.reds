// Made by fabrique/grapple.py from Apex Grapple's Localization.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Menu texts in English, French and Simplified Chinese (LocalizationChinese.reds), through Codeware's translation system. Everything here compiles only when
// Codeware is installed: without it, one unknown name would stop every redscript mod of the player from loading.
// Without Codeware the menu shows the keys instead.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new CyberGrappleFrench();
    }
    if Equals(language, n"zh-cn") {
      return new CyberGrappleChinese();
    }
    let other: ref<ModLocalizationPackage> = CyberGrappleTextsIn(language);
    if IsDefined(other) {
      return other;
    }
    return new CyberGrappleEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Enabled", "Cyber Grapple");
    this.Text("CyberGrapple-Enabled-Description", "With the Grapple System implant fitted (ripperdocs sell it) and assigned to the Combat Gadget quickslot, aim at a surface and press the Use Combat Gadget key (middle mouse button on a keyboard, R1 on a controller): the hook flies and the rope pulls you, while your aim steers you. Off: the implant stays fitted and does nothing.");
    this.Text("CyberGrapple-Profile1-Key", "Key");
    this.Text("CyberGrapple-Profile1-Fov", "Field of view");
    this.Text("CyberGrapple-OwnKey", "Own key");
    this.Text("CyberGrapple-OwnKey-Description", "Grapple with a key of your choice instead of the Use Combat Gadget key, which is then free for your grenades.");
    this.Text("CyberGrapple-Key", "Key");
    this.Text("CyberGrapple-Key-Description", "The grapple key, used when Own key is on. The mouse wheel cannot be used.");
    this.Text("CyberGrapple-KeyboardHold", "Keyboard: hold to grapple");
    this.Text("CyberGrapple-KeyboardHold-Description", "Hold the key to grapple. With the quick melee key, a tap still does the quick melee. Not on the scanner's key, which a hold opens.");
    this.Text("CyberGrapple-ControllerHold", "Controller: hold to grapple");
    this.Text("CyberGrapple-ControllerHold-Description", "Hold the button to grapple. With the quick melee button, a tap still does the quick melee. Not on the scanner's button (L1), which a hold opens.");
    this.Text("CyberGrapple-HoldTime", "Hold time");
    this.Text("CyberGrapple-HoldTime-Description", "How long to hold for the grapple, in seconds.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Enabled", "Cyber Grapple");
    this.Text("CyberGrapple-Enabled-Description", "Avec l'implant Système de grappin installé (les charcudocs le vendent) et placé dans l'emplacement rapide de gadget de combat, visez une surface et appuyez sur la touche Utiliser le gadget de combat (clic de la molette au clavier, R1 à la manette) : le crochet part et la corde vous tire, pendant que votre visée vous dirige. Éteint : l'implant reste installé sans rien faire.");
    this.Text("CyberGrapple-Profile1-Key", "Touche");
    this.Text("CyberGrapple-Profile1-Fov", "Champ de vision");
    this.Text("CyberGrapple-OwnKey", "Touche à part");
    this.Text("CyberGrapple-OwnKey-Description", "Lancer le grappin avec une touche au choix au lieu de la touche Utiliser le gadget de combat, qui reste alors libre pour vos grenades.");
    this.Text("CyberGrapple-Key", "Touche");
    this.Text("CyberGrapple-Key-Description", "La touche du grappin, quand « Touche à part » est allumée. La molette ne peut pas servir.");
    this.Text("CyberGrapple-KeyboardHold", "Clavier : maintenir pour le grappin");
    this.Text("CyberGrapple-KeyboardHold-Description", "Maintenir la touche lance le grappin. Avec la touche du coup rapide, un appui bref fait toujours le coup rapide. Pas sur la touche du scanner, qu'un appui long ouvre.");
    this.Text("CyberGrapple-ControllerHold", "Manette : maintenir pour le grappin");
    this.Text("CyberGrapple-ControllerHold-Description", "Maintenir le bouton lance le grappin. Avec le bouton du coup rapide, un appui bref fait toujours le coup rapide. Pas sur le bouton du scanner (L1), qu'un appui long ouvre.");
    this.Text("CyberGrapple-HoldTime", "Durée du maintien");
    this.Text("CyberGrapple-HoldTime-Description", "Combien de temps maintenir pour le grappin, en secondes.");
  }
}
