// Made by fabrique/crosshairs.py from the game's launcher.inkwidget (2.5), never edited by hand: run
// python -I fabrique/crosshairs.py after a change there (fabrique/test_crosshairs.py fails while this file
// is out of date). What each list of numbers holds: CrosshairPieces.reds.

public func ApexGrappleDrawCrosshairLauncher(root: ref<inkCanvas>, color: HDRColor) -> Void {
  let c0: ref<inkCanvas> = ApexGrappleCrosshairCanvas(root, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 3840.0, 2160.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // Root
  let c1: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.5, 0.5, 1.0]); // triblink
  ApexGrappleCrosshairImage(c1, inkEAnchor.Centered, [0.5, 0.5, 0.0, 191.6667, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\launcher\\laumcher.inkatlas", n"triblink", inkBrushMirrorType.NoMirror, color); // triblink
  ApexGrappleCrosshairImage(c1, inkEAnchor.Centered, [0.5, 0.5, -163.3333, -86.6667, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 120.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\launcher\\laumcher.inkatlas", n"triblink", inkBrushMirrorType.NoMirror, color); // triblink
  ApexGrappleCrosshairImage(c1, inkEAnchor.Centered, [0.5, 0.5, 163.0, -86.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, -120.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\launcher\\laumcher.inkatlas", n"triblink", inkBrushMirrorType.NoMirror, color); // triblink
  let c2: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // scales
  ApexGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.5, 0.5, 163.3334, -156.6666, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 0.217], true, r"base\\gameplay\\gui\\widgets\\crosshair\\launcher\\laumcher.inkatlas", n"scales", inkBrushMirrorType.NoMirror, color); // scales_tr
  ApexGrappleCrosshairImage(c2, inkEAnchor.Centered, [0.5, 0.5, -164.6667, 167.6667, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 0.217], true, r"base\\gameplay\\gui\\widgets\\crosshair\\launcher\\laumcher.inkatlas", n"scales", inkBrushMirrorType.Both, color); // scales_bl
  let c3: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.2, 1.2, 0.5, 0.5, 1.0]); // arrows
  ApexGrappleCrosshairImage(c3, inkEAnchor.Centered, [0.5, 0.5, -413.5714, 0.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\launcher\\laumcher.inkatlas", n"arrow", inkBrushMirrorType.NoMirror, color); // arrows
  ApexGrappleCrosshairImage(c3, inkEAnchor.Centered, [0.5, 0.5, 413.0, 0.0, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\launcher\\laumcher.inkatlas", n"arrow", inkBrushMirrorType.Horizontal, color); // arrows
  let c4: ref<inkCanvas> = ApexGrappleCrosshairCanvas(c0, inkEAnchor.Centered, [0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 550.0, 400.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0]); // square
  ApexGrappleCrosshairImage(c4, inkEAnchor.Centered, [0.5, 0.5, 734.0, 5.7142, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\launcher\\laumcher.inkatlas", n"sqr", inkBrushMirrorType.NoMirror, color); // square
  ApexGrappleCrosshairImage(c4, inkEAnchor.Centered, [0.5, 0.5, -734.2856, 5.7142, 0.0, 0.0, 32.0, 32.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0.5, 1.0], true, r"base\\gameplay\\gui\\widgets\\crosshair\\launcher\\laumcher.inkatlas", n"sqr", inkBrushMirrorType.NoMirror, color); // square
}
