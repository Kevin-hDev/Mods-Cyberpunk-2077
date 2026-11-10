// Made by fabrique/crosshairs.py from the game's mantis_blade.inkwidget (2.5), never edited by hand: run
// python -I fabrique/crosshairs.py after a change there (fabrique/test_crosshairs.py fails while this file
// is out of date). What each list of numbers holds: CrosshairPieces.reds.

public func ApexGrappleDrawCrosshairMantisBlades(root: ref<inkCanvas>, color: HDRColor) -> Void {
  let c0: ref<inkCanvas> = ApexGrappleCrosshairCanvas(root, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 3840.0, 2160.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // Root
  let c1: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // center
  let c2: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c1, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // hairs
  ApexGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.5, 0.5, 0.0, 65.0, 0.0, 0.0, 3.0, 40.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 0.4], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_B", inkBrushMirrorType.NoMirror, color); // blade_1
  ApexGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.5, 0.5, -61.0, -35.0, 0.0, 0.0, 3.0, 40.0, 0.0, 0.0, -60.0, 1.0, 1.0, 0.5, 0.5, 0.4], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_B", inkBrushMirrorType.NoMirror, color); // blade_2
  ApexGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.5, 0.5, 61.6666, -36.0, 0.0, 0.0, 3.0, 40.0, 0.0, 0.0, 60.0, 1.0, 1.0, 0.5, 0.5, 0.4], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_B", inkBrushMirrorType.NoMirror, color); // blade_3
  ApexGrappleCrosshairImage(c1, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"dot", inkBrushMirrorType.NoMirror, color); // dot
  let c3: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // legs
  let c4: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c3, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 41.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // bottom-R
  ApexGrappleCrosshairImage(c4, inkEAnchor.Centered, [0.5, 0.5, 624.0, -143.7537, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, -41.0, 1.0, 1.0, 0.5, 0.5, 0.1], true, r"base\\gameplay\\gui\\widgets\\crosshair\\mantis_blade\\mantis_blade.inkatlas", n"s_arm", inkBrushMirrorType.Horizontal, color); // BR
  let c5: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c3, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, -41.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // bottom-L
  ApexGrappleCrosshairImage(c5, inkEAnchor.Centered, [0.5, 0.5, -624.0988, -143.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 41.0, 1.0, 1.0, 0.5, 0.5, 0.1], true, r"base\\gameplay\\gui\\widgets\\crosshair\\mantis_blade\\mantis_blade.inkatlas", n"s_arm", inkBrushMirrorType.NoMirror, color); // BL
  let c6: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // nose
  let c7: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c6, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // nose-L
  ApexGrappleCrosshairImage(c7, inkEAnchor.Centered, [0.5, 0.5, -259.9001, 342.0142, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 38.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_A", inkBrushMirrorType.NoMirror, color); // mantis_blade_bg
  let c8: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c6, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // nose-R
  ApexGrappleCrosshairImage(c8, inkEAnchor.Centered, [0.5, 0.5, 0.0, 342.0142, -259.0, 0.0, 32.0, 32.0, 0.0, 0.0, -38.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_A", inkBrushMirrorType.NoMirror, color); // mantis_blade_bg
  let c9: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 0.25]); // scales-R
  ApexGrappleCrosshairImage(c9, inkEAnchor.Centered, [0.5, 0.5, 0.0, 449.9999, -307.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\mantis_blade\\mantis_blade.inkatlas", n"scales", inkBrushMirrorType.Horizontal, color); // mantis_blade_bg
  let c10: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 0.25]); // scales-L
  ApexGrappleCrosshairImage(c10, inkEAnchor.Centered, [0.5, 0.5, -307.0001, 449.9999, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\mantis_blade\\mantis_blade.inkatlas", n"scales", inkBrushMirrorType.NoMirror, color); // mantis_blade_bg
}
