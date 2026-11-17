// Made by fabrique/grapple.py from Apex Grapple's CrosshairDraw.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Draws the chosen crosshair in our frame (Crosshair.reds) from nothing, only when its settings changed: never every
// frame. The size scales the frame, which sits at the centre of the screen.

public func CyberGrappleCrosshairScale(size: Float) -> Float {
  return ClampF(size, 50.0, 200.0) / 100.0;
}

// For the log, and to know whether the frame must be drawn again. A change of the range indicator's settings draws it
// again too, in the crosshair's own colour, from which the indicator starts over (CrosshairRange.reds).
public func CyberGrappleCrosshairSettingsText(s: ref<CyberGrappleCrosshairSettings>) -> String {
  let shape: String = NameToString(EnumValueToName(n"CyberGrappleCrosshairShape", Cast<Int64>(EnumInt(s.shape))));
  let color: String = NameToString(EnumValueToName(n"CyberGrappleCrosshairColor", Cast<Int64>(EnumInt(s.color))));
  let away: String = NameToString(EnumValueToName(n"CyberGrappleCrosshairColor", Cast<Int64>(EnumInt(s.outOfRangeColor))));
  let range: String = s.rangeIndicator ? "range indicator on, " + away + " out of range" : "range indicator off";
  return shape + ", " + color + ", " + ToString(CyberGrappleCrosshairScale(s.size) * 100.0) + " %, " + range;
}

// Off is never drawn (CrosshairRule.reds); a value the mod does not know draws the simple crosshair, the default.
public func CyberGrappleCrosshairDraw(frame: ref<inkCanvas>, s: ref<CyberGrappleCrosshairSettings>) -> Void {
  frame.RemoveAllChildren();
  let scale: Float = CyberGrappleCrosshairScale(s.size);
  frame.SetScale(new Vector2(scale, scale));
  let color: HDRColor = CyberGrappleCrosshairTint(s.color);
  switch s.shape {
    case CyberGrappleCrosshairShape.Basic:
      CyberGrappleDrawCrosshairBasic(frame, color);
      break;
    case CyberGrappleCrosshairShape.Shotgun:
      CyberGrappleDrawCrosshairShotgun(frame, color);
      break;
    case CyberGrappleCrosshairShape.SmartRifle:
      CyberGrappleDrawCrosshairSmartRifle(frame, color);
      break;
    case CyberGrappleCrosshairShape.TechCircle:
      CyberGrappleDrawCrosshairTechCircle(frame, color);
      break;
    case CyberGrappleCrosshairShape.TechHex:
      CyberGrappleDrawCrosshairTechHex(frame, color);
      break;
    case CyberGrappleCrosshairShape.Launcher:
      CyberGrappleDrawCrosshairLauncher(frame, color);
      break;
    case CyberGrappleCrosshairShape.MantisBlades:
      CyberGrappleDrawCrosshairMantisBlades(frame, color);
      break;
    case CyberGrappleCrosshairShape.HeavyMachineGun:
      CyberGrappleDrawCrosshairHeavyMachineGun(frame, color);
      break;
    case CyberGrappleCrosshairShape.Dot:
      CyberGrappleDrawCrosshairDot(frame, color);
      break;
    default:
      CyberGrappleDrawCrosshairSimple(frame, color);
  }
}
