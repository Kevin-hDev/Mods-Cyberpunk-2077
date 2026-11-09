// Menu texts in Simplified Chinese, for the game's zh-cn language. Same keys as ApexGrappleEnglish in Localization.reds.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class ApexGrappleChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ApexGrapple-Enabled", "Apex Grapple");
    this.Text("ApexGrapple-Enabled-Description", "瞄准一个表面并按下敏捷近战键（键盘为 Q；手柄为 R3，在 Alternative 或 Switch Legacy 按键布局下为 L1）：钩子飞出，绳索拉动你，同时由你的瞄准操控方向。关闭：该键只执行敏捷近战。");
    this.Text("ApexGrapple-Profile1", "配置 1：基础抓钩");
    this.Text("ApexGrapple-Profile2", "配置 2");
    this.Text("ApexGrapple-Profile3", "配置 3");
    this.Text("ApexGrapple-Profile4", "配置 4");
    this.Text("ApexGrapple-Profile5", "配置 5");
    this.Text("ApexGrapple-ShowSettings", "显示设置");
    this.Text("ApexGrapple-ShowSettings-Description", "在下方显示此配置的设置。无论是否显示，此配置都照常生效。");
    this.Text("ApexGrapple-ProfileActive", "启用");
    this.Text("ApexGrapple-ProfileActive-Description", "此配置用自己的按键和下方的设置发射抓钩。需要 Codeware。");
    this.Text("ApexGrapple-ProfileKey", "按键");
    this.Text("ApexGrapple-ProfileKey-Description", "此配置的抓钩按键。两个配置使用同一按键时，编号较小的配置发射。不能使用鼠标滚轮。");
    this.Text("ApexGrapple-Implant", "手臂义体");
    this.Text("ApexGrapple-Implant-Description", "第一人称视角下，左臂发射抓钩所用的义体。无：绳索从手中射出。需要 Codeware。");
    this.Text("ApexGrapple-Implant-None", "无");
    this.Text("ApexGrapple-Implant-ProjectileLauncher", "射弹发射系统");
    this.Text("ApexGrapple-RequireLauncher", "需要射弹发射系统");
    this.Text("ApexGrapple-RequireLauncher-Description", "只有当V安装了射弹发射系统（无论是否显示）时，抓钩才能使用。否则抓钩不会发射。");
    this.Text("ApexGrapple-OwnKey", "独立按键");
    this.Text("ApexGrapple-OwnKey-Description", "用自选的按键发射抓钩，而不是敏捷近战键。需要 Codeware。");
    this.Text("ApexGrapple-Key", "按键");
    this.Text("ApexGrapple-Key-Description", "抓钩按键，在开启“独立按键”时使用。不能使用鼠标滚轮。");
    this.Text("ApexGrapple-KeyboardHold", "键盘：按住发射抓钩");
    this.Text("ApexGrapple-KeyboardHold-Description", "按住按键发射抓钩。使用敏捷近战键时，轻按一下仍然执行敏捷近战。扫描键除外，长按会打开扫描。");
    this.Text("ApexGrapple-ControllerHold", "手柄：按住发射抓钩");
    this.Text("ApexGrapple-ControllerHold-Description", "按住按钮发射抓钩。使用敏捷近战按钮时，轻按一下仍然执行敏捷近战。扫描按钮（L1）除外，长按会打开扫描。");
    this.Text("ApexGrapple-HoldTime", "按住时间");
    this.Text("ApexGrapple-HoldTime-Description", "发射抓钩需要按住多久，单位为秒。");
    this.Text("ApexGrapple-Range", "射程");
    this.Text("ApexGrapple-Range-Description", "钩子能到达多远，单位为米。");
    this.Text("ApexGrapple-HookSpeed", "钩子速度");
    this.Text("ApexGrapple-HookSpeed-Description", "钩子飞向目标的速度，单位为米/秒。");
    this.Text("ApexGrapple-HookReturn", "钩子回收速度");
    this.Text("ApexGrapple-HookReturn-Description", "钩子收回时比飞出时快几倍。下一次抓钩会等它收回。");
    this.Text("ApexGrapple-PullStrength", "牵引力度");
    this.Text("ApexGrapple-PullStrength-Description", "绳索拉动你的力度，单位为 m/s²。");
    this.Text("ApexGrapple-PullSpeedCap", "牵引速度上限");
    this.Text("ApexGrapple-PullSpeedCap-Description", "绳索所能增加的最高速度，单位为米/秒。你的惯性会叠加在其上。");
    this.Text("ApexGrapple-SteerStrength", "操控力度");
    this.Text("ApexGrapple-SteerStrength-Description", "牵引期间，瞄准使路线偏转的力度，单位为 m/s²。让准星保持在转弯内侧，即可绕着锚点盘旋。在你脱钩之前，移动键不起作用。");
    this.Text("ApexGrapple-RopeCarry", "绳索承重");
    this.Text("ApexGrapple-RopeCarry-Description", "钩子固定期间，绳索承担你体重的比例，单位为百分比。设为 100 时，你会笔直飞向瞄准的位置，直到脱钩才会下落，和 Apex 里一样。");
    this.Text("ApexGrapple-TakeOffLift", "起飞助力");
    this.Text("ApexGrapple-TakeOffLift-Description", "在地面开始牵引时的小幅跳跃，单位为米/秒。设为 0 时，你会贴着地面离开。");
    this.Text("ApexGrapple-TakeOffTime", "起飞时间");
    this.Text("ApexGrapple-TakeOffTime-Description", "牵引开始后的这段时间内会忽略地面，单位为秒，让你能够起飞。");
    this.Text("ApexGrapple-HoldToKeepPulling", "按住以持续牵引");
    this.Text("ApexGrapple-HoldToKeepPulling-Description", "松开按键即脱钩。轻按一下则一直拉到底。在扫描按钮上（手柄 L1），轻按一下总是拉到底：再按一次即脱钩。");
    this.Text("ApexGrapple-ArrivalDistance", "到达距离");
    this.Text("ApexGrapple-ArrivalDistance-Description", "牵引在距钩子此距离处停止，单位为米；较短的发射会在半途停止。");
    this.Text("ApexGrapple-LetGoPastAnchor", "越过锚点后脱钩");
    this.Text("ApexGrapple-LetGoPastAnchor-Description", "一旦你飞越锚点，绳索就不再把你往回拉，并在越过锚点此距离后脱钩，单位为米。");
    this.Text("ApexGrapple-LongestPull", "最长牵引时间");
    this.Text("ApexGrapple-LongestPull-Description", "单位为秒。0 表示不限制。");
    this.Text("ApexGrapple-LetGoOnLanding", "落地时脱钩");
    this.Text("ApexGrapple-LetGoOnLanding-Description", "接触地面会结束牵引。");
    this.Text("ApexGrapple-PreserveJump", "脱钩时保留跳跃");
    this.Text("ApexGrapple-PreserveJump-Description", "跳跃脱钩不消耗跳跃次数。");
    this.Text("ApexGrapple-RegainDoubleJump", "每次抓钩恢复二段跳");
    this.Text("ApexGrapple-RegainDoubleJump-Description", "抓钩勾住时，V 恢复二段跳。需要二段跳义体。");
    this.Text("ApexGrapple-HookTargets", "抓钩可勾载具和人物");
    this.Text("ApexGrapple-HookTargets-Description", "抓钩也能勾住载具、敌人和路人，并随其移动。载具总是把 V 拉过去。需要 Codeware。");
    this.Text("ApexGrapple-PullPeople", "把人拉向 V");
    this.Text("ApexGrapple-PullPeople-Description", "需开启上一项：在游戏允许时，被勾住的人会被拉向 V，而不是 V 被拉过去；否则 V 被拉过去（任务过场、坐在载具里的人、V 附近没有地面）。只有人类和仿生人会被拉过来：首领、无人机和机甲总是把 V 拉过去。");
    this.Text("ApexGrapple-PullDamage", "拉人时造成伤害");
    this.Text("ApexGrapple-PullDamage-Description", "需开启上面两项：被拉向 V 的人会被重重摔在 V 面前的地上，按游戏规则承受冲击伤害，可能因此死亡。关闭时，在其静止之前，坠落和撞击不会造成伤害；V 的射击仍会造成伤害。");
    this.Text("ApexGrapple-SteerPeople", "用准星控制被拉的人");
    this.Text("ApexGrapple-SteerPeople-Description", "在把人拉向 V 时生效：射出后抬高准星，被拉的人会被拉到更高处，最高 6 米；左右转动准星，会把人甩向那一侧，最远 8 米。偏差小于 5 度时不变。");
    this.Text("ApexGrapple-PunchWins", "敏捷近战优先于抓钩");
    this.Text("ApexGrapple-PunchWins-Description", "敏捷近战范围内有人或载具时，执行敏捷近战而不是抓钩。");
    this.Text("ApexGrapple-PunchRange", "敏捷近战范围");
    this.Text("ApexGrapple-PunchRange-Description", "距离小于此值的人或载具会受到敏捷近战，单位为米。");
    this.Text("ApexGrapple-SoftLanding", "抓钩后软着陆");
    this.Text("ApexGrapple-SoftLanding-Description", "抓钩之后的落地不造成伤害。关闭：沿用游戏原本的坠落伤害。");
    this.Text("ApexGrapple-FallEffect", "抓钩期间的坠落效果");
    this.Text("ApexGrapple-FallEffect-Description", "抓钩飞行期间直到落地时，游戏在长距离坠落中显示的画面变暗效果。关闭：隐藏。徒步坠落始终保留该效果。");
  }
}
