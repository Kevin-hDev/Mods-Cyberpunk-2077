// German texts, for the game's de-de language. This class holds every key shown, menu and card alike,
// because all four providers return it for this language (Languages.reds).

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleGerman extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Enabled", "Cyber Grapple");
    this.Text("CyberGrapple-Enabled-Description", "Ist das Implantat Enterhaken-System installiert (Ripperdocs verkaufen es) und dem Kampfgadget-Quickslot zugewiesen, ziele auf eine Oberfläche und drücke die Taste „Kampfgadget benutzen“ (mittlere Maustaste bei Tastatursteuerung; R1 auf dem Controller): Der Haken fliegt los und das Seil zieht dich, während du mit deinem Zielen die Richtung bestimmst. Aus: Das Implantat bleibt installiert und tut nichts.");
    this.Text("CyberGrapple-Profile1-Key", "Taste");
    this.Text("CyberGrapple-Profile1-Fov", "Sichtfeld");
    this.Text("CyberGrapple-OwnKey", "Eigene Taste");
    this.Text("CyberGrapple-OwnKey-Description", "Löse den Enterhaken mit einer Taste deiner Wahl aus statt mit der Taste „Kampfgadget benutzen“, die dann für deine Granaten frei bleibt.");
    this.Text("CyberGrapple-Key", "Taste");
    this.Text("CyberGrapple-Key-Description", "Die Taste für den Enterhaken, die gilt, wenn „Eigene Taste“ an ist. Das Mausrad kann nicht verwendet werden.");
    this.Text("CyberGrapple-KeyboardHold", "Tastatur: Halten für Enterhaken");
    this.Text("CyberGrapple-KeyboardHold-Description", "Halte die Taste, um den Enterhaken auszulösen. Bei der Taste für den schnellen Nahkampfangriff löst ein kurzes Antippen weiterhin den schnellen Nahkampfangriff aus. Nicht bei der Scanner-Taste, die zum Öffnen gehalten wird.");
    this.Text("CyberGrapple-ControllerHold", "Controller: Halten für Enterhaken");
    this.Text("CyberGrapple-ControllerHold-Description", "Halte den Knopf, um den Enterhaken auszulösen. Bei dem Knopf für den schnellen Nahkampfangriff löst ein kurzes Antippen weiterhin den schnellen Nahkampfangriff aus. Nicht bei dem Scanner-Knopf (L1), der zum Öffnen gehalten wird.");
    this.Text("CyberGrapple-HoldTime", "Haltedauer");
    this.Text("CyberGrapple-HoldTime-Description", "Wie lange du halten musst, um den Enterhaken auszulösen, in Sekunden.");
    this.Text("CyberGrapple-Crosshair", "Fadenkreuz bei leeren Händen und Fäusten");
    this.Text("CyberGrapple-CrosshairShape-Simple", "Schlicht");
    this.Text("CyberGrapple-CrosshairShape-Basic", "Einfach");
    this.Text("CyberGrapple-CrosshairShape-Shotgun", "Schrotflinte");
    this.Text("CyberGrapple-CrosshairShape-SmartRifle", "Smart");
    this.Text("CyberGrapple-CrosshairShape-TechCircle", "Tech, rund");
    this.Text("CyberGrapple-CrosshairShape-TechHex", "Tech, sechseckig");
    this.Text("CyberGrapple-CrosshairShape-Launcher", "Raketen-Abschuss-System");
    this.Text("CyberGrapple-CrosshairShape-MantisBlades", "Mantisklingen");
    this.Text("CyberGrapple-CrosshairShape-HeavyMachineGun", "Schweres Maschinengewehr");
    this.Text("CyberGrapple-CrosshairShape-Dot", "Punkt in Bildschirmmitte");
    this.Text("CyberGrapple-CrosshairColor", "Farbe");
    this.Text("CyberGrapple-CrosshairColor-Description", "Die Farbe des Fadenkreuzes. Türkis ist die Farbe der Fadenkreuze des Spiels.");
    this.Text("CyberGrapple-CrosshairColor-Yellow", "Gelb");
    this.Text("CyberGrapple-CrosshairColor-White", "Weiß");
    this.Text("CyberGrapple-CrosshairColor-Red", "Rot");
    this.Text("CyberGrapple-CrosshairColor-Green", "Grün");
    this.Text("CyberGrapple-CrosshairColor-Turquoise", "Türkis (die des Spiels)");
    this.Text("CyberGrapple-CrosshairSize", "Größe");
    this.Text("CyberGrapple-CrosshairSize-Description", "Die Größe des Fadenkreuzes, in Prozent der Größe der Fadenkreuze des Spiels.");
    this.Text("CyberGrapple-CrosshairRange", "Reichweitenanzeige");
    this.Text("CyberGrapple-CrosshairRange-Description", "Das Fadenkreuz nimmt die Farbe außer Reichweite an, wenn ein Tastendruck den Enterhaken nicht abfeuern würde: keine Ladung mehr übrig, das Implantat ist nicht im Kampfgadget-Quickslot (wenn „Eigene Taste“ auf Aus steht), nichts in Reichweite, der Himmel, eine Person oder ein Fahrzeug im Weg, die oder das die Kategorie des Implantats noch nicht packen kann, eine Person oder ein Motorrad jenseits der Entfernung, aus der sie gezogen werden können, jemand in Reichweite des schnellen Nahkampfangriffs oder der Enterhaken ist noch ausgeworfen.");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor", "Farbe außer Reichweite");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor-Description", "Die Farbe des Fadenkreuzes, wenn der Enterhaken nicht abgefeuert würde. Wähle eine andere als die Farbe des Fadenkreuzes: Bei gleicher Farbe ist die Anzeige aus.");
    this.Text("CyberGrapple-DynamicFov", "Dynamisches Sichtfeld");
    this.Text("CyberGrapple-DynamicFov-Description", "Solange das Seil V zieht, wird das Sichtfeld breiter und kehrt zurück, wenn der Zug endet. Nur in der Ego-Perspektive und nicht beim Zielen mit einer Waffe. Aus: Das Sichtfeld bleibt so, wie es in den Einstellungen des Spiels festgelegt ist.");
    this.Text("CyberGrapple-FovWidening", "Sichtfeld-Erweiterung");
    this.Text("CyberGrapple-FovWidening-Description", "Wird zur Sichtfeld-Einstellung des Spiels addiert, ebenfalls in Grad: Mit 10 wird aus 100 110. Die Summe beträgt höchstens 140.");
    this.Text("CyberGrapple-FovTransition", "Sichtfeld-Übergang");
    this.Text("CyberGrapple-FovTransition-Description", "In Sekunden: die Zeit, die das Sichtfeld braucht, um sich zu weiten, wenn der Zug beginnt, und um zurückzukehren, wenn er endet.");
    this.Text("CyberGrapple-Card-Name", "Enterhaken-System");
    this.Text("CyberGrapple-Card-Description", "Ein Armimplantat, das statt Projektilen einen Haken an einem Seil abfeuert.");
    this.Text("CyberGrapple-Card-Travel", "Feuert einen Enterhaken ab, der dich zur anvisierten Oberfläche zieht.");
    this.Text("CyberGrapple-Card-Pull20", "Zieht eine Person, einen Gegner oder ein Motorrad aus bis zu 20 m Entfernung zu dir.");
    this.Text("CyberGrapple-Card-Pull25", "Zieht eine Person, einen Gegner oder ein Motorrad aus bis zu 25 m Entfernung zu dir.");
    this.Text("CyberGrapple-Card-Pull30", "Zieht eine Person, einen Gegner oder ein Motorrad aus bis zu 30 m Entfernung zu dir.");
    this.Text("CyberGrapple-Card-Pull35", "Zieht eine Person, einen Gegner oder ein Motorrad aus bis zu 35 m Entfernung zu dir.");
    this.Text("CyberGrapple-Card-Pull40", "Zieht eine Person, einen Gegner oder ein Motorrad aus bis zu 40 m Entfernung zu dir.");
    this.Text("CyberGrapple-Card-Range", "REICHWEITE");
    this.Text("CyberGrapple-Card-TopSpeed", "MAX. TEMPO");
    this.Text("CyberGrapple-Card-Seize", "Zieht eine Person ganz zu dir heran und packt sie.");
    this.Text("CyberGrapple-Card-Next10", "Das Upgrade auf Kategorie 2 erfordert Charakterlevel 10.");
    this.Text("CyberGrapple-Card-Next20", "Das Upgrade auf Kategorie 3 erfordert Charakterlevel 20.");
    this.Text("CyberGrapple-Card-Next30", "Das Upgrade auf Kategorie 4 erfordert Charakterlevel 30.");
    this.Text("CyberGrapple-Card-Next40", "Das Upgrade auf Kategorie 5 erfordert Charakterlevel 40.");
    this.Text("CyberGrapple-Card-Distance", "{n} m");
    this.Text("CyberGrapple-Card-Speed", "{n} m/s");
    this.Text("CyberGrapple-Card-DecimalMark", ",");
    this.Text("CyberGrapple-Silent-OtherOn", "Das Enterhaken-Implantat ist aus, solange Apex Grapple an ist. Schalte Apex Grapple in seinen Einstellungen aus, um das Implantat zu nutzen. Dein Spielstand wird nicht verändert.");
    this.Text("CyberGrapple-Silent-OtherUnread", "Das Enterhaken-Implantat ist aus: Apex Grapple ist installiert, und sein Schalter konnte nicht gelesen werden. Verschiebe Apex Grapple aus dem Ordner des Spiels, um das Implantat zu nutzen. Dein Spielstand wird nicht verändert.");
    this.Text("CyberGrapple-Silent-NoTweakXL", "Cyber Grapple: Das Implantat Enterhaken-System existiert in diesem Spiel nicht, weil TweakXL nicht installiert ist. Installiere TweakXL und RED4ext und starte das Spiel dann erneut.");
    this.Text("CyberGrapple-Silent-NoRecords", "Cyber Grapple: Das Implantat Enterhaken-System konnte dieser Version des Spiels nicht hinzugefügt werden. Die Mod tut nichts, bis sie aktualisiert wird.");
    this.Text("CyberGrapple-Upgrade-Waiting", "Cyber Grapple: Das Level, das manche Upgrades des Enterhaken-Systems verlangen, konnte in dieser Version des Spiels nicht gelesen werden. Diese Upgrades verlangen kein Level, bis die Mod aktualisiert wird.");
    this.Text("CyberGrapple-CrosshairSource", "Fadenkreuz");
    this.Text("CyberGrapple-CrosshairSource-Description", "Wessen Fadenkreuz angezeigt wird, solange die Hände von V leer sind oder V mit Fäusten kämpft. Cyber Grapple: das Fadenkreuz dieser Mod, um den Enterhaken auszurichten, sobald er abgefeuert werden kann. Spiel: Es wird nichts hinzugefügt, wie im Spiel, das dort kein Fadenkreuz zeigt.");
    this.Text("CyberGrapple-CrosshairSource-Mod", "Cyber Grapple");
    this.Text("CyberGrapple-CrosshairSource-Game", "Spiel");
    this.Text("CyberGrapple-CrosshairPick", "Form des Fadenkreuzes");
    this.Text("CyberGrapple-CrosshairPick-Description", "Die Form des Fadenkreuzes dieser Mod. Es wird ausgeblendet, sobald V eine Waffe oder Arm-Cyberware hält, die ein eigenes Fadenkreuz haben, sowie in Fahrzeugen, mit dem Scanner und in Szenen.");
    this.Text("CyberGrapple-Impact", "Aufprall des Hakens");
    this.Text("CyberGrapple-ImpactEffect", "Aufpralleffekt");
    this.Text("CyberGrapple-ImpactEffect-Description", "Einer der Aufpralleffekte des Spiels, einmal dort angezeigt, wo der Haken eine Oberfläche oder ein Fahrzeug trifft. Keiner bei einer Person oder einem Motorrad. Aus: Wo der Haken trifft, erscheint nichts.");
    this.Text("CyberGrapple-ImpactStyle", "Stil des Aufpralleffekts");
    this.Text("CyberGrapple-ImpactStyle-Description", "Welcher Aufpralleffekt des Spiels angezeigt wird. Jeder ist nach dem benannt, was ihn im Spiel erzeugt: der getroffenen Oberfläche und der Waffe.");
    this.Text("CyberGrapple-ImpactStyle-ConcreteBullet", "Beton, Kugel");
    this.Text("CyberGrapple-ImpactStyle-ConcreteLargeCaliber", "Beton, großes Kaliber");
    this.Text("CyberGrapple-ImpactStyle-ConcreteHammer", "Beton, Hammer");
    this.Text("CyberGrapple-ImpactStyle-MetalHammer", "Metall, Hammer");
    this.Text("CyberGrapple-ImpactStyle-Monowire", "Monodraht");
    this.Text("CyberGrapple-ImpactStyle-DefaultBullet", "Allgemein, Kugel");
    this.Text("CyberGrapple-Voice", "Stimme von V");
    this.Text("CyberGrapple-VoiceLines", "Sprüche");
    this.Text("CyberGrapple-VoiceLines-Description", "V sagt einen Spruch, wenn der Enterhaken beginnt, eine Person zu V zu ziehen, und einen weiteren, wenn V eine Person tötet oder nichttödlich ausschaltet, die der Enterhaken herangezogen und gepackt hat. Erfordert Audioware, das die Sprüche abspielt. Aus: V sagt nichts.");
    this.Text("CyberGrapple-VoiceGender", "Stimmlage");
    this.Text("CyberGrapple-VoiceGender-Description", "Wessen Stimme die Sprüche sagt. Automatisch: die Stimme deines V. Feminin oder Maskulin: immer diese Stimmlage.");
    this.Text("CyberGrapple-VoiceGender-Auto", "Automatisch");
    this.Text("CyberGrapple-VoiceGender-Female", "Feminin");
    this.Text("CyberGrapple-VoiceGender-Male", "Maskulin");
    this.Text("CyberGrapple-VoicePullChance", "Häufigkeit des Spruchs beim Ziehen");
    this.Text("CyberGrapple-VoicePullChance-Description", "In Prozent, genau auf je 10 Züge: wie oft V einen Spruch sagt, wenn der Enterhaken beginnt, eine Person zu V zu ziehen.");
    this.Text("CyberGrapple-VoiceKillChance", "Häufigkeit des Spruchs beim Takedown");
    this.Text("CyberGrapple-VoiceKillChance-Description", "In Prozent, genau auf je 10 Takedowns: wie oft V einen Spruch sagt, wenn V eine Person tötet oder nichttödlich ausschaltet, die der Enterhaken herangezogen und gepackt hat.");
    this.Text("CyberGrapple-VoiceKillStyle", "Stil der Sprüche beim Takedown");
    this.Text("CyberGrapple-VoiceKillStyle-Description", "Wie V die Sprüche beim Takedown sagt. Normal: laut. Flüstern: V flüstert sie. Normal + Flüstern: beides, zufällig gemischt.");
    this.Text("CyberGrapple-VoiceKillStyle-Normal", "Normal");
    this.Text("CyberGrapple-VoiceKillStyle-Whisper", "Flüstern");
    this.Text("CyberGrapple-VoiceKillStyle-Both", "Normal + Flüstern");
  }
}
