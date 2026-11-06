// Menu texts in Simplified Chinese, for the game's zh-cn language. Same keys as AxleSlideEnglish in Localization.reds.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class AxleSlideChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("AxleSlide-Enabled", "Axle 滑铲");
    this.Text("AxleSlide-Enabled-Description", "用移动键操控滑铲方向，就像步行时一样，并且滑得更快更远，如同 Apex 英雄里的 Axle。需要 TweakXL。关闭：游戏原本的滑铲。");
    this.Text("AxleSlide-Steering", "转向");
    this.Text("AxleSlide-Steering-Description", "滑铲转向按键所指方向的快慢，单位为度/秒。");
    this.Text("AxleSlide-SpeedBoost", "速度加成");
    this.Text("AxleSlide-SpeedBoost-Description", "滑铲起步速度提高多少，单位为百分比。");
    this.Text("AxleSlide-FlatBoost", "平地距离");
    this.Text("AxleSlide-FlatBoost-Description", "滑铲在平地上多滑出多远，单位为百分比。");
    this.Text("AxleSlide-SlopeBoost", "斜坡距离");
    this.Text("AxleSlide-SlopeBoost-Description", "滑铲在上坡和下坡时多滑出多远，单位为百分比。");
  }
}
