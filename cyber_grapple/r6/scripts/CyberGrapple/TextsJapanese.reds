// Japanese texts, for the game's jp-jp language. This class holds every key shown, menu and card alike,
// because all four providers return it for this language (Languages.reds).

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class CyberGrappleJapanese extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("CyberGrapple-Enabled", "Cyber Grapple");
    this.Text("CyberGrapple-Enabled-Description", "グラップリングランチャーのインプラントを装着し（リパードクで購入可）、戦闘ガジェットスロットに割り当てていれば、面に狙いを定めて「戦闘ガジェットを使用」キー（キーボード操作ではマウスの中ボタン、コントローラーではR1）を押すと、フックが飛び、ロープに引っ張られる。引っ張られている間は、エイムで進む方向を操作できる。オフ：インプラントは装着されたまま何も起こらない。");
    this.Text("CyberGrapple-Profile1-Key", "キー");
    this.Text("CyberGrapple-Profile1-Fov", "視野角");
    this.Text("CyberGrapple-OwnKey", "専用キー");
    this.Text("CyberGrapple-OwnKey-Description", "「戦闘ガジェットを使用」キーの代わりに、好きなキーでグラップリングフックを発射する。このキーはグレネード用に空いたままになる。");
    this.Text("CyberGrapple-Key", "キー");
    this.Text("CyberGrapple-Key-Description", "専用キーがオンのときに使う、グラップリングフックのキー。マウスホイールは使えない。");
    this.Text("CyberGrapple-KeyboardHold", "キーボード：長押しで発射");
    this.Text("CyberGrapple-KeyboardHold-Description", "キーを長押しするとグラップリングフックを発射する。高速近接攻撃キーでは、軽く押せばこれまでどおり高速近接攻撃になる。スキャナーのキーでは使えない。長押しでスキャナーが開くため。");
    this.Text("CyberGrapple-ControllerHold", "コントローラー：長押しで発射");
    this.Text("CyberGrapple-ControllerHold-Description", "ボタンを長押しするとグラップリングフックを発射する。高速近接攻撃ボタンでは、軽く押せばこれまでどおり高速近接攻撃になる。スキャナーのボタン（L1）では使えない。長押しでスキャナーが開くため。");
    this.Text("CyberGrapple-HoldTime", "長押し時間");
    this.Text("CyberGrapple-HoldTime-Description", "グラップリングフックの発射に必要な長押しの長さ。単位は秒。");
    this.Text("CyberGrapple-Crosshair", "素手とナックル時のクロスヘア");
    this.Text("CyberGrapple-CrosshairShape-Simple", "シンプル");
    this.Text("CyberGrapple-CrosshairShape-Basic", "ベーシック");
    this.Text("CyberGrapple-CrosshairShape-Shotgun", "ショットガン");
    this.Text("CyberGrapple-CrosshairShape-SmartRifle", "スマート");
    this.Text("CyberGrapple-CrosshairShape-TechCircle", "テック（円形）");
    this.Text("CyberGrapple-CrosshairShape-TechHex", "テック（六角形）");
    this.Text("CyberGrapple-CrosshairShape-Launcher", "プロジェクタイルランチャー");
    this.Text("CyberGrapple-CrosshairShape-MantisBlades", "マンティスブレード");
    this.Text("CyberGrapple-CrosshairShape-HeavyMachineGun", "ヘビーマシンガン");
    this.Text("CyberGrapple-CrosshairShape-Dot", "画面中央のドット");
    this.Text("CyberGrapple-CrosshairColor", "カラー");
    this.Text("CyberGrapple-CrosshairColor-Description", "クロスヘアの色。ターコイズは、ゲームのクロスヘアの色。");
    this.Text("CyberGrapple-CrosshairColor-Yellow", "イエロー");
    this.Text("CyberGrapple-CrosshairColor-White", "ホワイト");
    this.Text("CyberGrapple-CrosshairColor-Red", "レッド");
    this.Text("CyberGrapple-CrosshairColor-Green", "グリーン");
    this.Text("CyberGrapple-CrosshairColor-Turquoise", "ターコイズ（ゲーム標準）");
    this.Text("CyberGrapple-CrosshairSize", "サイズ");
    this.Text("CyberGrapple-CrosshairSize-Description", "クロスヘアのサイズ。ゲームのクロスヘアに対する割合（%）で表す。");
    this.Text("CyberGrapple-CrosshairRange", "射程表示");
    this.Text("CyberGrapple-CrosshairRange-Description", "押してもグラップリングフックが発射されないとき、クロスヘアは射程外の色になる。該当するのは、チャージが残っていない、インプラントが戦闘ガジェットスロットにない（「専用キー」がオフのとき）、射程内に何もない、空を狙っている、インプラントのクラスではまだ捕らえられない人物や乗り物が射線上にいる、引き寄せられる距離より遠くに人物やオートバイがいる、高速近接攻撃の範囲内に誰かがいる、またはフックがまだ出たままの場合。");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor", "射程外の色");
    this.Text("CyberGrapple-CrosshairOutOfRangeColor-Description", "グラップリングフックが発射されないときのクロスヘアの色。クロスヘアの色とは別の色を選ぶ。同じ色にすると、射程表示はオフになる。");
    this.Text("CyberGrapple-DynamicFov", "ダイナミック視野角");
    this.Text("CyberGrapple-DynamicFov-Description", "ロープがVを引っ張っている間は視野角が広がり、引っ張りが止まると元に戻る。一人称視点でのみ働き、武器でエイム中は働かない。オフ：視野角はゲームの設定のまま。");
    this.Text("CyberGrapple-FovWidening", "視野角の拡大");
    this.Text("CyberGrapple-FovWidening-Description", "ゲームの視野角の設定に加算される。単位は同じ度数で、10なら100が110になる。合計は140が上限。");
    this.Text("CyberGrapple-FovTransition", "視野角の変化時間");
    this.Text("CyberGrapple-FovTransition-Description", "単位は秒。引っ張りが始まって視野角が広がるまでと、止まって元に戻るまでにかかる時間。");
    this.Text("CyberGrapple-Card-Name", "グラップリングランチャー");
    this.Text("CyberGrapple-Card-Description", "プロジェクタイルの代わりに、ロープ付きのフックを発射する腕のインプラント。");
    this.Text("CyberGrapple-Card-Travel", "グラップリングフックを発射し、狙った面まで自分を引き寄せる。");
    this.Text("CyberGrapple-Card-Pull20", "最大20m離れた人物、敵、オートバイを自分のほうへ引き寄せる。");
    this.Text("CyberGrapple-Card-Pull25", "最大25m離れた人物、敵、オートバイを自分のほうへ引き寄せる。");
    this.Text("CyberGrapple-Card-Pull30", "最大30m離れた人物、敵、オートバイを自分のほうへ引き寄せる。");
    this.Text("CyberGrapple-Card-Pull35", "最大35m離れた人物、敵、オートバイを自分のほうへ引き寄せる。");
    this.Text("CyberGrapple-Card-Pull40", "最大40m離れた人物、敵、オートバイを自分のほうへ引き寄せる。");
    this.Text("CyberGrapple-Card-Range", "射程");
    this.Text("CyberGrapple-Card-TopSpeed", "最高速度");
    this.Text("CyberGrapple-Card-Seize", "人物を手元まで引き寄せ、グラップルする。");
    this.Text("CyberGrapple-Card-Next10", "クラス2へのアップグレードにはキャラクターレベル10が必要。");
    this.Text("CyberGrapple-Card-Next20", "クラス3へのアップグレードにはキャラクターレベル20が必要。");
    this.Text("CyberGrapple-Card-Next30", "クラス4へのアップグレードにはキャラクターレベル30が必要。");
    this.Text("CyberGrapple-Card-Next40", "クラス5へのアップグレードにはキャラクターレベル40が必要。");
    this.Text("CyberGrapple-Card-Distance", "{n}m");
    this.Text("CyberGrapple-Card-Speed", "{n}m/s");
    this.Text("CyberGrapple-Card-DecimalMark", ".");
    this.Text("CyberGrapple-Silent-OtherOn", "Apex Grappleがオンの間は、グラップリングフックのインプラントはオフになります。インプラントを使うには、Apex Grappleの設定でオフにしてください。セーブデータは変更されません。");
    this.Text("CyberGrapple-Silent-OtherUnread", "グラップリングフックのインプラントはオフになっています。Apex Grappleはインストールされていますが、そのスイッチを読み取れませんでした。インプラントを使うには、Apex Grappleをゲームのフォルダーから移動してください。セーブデータは変更されません。");
    this.Text("CyberGrapple-Silent-NoTweakXL", "Cyber Grapple：TweakXLがインストールされていないため、このゲームにはグラップリングランチャーのインプラントが存在しません。TweakXLとRED4extをインストールしてから、ゲームを再起動してください。");
    this.Text("CyberGrapple-Silent-NoRecords", "Cyber Grapple：このバージョンのゲームには、グラップリングランチャーのインプラントを追加できませんでした。MODが更新されるまで、このMODは何もしません。");
    this.Text("CyberGrapple-Upgrade-Waiting", "Cyber Grapple：このバージョンのゲームから、グラップリングランチャーの一部のアップグレードに必要なレベルを読み取れませんでした。MODが更新されるまで、それらのアップグレードにレベルは必要ありません。");
    this.Text("CyberGrapple-CrosshairSource", "クロスヘア");
    this.Text("CyberGrapple-CrosshairSource-Description", "Vが素手のとき、またはナックルで戦っているときに、どのクロスヘアを表示するか。Cyber Grapple：グラップリングフックを発射できるときに狙いをつけるための、このMODのクロスヘア。ゲーム：何も追加しない。ゲームと同じく、この状態ではクロスヘアは表示されない。");
    this.Text("CyberGrapple-CrosshairSource-Mod", "Cyber Grapple");
    this.Text("CyberGrapple-CrosshairSource-Game", "ゲーム");
    this.Text("CyberGrapple-CrosshairPick", "クロスヘアの形");
    this.Text("CyberGrapple-CrosshairPick-Description", "このMODのクロスヘアの形。Vが武器や腕のサイバーウェアを手にするとすぐに非表示になる。これらには専用のクロスヘアがあるため。乗り物の中、スキャナー使用中、シーン中も非表示になる。");
    this.Text("CyberGrapple-Impact", "フックの衝撃");
    this.Text("CyberGrapple-ImpactEffect", "衝撃エフェクト");
    this.Text("CyberGrapple-ImpactEffect-Description", "ゲーム本来の衝撃エフェクトのひとつ。フックが面や乗り物に当たった位置に一度だけ表示される。人物やオートバイに当たったときは表示されない。オフ：フックが当たった位置には何も表示されない。");
    this.Text("CyberGrapple-ImpactStyle", "衝撃エフェクトのスタイル");
    this.Text("CyberGrapple-ImpactStyle-Description", "表示するゲームの衝撃エフェクト。それぞれ、ゲーム内でそれを生むもの、つまり当たった面と武器の名前が付いている。");
    this.Text("CyberGrapple-ImpactStyle-ConcreteBullet", "コンクリート（弾丸）");
    this.Text("CyberGrapple-ImpactStyle-ConcreteLargeCaliber", "コンクリート（大口径）");
    this.Text("CyberGrapple-ImpactStyle-ConcreteHammer", "コンクリート（ハンマー）");
    this.Text("CyberGrapple-ImpactStyle-MetalHammer", "金属（ハンマー）");
    this.Text("CyberGrapple-ImpactStyle-Monowire", "モノワイヤー");
    this.Text("CyberGrapple-ImpactStyle-DefaultBullet", "汎用（弾丸）");
    this.Text("CyberGrapple-Voice", "Vの声");
    this.Text("CyberGrapple-VoiceLines", "セリフ");
    this.Text("CyberGrapple-VoiceLines-Description", "グラップリングフックが人物をVのもとへ引き寄せ始めたとき、Vがセリフを言う。グラップリングフックで引き寄せてグラップルした人物をVが殺したときや気絶させたときにも、別のセリフを言う。セリフを再生するにはAudiowareが必要。オフ：Vは何も言わない。");
    this.Text("CyberGrapple-VoiceGender", "声");
    this.Text("CyberGrapple-VoiceGender-Description", "セリフを言う声。自動：自分のVの声。女声または男声：常にその声。");
    this.Text("CyberGrapple-VoiceGender-Auto", "自動");
    this.Text("CyberGrapple-VoiceGender-Female", "女声");
    this.Text("CyberGrapple-VoiceGender-Male", "男声");
    this.Text("CyberGrapple-VoicePullChance", "引き寄せ時のセリフの頻度");
    this.Text("CyberGrapple-VoicePullChance-Description", "グラップリングフックが人物をVのもとへ引き寄せ始めたときに、Vがセリフを言う頻度（パーセント、10回ごとに正確）。");
    this.Text("CyberGrapple-VoiceKillChance", "テイクダウン時のセリフの頻度");
    this.Text("CyberGrapple-VoiceKillChance-Description", "グラップリングフックで引き寄せてグラップルした人物をVが殺したときや気絶させたときに、Vがセリフを言う頻度（パーセント、10回ごとに正確）。");
    this.Text("CyberGrapple-VoiceKillStyle", "テイクダウン時のセリフのスタイル");
    this.Text("CyberGrapple-VoiceKillStyle-Description", "Vがテイクダウン時のセリフを言う方法。ノーマル：声に出して言う。ささやき：Vがささやく。ノーマル＋ささやき：両方をランダムに混ぜる。");
    this.Text("CyberGrapple-VoiceKillStyle-Normal", "ノーマル");
    this.Text("CyberGrapple-VoiceKillStyle-Whisper", "ささやき");
    this.Text("CyberGrapple-VoiceKillStyle-Both", "ノーマル＋ささやき");
  }
}
