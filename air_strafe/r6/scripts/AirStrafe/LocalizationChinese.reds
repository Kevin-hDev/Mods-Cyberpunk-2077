// Menu texts in Simplified Chinese, for the game's zh-cn language. Same keys as AirStrafeEnglish in Localization.reds.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class AirStrafeChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("AirStrafe-Enabled", "Air Strafe");
    this.Text("AirStrafe-Enabled-Description", "在空中用移动键操控你的惯性，就像步行时一样，且不损失速度。按住前进键并快速转动视角，惯性会立刻随之转向（tap strafe）。关闭：游戏原本的空中控制。");
    this.Text("AirStrafe-Steering", "空中转向");
    this.Text("AirStrafe-Steering-Description", "你的惯性转向按键所指方向的快慢，单位为度/秒。");
    this.Text("AirStrafe-BackTurn", "后退键掉头");
    this.Text("AirStrafe-BackTurn-Description", "开启：后退键会让你的惯性以全速转向身后。关闭：后退键只会让你减速。");
    this.Text("AirStrafe-TapStrafe", "Tap strafe 按键");
    this.Text("AirStrafe-TapStrafe-Description", "在空中连按或按住一个自选的按键（默认为 W），同时转动视角：你的惯性会跟着视角走。开启时只有这个按键有此效果：按前进键可以笔直跳跃，同时环顾四周。即使 Air Strafe 已关闭也有效。需要 Codeware。");
    this.Text("AirStrafe-TapKey", "按键");
    this.Text("AirStrafe-TapKey-Description", "用于 tap strafe 连按的按键。不能使用鼠标滚轮。");
    this.Text("AirStrafe-TapSteering", "Tap strafe 转向");
    this.Text("AirStrafe-TapSteering-Description", "连按该按键时，你的惯性转向的快慢，单位为度/秒。");
  }
}
