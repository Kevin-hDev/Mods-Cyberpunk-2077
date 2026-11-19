// The implant's texts in English, French and Simplified Chinese, through Codeware's translation system: the records
// name them by key (r6/tweaks/CyberGrapple). Also the menu's texts the made Localization*.reds lack: the crosshair's
// first line, the hook's impact effect and V's voice lines. Everything here compiles only when Codeware is installed:
// without it, one unknown name would stop every redscript mod of the player from loading.
// The mod is Cyber Grapple, the implant "Grapple System" (docs/cyber-grapple/README.md, D26 and D27).
// The game's own words, read from its text files: Tier is "Niveau" in French and "阶" in Chinese, V's level is
// "Character Level", "Niveau du personnage", "人物等级", and holding a person is "钳制".
// The choice of voice takes the words of the game's character creator: its "Feminine" and "Masculine" (keys 43482,
// 43481), and in Chinese its "Voice Tone" (23208, 声调) and Auto (78374, 自动). The French agrees with "Voix", where
// the game writes "Féminin" and "Masculin" after "Timbre de voix".
// The four "Next" lines name the levels of the game's sale rules as the game ships them (10, 20, 30, 40). Upgrade.reds
// reads the rules themselves: with a mod that moves them, the refusal follows and these lines do not.
// The card's units are written as the game writes its own in each language (onscreens.json of 2.5): in French a
// no-break space between the number and the unit, and a decimal comma; in Chinese 米 and 米/秒 after a space. The game
// writes no speed in metres a second in French: m/s is its abbreviation in French as in English.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

// Whether these texts exist: without Codeware the card stays the game's (ImplantCard.reds) and nothing translated is
// told on screen (Upgrade.reds).
@if(ModuleExists("Codeware"))
public func CyberGrappleTextsThere() -> Bool {
  return true;
}

