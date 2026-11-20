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
    this.Text("ExecutionLines-Voice-Description", "说台词的声音。自动：你的 V 的声音。女性化或男性化：始终使用该声音，此时下方该声音的两个部分（处决台词和钳制台词）的选择生效。");
    this.Text("ExecutionLines-Voice-Auto", "自动");
    this.Text("ExecutionLines-Voice-Female", "女性化");
    this.Text("ExecutionLines-Voice-Male", "男性化");
    this.Text("ExecutionLines-Chance", "处决台词频率");
    this.Text("ExecutionLines-Chance-Description", "V 在处决时说台词的频率：50 表示每十次中恰好五次，顺序随机。100：每次都说。击杀和非致命击倒计入同一组十次。");
    this.Text("ExecutionLines-GrabChance", "钳制台词频率");
    this.Text("ExecutionLines-GrabChance-Description", "V 钳制敌人几秒后，可以说一句台词：50 表示在持续这么久的钳制中，每十次恰好说五次，顺序随机。100：每次都说。0：从不说。说过钳制台词后，V 会在处决时说出它的收尾台词，与频率无关，前提是钳制台词已说完，且处决紧随其后。");
    this.Text("ExecutionLines-Style", "台词风格");
    this.Text("ExecutionLines-Style-Description", "V 说所有台词的方式：处决台词、钳制台词及其收尾台词。正常：大声说出。耳语：V 低声耳语。正常 + 耳语：两者随机混合。“自定义”部分只能进一步缩小范围：只有两者都允许时，才会说这句台词。收尾台词的说法与其钳制台词相同。");
    this.Text("ExecutionLines-Style-Normal", "正常");
    this.Text("ExecutionLines-Style-Whisper", "耳语");
    this.Text("ExecutionLines-Style-Both", "正常 + 耳语");
    this.Text("ExecutionLines-Volume", "正常台词音量");
    this.Text("ExecutionLines-Volume-Description", "V 大声说出的台词的音量。100：原始音量。调低则更轻；0：静音。");
    this.Text("ExecutionLines-WhisperVolume", "耳语台词音量");
    this.Text("ExecutionLines-WhisperVolume-Description", "V 耳语的台词的音量。100：原始音量。调低则更轻；0：静音。");
    this.Text("ExecutionLines-Choice-Both", "正常 + 耳语");
    this.Text("ExecutionLines-Choice-Normal", "正常");
    this.Text("ExecutionLines-Choice-Whisper", "耳语");
    this.Text("ExecutionLines-Choice-None", "无");
    this.Text("ExecutionLines-NoAudioware", "Execution Lines：未安装 Audioware，无法听到 V 的台词。请安装 Audioware 才能听到。");

    this.Text("ExecutionLines-Male", "男性 V，处决台词");
    this.Text("ExecutionLines-CustomMale", "自定义");
    this.Text("ExecutionLines-CustomMale-Description", "逐句选择男性 V 如何说每一句台词：大声说、耳语、两者皆可，或者不说。只有此选择和“台词风格”都允许时，才会说这句台词。关闭：只看“台词风格”，下方的选择会被忽略，即使之前改过。男性声音说话时，这些选择生效。");
    this.Text("ExecutionLines-MaleChooses", "A man chooses…");
    this.Text("ExecutionLines-MaleChooses-Description", "V 说：“A man chooses, a slave obeys.”（人自己做主，奴隶只会服从。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleInsanity", "Did I ever tell you…");
    this.Text("ExecutionLines-MaleInsanity-Description", "V 说：“Did I ever tell you what the definition of insanity is?”（我有没有告诉过你疯狂的定义是什么？）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleImpunity", "Executed with impunity");
    this.Text("ExecutionLines-MaleImpunity-Description", "V 说：“Executed with impunity!”（不受惩罚地处决！）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleExitLight", "Exit light, enter night");
    this.Text("ExecutionLines-MaleExitLight-Description", "V 说：“Exit light, enter night.”（光明离去，黑夜降临。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleKillOrBeKilled", "In this world…");
    this.Text("ExecutionLines-MaleKillOrBeKilled-Description", "V 说：“In this world, it's kill or be killed.”（在这个世界上，不是杀人就是被杀。）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleNotPersonal", "It's not personal…");
    this.Text("ExecutionLines-MaleNotPersonal-Description", "V 说：“It's not personal. You were just in my way.”（不是针对你。你只是挡了我的路。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleOneOfUs", "One of us must die");
    this.Text("ExecutionLines-MaleOneOfUs-Description", "V 说：“One of us must die.”（我们之中，必有一人要死。）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleSweetDreams", "Sweet dreams");
    this.Text("ExecutionLines-MaleSweetDreams-Description", "V 说：“Sweet dreams.”（做个好梦。）只在非致命击倒时说，击杀时不说。作为“I'm not locked in here…”的收尾台词时，无论你在此如何选择，V 都会说出它。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 处决时从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleDeath", "Your death will be swift");
    this.Text("ExecutionLines-MaleDeath-Description", "V 说：“Your death will be swift.”（你会死得很快。）只在击杀时说，非致命击倒时不说。作为“I'm not locked in here…”的收尾台词时，无论你在此如何选择，V 都会说出它。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 处决时从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleSoul", "Your soul is weak");
    this.Text("ExecutionLines-MaleSoul-Description", "V 说：“Your soul is weak.”（你的灵魂很软弱。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");

    this.Text("ExecutionLines-MaleGrab", "男性 V，钳制台词");
    this.Text("ExecutionLines-CustomMaleGrab", "自定义");
    this.Text("ExecutionLines-CustomMaleGrab-Description", "逐句选择男性 V 如何说每一句钳制台词：大声说、耳语、两者皆可，或者不说。只有此选择和“台词风格”都允许时，才会说这句台词。关闭：只看“台词风格”，下方的选择会被忽略，即使之前改过。男性声音说话时，这些选择生效。收尾台词没有单独的选择：它的说法与其钳制台词相同。");
    this.Text("ExecutionLines-MaleTicket", "A ticket to heaven…");
    this.Text("ExecutionLines-MaleTicket-Description", "钳制敌人时，V 说：“A ticket to heaven, or a lullaby?”（是通往天堂的门票，还是一首摇篮曲？）击杀后：“See you up there.”（天上见。）非致命击倒后：“Go to sleep!”（睡吧！）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleLockedIn", "I'm not locked in here…");
    this.Text("ExecutionLines-MaleLockedIn-Description", "钳制敌人时，V 说：“I'm not locked in here with you. You're locked in here with me.”（不是我被关在这里陪你，是你被关在这里陪我。）击杀后：“Your death will be swift.”（你会死得很快。）非致命击倒后：“Sweet dreams.”（做个好梦。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleLetYouGo", "Say my name…");
    this.Text("ExecutionLines-MaleLetYouGo-Description", "钳制敌人时，V 说：“Say my name and I'll let you go.”（说出我的名字，我就放你走。）击杀后：“You had your chance.”（你已经有过机会了。）非致命击倒后：“You had your chance.”（你已经有过机会了。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleScars", "Wanna know how…");
    this.Text("ExecutionLines-MaleScars-Description", "钳制敌人时，V 说：“Wanna know how I got these scars?”（想知道我这些伤疤是怎么来的吗？）击杀后：“Now you'll have your own.”（现在你也会有自己的了。）非致命击倒后：“Another time, maybe.”（也许下次吧。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-MaleSerious", "Why so serious?");
    this.Text("ExecutionLines-MaleSerious-Description", "钳制敌人时，V 说：“Why so serious?”（何必这么严肃？）击杀后：“Let's put a smile on that face.”（让那张脸笑一笑吧。）非致命击倒后：“Let's put a smile on that face.”（让那张脸笑一笑吧。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");

    this.Text("ExecutionLines-Female", "女性 V，处决台词");
    this.Text("ExecutionLines-CustomFemale", "自定义");
    this.Text("ExecutionLines-CustomFemale-Description", "逐句选择女性 V 如何说每一句台词：大声说、耳语、两者皆可，或者不说。只有此选择和“台词风格”都允许时，才会说这句台词。关闭：只看“台词风格”，下方的选择会被忽略，即使之前改过。女性声音说话时，这些选择生效。");
    this.Text("ExecutionLines-FemaleInsanity", "Did I ever tell you…");
    this.Text("ExecutionLines-FemaleInsanity-Description", "V 说：“Did I ever tell you what the definition of insanity is?”（我有没有告诉过你疯狂的定义是什么？）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleImpunity", "Executed with impunity");
    this.Text("ExecutionLines-FemaleImpunity-Description", "V 说：“Executed with impunity!”（不受惩罚地处决！）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleExitLight", "Exit light, enter night");
    this.Text("ExecutionLines-FemaleExitLight-Description", "V 说：“Exit light, enter night.”（光明离去，黑夜降临。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleKillOrBeKilled", "In this world…");
    this.Text("ExecutionLines-FemaleKillOrBeKilled-Description", "V 说：“In this world, it's kill or be killed.”（在这个世界上，不是杀人就是被杀。）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleNotPersonal", "It's not personal…");
    this.Text("ExecutionLines-FemaleNotPersonal-Description", "V 说：“It's not personal. You were just in my way.”（不是针对你。你只是挡了我的路。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleRespect", "Nothing is more badass…");
    this.Text("ExecutionLines-FemaleRespect-Description", "V 说：“Nothing is more badass than treating a woman with respect.”（没有什么比尊重女性更酷了。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleOneOfUs", "One of us must die");
    this.Text("ExecutionLines-FemaleOneOfUs-Description", "V 说：“One of us must die.”（我们之中，必有一人要死。）只在击杀时说，非致命击倒时不说。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleSweetDreams", "Sweet dreams");
    this.Text("ExecutionLines-FemaleSweetDreams-Description", "V 说：“Sweet dreams. And don't forget to dream of me.”（做个好梦。别忘了梦见我。）只在非致命击倒时说，击杀时不说。作为“I'm not locked in here…”的收尾台词时，无论你在此如何选择，V 都会说出它。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 处决时从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleDeath", "Your death will be swift");
    this.Text("ExecutionLines-FemaleDeath-Description", "V 说：“Your death will be swift.”（你会死得很快。）只在击杀时说，非致命击倒时不说。作为“I'm not locked in here…”的收尾台词时，无论你在此如何选择，V 都会说出它。正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 处决时从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleSoul", "Your soul is weak");
    this.Text("ExecutionLines-FemaleSoul-Description", "V 说：“Your soul is weak.”（你的灵魂很软弱。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");

    this.Text("ExecutionLines-FemaleGrab", "女性 V，钳制台词");
    this.Text("ExecutionLines-CustomFemaleGrab", "自定义");
    this.Text("ExecutionLines-CustomFemaleGrab-Description", "逐句选择女性 V 如何说每一句钳制台词：大声说、耳语、两者皆可，或者不说。只有此选择和“台词风格”都允许时，才会说这句台词。关闭：只看“台词风格”，下方的选择会被忽略，即使之前改过。女性声音说话时，这些选择生效。收尾台词没有单独的选择：它的说法与其钳制台词相同。");
    this.Text("ExecutionLines-FemaleTicket", "A ticket to heaven…");
    this.Text("ExecutionLines-FemaleTicket-Description", "钳制敌人时，V 说：“A ticket to heaven, or a lullaby?”（是通往天堂的门票，还是一首摇篮曲？）击杀后：“See you up there.”（天上见。）非致命击倒后：“Go to sleep!”（睡吧！）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleLockedIn", "I'm not locked in here…");
    this.Text("ExecutionLines-FemaleLockedIn-Description", "钳制敌人时，V 说：“I'm not locked in here with you. You're locked in here with me.”（不是我被关在这里陪你，是你被关在这里陪我。）击杀后：“Your death will be swift.”（你会死得很快。）非致命击倒后：“Sweet dreams. And don't forget to dream of me.”（做个好梦。别忘了梦见我。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleLetYouGo", "Say my name…");
    this.Text("ExecutionLines-FemaleLetYouGo-Description", "钳制敌人时，V 说：“Say my name and I'll let you go.”（说出我的名字，我就放你走。）击杀后：“You had your chance.”（你已经有过机会了。）非致命击倒后：“You had your chance.”（你已经有过机会了。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleScars", "Wanna know how…");
    this.Text("ExecutionLines-FemaleScars-Description", "钳制敌人时，V 说：“Wanna know how I got these scars?”（想知道我这些伤疤是怎么来的吗？）击杀后：“Now you'll have your own.”（现在你也会有自己的了。）非致命击倒后：“Another time, maybe.”（也许下次吧。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
    this.Text("ExecutionLines-FemaleSerious", "Why so serious?");
    this.Text("ExecutionLines-FemaleSerious-Description", "钳制敌人时，V 说：“Why so serious?”（何必这么严肃？）击杀后：“Let's put a smile on that face.”（让那张脸笑一笑吧。）非致命击倒后：“Let's put a smile on that face.”（让那张脸笑一笑吧。）正常 + 耳语：随机大声说或低声耳语。正常：只大声说。耳语：只低声耳语。无：V 从不说这句。“台词风格”也必须允许。");
  }
}
