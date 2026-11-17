// Made by fabrique/grapple.py from Apex Grapple's CrosshairTechHex.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Made by fabrique/crosshairs.py from the game's crosshair_tech_hex.inkwidget (2.5), never edited by hand: run
// python -I fabrique/crosshairs.py after a change there (fabrique/test_crosshairs.py fails while this file
// is out of date). What each list of numbers holds: CrosshairPieces.reds.

public func CyberGrappleDrawCrosshairTechHex(root: ref<inkCanvas>, color: HDRColor) -> Void {
  let c0: ref<inkCanvas> = CyberGrappleCrosshairCanvas(root, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // Root
  let c1: ref<inkCanvas> = CyberGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // Details
  CyberGrappleCrosshairImage(c1, inkEAnchor.Centered, [1.0, 0.5, -75.0, 0.0, 0.0, 0.0, 32.0, 110.0, 1.0, 1.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"shotgun", inkBrushMirrorType.Horizontal, color); // left
  CyberGrappleCrosshairSlicedImage(c1, inkEAnchor.Centered, [0.0, 0.5, 75.0, 0.0, 0.0, 0.0, 32.0, 110.0, 1.0, 1.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"shotgun", inkBrushMirrorType.NoMirror, [0.0, 30.0, 0.0, 30.0], color); // right
  CyberGrappleCrosshairImage(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"dot", inkBrushMirrorType.NoMirror, color); // dot
  CyberGrappleCrosshairRect(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 100.0, 2.0, 1.0, 1.0, 0.0, 1.0, 2.0, 0.5, 0.5, 0.2], color); // fg
}
