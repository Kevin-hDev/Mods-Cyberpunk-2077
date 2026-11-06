// Menu texts in Simplified Chinese, for the game's zh-cn language. Same keys as AutoSprintEnglish in Localization.reds.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class AutoSprintChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("AutoSprint-Enabled", "自动冲刺");
    this.Text("AutoSprint-Enabled-Description", "V 向前移动时会自动冲刺。蹲伏或慢走会中止冲刺。");
    this.Text("AutoSprint-Speed", "冲刺速度");
    this.Text("AutoSprint-Speed-Description", "按倍数调整站立冲刺的速度，无论是否自动。1.0 为游戏原速。超过 2.0 需要 TweakXL。");
    this.Text("AutoSprint-WalkSpeed", "步行速度");
    this.Text("AutoSprint-WalkSpeed-Description", "按倍数调整 V 直立移动但不冲刺时的速度，无论是否开启自动冲刺。慢走保持游戏原速。1.0 为游戏原速。超过 4.0 需要 TweakXL。");
    this.Text("AutoSprint-StepUp", "迈上路沿");
    this.Text("AutoSprint-StepUp-Description", "V 在步行或奔跑时会直接迈上路沿和低矮的台阶（最高 60 厘米），而不是被挡住停下。");
  }
}
