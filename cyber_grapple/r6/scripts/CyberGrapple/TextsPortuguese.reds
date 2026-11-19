// Brazilian Portuguese texts, for the game's pt-br language. This class holds every key shown, menu and card alike,
// because all four providers return it for this language (Languages.reds).

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class CyberGrapplePortuguese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Enabled", "Cyber Grapple");
    this.Text("CyberGrapple-Enabled-Description", "Com o implante Sistema lança-arpéu instalado (os medicânicos vendem) e atribuído ao espaço rápido de acessório de combate, mire em uma superfície e aperte a tecla “Usar acessório de combate” (botão do meio do mouse com o teclado; R1 no controle): o gancho dispara e a corda puxa você, enquanto a sua mira guia o movimento. Desligado: o implante continua instalado sem fazer nada.");
    this.Text("CyberGrapple-Profile1-Key", "Tecla");
    this.Text("CyberGrapple-Profile1-Fov", "Campo de visão");
    this.Text("CyberGrapple-OwnKey", "Tecla própria");
    this.Text("CyberGrapple-OwnKey-Description", "Lance o arpéu com uma tecla à sua escolha em vez da tecla “Usar acessório de combate”, que fica assim livre para as suas granadas.");
    this.Text("CyberGrapple-Key", "Tecla");
    this.Text("CyberGrapple-Key-Description", "A tecla do arpéu, usada quando “Tecla própria” está ligada. A roda do mouse não pode ser usada.");
    this.Text("CyberGrapple-KeyboardHold", "Teclado: segurar para lançar o arpéu");
    this.Text("CyberGrapple-KeyboardHold-Description", "Segure a tecla para lançar o arpéu. Com a tecla de ataque corpo a corpo rápido, um toque ainda faz o ataque corpo a corpo rápido. Não se aplica à tecla do escâner, que o abre ao ser segurada.");
    this.Text("CyberGrapple-ControllerHold", "Controle: segurar para lançar o arpéu");
    this.Text("CyberGrapple-ControllerHold-Description", "Segure o botão para lançar o arpéu. Com o botão de ataque corpo a corpo rápido, um toque ainda faz o ataque corpo a corpo rápido. Não se aplica ao botão do escâner (L1), que o abre ao ser segurado.");
    this.Text("CyberGrapple-HoldTime", "Tempo de segurar");
    this.Text("CyberGrapple-HoldTime-Description", "Por quanto tempo segurar para lançar o arpéu, em segundos.");
    this.Text("CyberGrapple-Crosshair", "Mira para mãos vazias e Punhos");
    this.Text("CyberGrapple-CrosshairShape-Simple", "Simples");
    this.Text("CyberGrapple-CrosshairShape-Basic", "Básica");
    this.Text("CyberGrapple-CrosshairShape-Shotgun", "Escopeta");
    this.Text("CyberGrapple-CrosshairShape-SmartRifle", "Inteligente");
    this.Text("CyberGrapple-CrosshairShape-TechCircle", "Tecnologia, redonda");
    this.Text("CyberGrapple-CrosshairShape-TechHex", "Tecnologia, hexagonal");
    this.Text("CyberGrapple-CrosshairShape-Launcher", "Sistema lança-projéteis");
    this.Text("CyberGrapple-CrosshairShape-MantisBlades", "Lâminas louva-a-deus");
    this.Text("CyberGrapple-CrosshairShape-HeavyMachineGun", "Metralhadora");
    this.Text("CyberGrapple-CrosshairShape-Dot", "Ponto no centro da tela");
    this.Text("CyberGrapple-CrosshairColor", "Cor");
    this.Text("CyberGrapple-CrosshairColor-Description", "A cor da mira. Turquesa é a cor das miras do jogo.");
    this.Text("CyberGrapple-CrosshairColor-Yellow", "Amarelo");
    this.Text("CyberGrapple-CrosshairColor-White", "Branco");
    this.Text("CyberGrapple-CrosshairColor-Red", "Vermelho");
    this.Text("CyberGrapple-CrosshairColor-Green", "Verde");
    this.Text("CyberGrapple-CrosshairColor-Turquoise", "Turquesa (a do jogo)");
    this.Text("CyberGrapple-CrosshairSize", "Tamanho");
    this.Text("CyberGrapple-CrosshairSize-Description", "O tamanho da mira, em porcentagem da mira do jogo.");
    this.Text("CyberGrapple-CrosshairRange", "Indicador de alcance");
    this.Text("CyberGrapple-CrosshairRange-Description", "A mira assume a cor fora do alcance quando apertar a tecla não lançaria o arpéu: nenhuma carga restante, o implante fora do espaço rápido de acessório de combate (com “Tecla própria” desligada), nada ao alcance, o céu, uma pessoa ou um veículo no caminho que a Categoria do implante ainda não consegue pegar, uma pessoa ou uma motocicleta além da distância de onde podem ser puxadas, alguém ao alcance do ataque corpo a corpo rápido, ou o arpéu ainda lançado.");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor", "Cor fora do alcance");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor-Description", "A cor da mira quando o arpéu não seria lançado. Escolha uma diferente da cor da mira: com a mesma cor, o indicador fica desligado.");
    this.Text("CyberGrapple-DynamicFov", "Campo de visão dinâmico");
    this.Text("CyberGrapple-DynamicFov-Description", "Enquanto a corda puxa V, o campo de visão se amplia e depois volta ao normal quando a puxada termina. Somente em primeira pessoa, e não ao mirar uma arma. Desligado: o campo de visão continua como definido nas configurações do jogo.");
    this.Text("CyberGrapple-FovWidening", "Ampliação do campo de visão");
    this.Text("CyberGrapple-FovWidening-Description", "Somado à configuração Campo de visão do jogo, nos mesmos graus: 10 transforma 100 em 110. O total fica limitado a 140.");
    this.Text("CyberGrapple-FovTransition", "Transição do campo de visão");
    this.Text("CyberGrapple-FovTransition-Description", "Em segundos: o tempo que o campo de visão leva para se ampliar quando a puxada começa e para voltar ao normal quando ela termina.");
    this.Text("CyberGrapple-Card-Name", "Sistema lança-arpéu");
    this.Text("CyberGrapple-Card-Description", "Um implante de braço que dispara um gancho preso a uma corda no lugar de projéteis.");
    this.Text("CyberGrapple-Card-Travel", "Lança um arpéu que leva você até a superfície mirada.");
    this.Text("CyberGrapple-Card-Pull20", "Puxa uma pessoa, um inimigo ou uma motocicleta na sua direção, de até 20 m de distância.");
    this.Text("CyberGrapple-Card-Pull25", "Puxa uma pessoa, um inimigo ou uma motocicleta na sua direção, de até 25 m de distância.");
    this.Text("CyberGrapple-Card-Pull30", "Puxa uma pessoa, um inimigo ou uma motocicleta na sua direção, de até 30 m de distância.");
    this.Text("CyberGrapple-Card-Pull35", "Puxa uma pessoa, um inimigo ou uma motocicleta na sua direção, de até 35 m de distância.");
    this.Text("CyberGrapple-Card-Pull40", "Puxa uma pessoa, um inimigo ou uma motocicleta na sua direção, de até 40 m de distância.");
    this.Text("CyberGrapple-Card-Range", "ALCANCE");
    this.Text("CyberGrapple-Card-TopSpeed", "VELOC. MÁX.");
    this.Text("CyberGrapple-Card-Seize", "Traz uma pessoa até você e a agarra.");
    this.Text("CyberGrapple-Card-Next10", "Melhorar para a Categoria 2 exige nível 10 do personagem.");
    this.Text("CyberGrapple-Card-Next20", "Melhorar para a Categoria 3 exige nível 20 do personagem.");
    this.Text("CyberGrapple-Card-Next30", "Melhorar para a Categoria 4 exige nível 30 do personagem.");
    this.Text("CyberGrapple-Card-Next40", "Melhorar para a Categoria 5 exige nível 40 do personagem.");
    this.Text("CyberGrapple-Card-Distance", "{n} m");
    this.Text("CyberGrapple-Card-Speed", "{n} m/s");
    this.Text("CyberGrapple-Card-DecimalMark", ",");
    this.Text("CyberGrapple-Silent-OtherOn", "O implante de arpéu está desligado enquanto o Apex Grapple estiver ligado. Desligue o Apex Grapple nas configurações dele para usar o implante. Seu jogo salvo não é alterado.");
    this.Text("CyberGrapple-Silent-OtherUnread", "O implante de arpéu está desligado: o Apex Grapple está instalado e não foi possível ler o interruptor dele. Mova o Apex Grapple para fora da pasta do jogo para usar o implante. Seu jogo salvo não é alterado.");
    this.Text("CyberGrapple-Silent-NoTweakXL", "Cyber Grapple: o implante Sistema lança-arpéu não existe neste jogo porque o TweakXL não está instalado. Instale o TweakXL e o RED4ext e inicie o jogo novamente.");
    this.Text("CyberGrapple-Silent-NoRecords", "Cyber Grapple: não foi possível adicionar o implante Sistema lança-arpéu a esta versão do jogo. O mod não faz nada até ser atualizado.");
    this.Text("CyberGrapple-Upgrade-Waiting", "Cyber Grapple: não foi possível ler, nesta versão do jogo, o nível que algumas melhorias do Sistema lança-arpéu exigem. Essas melhorias não exigem nenhum nível até o mod ser atualizado.");
    this.Text("CyberGrapple-CrosshairSource", "Mira");
    this.Text("CyberGrapple-CrosshairSource-Description", "A mira exibida enquanto as mãos de V estão vazias ou V luta com os Punhos. Cyber Grapple: a mira deste mod, para mirar o arpéu sempre que ele puder ser lançado. Jogo: nada é adicionado, como no jogo, que não exibe mira nesse caso.");
    this.Text("CyberGrapple-CrosshairSource-Mod", "Cyber Grapple");
    this.Text("CyberGrapple-CrosshairSource-Game", "Jogo");
    this.Text("CyberGrapple-CrosshairPick", "Forma da mira");
    this.Text("CyberGrapple-CrosshairPick-Description", "A forma da mira deste mod. Ela fica oculta assim que V segura uma arma ou uma cibernética dos braços, que têm miras próprias, e em veículos, com o escâner e durante cenas.");
    this.Text("CyberGrapple-Impact", "Impacto do gancho");
    this.Text("CyberGrapple-ImpactEffect", "Efeito de impacto");
    this.Text("CyberGrapple-ImpactEffect-Description", "Um dos efeitos de impacto do jogo, mostrado uma vez onde o gancho atinge uma superfície ou um veículo. Nenhum em uma pessoa nem em uma motocicleta. Desligado: nada aparece onde o gancho atinge.");
    this.Text("CyberGrapple-ImpactStyle", "Estilo do efeito de impacto");
    this.Text("CyberGrapple-ImpactStyle-Description", "Qual efeito de impacto do jogo é mostrado. Cada um tem o nome do que o produz no jogo: a superfície atingida e a arma.");
    this.Text("CyberGrapple-ImpactStyle-ConcreteBullet", "Concreto, bala");
    this.Text("CyberGrapple-ImpactStyle-ConcreteLargeCaliber", "Concreto, alto calibre");
    this.Text("CyberGrapple-ImpactStyle-ConcreteHammer", "Concreto, martelo");
    this.Text("CyberGrapple-ImpactStyle-MetalHammer", "Metal, martelo");
    this.Text("CyberGrapple-ImpactStyle-Monowire", "Monofio");
    this.Text("CyberGrapple-ImpactStyle-DefaultBullet", "Genérico, bala");
    this.Text("CyberGrapple-Voice", "Voz de V");
    this.Text("CyberGrapple-VoiceLines", "Falas");
    this.Text("CyberGrapple-VoiceLines-Description", "V diz uma fala quando o arpéu começa a puxar uma pessoa até V, e outra quando V mata ou nocauteia uma pessoa que o arpéu trouxe e agarrou. Requer Audioware, que reproduz as falas. Desligado: V não diz nada.");
    this.Text("CyberGrapple-VoiceGender", "Voz");
    this.Text("CyberGrapple-VoiceGender-Description", "A voz que diz as falas. Automática: a do seu V. Feminina ou Masculina: sempre essa voz.");
    this.Text("CyberGrapple-VoiceGender-Auto", "Automática");
    this.Text("CyberGrapple-VoiceGender-Female", "Feminina");
    this.Text("CyberGrapple-VoiceGender-Male", "Masculina");
    this.Text("CyberGrapple-VoicePullChance", "Frequência da fala ao puxar");
    this.Text("CyberGrapple-VoicePullChance-Description", "Em porcentagem, exata a cada 10 vezes: a frequência com que V diz uma fala quando o arpéu começa a puxar uma pessoa até V.");
    this.Text("CyberGrapple-VoiceKillChance", "Frequência da fala na neutralização");
    this.Text("CyberGrapple-VoiceKillChance-Description", "Em porcentagem, exata a cada 10 vezes: a frequência com que V diz uma fala quando V mata ou nocauteia uma pessoa que o arpéu trouxe e agarrou.");
    this.Text("CyberGrapple-VoiceKillStyle", "Estilo das falas na neutralização");
    this.Text("CyberGrapple-VoiceKillStyle-Description", "Como V diz as falas na neutralização. Normal: em voz alta. Sussurro: V as sussurra. Normal + Sussurro: as duas, misturadas ao acaso.");
    this.Text("CyberGrapple-VoiceKillStyle-Normal", "Normal");
    this.Text("CyberGrapple-VoiceKillStyle-Whisper", "Sussurro");
    this.Text("CyberGrapple-VoiceKillStyle-Both", "Normal + Sussurro");
  }
}
