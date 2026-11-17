// Spanish texts, for the game's es-es language. This class holds every key shown, menu and card alike,
// because all four providers return it for this language (Languages.reds).

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleSpanish extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Enabled", "Cyber Grapple");
    this.Text("CyberGrapple-Enabled-Description", "Con el implante Sistema de gancho instalado (los matasanos lo venden) y asignado al espacio rápido de dispositivos de combate, apunta a una superficie y pulsa la tecla «Usar dispositivo de combate» (botón central del ratón si juegas con teclado; R1 en el mando): el gancho sale disparado y la cuerda tira de ti, mientras tu puntería te dirige. Desactivado: el implante sigue instalado sin hacer nada.");
    this.Text("CyberGrapple-Profile1-Key", "Tecla");
    this.Text("CyberGrapple-Profile1-Fov", "Campo de visión");
    this.Text("CyberGrapple-OwnKey", "Tecla propia");
    this.Text("CyberGrapple-OwnKey-Description", "Lanza el gancho con una tecla de tu elección en lugar de la tecla «Usar dispositivo de combate», que queda así libre para tus granadas.");
    this.Text("CyberGrapple-Key", "Tecla");
    this.Text("CyberGrapple-Key-Description", "La tecla del gancho, que se usa cuando «Tecla propia» está activada. No se puede usar la rueda del ratón.");
    this.Text("CyberGrapple-KeyboardHold", "Teclado: mantener para lanzar el gancho");
    this.Text("CyberGrapple-KeyboardHold-Description", "Mantén la tecla para lanzar el gancho. Con la tecla de ataque rápido cuerpo a cuerpo, un toque breve sigue haciendo el ataque rápido cuerpo a cuerpo. No vale para la tecla del escáner, que se abre al mantenerla.");
    this.Text("CyberGrapple-ControllerHold", "Mando: mantener para lanzar el gancho");
    this.Text("CyberGrapple-ControllerHold-Description", "Mantén el botón para lanzar el gancho. Con el botón de ataque rápido cuerpo a cuerpo, un toque breve sigue haciendo el ataque rápido cuerpo a cuerpo. No vale para el botón del escáner (L1), que se abre al mantenerlo.");
    this.Text("CyberGrapple-HoldTime", "Tiempo para mantener");
    this.Text("CyberGrapple-HoldTime-Description", "Cuánto tiempo hay que mantener para lanzar el gancho, en segundos.");
    this.Text("CyberGrapple-Crosshair", "Mira con manos vacías y Puños");
    this.Text("CyberGrapple-CrosshairShape-Simple", "Simple");
    this.Text("CyberGrapple-CrosshairShape-Basic", "Básica");
    this.Text("CyberGrapple-CrosshairShape-Shotgun", "Escopeta");
    this.Text("CyberGrapple-CrosshairShape-SmartRifle", "Inteligente");
    this.Text("CyberGrapple-CrosshairShape-TechCircle", "Tecnológica, redonda");
    this.Text("CyberGrapple-CrosshairShape-TechHex", "Tecnológica, hexagonal");
    this.Text("CyberGrapple-CrosshairShape-Launcher", "Sistema de lanzamiento de proyectiles");
    this.Text("CyberGrapple-CrosshairShape-MantisBlades", "Garras mantis");
    this.Text("CyberGrapple-CrosshairShape-HeavyMachineGun", "Ametralladora pesada");
    this.Text("CyberGrapple-CrosshairShape-Dot", "Punto en el centro de la pantalla");
    this.Text("CyberGrapple-CrosshairColor", "Color");
    this.Text("CyberGrapple-CrosshairColor-Description", "El color de la mira. El turquesa es el color de las miras del juego.");
    this.Text("CyberGrapple-CrosshairColor-Yellow", "Amarillo");
    this.Text("CyberGrapple-CrosshairColor-White", "Blanco");
    this.Text("CyberGrapple-CrosshairColor-Red", "Rojo");
    this.Text("CyberGrapple-CrosshairColor-Green", "Verde");
    this.Text("CyberGrapple-CrosshairColor-Turquoise", "Turquesa (el del juego)");
    this.Text("CyberGrapple-CrosshairSize", "Tamaño");
    this.Text("CyberGrapple-CrosshairSize-Description", "El tamaño de la mira, en porcentaje del de las miras del juego.");
    this.Text("CyberGrapple-CrosshairRange", "Indicador de alcance");
    this.Text("CyberGrapple-CrosshairRange-Description", "La mira toma el color fuera de alcance cuando el gancho no se lanzaría al usarlo: no queda ninguna carga, el implante no está en el espacio rápido de dispositivos de combate (con «Tecla propia» desactivada), no hay nada al alcance, el cielo, una persona o un vehículo en medio que el nivel del implante todavía no es capaz de atraer, una persona o una moto más allá de la distancia desde la que se puede atraer, alguien al alcance del ataque rápido cuerpo a cuerpo, o el gancho sigue fuera.");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor", "Color fuera de alcance");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor-Description", "El color de la mira cuando el gancho no se lanzaría. Elige uno distinto del color de la mira: con el mismo color, el indicador queda desactivado.");
    this.Text("CyberGrapple-DynamicFov", "Campo de visión dinámico");
    this.Text("CyberGrapple-DynamicFov-Description", "Mientras la cuerda tira de V, el campo de visión se amplía y vuelve a la normalidad cuando el tirón se detiene. Solo en primera persona, y no al apuntar con un arma. Desactivado: el campo de visión se queda como está en los ajustes del juego.");
    this.Text("CyberGrapple-FovWidening", "Ampliación del campo de visión");
    this.Text("CyberGrapple-FovWidening-Description", "Se suma al ajuste Campo de visión del juego, en los mismos grados: 10 convierte 100 en 110. El total se detiene en 140.");
    this.Text("CyberGrapple-FovTransition", "Transición del campo de visión");
    this.Text("CyberGrapple-FovTransition-Description", "En segundos: el tiempo que tarda el campo de visión en ampliarse cuando empieza el tirón y en volver cuando se detiene.");
    this.Text("CyberGrapple-Card-Name", "Sistema de gancho");
    this.Text("CyberGrapple-Card-Description", "Un implante de brazo que dispara un gancho atado a una cuerda en lugar de proyectiles.");
    this.Text("CyberGrapple-Card-Travel", "Dispara un gancho que te lleva hasta la superficie a la que apuntas.");
    this.Text("CyberGrapple-Card-Pull20", "Atrae hacia ti a una persona, un enemigo o una moto a una distancia de hasta 20 m.");
    this.Text("CyberGrapple-Card-Pull25", "Atrae hacia ti a una persona, un enemigo o una moto a una distancia de hasta 25 m.");
    this.Text("CyberGrapple-Card-Pull30", "Atrae hacia ti a una persona, un enemigo o una moto a una distancia de hasta 30 m.");
    this.Text("CyberGrapple-Card-Pull35", "Atrae hacia ti a una persona, un enemigo o una moto a una distancia de hasta 35 m.");
    this.Text("CyberGrapple-Card-Pull40", "Atrae hacia ti a una persona, un enemigo o una moto a una distancia de hasta 40 m.");
    this.Text("CyberGrapple-Card-Range", "ALCANCE");
    this.Text("CyberGrapple-Card-TopSpeed", "VELOCIDAD MÁX.");
    this.Text("CyberGrapple-Card-Seize", "Trae a una persona hasta ti y la agarra.");
    this.Text("CyberGrapple-Card-Next10", "Mejorar al nivel 2 requiere un personaje de nivel 10.");
    this.Text("CyberGrapple-Card-Next20", "Mejorar al nivel 3 requiere un personaje de nivel 20.");
    this.Text("CyberGrapple-Card-Next30", "Mejorar al nivel 4 requiere un personaje de nivel 30.");
    this.Text("CyberGrapple-Card-Next40", "Mejorar al nivel 5 requiere un personaje de nivel 40.");
    this.Text("CyberGrapple-Card-Distance", "{n} m");
    this.Text("CyberGrapple-Card-Speed", "{n} m/s");
    this.Text("CyberGrapple-Card-DecimalMark", ",");
    this.Text("CyberGrapple-Silent-OtherOn", "El implante de gancho está desactivado mientras Apex Grapple esté activado. Desactiva Apex Grapple en sus ajustes para usar el implante. Tu partida guardada no se modifica.");
    this.Text("CyberGrapple-Silent-OtherUnread", "El implante de gancho está desactivado: Apex Grapple está instalado y no se ha podido leer su interruptor. Mueve Apex Grapple fuera de la carpeta del juego para usar el implante. Tu partida guardada no se modifica.");
    this.Text("CyberGrapple-Silent-NoTweakXL", "Cyber Grapple: el implante Sistema de gancho no existe en este juego porque TweakXL no está instalado. Instala TweakXL y RED4ext, y vuelve a iniciar el juego.");
    this.Text("CyberGrapple-Silent-NoRecords", "Cyber Grapple: no se ha podido añadir el implante Sistema de gancho a esta versión del juego. El mod no hace nada hasta que se actualice.");
    this.Text("CyberGrapple-Upgrade-Waiting", "Cyber Grapple: no se ha podido leer, en esta versión del juego, el nivel del personaje que piden algunas mejoras del Sistema de gancho. Esas mejoras no piden ningún nivel del personaje hasta que se actualice el mod.");
    this.Text("CyberGrapple-CrosshairSource", "Mira");
    this.Text("CyberGrapple-CrosshairSource-Description", "Qué mira se muestra mientras V tiene las manos vacías o lucha con los Puños. Cyber Grapple: la mira de este mod, para apuntar con el gancho siempre que pueda dispararse. Juego: no se añade nada, como en el juego, que no muestra ninguna mira ahí.");
    this.Text("CyberGrapple-CrosshairSource-Mod", "Cyber Grapple");
    this.Text("CyberGrapple-CrosshairSource-Game", "Juego");
    this.Text("CyberGrapple-CrosshairPick", "Forma de la mira");
    this.Text("CyberGrapple-CrosshairPick-Description", "La forma de la mira de este mod. Se oculta en cuanto V sostiene un arma o ciberware de los brazos, que tienen su propia mira, y también en vehículos, con el escáner y durante las escenas.");
  }
}
