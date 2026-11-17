// Italian texts, for the game's it-it language. This class holds every key shown, menu and card alike,
// because all four providers return it for this language (Languages.reds).

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleItalian extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Enabled", "Cyber Grapple");
    this.Text("CyberGrapple-Enabled-Description", "Con l'impianto Sistema di lancio rampino installato (i bisturi lo vendono) e assegnato allo slot rapido gadget da combattimento, mira a una superficie e premi il tasto «Usa gadget da combattimento» (tasto centrale del mouse con la tastiera; R1 su controller): il gancio parte e la corda ti tira, mentre la mira ti guida. Disattivato: l'impianto resta installato senza fare nulla.");
    this.Text("CyberGrapple-Profile1-Key", "Tasto");
    this.Text("CyberGrapple-Profile1-Fov", "Campo visivo");
    this.Text("CyberGrapple-OwnKey", "Tasto dedicato");
    this.Text("CyberGrapple-OwnKey-Description", "Usa il rampino con un tasto a tua scelta invece del tasto «Usa gadget da combattimento», che resta così libero per le tue granate.");
    this.Text("CyberGrapple-Key", "Tasto");
    this.Text("CyberGrapple-Key-Description", "Il tasto del rampino, usato quando «Tasto dedicato» è attivato. La rotellina del mouse non può essere usata.");
    this.Text("CyberGrapple-KeyboardHold", "Tastiera: tieni premuto per il rampino");
    this.Text("CyberGrapple-KeyboardHold-Description", "Tieni premuto il tasto per usare il rampino. Con il tasto dell'attacco corpo a corpo rapido, una pressione breve esegue comunque l'attacco corpo a corpo rapido. Non vale per il tasto dello scanner, perché tenerlo premuto apre lo scanner.");
    this.Text("CyberGrapple-ControllerHold", "Controller: tieni premuto per il rampino");
    this.Text("CyberGrapple-ControllerHold-Description", "Tieni premuto il pulsante per usare il rampino. Con il pulsante dell'attacco corpo a corpo rapido, una pressione breve esegue comunque l'attacco corpo a corpo rapido. Non vale per il pulsante dello scanner (L1), perché tenerlo premuto apre lo scanner.");
    this.Text("CyberGrapple-HoldTime", "Durata pressione");
    this.Text("CyberGrapple-HoldTime-Description", "Per quanto tempo tenere premuto per usare il rampino, in secondi.");
    this.Text("CyberGrapple-Crosshair", "Mirino a mani vuote e con i Pugni");
    this.Text("CyberGrapple-CrosshairShape-Simple", "Semplice");
    this.Text("CyberGrapple-CrosshairShape-Basic", "Base");
    this.Text("CyberGrapple-CrosshairShape-Shotgun", "Fucile a pompa");
    this.Text("CyberGrapple-CrosshairShape-SmartRifle", "Smart");
    this.Text("CyberGrapple-CrosshairShape-TechCircle", "Tecnologica, rotonda");
    this.Text("CyberGrapple-CrosshairShape-TechHex", "Tecnologica, esagonale");
    this.Text("CyberGrapple-CrosshairShape-Launcher", "Sistema di lancio proiettili");
    this.Text("CyberGrapple-CrosshairShape-MantisBlades", "Lame da mantide");
    this.Text("CyberGrapple-CrosshairShape-HeavyMachineGun", "Mitragliatrice pesante");
    this.Text("CyberGrapple-CrosshairShape-Dot", "Punto al centro dello schermo");
    this.Text("CyberGrapple-CrosshairColor", "Colore");
    this.Text("CyberGrapple-CrosshairColor-Description", "Il colore del mirino. Il turchese è il colore dei mirini del gioco.");
    this.Text("CyberGrapple-CrosshairColor-Yellow", "Giallo");
    this.Text("CyberGrapple-CrosshairColor-White", "Bianco");
    this.Text("CyberGrapple-CrosshairColor-Red", "Rosso");
    this.Text("CyberGrapple-CrosshairColor-Green", "Verde");
    this.Text("CyberGrapple-CrosshairColor-Turquoise", "Turchese (quello del gioco)");
    this.Text("CyberGrapple-CrosshairSize", "Dimensioni");
    this.Text("CyberGrapple-CrosshairSize-Description", "Le dimensioni del mirino, in percentuale di quelle del gioco.");
    this.Text("CyberGrapple-CrosshairRange", "Indicatore di portata");
    this.Text("CyberGrapple-CrosshairRange-Description", "Il mirino prende il colore fuori portata quando una pressione non lancerebbe il rampino: nessuna carica rimasta, l'impianto non è nello slot rapido gadget da combattimento (con «Tasto dedicato» disattivato), niente a portata, il cielo, una persona o un veicolo in mezzo che il Grado dell'impianto non può ancora prendere, una persona o una moto oltre la distanza da cui può essere tirata, qualcuno a portata dell'attacco corpo a corpo rapido, oppure il rampino ancora fuori.");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor", "Colore fuori portata");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor-Description", "Il colore del mirino quando il rampino non partirebbe. Scegline uno diverso da quello del mirino: con lo stesso colore, l'indicatore è disattivato.");
    this.Text("CyberGrapple-DynamicFov", "Campo visivo dinamico");
    this.Text("CyberGrapple-DynamicFov-Description", "Mentre la corda tira V, il campo visivo si allarga, poi torna normale quando la trazione finisce. Solo in prima persona, e non mentre si mira con un'arma. Disattivato: il campo visivo resta quello delle impostazioni del gioco.");
    this.Text("CyberGrapple-FovWidening", "Ampliamento del campo visivo");
    this.Text("CyberGrapple-FovWidening-Description", "Si aggiunge all'impostazione Campo visivo del gioco, negli stessi gradi: 10 porta 100 a 110. Il totale si ferma a 140.");
    this.Text("CyberGrapple-FovTransition", "Transizione del campo visivo");
    this.Text("CyberGrapple-FovTransition-Description", "In secondi: il tempo che il campo visivo impiega ad allargarsi quando inizia la trazione e a tornare normale quando finisce.");
    this.Text("CyberGrapple-Card-Name", "Sistema di lancio rampino");
    this.Text("CyberGrapple-Card-Description", "Un impianto per il braccio che lancia un gancio legato a una corda al posto dei proiettili.");
    this.Text("CyberGrapple-Card-Travel", "Lancia un rampino che ti trascina fino alla superficie su cui miri.");
    this.Text("CyberGrapple-Card-Pull20", "Tira verso di te una persona, un nemico o una moto, da una distanza massima di 20 m.");
    this.Text("CyberGrapple-Card-Pull25", "Tira verso di te una persona, un nemico o una moto, da una distanza massima di 25 m.");
    this.Text("CyberGrapple-Card-Pull30", "Tira verso di te una persona, un nemico o una moto, da una distanza massima di 30 m.");
    this.Text("CyberGrapple-Card-Pull35", "Tira verso di te una persona, un nemico o una moto, da una distanza massima di 35 m.");
    this.Text("CyberGrapple-Card-Pull40", "Tira verso di te una persona, un nemico o una moto, da una distanza massima di 40 m.");
    this.Text("CyberGrapple-Card-Range", "PORTATA");
    this.Text("CyberGrapple-Card-TopSpeed", "VELOCITÀ MAX.");
    this.Text("CyberGrapple-Card-Seize", "Porta una persona fino a te e la afferra.");
    this.Text("CyberGrapple-Card-Next10", "Il potenziamento al Grado 2 richiede il Livello personaggio 10.");
    this.Text("CyberGrapple-Card-Next20", "Il potenziamento al Grado 3 richiede il Livello personaggio 20.");
    this.Text("CyberGrapple-Card-Next30", "Il potenziamento al Grado 4 richiede il Livello personaggio 30.");
    this.Text("CyberGrapple-Card-Next40", "Il potenziamento al Grado 5 richiede il Livello personaggio 40.");
    this.Text("CyberGrapple-Card-Distance", "{n} m");
    this.Text("CyberGrapple-Card-Speed", "{n} m/s");
    this.Text("CyberGrapple-Card-DecimalMark", ",");
    this.Text("CyberGrapple-Silent-OtherOn", "L'impianto rampino è spento finché Apex Grapple è acceso. Spegni Apex Grapple nelle sue impostazioni per usare l'impianto. Il tuo salvataggio non viene modificato.");
    this.Text("CyberGrapple-Silent-OtherUnread", "L'impianto rampino è spento: Apex Grapple è installato e non è stato possibile leggere il suo interruttore. Sposta Apex Grapple fuori dalla cartella del gioco per usare l'impianto. Il tuo salvataggio non viene modificato.");
    this.Text("CyberGrapple-Silent-NoTweakXL", "Cyber Grapple: l'impianto Sistema di lancio rampino non esiste in questo gioco perché TweakXL non è installato. Installa TweakXL e RED4ext, poi riavvia il gioco.");
    this.Text("CyberGrapple-Silent-NoRecords", "Cyber Grapple: non è stato possibile aggiungere l'impianto Sistema di lancio rampino a questa versione del gioco. Il mod non fa nulla finché non viene aggiornato.");
    this.Text("CyberGrapple-Upgrade-Waiting", "Cyber Grapple: non è stato possibile leggere, in questa versione del gioco, il livello richiesto da alcuni potenziamenti del Sistema di lancio rampino. Questi potenziamenti non richiedono alcun livello finché il mod non viene aggiornato.");
    this.Text("CyberGrapple-CrosshairSource", "Mirino");
    this.Text("CyberGrapple-CrosshairSource-Description", "Quale mirino viene mostrato mentre V ha le mani vuote o combatte con i Pugni. Cyber Grapple: il mirino di questo mod, per puntare il rampino ogni volta che può partire. Gioco: non viene aggiunto nulla, come nel gioco, che in quel caso non mostra alcun mirino.");
    this.Text("CyberGrapple-CrosshairSource-Mod", "Cyber Grapple");
    this.Text("CyberGrapple-CrosshairSource-Game", "Gioco");
    this.Text("CyberGrapple-CrosshairPick", "Forma del mirino");
    this.Text("CyberGrapple-CrosshairPick-Description", "La forma del mirino di questo mod. Viene nascosto non appena V impugna un'arma o un cyberware per le braccia, che hanno un mirino proprio, e nei veicoli, con lo scanner e durante le scene.");
  }
}
