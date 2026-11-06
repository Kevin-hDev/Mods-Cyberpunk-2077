// Menu texts in English, French and Simplified Chinese (LocalizationChinese.reds), through Codeware's translation system.
// Everything here compiles only when Codeware is installed: without it, one unknown name would stop every
// redscript mod of the player from loading. Without Codeware the menu shows the keys instead.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class AxleSlideLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new AxleSlideFrench();
    }
    if Equals(language, n"zh-cn") {
      return new AxleSlideChinese();
    }
    return new AxleSlideEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class AxleSlideEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("AxleSlide-Enabled", "Axle slide");
    this.Text("AxleSlide-Enabled-Description", "Steer your slides with the move keys, as when walking, and slide faster and farther, as Axle in Apex Legends. Needs TweakXL. Off: the game's slide.");
    this.Text("AxleSlide-Steering", "Steering");
    this.Text("AxleSlide-Steering-Description", "How fast a slide turns toward the direction of the keys, in degrees a second.");
    this.Text("AxleSlide-SpeedBoost", "Speed boost");
    this.Text("AxleSlide-SpeedBoost-Description", "How much faster a slide starts, in percent.");
    this.Text("AxleSlide-FlatBoost", "Distance on flat ground");
    this.Text("AxleSlide-FlatBoost-Description", "How much farther a slide goes on flat ground, in percent.");
    this.Text("AxleSlide-SlopeBoost", "Distance on slopes");
    this.Text("AxleSlide-SlopeBoost-Description", "How much farther a slide goes uphill and downhill, in percent.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class AxleSlideFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("AxleSlide-Enabled", "Glissade Axle");
    this.Text("AxleSlide-Enabled-Description", "Diriger ses glissades avec les touches de déplacement, comme en marchant, et glisser plus vite et plus loin, comme Axle dans Apex Legends. Nécessite TweakXL. Éteint : la glissade du jeu.");
    this.Text("AxleSlide-Steering", "Direction");
    this.Text("AxleSlide-Steering-Description", "La vitesse à laquelle la glissade tourne vers la direction des touches, en degrés par seconde.");
    this.Text("AxleSlide-SpeedBoost", "Bonus de vitesse");
    this.Text("AxleSlide-SpeedBoost-Description", "De combien la glissade part plus vite, en pourcentage.");
    this.Text("AxleSlide-FlatBoost", "Distance sur le plat");
    this.Text("AxleSlide-FlatBoost-Description", "De combien la glissade va plus loin sur le plat, en pourcentage.");
    this.Text("AxleSlide-SlopeBoost", "Distance en pente");
    this.Text("AxleSlide-SlopeBoost-Description", "De combien la glissade va plus loin en montée et en descente, en pourcentage.");
  }
}
