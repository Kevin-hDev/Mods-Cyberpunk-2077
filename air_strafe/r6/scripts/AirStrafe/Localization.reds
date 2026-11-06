// Menu texts in English, French and Simplified Chinese (LocalizationChinese.reds), through Codeware's translation system.
// Everything here compiles only when Codeware is installed: without it, one unknown name would stop every
// redscript mod of the player from loading. Without Codeware the menu shows the keys instead.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class AirStrafeLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new AirStrafeFrench();
    }
    if Equals(language, n"zh-cn") {
      return new AirStrafeChinese();
    }
    return new AirStrafeEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class AirStrafeEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("AirStrafe-Enabled", "Air strafe");
    this.Text("AirStrafe-Enabled-Description", "Steer your momentum in the air with the move keys, as when walking, without losing speed. Hold forward and turn the view quickly to swing it at once (tap strafe). Off: the game's air control.");
    this.Text("AirStrafe-Steering", "Air steering");
    this.Text("AirStrafe-Steering-Description", "How fast your momentum turns toward the direction of the keys, in degrees a second.");
    this.Text("AirStrafe-BackTurn", "Back key turns around");
    this.Text("AirStrafe-BackTurn-Description", "On: the back key swings your momentum behind you at full speed. Off: it only slows you down.");
    this.Text("AirStrafe-TapStrafe", "Tap strafe key");
    this.Text("AirStrafe-TapStrafe-Description", "Spam or hold a key of your choice in the air, W by default, while turning the view: your momentum follows the view. While on, only this key does it: forward lets you jump straight while you look around. Works with Air strafe off. Needs Codeware.");
    this.Text("AirStrafe-TapKey", "Key");
    this.Text("AirStrafe-TapKey-Description", "The key to spam for the tap strafe. The mouse wheel cannot be used.");
    this.Text("AirStrafe-TapSteering", "Tap strafe steering");
    this.Text("AirStrafe-TapSteering-Description", "How fast your momentum turns while you spam the key, in degrees a second.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class AirStrafeFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("AirStrafe-Enabled", "Air strafe");
    this.Text("AirStrafe-Enabled-Description", "En l'air, diriger son élan avec les touches de déplacement, comme en marchant, sans perdre de vitesse. Avant tenu, un coup de vue rapide le renvoie aussitôt (tap strafe). Éteint : le contrôle en l'air du jeu.");
    this.Text("AirStrafe-Steering", "Direction en l'air");
    this.Text("AirStrafe-Steering-Description", "La vitesse à laquelle l'élan tourne vers la direction des touches, en degrés par seconde.");
    this.Text("AirStrafe-BackTurn", "Demi-tour avec la touche arrière");
    this.Text("AirStrafe-BackTurn-Description", "Allumé : la touche arrière renvoie l'élan derrière soi, à pleine vitesse. Éteint : elle ralentit seulement.");
    this.Text("AirStrafe-TapStrafe", "Touche de tap strafe");
    this.Text("AirStrafe-TapStrafe-Description", "En l'air, mitrailler ou tenir une touche au choix, W par défaut, en tournant la vue : l'élan suit la vue. Allumée, seule cette touche le fait : avancer permet de sauter tout droit en regardant autour. Marche aussi avec l'air strafe éteint. Nécessite Codeware.");
    this.Text("AirStrafe-TapKey", "Touche");
    this.Text("AirStrafe-TapKey-Description", "La touche à mitrailler pour le tap strafe. La molette ne peut pas servir.");
    this.Text("AirStrafe-TapSteering", "Direction du tap strafe");
    this.Text("AirStrafe-TapSteering-Description", "La vitesse à laquelle l'élan tourne quand on mitraille la touche, en degrés par seconde.");
  }
}
