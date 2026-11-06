// Menu texts in English, French and Simplified Chinese (LocalizationChinese.reds), through Codeware's translation system.
// Everything here compiles only when Codeware is installed: without it, one unknown name would stop every
// redscript mod of the player from loading. Without Codeware the menu shows the keys instead.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class OmniSlideLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new OmniSlideFrench();
    }
    if Equals(language, n"zh-cn") {
      return new OmniSlideChinese();
    }
    return new OmniSlideEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class OmniSlideEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("OmniSlide-Enabled", "Slide in every direction");
    this.Text("OmniSlide-Enabled-Description", "Slide sideways, diagonally and backwards. V's body turns with the camera, so the slide goes on when you look around. Needs TweakXL.");
    this.Text("OmniSlide-Speed", "Slide speed");
    this.Text("OmniSlide-Speed-Description", "Multiplies the slide's speed. 1.0 is the game's speed.");
    this.Text("OmniSlide-Slopes", "Slopes");
    this.Text("OmniSlide-Slopes-Description", "Going down, a slide goes farther, and on a steep descent it goes on until the ground flattens. Going up, it stops sooner. 0 is the game: no effect.");
    this.Text("OmniSlide-CrouchInAir", "Slide on landing");
    this.Text("OmniSlide-CrouchInAir-Description", "Press crouch at any moment of a jump to slide on landing. In the game, a press while rising or at the top of the jump is lost.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class OmniSlideFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("OmniSlide-Enabled", "Glissade dans toutes les directions");
    this.Text("OmniSlide-Enabled-Description", "Glisser sur le côté, en diagonale et en arrière. Le corps de V tourne avec la caméra : la glissade continue quand on regarde autour. Nécessite TweakXL.");
    this.Text("OmniSlide-Speed", "Vitesse de la glissade");
    this.Text("OmniSlide-Speed-Description", "Multiplie la vitesse de la glissade. 1.0 est la vitesse du jeu.");
    this.Text("OmniSlide-Slopes", "Effet des pentes");
    this.Text("OmniSlide-Slopes-Description", "En descente, la glissade va plus loin, et dans une descente raide elle continue jusqu'à ce que le sol redevienne plat. En montée, elle s'arrête plus tôt. 0 = le jeu : aucun effet.");
    this.Text("OmniSlide-CrouchInAir", "Glissade à l'atterrissage");
    this.Text("OmniSlide-CrouchInAir-Description", "Appuyer sur s'accroupir à n'importe quel moment d'un saut pour glisser à l'atterrissage. Dans le jeu, un appui pendant la montée ou en haut du saut est perdu.");
  }
}
