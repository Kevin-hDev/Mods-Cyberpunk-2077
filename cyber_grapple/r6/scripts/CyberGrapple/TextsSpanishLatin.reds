// Latin American Spanish, for the game's es-mx language: derived from CyberGrappleSpanish, it holds only the texts
// where the game uses another word in Latin America.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleSpanishLatin extends CyberGrappleSpanish {
  protected func DefineTexts() {
    super.DefineTexts();
    this.Text("CyberGrapple-Enabled-Description", "Con el implante Sistema de gancho instalado (los matasanos lo venden) y asignado al espacio rápido de dispositivos de combate, apunta a una superficie y oprime la tecla «Usar dispositivo de combate» (botón central del ratón si juegas con teclado; R1 en el control): el gancho sale disparado y la cuerda tira de ti, mientras tu puntería te dirige. Desactivado: el implante sigue instalado sin hacer nada.");
    this.Text("CyberGrapple-ControllerHold", "Control: mantener para lanzar el gancho");
    this.Text("CyberGrapple-Silent-OtherUnread", "El implante de gancho está desactivado: Apex Grapple está instalado y no se pudo leer su interruptor. Mueve Apex Grapple fuera de la carpeta del juego para usar el implante. Tu partida guardada no se modifica.");
    this.Text("CyberGrapple-Silent-NoRecords", "Cyber Grapple: no se pudo añadir el implante Sistema de gancho a esta versión del juego. El mod no hace nada hasta que se actualice.");
    this.Text("CyberGrapple-Upgrade-Waiting", "Cyber Grapple: no se pudo leer, en esta versión del juego, el nivel del personaje que piden algunas mejoras del Sistema de gancho. Esas mejoras no piden ningún nivel del personaje hasta que se actualice el mod.");
  }
}
