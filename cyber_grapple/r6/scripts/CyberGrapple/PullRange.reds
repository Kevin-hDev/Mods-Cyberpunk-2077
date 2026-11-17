// How far a person or a motorcycle is taken from: a distance of its own, shorter than the range V travels over.
// Kevin, 16 November 2026: "il faut aussi qu'on fixe une distance differente du range du grapin qui tire V pour les
// mouvements, on ne doit pas finir par tiré des ennemies jusqu'a 70m". The field, settings.pullRange, is written into
// the made settings by the making (ADDED in fabrique/grapple_spec.py) and filled from the tier (Tiers.reds); the rule
// of the shot and of the crosshair's colour (AimRule.reds, made) is patched to ask here.

// The farthest a person or a vehicle in the way takes the hook from. A car is travelled to, as a wall is: the range.
// A person, and a motorcycle or its rider, come to V: the shorter distance. Beyond it they stay in the way and no
// shot is fired at what lies behind them, as below the tier that pulls.
public func CyberGrappleTargetReach(settings: ref<CyberGrappleSettings>, way: CyberGrappleInTheWay) -> Float {
  if way.vehicle && !IsDefined(way.object as BikeObject) {
    return settings.range;
  }
  return settings.pullRange;
}
