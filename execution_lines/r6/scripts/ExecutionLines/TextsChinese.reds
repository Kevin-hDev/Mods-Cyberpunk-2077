// Menu texts in Simplified Chinese, for the game's zh-cn language. Same keys as ExecutionLinesEnglish in Texts.reds,
// which says why a phrase's label stays in English.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class ExecutionLinesChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ExecutionLines-Enabled", "启用");
    this.Text("ExecutionLines-Enabled-Description", "V 处决人物时会说一句台词：处决造成的击杀或非致命击倒才算，枪击不算。需要 Audioware 来播放台词。关闭：本模组不再说任何台词。");
    this.Text("ExecutionLines-Voice", "声音");
    this.Text("ExecutionLines-Voice-Description", "说台词的声音。自动：你的 V 的声音。女性化或男性化：始终使用该声音，此时下方“女性 V”或“男性 V”部分的选择生效。");
    this.Text("ExecutionLines-Voice-Auto", "自动");
    this.Text("ExecutionLines-Voice-Female", "女性化");
    this.Text("ExecutionLines-Voice-Male", "男性化");
    this.Text("ExecutionLines-Chance", "处决台词频率");
    this.Text("ExecutionLines-Chance-Description", "V 在处决时说台词的频率：50 表示每十次中恰好五次，顺序随机。100：每次都说。击杀和非致命击倒计入同一组十次。");
    this.Text("ExecutionLines-Style", "处决台词风格");
    this.Text("ExecutionLines-Style-Description", "V 说所有台词的方式。正常：大声说出。耳语：V 低声耳语。正常 + 耳语：两者随机混合。“自定义”部分只能进一步缩小范围：只有两者都允许时，才会说这句台词。");
    this.Text("ExecutionLines-Style-Normal", "正常");
    this.Text("ExecutionLines-Style-Whisper", "耳语");
    this.Text("ExecutionLines-Style-Both", "正常 + 耳语");
    this.Text("ExecutionLines-Choice-Both", "正常 + 耳语");
    this.Text("ExecutionLines-Choice-Normal", "正常");
    this.Text("ExecutionLines-Choice-Whisper", "耳语");
    this.Text("ExecutionLines-Choice-None", "无");
    this.Text("ExecutionLines-NoAudioware", "Execution Lines：未安装 Audioware，无法听到 V 的台词。请安装 Audioware 才能听到。");

    this.Text("ExecutionLines-Male", "男性 V");
    this.Text("ExecutionLines-CustomMale", "自定义");
    this.Text("ExecutionLines-CustomMale-Description", "逐句选择男性 V 如何说每一句台词：大声说、耳语、两者皆可，或者不说。只有此选择和“处决台词风格”都允许时，才会说这句台词。关闭：只看“处决台词风格”，下方的选择会被忽略，即使之前改过。男性声音说话时，这些选择生效。");
    this.Text("ExecutionLines-MaleChooses", "A man chooses…");
    this.Text("ExecutionLines-MaleChooses-Description", "V 说：“A man chooses, a slave obeys.”（人自己做主，奴隶只会服从。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleInsanity", "Did I ever tell you…");
    this.Text("ExecutionLines-MaleInsanity-Description", "V 说：“Did I ever tell you what the definition of insanity is?”（我有没有告诉过你疯狂的定义是什么？）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleImpunity", "Executed with impunity");
    this.Text("ExecutionLines-MaleImpunity-Description", "V 说：“Executed with impunity!”（不受惩罚地处决！）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleKillOrBeKilled", "In this world…");
    this.Text("ExecutionLines-MaleKillOrBeKilled-Description", "V 说：“In this world, it's kill or be killed.”（在这个世界上，不是杀人就是被杀。）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleOneOfUs", "One of us must die");
    this.Text("ExecutionLines-MaleOneOfUs-Description", "V 说：“One of us must die.”（我们之中，必有一人要死。）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleDeath", "Your death will be swift");
    this.Text("ExecutionLines-MaleDeath-Description", "V 说：“Your death will be swift.”（你会死得很快。）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleSoul", "Your soul is weak");
    this.Text("ExecutionLines-MaleSoul-Description", "V 说：“Your soul is weak.”（你的灵魂很软弱。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");

    this.Text("ExecutionLines-Female", "女性 V");
    this.Text("ExecutionLines-CustomFemale", "自定义");
    this.Text("ExecutionLines-CustomFemale-Description", "逐句选择女性 V 如何说每一句台词：大声说、耳语、两者皆可，或者不说。只有此选择和“处决台词风格”都允许时，才会说这句台词。关闭：只看“处决台词风格”，下方的选择会被忽略，即使之前改过。女性声音说话时，这些选择生效。");
    this.Text("ExecutionLines-FemaleInsanity", "Did I ever tell you…");
    this.Text("ExecutionLines-FemaleInsanity-Description", "V 说：“Did I ever tell you what the definition of insanity is?”（我有没有告诉过你疯狂的定义是什么？）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleImpunity", "Executed with impunity");
    this.Text("ExecutionLines-FemaleImpunity-Description", "V 说：“Executed with impunity!”（不受惩罚地处决！）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleKillOrBeKilled", "In this world…");
    this.Text("ExecutionLines-FemaleKillOrBeKilled-Description", "V 说：“In this world, it's kill or be killed.”（在这个世界上，不是杀人就是被杀。）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleRespect", "Nothing is more badass…");
    this.Text("ExecutionLines-FemaleRespect-Description", "V 说：“Nothing is more badass than treating a woman with respect.”（没有什么比尊重女性更酷了。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleOneOfUs", "One of us must die");
    this.Text("ExecutionLines-FemaleOneOfUs-Description", "V 说：“One of us must die.”（我们之中，必有一人要死。）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleDeath", "Your death will be swift");
    this.Text("ExecutionLines-FemaleDeath-Description", "V 说：“Your death will be swift.”（你会死得很快。）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleSoul", "Your soul is weak");
    this.Text("ExecutionLines-FemaleSoul-Description", "V 说：“Your soul is weak.”（你的灵魂很软弱。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“处决台词风格”也必须允许。");
  }
}
