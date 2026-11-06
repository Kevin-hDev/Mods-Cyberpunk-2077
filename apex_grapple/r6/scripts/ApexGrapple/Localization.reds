// Menu texts in English, French and Simplified Chinese (LocalizationChinese.reds), through Codeware's translation system. Everything here compiles only when
// Codeware is installed: without it, one unknown name would stop every redscript mod of the player from loading.
// Without Codeware the menu shows the keys instead.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleLocalization extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new ApexGrappleFrench();
    }
    if Equals(language, n"zh-cn") {
      return new ApexGrappleChinese();
    }
    return new ApexGrappleEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-Enabled", "Apex Grapple");
    this.Text("ApexGrapple-Enabled-Description", "Aim at a surface and press the quick melee key (Q on a keyboard; R3 on a controller, or L1 in the Alternative or Switch Legacy layout): the hook flies and the rope pulls you, while your aim steers you. Off: the key does only the quick melee.");
    this.Text("ApexGrapple-Profile1", "Profile 1: base grapple");
    this.Text("ApexGrapple-Profile2", "Profile 2");
    this.Text("ApexGrapple-Profile3", "Profile 3");
    this.Text("ApexGrapple-Profile4", "Profile 4");
    this.Text("ApexGrapple-Profile5", "Profile 5");
    this.Text("ApexGrapple-ShowSettings", "Show settings");
    this.Text("ApexGrapple-ShowSettings-Description", "Shows this profile's settings below. Shown or hidden, the profile keeps working.");
    this.Text("ApexGrapple-ProfileActive", "Enabled");
    this.Text("ApexGrapple-ProfileActive-Description", "This profile fires its own grapple with its key and the settings below. Needs Codeware.");
    this.Text("ApexGrapple-ProfileKey", "Key");
    this.Text("ApexGrapple-ProfileKey-Description", "The key of this profile's grapple. Two profiles on one key: the lower number fires. The mouse wheel cannot be used.");
    this.Text("ApexGrapple-Implant", "Arm implant");
    this.Text("ApexGrapple-Implant-Description", "The implant your left arm fires the grapple from, seen in first person. None: the rope leaves from your hand. Needs Codeware.");
    this.Text("ApexGrapple-Implant-None", "None");
    this.Text("ApexGrapple-Implant-ProjectileLauncher", "Projectile Launch System");
    this.Text("ApexGrapple-RequireLauncher", "Require the Projectile Launch System");
    this.Text("ApexGrapple-RequireLauncher-Description", "The grapple works only if V has the Projectile Launch System installed, shown or not. Without it, the grapple does not fire.");
    this.Text("ApexGrapple-OwnKey", "Own key");
    this.Text("ApexGrapple-OwnKey-Description", "Grapple with a key of your choice instead of the quick melee key. Needs Codeware.");
    this.Text("ApexGrapple-Key", "Key");
    this.Text("ApexGrapple-Key-Description", "The grapple key, used when Own key is on. The mouse wheel cannot be used.");
    this.Text("ApexGrapple-KeyboardHold", "Keyboard: hold to grapple");
    this.Text("ApexGrapple-KeyboardHold-Description", "Hold the key to grapple. With the quick melee key, a tap still does the quick melee. Not on the scanner's key, which a hold opens.");
    this.Text("ApexGrapple-ControllerHold", "Controller: hold to grapple");
    this.Text("ApexGrapple-ControllerHold-Description", "Hold the button to grapple. With the quick melee button, a tap still does the quick melee. Not on the scanner's button (L1), which a hold opens.");
    this.Text("ApexGrapple-HoldTime", "Hold time");
    this.Text("ApexGrapple-HoldTime-Description", "How long to hold for the grapple, in seconds.");
    this.Text("ApexGrapple-Range", "Range");
    this.Text("ApexGrapple-Range-Description", "How far the hook reaches, in metres.");
    this.Text("ApexGrapple-HookSpeed", "Hook speed");
    this.Text("ApexGrapple-HookSpeed-Description", "How fast the hook flies to its target, in metres a second.");
    this.Text("ApexGrapple-HookReturn", "Hook return speed");
    this.Text("ApexGrapple-HookReturn-Description", "How many times faster than on its way out the hook comes back. A new grapple waits for it.");
    this.Text("ApexGrapple-PullStrength", "Pull strength");
    this.Text("ApexGrapple-PullStrength-Description", "How hard the rope pulls you, in m/s².");
    this.Text("ApexGrapple-PullSpeedCap", "Pull speed cap");
    this.Text("ApexGrapple-PullSpeedCap-Description", "Top speed the rope adds, in metres a second. Your momentum adds to it.");
    this.Text("ApexGrapple-SteerStrength", "Steering strength");
    this.Text("ApexGrapple-SteerStrength-Description", "How much your aim bends your path during a pull, in m/s². Keep the crosshair inside a turn to circle round the point. The move keys do nothing until you let go.");
    this.Text("ApexGrapple-RopeCarry", "Rope carries you");
    this.Text("ApexGrapple-RopeCarry-Description", "How much of your weight the rope holds while the hook is set, in per cent. At 100 you fly straight where you aimed and fall only once you let go, as in Apex.");
    this.Text("ApexGrapple-TakeOffLift", "Take-off lift");
    this.Text("ApexGrapple-TakeOffLift-Description", "A small hop when a pull starts on the ground, in metres a second. At 0 you leave along the floor.");
    this.Text("ApexGrapple-TakeOffTime", "Take-off time");
    this.Text("ApexGrapple-TakeOffTime-Description", "The ground is ignored this long at the start of a pull, in seconds, so you can take off.");
    this.Text("ApexGrapple-HoldToKeepPulling", "Hold to keep pulling");
    this.Text("ApexGrapple-HoldToKeepPulling-Description", "Releasing the key lets go. A quick tap pulls all the way. On the scanner's button (L1 on a controller), a tap always pulls all the way: a second press lets go.");
    this.Text("ApexGrapple-ArrivalDistance", "Arrival distance");
    this.Text("ApexGrapple-ArrivalDistance-Description", "The pull stops this far from the hook, in metres; a shorter shot stops halfway.");
    this.Text("ApexGrapple-LetGoPastAnchor", "Let go past the point");
    this.Text("ApexGrapple-LetGoPastAnchor-Description", "Once you fly past the point, the rope no longer pulls you back, and it lets go this far beyond it, in metres.");
    this.Text("ApexGrapple-LongestPull", "Longest pull");
    this.Text("ApexGrapple-LongestPull-Description", "In seconds. 0 means no limit.");
    this.Text("ApexGrapple-LetGoOnLanding", "Let go on landing");
    this.Text("ApexGrapple-LetGoOnLanding-Description", "Touching the ground ends the pull.");
    this.Text("ApexGrapple-PreserveJump", "Preserve jump when detaching");
    this.Text("ApexGrapple-PreserveJump-Description", "Jumping to let go spends no jump.");
    this.Text("ApexGrapple-RegainDoubleJump", "Double jump back on each grapple");
    this.Text("ApexGrapple-RegainDoubleJump-Description", "When the hook catches, V gets the double jump back. Needs the double jump cyberware.");
    this.Text("ApexGrapple-HookTargets", "Grapple onto vehicles and people");
    this.Text("ApexGrapple-HookTargets-Description", "The hook also takes vehicles, enemies and passers-by, and follows them as they move. A vehicle always pulls V. Needs Codeware.");
    this.Text("ApexGrapple-PullPeople", "Pull people to V");
    this.Text("ApexGrapple-PullPeople-Description", "Works with the setting above on: a person the hook takes is pulled to V, instead of V to them, when the game allows it; otherwise V is pulled (a scene, a vehicle, something in the way, no ground by V). Only humans and androids come: bosses, drones and mechs always pull V.");
    this.Text("ApexGrapple-PullDamage", "Damage when pulling people");
    this.Text("ApexGrapple-PullDamage-Description", "Works with the two settings above on: a person pulled to V is slammed to the ground in front of V and takes the blow, as the game counts it; it can kill. Off, the fall and what they hit do them no harm until they lie still; V's shots still hurt.");
    this.Text("ApexGrapple-SteerPeople", "Steer pulled people with the aim");
    this.Text("ApexGrapple-SteerPeople-Description", "Works when people are pulled to V: the aim raised after the shot brings the person back higher, up to 6 m; the aim turned sends them that way, up to 8 m. Under 5 degrees nothing changes.");
    this.Text("ApexGrapple-PunchWins", "Quick melee wins over grapple");
    this.Text("ApexGrapple-PunchWins-Description", "Someone or a vehicle within quick melee range gets the quick melee instead of the grapple.");
    this.Text("ApexGrapple-PunchRange", "Quick melee range");
    this.Text("ApexGrapple-PunchRange-Description", "Someone or a vehicle closer than this, in metres, gets the quick melee.");
    this.Text("ApexGrapple-SoftLanding", "Soft landing after a grapple");
    this.Text("ApexGrapple-SoftLanding-Description", "The landing that follows a grapple does no damage. Off: the game's falls.");
    this.Text("ApexGrapple-FallEffect", "Fall effect during a grapple");
    this.Text("ApexGrapple-FallEffect-Description", "The darkening the game shows in a long fall, during a grapple's flight until you land. Off: hidden. Falls on foot always keep it.");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-Enabled", "Apex Grapple");
    this.Text("ApexGrapple-Enabled-Description", "Visez une surface et appuyez sur la touche du coup rapide (Q au clavier ; R3 à la manette, ou L1 en disposition Alternative ou Switch Legacy) : le crochet part et la corde vous tire, pendant que votre visée vous dirige. Éteint : la touche ne fait que le coup rapide.");
    this.Text("ApexGrapple-Profile1", "Profil 1 : grappin de base");
    this.Text("ApexGrapple-Profile2", "Profil 2");
    this.Text("ApexGrapple-Profile3", "Profil 3");
    this.Text("ApexGrapple-Profile4", "Profil 4");
    this.Text("ApexGrapple-Profile5", "Profil 5");
    this.Text("ApexGrapple-ShowSettings", "Afficher les réglages");
    this.Text("ApexGrapple-ShowSettings-Description", "Affiche les réglages de ce profil en dessous. Affichés ou non, le profil marche.");
    this.Text("ApexGrapple-ProfileActive", "Activé");
    this.Text("ApexGrapple-ProfileActive-Description", "Ce profil tire son propre grappin avec sa touche et les réglages ci-dessous. Nécessite Codeware.");
    this.Text("ApexGrapple-ProfileKey", "Touche");
    this.Text("ApexGrapple-ProfileKey-Description", "La touche du grappin de ce profil. Deux profils sur la même touche : le plus petit numéro tire. La molette ne peut pas servir.");
    this.Text("ApexGrapple-Implant", "Implant du bras");
    this.Text("ApexGrapple-Implant-Description", "L'implant d'où votre bras gauche tire le grappin, vu en première personne. Aucun : la corde part de votre main. Nécessite Codeware.");
    this.Text("ApexGrapple-Implant-None", "Aucun");
    this.Text("ApexGrapple-Implant-ProjectileLauncher", "Lance-projectile");
    this.Text("ApexGrapple-RequireLauncher", "Exiger le lance-projectile");
    this.Text("ApexGrapple-RequireLauncher-Description", "Le grappin ne marche que si V a le lance-projectile installé, affiché ou non. Sans lui, le grappin ne part pas.");
    this.Text("ApexGrapple-OwnKey", "Touche à part");
    this.Text("ApexGrapple-OwnKey-Description", "Lancer le grappin avec une touche au choix au lieu de celle du coup rapide. Nécessite Codeware.");
    this.Text("ApexGrapple-Key", "Touche");
    this.Text("ApexGrapple-Key-Description", "La touche du grappin, quand « Touche à part » est allumée. La molette ne peut pas servir.");
    this.Text("ApexGrapple-KeyboardHold", "Clavier : maintenir pour le grappin");
    this.Text("ApexGrapple-KeyboardHold-Description", "Maintenir la touche lance le grappin. Avec la touche du coup rapide, un appui bref fait toujours le coup rapide. Pas sur la touche du scanner, qu'un appui long ouvre.");
    this.Text("ApexGrapple-ControllerHold", "Manette : maintenir pour le grappin");
    this.Text("ApexGrapple-ControllerHold-Description", "Maintenir le bouton lance le grappin. Avec le bouton du coup rapide, un appui bref fait toujours le coup rapide. Pas sur le bouton du scanner (L1), qu'un appui long ouvre.");
    this.Text("ApexGrapple-HoldTime", "Durée du maintien");
    this.Text("ApexGrapple-HoldTime-Description", "Combien de temps maintenir pour le grappin, en secondes.");
    this.Text("ApexGrapple-Range", "Portée");
    this.Text("ApexGrapple-Range-Description", "Jusqu'où le crochet porte, en mètres.");
    this.Text("ApexGrapple-HookSpeed", "Vitesse du crochet");
    this.Text("ApexGrapple-HookSpeed-Description", "La vitesse du crochet jusqu'à sa cible, en mètres par seconde.");
    this.Text("ApexGrapple-HookReturn", "Vitesse de retour du crochet");
    this.Text("ApexGrapple-HookReturn-Description", "Combien de fois plus vite qu'à l'aller le crochet revient. Un nouveau grappin l'attend.");
    this.Text("ApexGrapple-PullStrength", "Force de traction");
    this.Text("ApexGrapple-PullStrength-Description", "La force avec laquelle la corde vous tire, en m/s².");
    this.Text("ApexGrapple-PullSpeedCap", "Vitesse maximale de traction");
    this.Text("ApexGrapple-PullSpeedCap-Description", "La vitesse maximale que la corde ajoute, en mètres par seconde. Votre élan s'y ajoute.");
    this.Text("ApexGrapple-SteerStrength", "Force du pilotage");
    this.Text("ApexGrapple-SteerStrength-Description", "À quel point votre visée courbe votre trajet pendant la traction, en m/s². Gardez le viseur à l'intérieur d'un virage pour tourner autour du point. Les touches de déplacement ne font rien avant le lâcher.");
    this.Text("ApexGrapple-RopeCarry", "La corde vous porte");
    this.Text("ApexGrapple-RopeCarry-Description", "La part de votre poids que tient la corde tant que le crochet est planté, en pour cent. À 100 vous partez droit où vous avez visé et ne tombez qu'au lâcher, comme dans Apex.");
    this.Text("ApexGrapple-TakeOffLift", "Élan de décollage");
    this.Text("ApexGrapple-TakeOffLift-Description", "Un petit bond quand la traction part du sol, en mètres par seconde. À 0 vous partez au ras du sol.");
    this.Text("ApexGrapple-TakeOffTime", "Temps de décollage");
    this.Text("ApexGrapple-TakeOffTime-Description", "Le sol ne compte pas pendant ce temps au début de la traction, en secondes, pour pouvoir décoller.");
    this.Text("ApexGrapple-HoldToKeepPulling", "Maintenir pour tirer");
    this.Text("ApexGrapple-HoldToKeepPulling-Description", "Relâcher la touche lâche la corde. Un appui bref tire jusqu'au bout. Sur le bouton du scanner (L1 à la manette), un appui bref tire toujours jusqu'au bout : un second appui lâche la corde.");
    this.Text("ApexGrapple-ArrivalDistance", "Distance d'arrivée");
    this.Text("ApexGrapple-ArrivalDistance-Description", "La traction s'arrête à cette distance du crochet, en mètres ; un tir plus court s'arrête à mi-chemin.");
    this.Text("ApexGrapple-LetGoPastAnchor", "Lâcher après le point");
    this.Text("ApexGrapple-LetGoPastAnchor-Description", "Une fois le point dépassé, la corde ne vous tire plus en arrière, et elle lâche à cette distance au-delà, en mètres.");
    this.Text("ApexGrapple-LongestPull", "Traction la plus longue");
    this.Text("ApexGrapple-LongestPull-Description", "En secondes. 0 : sans limite.");
    this.Text("ApexGrapple-LetGoOnLanding", "Lâcher à l'atterrissage");
    this.Text("ApexGrapple-LetGoOnLanding-Description", "Toucher le sol termine la traction.");
    this.Text("ApexGrapple-PreserveJump", "Garder le saut au lâcher");
    this.Text("ApexGrapple-PreserveJump-Description", "Sauter pour lâcher ne dépense aucun saut.");
    this.Text("ApexGrapple-RegainDoubleJump", "Double saut rendu à chaque grappin");
    this.Text("ApexGrapple-RegainDoubleJump-Description", "Quand le crochet s'accroche, V retrouve son double saut. Demande l'implant de double saut.");
    this.Text("ApexGrapple-HookTargets", "Grappin sur les véhicules et les personnes");
    this.Text("ApexGrapple-HookTargets-Description", "Le crochet prend aussi les véhicules, les ennemis et les passants, et les suit quand ils bougent. Un véhicule tire toujours V. Demande Codeware.");
    this.Text("ApexGrapple-PullPeople", "Tirer les personnes vers V");
    this.Text("ApexGrapple-PullPeople-Description", "Marche avec le réglage du dessus allumé : la personne prise vient vers V, au lieu de V vers elle, quand le jeu le permet ; sinon V est tiré (scène, véhicule, obstacle, pas de sol près de V). Seuls les humains et les androïdes viennent : les boss, les drones et les mechs tirent toujours V.");
    this.Text("ApexGrapple-PullDamage", "Dégâts quand la personne est tirée");
    this.Text("ApexGrapple-PullDamage-Description", "Marche avec les deux réglages du dessus allumés : la personne tirée vers V est plaquée au sol devant V et prend le choc, comme le jeu le compte ; elle peut en mourir. Éteint, la chute et ce qu'elle heurte ne la blessent pas jusqu'à ce qu'elle soit immobile ; les tirs de V la blessent toujours.");
    this.Text("ApexGrapple-SteerPeople", "Diriger la personne au viseur");
    this.Text("ApexGrapple-SteerPeople-Description", "Marche quand les personnes sont tirées vers V : le viseur levé après le tir ramène la personne plus haut, jusqu'à 6 m ; le viseur tourné l'envoie de ce côté, jusqu'à 8 m. Sous 5 degrés, rien ne change.");
    this.Text("ApexGrapple-PunchWins", "Le coup rapide passe avant le grappin");
    this.Text("ApexGrapple-PunchWins-Description", "Une personne ou un véhicule à portée du coup rapide le reçoit au lieu du grappin.");
    this.Text("ApexGrapple-PunchRange", "Portée du coup rapide");
    this.Text("ApexGrapple-PunchRange-Description", "Une personne ou un véhicule plus proche que cette distance, en mètres, reçoit le coup rapide.");
    this.Text("ApexGrapple-SoftLanding", "Atterrissage sans dégâts");
    this.Text("ApexGrapple-SoftLanding-Description", "L'atterrissage qui suit un grappin ne fait pas de dégâts. Éteint : les chutes du jeu.");
    this.Text("ApexGrapple-FallEffect", "Effet de chute pendant le grappin");
    this.Text("ApexGrapple-FallEffect-Description", "L'assombrissement que le jeu montre pendant une longue chute, pendant le vol du grappin et jusqu'à l'atterrissage. Éteint : masqué. Les chutes à pied le gardent toujours.");
  }
}
