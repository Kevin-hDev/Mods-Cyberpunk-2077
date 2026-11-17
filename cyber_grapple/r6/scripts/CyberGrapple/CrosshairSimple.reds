// Made by fabrique/grapple.py from Apex Grapple's CrosshairSimple.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Made by fabrique/crosshairs.py from the game's crosshair_simple.inkwidget (2.5), never edited by hand: run
// python -I fabrique/crosshairs.py after a change there (fabrique/test_crosshairs.py fails while this file
// is out of date). What each list of numbers holds: CrosshairPieces.reds.

public func CyberGrappleDrawCrosshairSimple(root: ref<inkCanvas>, color: HDRColor) -> Void {
  let c0: ref<inkCanvas> = CyberGrappleCrosshairCanvas(root, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // root
  let c1: ref<inkCanvas> = CyberGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // reticle
  let c2: ref<inkCanvas> = CyberGrappleCrosshairCanvas(c1, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // crosshair
  let c3: ref<inkCanvas> = CyberGrappleCrosshairCanvas(c2, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // Details
  CyberGrappleCrosshairRect(c3, inkEAnchor.Centered, [0.5, 1.0, 0.0, -25.0, 0.0, 0.0, 3.0, 14.0, 0.0, -20.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], color); // top
  CyberGrappleCrosshairRect(c3, inkEAnchor.Centered, [0.5, 0.0, 0.0, 25.0, 0.0, 0.0, 3.0, 14.0, 0.0, 20.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], color); // bot
  CyberGrappleCrosshairRect(c3, inkEAnchor.Centered, [0.5, 0.5, -25.0, 0.0, 0.0, 0.0, 42.0, 3.0, -60.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], color); // left
  CyberGrappleCrosshairRect(c3, inkEAnchor.Centered, [0.5, 0.5, 25.0, 0.0, 0.0, 0.0, 42.0, 3.0, 60.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], color); // right
  CyberGrappleCrosshairCircle(c2, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 8.0, 8.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], 6u, color); // dot
}
