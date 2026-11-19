// Russian texts, for the game's ru-ru language. This class holds every key shown, menu and card alike,
// because all four providers return it for this language (Languages.reds).

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleRussian extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Enabled", "Cyber Grapple");
    this.Text("CyberGrapple-Enabled-Description", "С установленным имплантом «Система запуска крюка-кошки» (его продают риперы), помещённым в ячейку для боевых устройств, прицельтесь в поверхность и нажмите клавишу «Применить боевое устройство» (средняя кнопка мыши при игре с клавиатурой; R1 на контроллере): крюк вылетает, трос тянет вас, а направление задаёт ваш прицел. Выкл.: имплант остаётся установленным и ничего не делает.");
    this.Text("CyberGrapple-Profile1-Key", "Клавиша");
    this.Text("CyberGrapple-Profile1-Fov", "Угол обзора");
    this.Text("CyberGrapple-OwnKey", "Своя клавиша");
    this.Text("CyberGrapple-OwnKey-Description", "Запускать крюк-кошку клавишей на ваш выбор вместо клавиши «Применить боевое устройство», которая тогда остаётся свободной для гранат.");
    this.Text("CyberGrapple-Key", "Клавиша");
    this.Text("CyberGrapple-Key-Description", "Клавиша крюка-кошки, которая используется, когда включена «Своя клавиша». Колёсико мыши использовать нельзя.");
    this.Text("CyberGrapple-KeyboardHold", "Клавиатура: зажать для крюка-кошки");
    this.Text("CyberGrapple-KeyboardHold-Description", "Зажмите клавишу, чтобы запустить крюк-кошку. С клавишей быстрого удара в ближнем бою короткое нажатие по-прежнему выполняет быстрый удар в ближнем бою. Не относится к клавише сканера: если её зажать, открывается сканер.");
    this.Text("CyberGrapple-ControllerHold", "Контроллер: зажать для крюка-кошки");
    this.Text("CyberGrapple-ControllerHold-Description", "Зажмите кнопку, чтобы запустить крюк-кошку. С кнопкой быстрого удара в ближнем бою короткое нажатие по-прежнему выполняет быстрый удар в ближнем бою. Не относится к кнопке сканера (L1): если её зажать, открывается сканер.");
    this.Text("CyberGrapple-HoldTime", "Время удержания");
    this.Text("CyberGrapple-HoldTime-Description", "Сколько секунд нужно удерживать, чтобы запустить крюк-кошку.");
    this.Text("CyberGrapple-Crosshair", "Прицел при пустых руках и Кулаках");
    this.Text("CyberGrapple-CrosshairShape-Simple", "Простой");
    this.Text("CyberGrapple-CrosshairShape-Basic", "Базовый");
    this.Text("CyberGrapple-CrosshairShape-Shotgun", "Дробовик");
    this.Text("CyberGrapple-CrosshairShape-SmartRifle", "Умное");
    this.Text("CyberGrapple-CrosshairShape-TechCircle", "Электромагнитное, круглое");
    this.Text("CyberGrapple-CrosshairShape-TechHex", "Электромагнитное, шестиугольное");
    this.Text("CyberGrapple-CrosshairShape-Launcher", "Система запуска снарядов");
    this.Text("CyberGrapple-CrosshairShape-MantisBlades", "Клинки богомола");
    this.Text("CyberGrapple-CrosshairShape-HeavyMachineGun", "Крупнокалиберный пулемёт");
    this.Text("CyberGrapple-CrosshairShape-Dot", "Точка в центре экрана");
    this.Text("CyberGrapple-CrosshairColor", "Цвет");
    this.Text("CyberGrapple-CrosshairColor-Description", "Цвет прицела. Бирюзовый: цвет прицелов игры.");
    this.Text("CyberGrapple-CrosshairColor-Yellow", "Жёлтый");
    this.Text("CyberGrapple-CrosshairColor-White", "Белый");
    this.Text("CyberGrapple-CrosshairColor-Red", "Красный");
    this.Text("CyberGrapple-CrosshairColor-Green", "Зелёный");
    this.Text("CyberGrapple-CrosshairColor-Turquoise", "Бирюзовый (как в игре)");
    this.Text("CyberGrapple-CrosshairSize", "Размер");
    this.Text("CyberGrapple-CrosshairSize-Description", "Размер прицела в процентах от размера прицелов игры.");
    this.Text("CyberGrapple-CrosshairRange", "Индикатор дальности");
    this.Text("CyberGrapple-CrosshairRange-Description", "Прицел принимает цвет вне дальности, когда нажатие не запустило бы крюк-кошку: не осталось зарядов, имплант не находится в ячейке для боевых устройств (если «Своя клавиша» выключена), в пределах дальности ничего нет, прицел направлен в небо, на пути человек или транспортное средство, которых имплант текущего уровня ещё не может захватить, человек или мотоцикл находятся дальше, чем их можно притянуть, кто-то находится в пределах быстрого удара в ближнем бою или крюк-кошка ещё не втянута обратно.");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor", "Цвет вне дальности");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor-Description", "Цвет прицела, когда крюк-кошка не запустилась бы. Выберите цвет, отличный от цвета прицела: при одинаковых цветах индикатор выключен.");
    this.Text("CyberGrapple-DynamicFov", "Динамический угол обзора");
    this.Text("CyberGrapple-DynamicFov-Description", "Пока трос тянет V, угол обзора увеличивается, а когда тяга прекращается, возвращается обратно. Только от первого лица и не при прицеливании с оружием. Выкл.: угол обзора остаётся таким, как в настройках игры.");
    this.Text("CyberGrapple-FovWidening", "Увеличение угла обзора");
    this.Text("CyberGrapple-FovWidening-Description", "Добавляется к значению «Угол обзора» в настройках игры, в тех же градусах: 10 превращает 100 в 110. Итоговое значение не превышает 140.");
    this.Text("CyberGrapple-FovTransition", "Время изменения угла обзора");
    this.Text("CyberGrapple-FovTransition-Description", "В секундах: время, за которое угол обзора увеличивается, когда начинается тяга, и возвращается обратно, когда она прекращается.");
    this.Text("CyberGrapple-Card-Name", "Система запуска крюка-кошки");
    this.Text("CyberGrapple-Card-Description", "Имплант для руки, который вместо снарядов запускает крюк на тросе.");
    this.Text("CyberGrapple-Card-Travel", "Запускает крюк-кошку, которая подтягивает вас к поверхности, на которую вы целитесь.");
    this.Text("CyberGrapple-Card-Pull20", "Притягивает к вам человека, врага или мотоцикл с расстояния до 20 м.");
    this.Text("CyberGrapple-Card-Pull25", "Притягивает к вам человека, врага или мотоцикл с расстояния до 25 м.");
    this.Text("CyberGrapple-Card-Pull30", "Притягивает к вам человека, врага или мотоцикл с расстояния до 30 м.");
    this.Text("CyberGrapple-Card-Pull35", "Притягивает к вам человека, врага или мотоцикл с расстояния до 35 м.");
    this.Text("CyberGrapple-Card-Pull40", "Притягивает к вам человека, врага или мотоцикл с расстояния до 40 м.");
    this.Text("CyberGrapple-Card-Range", "ДАЛЬНОСТЬ");
    this.Text("CyberGrapple-Card-TopSpeed", "МАКС. СКОРОСТЬ");
    this.Text("CyberGrapple-Card-Seize", "Притягивает человека вплотную к вам и хватает его.");
    this.Text("CyberGrapple-Card-Next10", "Улучшение до уровня 2 требует уровня персонажа 10.");
    this.Text("CyberGrapple-Card-Next20", "Улучшение до уровня 3 требует уровня персонажа 20.");
    this.Text("CyberGrapple-Card-Next30", "Улучшение до уровня 4 требует уровня персонажа 30.");
    this.Text("CyberGrapple-Card-Next40", "Улучшение до уровня 5 требует уровня персонажа 40.");
    this.Text("CyberGrapple-Card-Distance", "{n} м");
    this.Text("CyberGrapple-Card-Speed", "{n} м/с");
    this.Text("CyberGrapple-Card-DecimalMark", ",");
    this.Text("CyberGrapple-Silent-OtherOn", "Имплант крюка-кошки выключен, пока включён Apex Grapple. Чтобы пользоваться имплантом, выключите Apex Grapple в его настройках. Ваше сохранение не изменено.");
    this.Text("CyberGrapple-Silent-OtherUnread", "Имплант крюка-кошки выключен: Apex Grapple установлен, но его переключатель не удалось прочитать. Чтобы пользоваться имплантом, уберите Apex Grapple из папки игры. Ваше сохранение не изменено.");
    this.Text("CyberGrapple-Silent-NoTweakXL", "Cyber Grapple: имплант «Система запуска крюка-кошки» отсутствует в этой игре, потому что TweakXL не установлен. Установите TweakXL и RED4ext, затем снова запустите игру.");
    this.Text("CyberGrapple-Silent-NoRecords", "Cyber Grapple: не удалось добавить имплант «Система запуска крюка-кошки» в эту версию игры. Пока мод не обновлён, он ничего не делает.");
    this.Text("CyberGrapple-Upgrade-Waiting", "Cyber Grapple: не удалось прочитать в этой версии игры уровень персонажа, который нужен для некоторых улучшений импланта «Система запуска крюка-кошки». Пока мод не обновлён, эти улучшения не требуют никакого уровня персонажа.");
    this.Text("CyberGrapple-CrosshairSource", "Прицел");
    this.Text("CyberGrapple-CrosshairSource-Description", "Чей прицел показывается, пока у V пустые руки или V дерётся Кулаками. Cyber Grapple: прицел этого мода, чтобы целиться, когда крюк-кошку можно запустить. Игра: ничего не добавляется, как в самой игре, которая в этом случае не показывает прицел.");
    this.Text("CyberGrapple-CrosshairSource-Mod", "Cyber Grapple");
    this.Text("CyberGrapple-CrosshairSource-Game", "Игра");
    this.Text("CyberGrapple-CrosshairPick", "Форма прицела");
    this.Text("CyberGrapple-CrosshairPick-Description", "Форма прицела этого мода. Он скрывается, как только V берёт оружие или киберимпланты рук, у которых есть собственные прицелы, а также в транспортном средстве, при включённом сканере и во время сцен.");
    this.Text("CyberGrapple-Impact", "Попадание крюка");
    this.Text("CyberGrapple-ImpactEffect", "Эффект попадания");
    this.Text("CyberGrapple-ImpactEffect-Description", "Один из эффектов попадания из игры, показывается один раз там, где крюк попадает в поверхность или транспортное средство. Не показывается при попадании в человека или мотоцикл. Выкл.: там, где попадает крюк, ничего не появляется.");
    this.Text("CyberGrapple-ImpactStyle", "Вид эффекта попадания");
    this.Text("CyberGrapple-ImpactStyle-Description", "Какой из эффектов попадания из игры показывается. Каждый назван по тому, что создаёт его в игре: поверхность, в которую попали, и оружие.");
    this.Text("CyberGrapple-ImpactStyle-ConcreteBullet", "Бетон, пуля");
    this.Text("CyberGrapple-ImpactStyle-ConcreteLargeCaliber", "Бетон, крупный калибр");
    this.Text("CyberGrapple-ImpactStyle-ConcreteHammer", "Бетон, молот");
    this.Text("CyberGrapple-ImpactStyle-MetalHammer", "Металл, молот");
    this.Text("CyberGrapple-ImpactStyle-Monowire", "Моноструна");
    this.Text("CyberGrapple-ImpactStyle-DefaultBullet", "Общий, пуля");
    this.Text("CyberGrapple-Voice", "Голос V");
    this.Text("CyberGrapple-VoiceLines", "Реплики");
    this.Text("CyberGrapple-VoiceLines-Description", "V произносит реплику, когда крюк-кошка начинает тянуть человека к V, и ещё одну, когда V убивает или оглушает человека, которого крюк-кошка притянула и схватила. Требуется Audioware, который воспроизводит реплики. Выкл.: V ничего не говорит.");
    this.Text("CyberGrapple-VoiceGender", "Голос");
    this.Text("CyberGrapple-VoiceGender-Description", "Чьим голосом звучат реплики. Автоматический: голос вашего V. Женский или Мужской: всегда этот голос.");
    this.Text("CyberGrapple-VoiceGender-Auto", "Автоматический");
    this.Text("CyberGrapple-VoiceGender-Female", "Женский");
    this.Text("CyberGrapple-VoiceGender-Male", "Мужской");
    this.Text("CyberGrapple-VoicePullChance", "Частота реплики при притягивании");
    this.Text("CyberGrapple-VoicePullChance-Description", "В процентах, точно на каждые 10 раз: как часто V произносит реплику, когда крюк-кошка начинает тянуть человека к V.");
    this.Text("CyberGrapple-VoiceKillChance", "Частота реплики при обезвреживании");
    this.Text("CyberGrapple-VoiceKillChance-Description", "В процентах, точно на каждые 10 раз: как часто V произносит реплику, когда V убивает или оглушает человека, которого крюк-кошка притянула и схватила.");
    this.Text("CyberGrapple-VoiceKillStyle", "Вид реплик при обезвреживании");
    this.Text("CyberGrapple-VoiceKillStyle-Description", "Как V произносит реплики при обезвреживании. Обычный: вслух. Шёпот: V шепчет их. Обычный + шёпот: и то и другое, вперемешку.");
    this.Text("CyberGrapple-VoiceKillStyle-Normal", "Обычный");
    this.Text("CyberGrapple-VoiceKillStyle-Whisper", "Шёпот");
    this.Text("CyberGrapple-VoiceKillStyle-Both", "Обычный + шёпот");
  }
}
