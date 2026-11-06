// Menu texts in Simplified Chinese, for the game's zh-cn language. Same keys as OmniSprintEnglish in Localization.reds.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class OmniSprintChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("OmniSprint-Enabled", "全方向冲刺");
    this.Text("OmniSprint-Enabled-Description", "也可向侧面、斜向和后方冲刺。需要 TweakXL。");
  }
}
