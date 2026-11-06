// Menu texts in Simplified Chinese, for the game's zh-cn language. Same keys as OmniSlideEnglish in Localization.reds.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class OmniSlideChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("OmniSlide-Enabled", "全方向滑铲");
    this.Text("OmniSlide-Enabled-Description", "可向侧面、斜向和后方滑铲。V 的身体随镜头转动，因此你环顾四周时滑铲仍会继续。需要 TweakXL。");
    this.Text("OmniSlide-Speed", "滑铲速度");
    this.Text("OmniSlide-Speed-Description", "按倍数调整滑铲的速度。1.0 为游戏原速。");
    this.Text("OmniSlide-Slopes", "斜坡效果");
    this.Text("OmniSlide-Slopes-Description", "下坡时滑铲滑得更远，遇到陡峭的下坡会一直滑到地面变平为止。上坡时则更早停下。0 为游戏原样：无效果。");
    this.Text("OmniSlide-CrouchInAir", "落地滑铲");
    this.Text("OmniSlide-CrouchInAir-Description", "在跳跃的任意时刻按下蹲伏键，落地时就会滑铲。游戏原本会忽略在上升途中或跳跃最高点按下的蹲伏键。");
  }
}
