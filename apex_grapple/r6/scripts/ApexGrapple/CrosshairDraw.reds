// Draws the chosen crosshair in our frame (Crosshair.reds) from nothing, only when its settings changed: never every
// frame. The size scales the frame, which sits at the centre of the screen.

public func ApexGrappleCrosshairScale(size: Float) -> Float {
  return ClampF(size, 50.0, 200.0) / 100.0;
}

// For the log, and to know whether the frame must be drawn again. A change of the range indicator's settings draws it
// again too, in the crosshair's own colour, from which the indicator starts over (CrosshairRange.reds).
public func ApexGrappleCrosshairSettingsText(s: ref<ApexGrappleCrosshairSettings>) -> String {
  let shape: String = NameToString(EnumValueToName(n"ApexGrappleCrosshairShape", Cast<Int64>(EnumInt(s.shape))));
  let color: String = NameToString(EnumValueToName(n"ApexGrappleCrosshairColor", Cast<Int64>(EnumInt(s.color))));
  let away: String = NameToString(EnumValueToName(n"ApexGrappleCrosshairColor", Cast<Int64>(EnumInt(s.outOfRangeColor))));
  let range: String = s.rangeIndicator ? "range indicator on, " + away + " out of range" : "range indicator off";
  return shape + ", " + color + ", " + ToString(ApexGrappleCrosshairScale(s.size) * 100.0) + " %, " + range;
}

// Off is never drawn (CrosshairRule.reds); a value the mod does not know draws the simple crosshair, the default.
public func ApexGrappleCrosshairDraw(frame: ref<inkCanvas>, s: ref<ApexGrappleCrosshairSettings>) -> Void {
  frame.RemoveAllChildren();
  let scale: Float = ApexGrappleCrosshairScale(s.size);
  frame.SetScale(new Vector2(scale, scale));
  let color: HDRColor = ApexGrappleCrosshairTint(s.color);
  switch s.shape {
    case ApexGrappleCrosshairShape.Basic:
      ApexGrappleDrawCrosshairBasic(frame, color);
      break;
    case ApexGrappleCrosshairShape.Shotgun:
      ApexGrappleDrawCrosshairShotgun(frame, color);
      break;
    case ApexGrappleCrosshairShape.SmartRifle:
      ApexGrappleDrawCrosshairSmartRifle(frame, color);
      break;
    case ApexGrappleCrosshairShape.TechCircle:
      ApexGrappleDrawCrosshairTechCircle(frame, color);
      break;
    case ApexGrappleCrosshairShape.TechHex:
      ApexGrappleDrawCrosshairTechHex(frame, color);
      break;
    case ApexGrappleCrosshairShape.Launcher:
      ApexGrappleDrawCrosshairLauncher(frame, color);
      break;
    case ApexGrappleCrosshairShape.MantisBlades:
      ApexGrappleDrawCrosshairMantisBlades(frame, color);
      break;
    case ApexGrappleCrosshairShape.HeavyMachineGun:
      ApexGrappleDrawCrosshairHeavyMachineGun(frame, color);
      break;
    case ApexGrappleCrosshairShape.Dot:
      ApexGrappleDrawCrosshairDot(frame, color);
      break;
    default:
      ApexGrappleDrawCrosshairSimple(frame, color);
  }
}
