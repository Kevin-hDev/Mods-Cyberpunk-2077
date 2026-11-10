// Made by fabrique/crosshairs.py from the game's crosshair_tech_circle.inkwidget (2.5), never edited by hand: run
// python -I fabrique/crosshairs.py after a change there (fabrique/test_crosshairs.py fails while this file
// is out of date). What each list of numbers holds: CrosshairPieces.reds.

public func ApexGrappleDrawCrosshairTechCircle(root: ref<inkCanvas>, color: HDRColor) -> Void {
  let c0: ref<inkCanvas> = ApexGrappleCrosshairCanvas(root, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // Root
  let c1: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // reticle
  let c2: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c1, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // crosshair
  let c3: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c2, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // top
  ApexGrappleCrosshairImage(c3, inkEAnchor.Centered, [0.5, 1.0, 0.0, -25.0, 0.0, 0.0, 3.0, 8.0, -3.0, -20.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_B", inkBrushMirrorType.NoMirror, color); // top_l
  ApexGrappleCrosshairImage(c3, inkEAnchor.Centered, [0.5, 1.0, 0.0, -25.0, 0.0, 0.0, 3.0, 8.0, 3.0, -20.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_B", inkBrushMirrorType.NoMirror, color); // top_r
  ApexGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.5, 1.0, 0.0, 25.0, 0.0, 0.0, 3.0, 14.0, 0.0, 20.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_B", inkBrushMirrorType.NoMirror, color); // bot
  ApexGrappleCrosshairImage(c2, inkEAnchor.CenterLeft, [1.0, 0.5, -25.0, 0.0, 0.0, 0.0, 3.0, 25.0, -20.0, 0.0, 90.0, 1.0, 1.0, 0.5, 0.5, 1.0], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_B", inkBrushMirrorType.NoMirror, color); // left
  ApexGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.0, 0.5, 25.0, 0.0, 0.0, 0.0, 3.0, 25.0, 20.0, 0.0, 90.0, 1.0, 1.0, 0.5, 0.5, 1.0], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"riska_B", inkBrushMirrorType.NoMirror, color); // right
  ApexGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"dot", inkBrushMirrorType.NoMirror, color); // dot
}
