// Made by fabrique/crosshairs.py from the game's crosshair_shotgun.inkwidget (2.5), never edited by hand: run
// python -I fabrique/crosshairs.py after a change there (fabrique/test_crosshairs.py fails while this file
// is out of date). What each list of numbers holds: CrosshairPieces.reds.

public func ApexGrappleDrawCrosshairShotgun(root: ref<inkCanvas>, color: HDRColor) -> Void {
  let c0: ref<inkCanvas> = ApexGrappleCrosshairCanvas(root, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // root
  let c1: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // reticle
  let c2: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c1, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // crosshair
  let c3: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c2, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // Details
  ApexGrappleCrosshairImage(c3, inkEAnchor.Centered, [1.0, 0.5, -25.0, 0.0, 0.0, 0.0, 31.0, 160.0, -60.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 0.35], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"shotgun", inkBrushMirrorType.Horizontal, color); // left
  ApexGrappleCrosshairImage(c3, inkEAnchor.Centered, [0.0, 0.5, 25.0, 0.0, 0.0, 0.0, 31.0, 160.0, 60.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 0.35], false, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"shotgun", inkBrushMirrorType.NoMirror, color); // right
  ApexGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\master_crosshair.inkatlas", n"dot", inkBrushMirrorType.NoMirror, color); // dot
}
