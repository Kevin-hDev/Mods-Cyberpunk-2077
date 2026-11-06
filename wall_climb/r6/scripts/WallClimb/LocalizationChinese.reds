// Menu texts in Simplified Chinese, for the game's zh-cn language. Same keys as WallClimbEnglish in Localization.reds.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class WallClimbChinese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("WallClimb-Enabled", "墙面攀爬");
    this.Text("WallClimb-Enabled-Description", "跳向或落向墙壁并按住前进键：V 会双手交替攀爬墙面。前进键配合左右键可斜向攀爬；在墙上时单按左右键可沿墙横向移动，并绕过墙角。边缘够得着时，V 会翻上去。攀爬时会收起武器。");
    this.Text("WallClimb-MaxHeight", "最大攀爬高度");
    this.Text("WallClimb-MaxHeight-Description", "V 松手前能爬多高，单位为米，从 V 抓住墙的位置起算。");
    this.Text("WallClimb-ClimbSpeed", "攀爬速度");
    this.Text("WallClimb-ClimbSpeed-Description", "V 的攀爬速度：1 为正常速度，3 为三倍速度。");
    this.Text("WallClimb-HoldOn", "停下时留在墙上");
    this.Text("WallClimb-HoldOn-Description", "开启：松开摇杆或移动键后，V 会停下并像在梯子上一样抓住墙面；再次推动即可继续攀爬。关闭：V 松手并坠落。按后退键始终会松手。");
    this.Text("WallClimb-Regrab", "再次抓墙");
    this.Text("WallClimb-Regrab-Description", "开启：攀爬后坠落时，V 在松手 0.9 秒后可以再次抓住墙面，次数不限。关闭：落地前只能攀爬一次。");
    this.Text("WallClimb-LadderCamera", "在梯子上视角回正");
    this.Text("WallClimb-LadderCamera-Description", "开启：使用游戏的梯子镜头，V 抓住梯子时视角会自动回正。关闭：视角保持在你调整的位置；墙面攀爬开启时，游戏中的梯子也一样。");
    this.Text("WallClimb-SoftLanding", "攀爬后无坠落伤害");
    this.Text("WallClimb-SoftLanding-Description", "开启：攀爬之后的落地不造成伤害。关闭：沿用游戏原本的坠落伤害。");
    this.Text("WallClimb-FallEffect", "攀爬后的坠落效果");
    this.Text("WallClimb-FallEffect-Description", "开启：从攀爬开始直到落地，显示游戏在长距离坠落中的画面变暗效果。关闭：隐藏。徒步坠落始终保留该效果。");
  }
}
