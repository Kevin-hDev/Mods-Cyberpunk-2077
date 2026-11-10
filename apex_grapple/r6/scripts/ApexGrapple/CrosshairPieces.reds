// The pieces the crosshairs are drawn with (Crosshair<Name>.reds, made by fabrique/crosshairs.py from the game's own
// crosshair files). Each piece is placed with the 16 numbers its file gives it, in this order: anchor point x y, margin
// left top right bottom, size x y, translation x y, rotation, scale x y, pivot x y, opacity. One list rather than
// sixteen parameters keeps each piece on one line of the made files.

public func ApexGrappleCrosshairPlace(w: ref<inkWidget>, parent: ref<inkCompoundWidget>, anchor: inkEAnchor, l: array<Float>) -> Void {
  w.SetAnchor(anchor);
  w.SetAnchorPoint(new Vector2(l[0], l[1]));
  w.SetMargin(new inkMargin(l[2], l[3], l[4], l[5]));
  w.SetSize(new Vector2(l[6], l[7]));
  w.SetTranslation(new Vector2(l[8], l[9]));
  w.SetRotation(l[10]);
  w.SetScale(new Vector2(l[11], l[12]));
  w.SetRenderTransformPivot(new Vector2(l[13], l[14]));
  w.SetOpacity(l[15]);
  w.Reparent(parent);
}

// Canvases are never tinted: a tint would multiply the colour of every piece they hold.
public func ApexGrappleCrosshairCanvas(parent: ref<inkCompoundWidget>, anchor: inkEAnchor, l: array<Float>) -> ref<inkCanvas> {
  let canvas: ref<inkCanvas> = new inkCanvas();
  ApexGrappleCrosshairPlace(canvas, parent, anchor, l);
  return canvas;
}

public func ApexGrappleCrosshairRect(parent: ref<inkCompoundWidget>, anchor: inkEAnchor, l: array<Float>, color: HDRColor) -> Void {
  let rect: ref<inkRectangle> = new inkRectangle();
  rect.SetTintColor(color);
  ApexGrappleCrosshairPlace(rect, parent, anchor, l);
}

// segments: the number of sides the game's file gives the circle (6 for the simple crosshair's dot).
public func ApexGrappleCrosshairCircle(parent: ref<inkCompoundWidget>, anchor: inkEAnchor, l: array<Float>, segments: Uint32, color: HDRColor) -> Void {
  let circle: ref<inkCircle> = new inkCircle();
  circle.segmentsNumber = segments;
  circle.SetTintColor(color);
  ApexGrappleCrosshairPlace(circle, parent, anchor, l);
}

// fit: the image takes the size of its part of the atlas, as the game's file asks for some.
public func ApexGrappleCrosshairImage(parent: ref<inkCompoundWidget>, anchor: inkEAnchor, l: array<Float>, fit: Bool, atlas: ResRef, part: CName, mirror: inkBrushMirrorType, color: HDRColor) -> ref<inkImage> {
  let image: ref<inkImage> = new inkImage();
  image.SetAtlasResource(atlas);
  image.SetTexturePart(part);
  image.SetBrushMirrorType(mirror);
  image.SetTintColor(color);
  ApexGrappleCrosshairPlace(image, parent, anchor, l);
  image.SetFitToContent(fit);
  return image;
}

// An image whose borders keep their size as it stretches (nine-slice), with its file's margins: left top right bottom.
public func ApexGrappleCrosshairSlicedImage(parent: ref<inkCompoundWidget>, anchor: inkEAnchor, l: array<Float>, fit: Bool, atlas: ResRef, part: CName, mirror: inkBrushMirrorType, nine: array<Float>, color: HDRColor) -> Void {
  let image: ref<inkImage> = ApexGrappleCrosshairImage(parent, anchor, l, fit, atlas, part, mirror, color);
  image.useNineSliceScale = true;
  image.nineSliceScale = new inkMargin(nine[0], nine[1], nine[2], nine[3]);
}