@if(!ModuleExists("Codeware"))
public func CyberGrappleTextsThere() -> Bool {
  return false;
}

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleImplantTexts extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    if Equals(language, n"fr-fr") {
      return new CyberGrappleImplantFrench();
    }
    if Equals(language, n"zh-cn") {
      return new CyberGrappleImplantChinese();
    }
    let other: ref<ModLocalizationPackage> = CyberGrappleTextsIn(language);
    if IsDefined(other) {
      return other;
    }
    return new CyberGrappleImplantEnglish();
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleImplantEnglish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Card-Name", "Grapple System");
    this.Text("CyberGrapple-Card-Description", "An arm implant that fires a hook on a rope in place of projectiles.");
    this.Text("CyberGrapple-Card-Travel", "Fires a grapple that pulls you to the surface you aim at.");
    this.Text("CyberGrapple-Card-Pull20", "Pulls a person, an enemy or a motorcycle toward you, from up to 20 m away.");
    this.Text("CyberGrapple-Card-Pull25", "Pulls a person, an enemy or a motorcycle toward you, from up to 25 m away.");
    this.Text("CyberGrapple-Card-Pull30", "Pulls a person, an enemy or a motorcycle toward you, from up to 30 m away.");
    this.Text("CyberGrapple-Card-Pull35", "Pulls a person, an enemy or a motorcycle toward you, from up to 35 m away.");
    this.Text("CyberGrapple-Card-Pull40", "Pulls a person, an enemy or a motorcycle toward you, from up to 40 m away.");
    this.Text("CyberGrapple-Card-Range", "RANGE");
    this.Text("CyberGrapple-Card-TopSpeed", "TOP SPEED");
    this.Text("CyberGrapple-Card-Seize", "Brings a person all the way to you and grabs them.");
    this.Text("CyberGrapple-Card-Next10", "Upgrading to Tier 2 requires Character Level 10.");
    this.Text("CyberGrapple-Card-Next20", "Upgrading to Tier 3 requires Character Level 20.");
    this.Text("CyberGrapple-Card-Next30", "Upgrading to Tier 4 requires Character Level 30.");
    this.Text("CyberGrapple-Card-Next40", "Upgrading to Tier 5 requires Character Level 40.");
    this.Text("CyberGrapple-Card-Distance", "{n} m");
    this.Text("CyberGrapple-Card-Speed", "{n} m/s");
    this.Text("CyberGrapple-Card-DecimalMark", ".");
    this.Text("CyberGrapple-Silent-OtherOn", "The grapple implant is off while Apex Grapple is switched on. Switch Apex Grapple off in its settings to use the implant. Your save is not changed.");
    this.Text("CyberGrapple-Silent-OtherUnread", "The grapple implant is off: Apex Grapple is installed and its switch could not be read. Move Apex Grapple out of the game's folder to use the implant. Your save is not changed.");
    this.Text("CyberGrapple-Silent-NoTweakXL", "Cyber Grapple: the Grapple System implant does not exist in this game because TweakXL is not installed. Install TweakXL and RED4ext, then start the game again.");
    this.Text("CyberGrapple-Silent-NoRecords", "Cyber Grapple: the Grapple System implant could not be added to this version of the game. The mod does nothing until it is updated.");
    this.Text("CyberGrapple-Upgrade-Waiting", "Cyber Grapple: the level some upgrades of the Grapple System ask for could not be read from this version of the game. Those upgrades ask for no level until the mod is updated.");
    this.Text("CyberGrapple-CrosshairSource", "Crosshair");
    this.Text("CyberGrapple-CrosshairSource-Description", "Whose crosshair shows while V's hands are empty or V fights with Fists. Cyber Grapple: this mod's crosshair, to aim the grapple whenever it can fire. Game: nothing is added, as in the game, which shows no crosshair there.");
    this.Text("CyberGrapple-CrosshairSource-Mod", "Cyber Grapple");
    this.Text("CyberGrapple-CrosshairSource-Game", "Game");
    this.Text("CyberGrapple-CrosshairPick", "Crosshair shape");
    this.Text("CyberGrapple-CrosshairPick-Description", "The shape of this mod's crosshair. It is hidden as soon as V holds a weapon or arm cyberware, which have crosshairs of their own, and in vehicles, with the scanner and in scenes.");
    this.Text("CyberGrapple-Impact", "Hook impact");
    this.Text("CyberGrapple-ImpactEffect", "Impact effect");
    this.Text("CyberGrapple-ImpactEffect-Description", "One of the game's own impact effects, shown once where the hook hits a surface or a vehicle. None on a person or a motorcycle. Off: nothing shows where the hook hits.");
    this.Text("CyberGrapple-ImpactStyle", "Impact effect style");
    this.Text("CyberGrapple-ImpactStyle-Description", "Which of the game's impact effects shows. Each is named after what makes it in the game: the surface hit and the weapon.");
    this.Text("CyberGrapple-ImpactStyle-ConcreteBullet", "Concrete, bullet");
    this.Text("CyberGrapple-ImpactStyle-ConcreteLargeCaliber", "Concrete, high caliber");
    this.Text("CyberGrapple-ImpactStyle-ConcreteHammer", "Concrete, hammer");
    this.Text("CyberGrapple-ImpactStyle-MetalHammer", "Metal, hammer");
    this.Text("CyberGrapple-ImpactStyle-Monowire", "Monowire");
    this.Text("CyberGrapple-ImpactStyle-DefaultBullet", "Generic, bullet");
    this.Text("CyberGrapple-Voice", "V's voice");
    this.Text("CyberGrapple-VoiceLines", "Voice lines");
    this.Text("CyberGrapple-VoiceLines-Description", "V says a line when the grapple starts pulling a person toward V, and another when V kills or knocks out a person the grapple brought and grabbed. Requires Audioware, which plays the lines. Off: V says nothing.");
    this.Text("CyberGrapple-VoiceGender", "Voice");
    this.Text("CyberGrapple-VoiceGender-Description", "Whose voice says the lines. Automatic: the voice of your V. Feminine or Masculine: always that voice.");
    this.Text("CyberGrapple-VoiceGender-Auto", "Automatic");
    this.Text("CyberGrapple-VoiceGender-Female", "Feminine");
    this.Text("CyberGrapple-VoiceGender-Male", "Masculine");
    this.Text("CyberGrapple-VoicePullChance", "Pull line frequency");
    this.Text("CyberGrapple-VoicePullChance-Description", "In percent, exact over every 10 pulls: how often V says a line when the grapple starts pulling a person toward V.");
    this.Text("CyberGrapple-VoiceKillChance", "Execution line frequency");
    this.Text("CyberGrapple-VoiceKillChance-Description", "In percent, exact over every 10 takedowns: how often V says a line when V kills or knocks out a person the grapple brought and grabbed.");
    this.Text("CyberGrapple-VoiceKillStyle", "Execution line style");
    this.Text("CyberGrapple-VoiceKillStyle-Description", "How V says the execution lines. Normal: out loud. Whisper: V whispers them. Normal + Whisper: both, mixed at random.");
    this.Text("CyberGrapple-VoiceKillStyle-Normal", "Normal");
    this.Text("CyberGrapple-VoiceKillStyle-Whisper", "Whisper");
    this.Text("CyberGrapple-VoiceKillStyle-Both", "Normal + Whisper");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleImplantFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Card-Name", "Système de grappin");
    this.Text("CyberGrapple-Card-Description", "Un implant de bras qui tire un crochet au bout d'une corde à la place des projectiles.");
    this.Text("CyberGrapple-Card-Travel", "Tire un grappin qui vous amène à la surface visée.");
    this.Text("CyberGrapple-Card-Pull20", "Tire vers vous une personne, un ennemi ou une moto, jusqu'à 20 m de distance.");
    this.Text("CyberGrapple-Card-Pull25", "Tire vers vous une personne, un ennemi ou une moto, jusqu'à 25 m de distance.");
    this.Text("CyberGrapple-Card-Pull30", "Tire vers vous une personne, un ennemi ou une moto, jusqu'à 30 m de distance.");
    this.Text("CyberGrapple-Card-Pull35", "Tire vers vous une personne, un ennemi ou une moto, jusqu'à 35 m de distance.");
    this.Text("CyberGrapple-Card-Pull40", "Tire vers vous une personne, un ennemi ou une moto, jusqu'à 40 m de distance.");
    this.Text("CyberGrapple-Card-Range", "PORTÉE");
    this.Text("CyberGrapple-Card-TopSpeed", "VITESSE MAX.");
    this.Text("CyberGrapple-Card-Seize", "Ramène une personne jusqu'à vous et la saisit.");
    this.Text("CyberGrapple-Card-Next10", "L'amélioration au niveau 2 demande un personnage de niveau 10.");
    this.Text("CyberGrapple-Card-Next20", "L'amélioration au niveau 3 demande un personnage de niveau 20.");
    this.Text("CyberGrapple-Card-Next30", "L'amélioration au niveau 4 demande un personnage de niveau 30.");
    this.Text("CyberGrapple-Card-Next40", "L'amélioration au niveau 5 demande un personnage de niveau 40.");
    this.Text("CyberGrapple-Card-Distance", "{n} m");
    this.Text("CyberGrapple-Card-Speed", "{n} m/s");
    this.Text("CyberGrapple-Card-DecimalMark", ",");
    this.Text("CyberGrapple-Silent-OtherOn", "Le grappin de l'implant est coupé tant qu'Apex Grapple est allumé. Éteignez Apex Grapple dans ses réglages pour utiliser l'implant. Votre sauvegarde n'est pas modifiée.");
    this.Text("CyberGrapple-Silent-OtherUnread", "Le grappin de l'implant est coupé : Apex Grapple est installé et son interrupteur n'a pas pu être lu. Déplacez Apex Grapple hors du dossier du jeu pour utiliser l'implant. Votre sauvegarde n'est pas modifiée.");
    this.Text("CyberGrapple-Silent-NoTweakXL", "Cyber Grapple : l'implant Système de grappin n'existe pas dans ce jeu, car TweakXL n'est pas installé. Installez TweakXL et RED4ext, puis relancez le jeu.");
    this.Text("CyberGrapple-Silent-NoRecords", "Cyber Grapple : l'implant Système de grappin n'a pas pu être ajouté à cette version du jeu. Le mod ne fait rien tant qu'il n'est pas mis à jour.");
    this.Text("CyberGrapple-Upgrade-Waiting", "Cyber Grapple : le niveau du personnage que demandent certaines améliorations du Système de grappin n'a pas pu être lu dans cette version du jeu. Ces améliorations ne demandent aucun niveau du personnage tant que le mod n'est pas mis à jour.");
    this.Text("CyberGrapple-CrosshairSource", "Réticule");
    this.Text("CyberGrapple-CrosshairSource-Description", "Le réticule affiché tant que V a les mains vides ou se bat avec les Poings. Cyber Grapple : le réticule de ce mod, pour viser avec le grappin quand il peut tirer. Jeu : rien n'est ajouté, comme dans le jeu, qui n'affiche aucun réticule dans ce cas.");
    this.Text("CyberGrapple-CrosshairSource-Mod", "Cyber Grapple");
    this.Text("CyberGrapple-CrosshairSource-Game", "Jeu");
    this.Text("CyberGrapple-CrosshairPick", "Forme du réticule");
    this.Text("CyberGrapple-CrosshairPick-Description", "La forme du réticule de ce mod. Il est caché dès que V tient une arme ou du matériel cybernétique des bras, qui ont leur propre réticule, ainsi qu'en véhicule, avec le scanner et pendant les scènes.");
    this.Text("CyberGrapple-Impact", "Impact du crochet");
    this.Text("CyberGrapple-ImpactEffect", "Effet d'impact");
    this.Text("CyberGrapple-ImpactEffect-Description", "Un des effets d'impact du jeu, affiché une fois là où le crochet touche une surface ou un véhicule. Aucun sur une personne ni sur une moto. Éteint : rien n'apparaît là où le crochet touche.");
    this.Text("CyberGrapple-ImpactStyle", "Style de l'effet d'impact");
    this.Text("CyberGrapple-ImpactStyle-Description", "L'effet d'impact du jeu qui s'affiche. Chacun porte le nom de ce qui le produit dans le jeu : la surface touchée et l'arme.");
    this.Text("CyberGrapple-ImpactStyle-ConcreteBullet", "Béton, balle");
    this.Text("CyberGrapple-ImpactStyle-ConcreteLargeCaliber", "Béton, gros calibre");
    this.Text("CyberGrapple-ImpactStyle-ConcreteHammer", "Béton, marteau");
    this.Text("CyberGrapple-ImpactStyle-MetalHammer", "Métal, marteau");
    this.Text("CyberGrapple-ImpactStyle-Monowire", "Monocâble");
    this.Text("CyberGrapple-ImpactStyle-DefaultBullet", "Générique, balle");
    this.Text("CyberGrapple-Voice", "Voix de V");
    this.Text("CyberGrapple-VoiceLines", "Répliques");
    this.Text("CyberGrapple-VoiceLines-Description", "V dit une réplique quand le grappin commence à tirer une personne vers V, et une autre quand V tue ou neutralise sans tuer une personne que le grappin a ramenée et saisie. Demande Audioware, qui joue les répliques. Éteint : V ne dit rien.");
    this.Text("CyberGrapple-VoiceGender", "Voix");
    this.Text("CyberGrapple-VoiceGender-Description", "La voix qui dit les répliques. Automatique : celle de votre V. Féminine ou Masculine : toujours cette voix.");
    this.Text("CyberGrapple-VoiceGender-Auto", "Automatique");
    this.Text("CyberGrapple-VoiceGender-Female", "Féminine");
    this.Text("CyberGrapple-VoiceGender-Male", "Masculine");
    this.Text("CyberGrapple-VoicePullChance", "Fréquence : personne tirée");
    this.Text("CyberGrapple-VoicePullChance-Description", "En pour cent, exact sur chaque série de 10 : la fréquence à laquelle V dit une réplique quand le grappin commence à tirer une personne vers V.");
    this.Text("CyberGrapple-VoiceKillChance", "Fréquence : exécution");
    this.Text("CyberGrapple-VoiceKillChance-Description", "En pour cent, exact sur chaque série de 10 : la fréquence à laquelle V dit une réplique quand V tue ou neutralise sans tuer une personne que le grappin a ramenée et saisie.");
    this.Text("CyberGrapple-VoiceKillStyle", "Style des répliques d'exécution");
    this.Text("CyberGrapple-VoiceKillStyle-Description", "Comment V dit les répliques d'exécution. Normale : à voix haute. Chuchotée : V les chuchote. Normale + chuchotée : les deux, mêlées au hasard.");
    this.Text("CyberGrapple-VoiceKillStyle-Normal", "Normale");
    this.Text("CyberGrapple-VoiceKillStyle-Whisper", "Chuchotée");
    this.Text("CyberGrapple-VoiceKillStyle-Both", "Normale + chuchotée");
  }
}

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleImplantChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Card-Name", "抓钩系统");
    this.Text("CyberGrapple-Card-Description", "一种手臂义体，发射带绳索的钩子，取代射弹。");
    this.Text("CyberGrapple-Card-Travel", "发射抓钩，将你拉向瞄准的表面。");
    this.Text("CyberGrapple-Card-Pull20", "将最远 20 米内的人物、敌人或摩托车拉向你。");
    this.Text("CyberGrapple-Card-Pull25", "将最远 25 米内的人物、敌人或摩托车拉向你。");
    this.Text("CyberGrapple-Card-Pull30", "将最远 30 米内的人物、敌人或摩托车拉向你。");
    this.Text("CyberGrapple-Card-Pull35", "将最远 35 米内的人物、敌人或摩托车拉向你。");
    this.Text("CyberGrapple-Card-Pull40", "将最远 40 米内的人物、敌人或摩托车拉向你。");
    this.Text("CyberGrapple-Card-Range", "射程");
    this.Text("CyberGrapple-Card-TopSpeed", "最高速度");
    this.Text("CyberGrapple-Card-Seize", "将人物一路拉到你身前并将其钳制。");
    this.Text("CyberGrapple-Card-Next10", "升级至 2 阶需要人物等级达到 10。");
    this.Text("CyberGrapple-Card-Next20", "升级至 3 阶需要人物等级达到 20。");
    this.Text("CyberGrapple-Card-Next30", "升级至 4 阶需要人物等级达到 30。");
    this.Text("CyberGrapple-Card-Next40", "升级至 5 阶需要人物等级达到 40。");
    this.Text("CyberGrapple-Card-Distance", "{n} 米");
    this.Text("CyberGrapple-Card-Speed", "{n} 米/秒");
    this.Text("CyberGrapple-Card-DecimalMark", ".");
    this.Text("CyberGrapple-Silent-OtherOn", "Apex Grapple 开启时，义体抓钩处于关闭状态。请在 Apex Grapple 的设置中将其关闭，以使用义体抓钩。你的存档不会被更改。");
    this.Text("CyberGrapple-Silent-OtherUnread", "义体抓钩已关闭：已安装 Apex Grapple，但无法读取其开关。请将 Apex Grapple 移出游戏文件夹，以使用义体。你的存档不会被更改。");
    this.Text("CyberGrapple-Silent-NoTweakXL", "Cyber Grapple：由于未安装 TweakXL，此游戏中不存在抓钩系统义体。请安装 TweakXL 和 RED4ext，然后重新启动游戏。");
    this.Text("CyberGrapple-Silent-NoRecords", "Cyber Grapple：无法将抓钩系统义体添加到此版本的游戏中。在模组更新之前，它不会起任何作用。");
    this.Text("CyberGrapple-Upgrade-Waiting", "Cyber Grapple：无法从此版本的游戏中读取抓钩系统部分升级所需的人物等级。在模组更新之前，这些升级不要求任何人物等级。");
    this.Text("CyberGrapple-CrosshairSource", "准星");
    this.Text("CyberGrapple-CrosshairSource-Description", "V 空手或使用徒手战斗时显示哪一种准星。Cyber Grapple：本模组的准星，用于在抓钩可以发射时瞄准。游戏：不添加任何内容，与游戏本身一致，此时游戏不显示准星。");
    this.Text("CyberGrapple-CrosshairSource-Mod", "Cyber Grapple");
    this.Text("CyberGrapple-CrosshairSource-Game", "游戏");
    this.Text("CyberGrapple-CrosshairPick", "准星样式");
    this.Text("CyberGrapple-CrosshairPick-Description", "本模组准星的样式。V 手持武器或手臂义体时隐藏（它们有自己的准星），在载具中、使用扫描器时和过场中也隐藏。");
    this.Text("CyberGrapple-Impact", "钩子命中");
    this.Text("CyberGrapple-ImpactEffect", "命中效果");
    this.Text("CyberGrapple-ImpactEffect-Description", "游戏自带的命中效果之一，在钩子击中表面或载具的位置显示一次。击中人物或摩托车时不显示。关闭：钩子击中处不显示任何效果。");
    this.Text("CyberGrapple-ImpactStyle", "命中效果样式");
    this.Text("CyberGrapple-ImpactStyle-Description", "显示游戏中的哪一种命中效果。每种效果以游戏中产生它的来源命名：被击中的表面和武器。");
    this.Text("CyberGrapple-ImpactStyle-ConcreteBullet", "混凝土，子弹");
    this.Text("CyberGrapple-ImpactStyle-ConcreteLargeCaliber", "混凝土，大口径");
    this.Text("CyberGrapple-ImpactStyle-ConcreteHammer", "混凝土，锤子");
    this.Text("CyberGrapple-ImpactStyle-MetalHammer", "金属，锤子");
    this.Text("CyberGrapple-ImpactStyle-Monowire", "单分子线");
    this.Text("CyberGrapple-ImpactStyle-DefaultBullet", "通用，子弹");
    this.Text("CyberGrapple-Voice", "V 的语音");
    this.Text("CyberGrapple-VoiceLines", "台词");
    this.Text("CyberGrapple-VoiceLines-Description", "抓钩开始将人物拉向 V 时，V 会说一句台词；V 杀死或非致命击倒被抓钩拉来并钳制的人物时，会再说一句。需要 Audioware 来播放台词。关闭：V 什么也不说。");
    this.Text("CyberGrapple-VoiceGender", "声调");
    this.Text("CyberGrapple-VoiceGender-Description", "说台词的声音。自动：你的 V 的声音。女性化或男性化：始终使用该声音。");
    this.Text("CyberGrapple-VoiceGender-Auto", "自动");
    this.Text("CyberGrapple-VoiceGender-Female", "女性化");
    this.Text("CyberGrapple-VoiceGender-Male", "男性化");
    this.Text("CyberGrapple-VoicePullChance", "拉人台词频率");
    this.Text("CyberGrapple-VoicePullChance-Description", "以百分比表示，每 10 次精确计算：抓钩开始将人物拉向 V 时，V 说台词的频率。");
    this.Text("CyberGrapple-VoiceKillChance", "处决台词频率");
    this.Text("CyberGrapple-VoiceKillChance-Description", "以百分比表示，每 10 次精确计算：V 杀死或非致命击倒被抓钩拉来并钳制的人物时，说台词的频率。");
    this.Text("CyberGrapple-VoiceKillStyle", "处决台词样式");
    this.Text("CyberGrapple-VoiceKillStyle-Description", "V 说处决台词的方式。普通：大声说出。耳语：V 低声耳语。普通 + 耳语：两者随机混合。");
    this.Text("CyberGrapple-VoiceKillStyle-Normal", "普通");
    this.Text("CyberGrapple-VoiceKillStyle-Whisper", "耳语");
    this.Text("CyberGrapple-VoiceKillStyle-Both", "普通 + 耳语");
  }
}
