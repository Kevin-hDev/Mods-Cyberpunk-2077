// Made by fabrique/grapple.py from Apex Grapple's CrosshairHeavyMachineGun.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Made by fabrique/crosshairs.py from the game's crosshair_custom_hmg.inkwidget (2.5), never edited by hand: run
// python -I fabrique/crosshairs.py after a change there (fabrique/test_crosshairs.py fails while this file
// is out of date). What each list of numbers holds: CrosshairPieces.reds.

public func CyberGrappleDrawCrosshairHeavyMachineGun(root: ref<inkCanvas>, color: HDRColor) -> Void {
  let c0: ref<inkCanvas> = CyberGrappleCrosshairCanvas(root, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 3840.0, 2160.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // Root
  let c1: ref<inkCanvas> = CyberGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 1.0, 1.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // fluff
  let c2: ref<inkCanvas> = CyberGrappleCrosshairCanvas(c1, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // hori
  CyberGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.5, 0.5, -240.0, -51.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\custom\\militech\\militech_turret_fluff.inkatlas", n"s_top", inkBrushMirrorType.Vertical, color); // hori_tl
  CyberGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.5, 0.5, 240.0, 50.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 180.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\custom\\militech\\militech_turret_fluff.inkatlas", n"s_top", inkBrushMirrorType.Vertical, color); // hori_br
  CyberGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.5, 0.5, 240.0, -51.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\custom\\militech\\militech_turret_fluff.inkatlas", n"s_top", inkBrushMirrorType.Both, color); // hori_tr
  CyberGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.5, 0.5, -240.0, 51.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 180.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\custom\\militech\\militech_turret_fluff.inkatlas", n"s_top", inkBrushMirrorType.Both, color); // hori_br
  let c3: ref<inkCanvas> = CyberGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // reticle
  let c4: ref<inkCanvas> = CyberGrappleCrosshairCanvas(c3, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // crosshair
  CyberGrappleCrosshairImage(c4, inkEAnchor.Centered, [0.5, 1.0, 0.0, -25.0, 0.0, 0.0, 3.0, 14.0, 0.0, -20.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_B", inkBrushMirrorType.NoMirror, color); // top
  CyberGrappleCrosshairImage(c4, inkEAnchor.Centered, [0.5, 0.0, 0.0, 25.0, 0.0, 0.0, 3.0, 14.0, 0.0, 20.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_B", inkBrushMirrorType.NoMirror, color); // bot
  CyberGrappleCrosshairImage(c4, inkEAnchor.Centered, [1.0, 0.5, -25.0, 0.0, 0.0, 0.0, 3.0, 42.0, -60.0, 0.0, 90.0, 1.0, 1.0, 0.5, 0.5, 1.0], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_B", inkBrushMirrorType.NoMirror, color); // left
  CyberGrappleCrosshairImage(c4, inkEAnchor.Centered, [0.0, 0.5, 25.0, 0.0, 0.0, 0.0, 3.0, 42.0, 60.0, 0.0, 90.0, 1.0, 1.0, 0.5, 0.5, 1.0], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_B", inkBrushMirrorType.NoMirror, color); // right
  CyberGrappleCrosshairImage(c4, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"dot", inkBrushMirrorType.NoMirror, color); // dot
}
