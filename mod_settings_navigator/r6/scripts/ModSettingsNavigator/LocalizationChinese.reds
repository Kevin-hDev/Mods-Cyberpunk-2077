// Menu texts in Simplified Chinese, for the game's zh-cn language. Same keys as ModSettingsNavigatorEnglish in Localization.reds.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class ModSettingsNavigatorChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ModSettingsNavigator-Sections", "可折叠分区");
    this.Text("ModSettingsNavigator-Sections-Description", "点击分区标题（或用手柄选中后按确认键）即可折叠或展开该分区。折叠的分区会保持折叠，直到游戏关闭；如果安装了 RedFileSystem，则会一直保留。");
    this.Text("ModSettingsNavigator-Position", "回到上次的位置");
    this.Text("ModSettingsNavigator-Position-Description", "重新打开 Mod Settings 时，回到你上次所在的模组和行。读取存档或重启游戏后会重置。");
    this.Text("ModSettingsNavigator-Page", "第 {0} / {1} 页");
    this.Text("ModSettingsNavigator-PreviousPage", "上一页");
    this.Text("ModSettingsNavigator-NextPage", "下一页");
  }
}
