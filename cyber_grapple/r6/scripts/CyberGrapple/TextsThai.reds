// Thai texts, for the game's th-th language. This class holds every key shown, menu and card alike,
// because all four providers return it for this language (Languages.reds).

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleThai extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Enabled", "Cyber Grapple");
    this.Text("CyberGrapple-Enabled-Description", "เมื่อติดตั้งอวัยวะปลูกถ่ายระบบยิงตะขอเกี่ยวแล้ว (ริปเปอร์ด็อคมีขาย) และกำหนดไว้ที่ควิกสล็อตแกดเจ็ดต่อสู้ ให้เล็งไปที่พื้นผิวแล้วกดปุ่ม “ใช้แกดเจ็ดต่อสู้” (ปุ่มกลางเมาส์เมื่อเล่นด้วยคีย์บอร์ด, R1 บนคอนโทรลเลอร์): ตะขอจะพุ่งออกไปและเชือกจะดึงคุณไป โดยการเล็งของคุณเป็นตัวกำหนดทิศทาง ปิด: อวัยวะปลูกถ่ายจะยังติดตั้งอยู่แต่ไม่ทำอะไร");
    this.Text("CyberGrapple-Profile1-Key", "ปุ่ม");
    this.Text("CyberGrapple-Profile1-Fov", "ขอบเขตการมองเห็น");
    this.Text("CyberGrapple-OwnKey", "ปุ่มกำหนดเอง");
    this.Text("CyberGrapple-OwnKey-Description", "ยิงตะขอเกี่ยวด้วยปุ่มที่คุณเลือกเอง แทนปุ่ม “ใช้แกดเจ็ดต่อสู้” ซึ่งจะว่างไว้ให้ระเบิดมือของคุณ");
    this.Text("CyberGrapple-Key", "ปุ่ม");
    this.Text("CyberGrapple-Key-Description", "ปุ่มยิงตะขอเกี่ยว ใช้เมื่อเปิด “ปุ่มกำหนดเอง” ไม่สามารถใช้ล้อเมาส์ได้");
    this.Text("CyberGrapple-KeyboardHold", "คีย์บอร์ด: กดค้างเพื่อยิงตะขอเกี่ยว");
    this.Text("CyberGrapple-KeyboardHold-Description", "กดปุ่มค้างไว้เพื่อยิงตะขอเกี่ยว หากใช้ปุ่มโจมตีประชิดอย่างรวดเร็ว การกดแตะครั้งเดียวจะยังเป็นการโจมตีประชิดอย่างรวดเร็วเหมือนเดิม ยกเว้นปุ่มสแกนเนอร์ ซึ่งการกดค้างจะเปิดสแกนเนอร์");
    this.Text("CyberGrapple-ControllerHold", "คอนโทรลเลอร์: กดค้างเพื่อยิงตะขอเกี่ยว");
    this.Text("CyberGrapple-ControllerHold-Description", "กดปุ่มค้างไว้เพื่อยิงตะขอเกี่ยว หากใช้ปุ่มโจมตีประชิดอย่างรวดเร็ว การกดแตะครั้งเดียวจะยังเป็นการโจมตีประชิดอย่างรวดเร็วเหมือนเดิม ยกเว้นปุ่มสแกนเนอร์ (L1) ซึ่งการกดค้างจะเปิดสแกนเนอร์");
    this.Text("CyberGrapple-HoldTime", "เวลากดค้าง");
    this.Text("CyberGrapple-HoldTime-Description", "ระยะเวลาที่ต้องกดค้างเพื่อยิงตะขอเกี่ยว หน่วยเป็นวินาที");
    this.Text("CyberGrapple-Crosshair", "เป้าเล็งสำหรับมือเปล่าและหมัด");
    this.Text("CyberGrapple-CrosshairShape-Simple", "เรียบง่าย");
    this.Text("CyberGrapple-CrosshairShape-Basic", "พื้นฐาน");
    this.Text("CyberGrapple-CrosshairShape-Shotgun", "ปืนลูกซอง");
    this.Text("CyberGrapple-CrosshairShape-SmartRifle", "สมาร์ท");
    this.Text("CyberGrapple-CrosshairShape-TechCircle", "เทค (ทรงกลม)");
    this.Text("CyberGrapple-CrosshairShape-TechHex", "เทค (ทรงหกเหลี่ยม)");
    this.Text("CyberGrapple-CrosshairShape-Launcher", "ระบบยิงวัตถุ");
    this.Text("CyberGrapple-CrosshairShape-MantisBlades", "แมนทิสเบลด");
    this.Text("CyberGrapple-CrosshairShape-HeavyMachineGun", "ปืนกลหนัก");
    this.Text("CyberGrapple-CrosshairShape-Dot", "จุดกลางหน้าจอ");
    this.Text("CyberGrapple-CrosshairColor", "สี");
    this.Text("CyberGrapple-CrosshairColor-Description", "สีของเป้าเล็ง สีเทอร์ควอยซ์คือสีเป้าเล็งของเกม");
    this.Text("CyberGrapple-CrosshairColor-Yellow", "สีเหลือง");
    this.Text("CyberGrapple-CrosshairColor-White", "สีขาว");
    this.Text("CyberGrapple-CrosshairColor-Red", "สีแดง");
    this.Text("CyberGrapple-CrosshairColor-Green", "สีเขียว");
    this.Text("CyberGrapple-CrosshairColor-Turquoise", "สีเทอร์ควอยซ์ (ของเกม)");
    this.Text("CyberGrapple-CrosshairSize", "ขนาด");
    this.Text("CyberGrapple-CrosshairSize-Description", "ขนาดของเป้าเล็ง เป็นเปอร์เซ็นต์ของเป้าเล็งในเกม");
    this.Text("CyberGrapple-CrosshairRange", "ตัวบอกระยะ");
    this.Text("CyberGrapple-CrosshairRange-Description", "เป้าเล็งจะเปลี่ยนเป็นสีนอกระยะเมื่อการกดปุ่มจะไม่ยิงตะขอเกี่ยว ได้แก่ จำนวนชาร์จหมด, อวัยวะปลูกถ่ายไม่ได้อยู่ในควิกสล็อตแกดเจ็ดต่อสู้ (เมื่อ “ปุ่มกำหนดเอง” ปิดอยู่), ไม่มีสิ่งใดอยู่ในระยะ, เล็งท้องฟ้า, มีคนหรือพาหนะอยู่ตรงหน้าซึ่งระดับของอวัยวะปลูกถ่ายยังรองรับไม่ได้, คนหรือมอเตอร์ไซค์อยู่ไกลเกินระยะที่ดึงได้, มีคนอยู่ในระยะโจมตีประชิดอย่างรวดเร็ว หรือตะขอเกี่ยวยังไม่ถูกเก็บกลับ");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor", "สีนอกระยะ");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor-Description", "สีของเป้าเล็งขณะที่จะไม่ยิงตะขอเกี่ยว ให้เลือกสีอื่นที่ไม่ใช่สีของเป้าเล็ง: หากเป็นสีเดียวกัน ตัวบอกระยะจะปิด");
    this.Text("CyberGrapple-DynamicFov", "ขอบเขตการมองเห็นแบบไดนามิก");
    this.Text("CyberGrapple-DynamicFov-Description", "ขณะที่เชือกดึง V ขอบเขตการมองเห็นจะกว้างขึ้น แล้วกลับคืนเมื่อหยุดดึง ใช้ได้เฉพาะมุมมองบุคคลที่หนึ่ง และไม่ทำงานขณะเล็งอาวุธ ปิด: ขอบเขตการมองเห็นจะคงตามค่าในการตั้งค่าของเกม");
    this.Text("CyberGrapple-FovWidening", "การขยายขอบเขตการมองเห็น");
    this.Text("CyberGrapple-FovWidening-Description", "บวกเพิ่มจากการตั้งค่าขอบเขตการมองเห็นของเกม ในหน่วยองศาเดียวกัน: 10 ทำให้ 100 เป็น 110 ผลรวมสูงสุดไม่เกิน 140");
    this.Text("CyberGrapple-FovTransition", "การเปลี่ยนผ่านขอบเขตการมองเห็น");
    this.Text("CyberGrapple-FovTransition-Description", "หน่วยเป็นวินาที: เวลาที่ขอบเขตการมองเห็นใช้ขยายกว้างเมื่อเริ่มดึง และใช้กลับคืนเมื่อหยุดดึง");
    this.Text("CyberGrapple-Card-Name", "ระบบยิงตะขอเกี่ยว");
    this.Text("CyberGrapple-Card-Description", "อวัยวะปลูกถ่ายที่แขน ยิงตะขอที่ผูกกับเชือกแทนการยิงวัตถุ");
    this.Text("CyberGrapple-Card-Travel", "ยิงตะขอเกี่ยวเพื่อดึงคุณไปยังพื้นผิวที่เล็งอยู่");
    this.Text("CyberGrapple-Card-Pull20", "ดึงคน ศัตรู หรือมอเตอร์ไซค์เข้าหาตัวคุณ จากระยะไกลสุด 20 เมตร");
    this.Text("CyberGrapple-Card-Pull25", "ดึงคน ศัตรู หรือมอเตอร์ไซค์เข้าหาตัวคุณ จากระยะไกลสุด 25 เมตร");
    this.Text("CyberGrapple-Card-Pull30", "ดึงคน ศัตรู หรือมอเตอร์ไซค์เข้าหาตัวคุณ จากระยะไกลสุด 30 เมตร");
    this.Text("CyberGrapple-Card-Pull35", "ดึงคน ศัตรู หรือมอเตอร์ไซค์เข้าหาตัวคุณ จากระยะไกลสุด 35 เมตร");
    this.Text("CyberGrapple-Card-Pull40", "ดึงคน ศัตรู หรือมอเตอร์ไซค์เข้าหาตัวคุณ จากระยะไกลสุด 40 เมตร");
    this.Text("CyberGrapple-Card-Range", "ระยะ");
    this.Text("CyberGrapple-Card-TopSpeed", "ความเร็วสูงสุด");
    this.Text("CyberGrapple-Card-Seize", "ดึงคนมาถึงตัวคุณและจับตัวไว้");
    this.Text("CyberGrapple-Card-Next10", "การอัพเกรดเป็นระดับ 2 ต้องมีเลเวลตัวละคร 10");
    this.Text("CyberGrapple-Card-Next20", "การอัพเกรดเป็นระดับ 3 ต้องมีเลเวลตัวละคร 20");
    this.Text("CyberGrapple-Card-Next30", "การอัพเกรดเป็นระดับ 4 ต้องมีเลเวลตัวละคร 30");
    this.Text("CyberGrapple-Card-Next40", "การอัพเกรดเป็นระดับ 5 ต้องมีเลเวลตัวละคร 40");
    this.Text("CyberGrapple-Card-Distance", "{n} เมตร");
    this.Text("CyberGrapple-Card-Speed", "{n} เมตร/วิ");
    this.Text("CyberGrapple-Card-DecimalMark", ".");
    this.Text("CyberGrapple-Silent-OtherOn", "อวัยวะปลูกถ่ายตะขอเกี่ยวปิดอยู่ขณะที่ Apex Grapple เปิดอยู่ ปิด Apex Grapple ในการตั้งค่าของมันเพื่อใช้อวัยวะปลูกถ่ายนี้ เซฟของคุณจะไม่ถูกเปลี่ยนแปลง");
    this.Text("CyberGrapple-Silent-OtherUnread", "อวัยวะปลูกถ่ายตะขอเกี่ยวปิดอยู่: ติดตั้ง Apex Grapple ไว้ และอ่านสวิตช์เปิด/ปิดของมันไม่ได้ ย้าย Apex Grapple ออกจากโฟลเดอร์ของเกมเพื่อใช้อวัยวะปลูกถ่ายนี้ เซฟของคุณจะไม่ถูกเปลี่ยนแปลง");
    this.Text("CyberGrapple-Silent-NoTweakXL", "Cyber Grapple: ไม่มีอวัยวะปลูกถ่ายระบบยิงตะขอเกี่ยวในเกมนี้ เพราะยังไม่ได้ติดตั้ง TweakXL ให้ติดตั้ง TweakXL และ RED4ext แล้วรีสตาร์ทเกม");
    this.Text("CyberGrapple-Silent-NoRecords", "Cyber Grapple: ไม่สามารถเพิ่มอวัยวะปลูกถ่ายระบบยิงตะขอเกี่ยวลงในเกมเวอร์ชันนี้ได้ ม็อดจะไม่ทำงานจนกว่าจะมีการอัปเดต");
    this.Text("CyberGrapple-Upgrade-Waiting", "Cyber Grapple: ไม่สามารถอ่านเลเวลที่การอัพเกรดบางอย่างของระบบยิงตะขอเกี่ยวต้องการจากเกมเวอร์ชันนี้ได้ การอัพเกรดเหล่านั้นจะไม่ต้องการเลเวลจนกว่าม็อดจะได้รับการอัปเดต");
    this.Text("CyberGrapple-CrosshairSource", "เป้าเล็ง");
    this.Text("CyberGrapple-CrosshairSource-Description", "เป้าเล็งของใครที่จะแสดงขณะที่มือของ V ว่างเปล่าหรือ V ต่อสู้ด้วยหมัด Cyber Grapple: เป้าเล็งของม็อดนี้ ใช้เล็งตะขอเกี่ยวทุกครั้งที่ยิงได้ เกม: ไม่เพิ่มอะไร เหมือนในเกมซึ่งไม่แสดงเป้าเล็งในกรณีนั้น");
    this.Text("CyberGrapple-CrosshairSource-Mod", "Cyber Grapple");
    this.Text("CyberGrapple-CrosshairSource-Game", "เกม");
    this.Text("CyberGrapple-CrosshairPick", "รูปทรงเป้าเล็ง");
    this.Text("CyberGrapple-CrosshairPick-Description", "รูปทรงของเป้าเล็งจากม็อดนี้ เป้าเล็งนี้จะถูกซ่อนทันทีที่ V ถืออาวุธหรือไซเบอร์แวร์แขน ซึ่งมีเป้าเล็งของตัวเอง และจะซ่อนเมื่ออยู่ในพาหนะ ขณะใช้สแกนเนอร์ และในฉากต่างๆ");
  }
}
