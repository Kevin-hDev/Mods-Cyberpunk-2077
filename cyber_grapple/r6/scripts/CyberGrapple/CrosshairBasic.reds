// Made by fabrique/grapple.py from Apex Grapple's CrosshairBasic.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Made by fabrique/crosshairs.py from the game's crosshair_basic.inkwidget (2.5), never edited by hand: run
// python -I fabrique/crosshairs.py after a change there (fabrique/test_crosshairs.py fails while this file
// is out of date). What each list of numbers holds: CrosshairPieces.reds.

public func CyberGrappleDrawCrosshairBasic(root: ref<inkCanvas>, color: HDRColor) -> Void {
  let c0: ref<inkCanvas> = CyberGrappleCrosshairCanvas(root, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // Root
  CyberGrappleCrosshairImage(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], false, r"base\\gameplay\\gui\\widgets\\crosshair\\pistols\\atlas_pistol_crosshair.inkatlas", n"dot", inkBrushMirrorType.NoMirror, color); // center
  CyberGrappleCrosshairImage(c0, inkEAnchor.Centered, [1.0, 0.5, -7.0, 0.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\pistols\\atlas_pistol_crosshair.inkatlas", n"left", inkBrushMirrorType.NoMirror, color); // left
  CyberGrappleCrosshairImage(c0, inkEAnchor.Centered, [0.0, 0.5, 7.0, 0.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\pistols\\atlas_pistol_crosshair.inkatlas", n"right", inkBrushMirrorType.NoMirror, color); // right
  CyberGrappleCrosshairImage(c0, inkEAnchor.Centered, [0.5, 1.0, 0.0, -7.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\pistols\\atlas_pistol_crosshair.inkatlas", n"up", inkBrushMirrorType.NoMirror, color); // up
  CyberGrappleCrosshairImage(c0, inkEAnchor.Centered, [0.5, 0.0, 0.0, 7.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\pistols\\atlas_pistol_crosshair.inkatlas", n"down", inkBrushMirrorType.NoMirror, color); // down
}
