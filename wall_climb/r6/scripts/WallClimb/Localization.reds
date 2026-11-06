// Menu texts in English, French and Simplified Chinese (LocalizationChinese.reds), through Codeware's translation system.
// Everything here compiles only when Codeware is installed: without it, one unknown name would stop every
// redscript mod of the player from loading. Without Codeware the menu shows the keys instead.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class WallClimbLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new WallClimbFrench();
    }
    if Equals(language, n"zh-cn") {
      return new WallClimbChinese();
    }
    return new WallClimbEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class WallClimbEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("WallClimb-Enabled", "Wall climb");
    this.Text("WallClimb-Enabled-Description", "Jump or fall against a wall and hold forward: V climbs it hand over hand. Forward with left or right climbs diagonally; once on the wall, left or right alone climbs along it, round corners too. V pulls up if a ledge is within reach. The weapon is put away during the climb.");
    this.Text("WallClimb-MaxHeight", "Highest climb");
    this.Text("WallClimb-MaxHeight-Description", "How high V climbs before letting go, in metres above where V caught the wall.");
    this.Text("WallClimb-ClimbSpeed", "Climbing speed");
    this.Text("WallClimb-ClimbSpeed-Description", "How fast V climbs: 1 is the normal speed, 3 three times as fast.");
    this.Text("WallClimb-HoldOn", "Hold on when stopping");
    this.Text("WallClimb-HoldOn-Description", "On: when you let go of the stick or the move keys, V stops and holds on to the wall as on a ladder; push them again to climb on. Off: V lets go and falls. Back always lets go.");
    this.Text("WallClimb-Regrab", "Grab the wall again");
    this.Text("WallClimb-Regrab-Description", "On: falling after a climb, V can grab a wall again 0.9 s after letting go, as often as you like. Off: one climb until V lands.");
    this.Text("WallClimb-LadderCamera", "Recentre the view on ladders");
    this.Text("WallClimb-LadderCamera-Description", "On: the game's ladder camera, which brings the view back when V holds on to a ladder. Off: the view stays where you put it, on the game's ladders too, while Wall climb is on.");
    this.Text("WallClimb-SoftLanding", "No fall damage after a climb");
    this.Text("WallClimb-SoftLanding-Description", "On: the landing that follows a climb does no damage. Off: the game's falls.");
    this.Text("WallClimb-FallEffect", "Fall effect after a climb");
    this.Text("WallClimb-FallEffect-Description", "On: the darkening the game shows in a long fall, from a climb until you land. Off: hidden. Falls on foot always keep it.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class WallClimbFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("WallClimb-Enabled", "Grimpe murale");
    this.Text("WallClimb-Enabled-Description", "Sauter ou tomber contre un mur en tenant avant : V le grimpe main après main. Avant avec gauche ou droite grimpe en biais ; une fois sur le mur, gauche ou droite seul fait aller V le long du mur, en passant les angles. V se hisse si un rebord est à portée. L'arme est rangée pendant la grimpe.");
    this.Text("WallClimb-MaxHeight", "Hauteur maximale");
    this.Text("WallClimb-MaxHeight-Description", "Jusqu'où V grimpe avant de lâcher, en mètres au-dessus de l'endroit où V a attrapé le mur.");
    this.Text("WallClimb-ClimbSpeed", "Vitesse de grimpe");
    this.Text("WallClimb-ClimbSpeed-Description", "À quelle vitesse V grimpe : 1 pour la vitesse normale, 3 pour trois fois plus vite.");
    this.Text("WallClimb-HoldOn", "Rester sur le mur à l'arrêt");
    this.Text("WallClimb-HoldOn-Description", "Allumé : quand on relâche le stick ou les touches de déplacement, V s'arrête et se tient au mur comme sur une échelle ; les pousser de nouveau pour repartir. Éteint : V lâche et tombe. Arrière lâche toujours le mur.");
    this.Text("WallClimb-Regrab", "Se raccrocher au mur");
    this.Text("WallClimb-Regrab-Description", "Allumé : en tombant après une grimpe, V peut reprendre un mur 0,9 s après l'avoir lâché, autant de fois qu'on veut. Éteint : une seule grimpe jusqu'à ce que V touche le sol.");
    this.Text("WallClimb-LadderCamera", "Recentrer la vue sur les échelles");
    this.Text("WallClimb-LadderCamera-Description", "Allumé : la caméra d'échelle du jeu, qui ramène la vue quand V se tient à une échelle. Éteint : la vue reste là où on l'a mise, sur les échelles du jeu aussi, tant que la grimpe murale est allumée.");
    this.Text("WallClimb-SoftLanding", "Aucun dégât de chute après une grimpe");
    this.Text("WallClimb-SoftLanding-Description", "Allumé : l'atterrissage qui suit une grimpe ne fait pas de dégâts. Éteint : les chutes du jeu.");
    this.Text("WallClimb-FallEffect", "Effet de chute après une grimpe");
    this.Text("WallClimb-FallEffect-Description", "Allumé : l'assombrissement que le jeu montre pendant une longue chute, depuis une grimpe jusqu'à l'atterrissage. Éteint : masqué. Les chutes à pied le gardent toujours.");
  }
}
