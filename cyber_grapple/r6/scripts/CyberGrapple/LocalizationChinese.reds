// Made by fabrique/grapple.py from Apex Grapple's LocalizationChinese.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Menu texts in Simplified Chinese, for the game's zh-cn language. Same keys as CyberGrappleEnglish in Localization.reds.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Enabled", "Cyber Grapple");
    this.Text("CyberGrapple-Enabled-Description", "安装抓钩系统义体（义体医生有售）并将其分配在战斗辅助道具快捷栏上后，瞄准一个表面并按下“使用战斗辅助道具”键（键盘为鼠标中键，手柄为 R1）：钩子飞出，绳索拉动你，同时由你的瞄准操控方向。关闭：义体仍保持安装，但不起任何作用。");
    this.Text("CyberGrapple-Profile1-Key", "按键");
    this.Text("CyberGrapple-Profile1-Fov", "视野");
    this.Text("CyberGrapple-OwnKey", "独立按键");
    this.Text("CyberGrapple-OwnKey-Description", "用自选的按键发射抓钩，而不是“使用战斗辅助道具”键；该键随之空出，可供手雷使用。");
    this.Text("CyberGrapple-Key", "按键");
    this.Text("CyberGrapple-Key-Description", "抓钩按键，在开启“独立按键”时使用。不能使用鼠标滚轮。");
    this.Text("CyberGrapple-KeyboardHold", "键盘：按住发射抓钩");
    this.Text("CyberGrapple-KeyboardHold-Description", "按住按键发射抓钩。使用敏捷近战键时，轻按一下仍然执行敏捷近战。扫描键除外，长按会打开扫描。");
    this.Text("CyberGrapple-ControllerHold", "手柄：按住发射抓钩");
    this.Text("CyberGrapple-ControllerHold-Description", "按住按钮发射抓钩。使用敏捷近战按钮时，轻按一下仍然执行敏捷近战。扫描按钮（L1）除外，长按会打开扫描。");
    this.Text("CyberGrapple-HoldTime", "按住时间");
    this.Text("CyberGrapple-HoldTime-Description", "发射抓钩需要按住多久，单位为秒。");
  }
}
