// The grapple's rule, Borderlands 4's: a surface within range takes the hook; someone or a vehicle in the way, or
// nothing in range, leaves the key to the game's quick melee. Someone within quick melee range wins over a surface
// behind them ("Quick melee wins over grapple"). With "Grapple onto vehicles and people", the person or vehicle in the
// way takes the hook instead (Target.reds). One rule for the shot (Shot.reds) and the crosshair's range indicator
// (CrosshairRange.reds), so that the colour never tells what the key would not do. The shot's log text is made apart
// from the verdict, so that the crosshair asks for no text each frame.

enum ApexGrappleAimReason {
  NothingInRange = 0,
  QuickMelee = 1,
  InTheWay = 2,
  Person = 3,
  Rider = 4,
  Vehicle = 5,
  Surface = 6
}

public struct ApexGrappleVerdict {
  let fires: Bool;
  let reason: ApexGrappleAimReason;
  // The nearest person or vehicle within range (at -1: none), the surface within range (-1: none), and the rider a
  // motorcycle is taken by.
  let way: ApexGrappleInTheWay;
  let surfaceAt: Float;
  let rider: wref<GameObject>;
}

// A distance the rays found, kept within the range and -1 beyond it: judged so, rays cast farther than a profile's
// range give it what rays of its own length would have found.
public func ApexGrappleWithin(at: Float, range: Float) -> Float {
  return at <= range ? at : -1.0;
}

// The surface ray stopped by a person or a vehicle is no surface, and what lies behind them is not known: until
// 2 November 2026 the hook was planted where a passer-by stood when the game's targeting saw no one, and hung there in
// the air as they walked on (Kevin). Codeware tells what a ray hit; without it, the targeting alone, as before.
public func ApexGrappleVerdictOf(sight: ApexGrappleSight, settings: ref<ApexGrappleSettings>) -> ApexGrappleVerdict {
  let verdict: ApexGrappleVerdict;
  let surfaceAt: Float = ApexGrappleWithin(sight.surfaceAt, settings.range);
  let met: ref<GameObject> = sight.met;
  let way: ApexGrappleInTheWay;
  way.at = -1.0;
  if surfaceAt >= 0.0 && ApexGrappleIsTarget(met) {
    way = ApexGrappleWayByRay(met, surfaceAt, sight.surface, IsDefined(met as VehicleObject));
    surfaceAt = -1.0;
  }
  let vehicleAt: Float = ApexGrappleWithin(sight.vehicleAt, settings.range);
  if ApexGrappleCloser(vehicleAt, way.at) && ApexGrappleCloser(vehicleAt, surfaceAt) {
    way = ApexGrappleWayByRay(sight.vehicleObject, vehicleAt, sight.vehicle, true);
  }
  let peopleAt: Float = ApexGrappleWithin(sight.peopleAt, settings.range);
  let body: ref<GameObject> = sight.body;
  if ApexGrappleCloser(peopleAt, way.at) && ApexGrappleCloser(peopleAt, surfaceAt) && (!IsDefined(body) || IsDefined(body as ScriptedPuppet)) {
    way = ApexGrappleWayByRay(body, peopleAt, sight.people, false);
  }
  let looked: ref<GameObject> = sight.looked;
  if ApexGrappleCloser(sight.lookedAt, way.at) && ApexGrappleCloser(sight.lookedAt, surfaceAt) {
    way.object = looked;
    way.at = sight.lookedAt;
    way.vehicle = IsDefined(looked as VehicleObject);
    way.byRay = false;
  }
  verdict.way = way;
  verdict.surfaceAt = surfaceAt;
  if settings.punchWins && way.at >= 0.0 && way.at <= settings.punchRange {
    verdict.reason = ApexGrappleAimReason.QuickMelee;
    return verdict;
  }
  if way.at >= 0.0 {
    verdict.reason = ApexGrappleAimReason.InTheWay;
    if settings.hookTargets && ApexGrappleTargetsAvailable() && IsDefined(way.object) && way.at <= settings.range {
      if !way.vehicle {
        verdict.fires = true;
        verdict.reason = ApexGrappleAimReason.Person;
        return verdict;
      }
      let rider: ref<GameObject> = ApexGrappleRiderOf(way.object);
      if IsDefined(rider) {
        verdict.fires = true;
        verdict.reason = ApexGrappleAimReason.Rider;
        verdict.rider = rider;
        return verdict;
      }
      if way.byRay {
        verdict.fires = true;
        verdict.reason = ApexGrappleAimReason.Vehicle;
      }
    }
    return verdict;
  }
  if surfaceAt < 0.0 {
    verdict.reason = ApexGrappleAimReason.NothingInRange;
    return verdict;
  }
  verdict.fires = true;
  verdict.reason = ApexGrappleAimReason.Surface;
  return verdict;
}

// The shot's aim, with what the rays met for the log.
public func ApexGrappleAimIn(sight: ApexGrappleSight, settings: ref<ApexGrappleSettings>) -> ApexGrappleAim {
  let verdict: ApexGrappleVerdict = ApexGrappleVerdictOf(sight, settings);
  let way: ApexGrappleInTheWay = verdict.way;
  let aim: ApexGrappleAim;
  if Equals(verdict.reason, ApexGrappleAimReason.Surface) {
    let met: ref<GameObject> = sight.met;
    aim.found = true;
    aim.anchor = Vector4.Vector3To4(sight.surface.position);
    aim.distance = verdict.surfaceAt;
    aim.seen = "surface " + ToString(verdict.surfaceAt) + " m away" + ApexGrappleMetText(met, sight.surface);
    return aim;
  }
  if Equals(verdict.reason, ApexGrappleAimReason.NothingInRange) {
    aim.seen = "no surface within " + ToString(settings.range) + " m";
    return aim;
  }
  let how: String = way.byRay ? ", met by the ray" + ApexGrappleMetText(way.object, way.hit) : ", seen by the game's targeting";
  if Equals(verdict.reason, ApexGrappleAimReason.Person) {
    aim = ApexGrappleAimAtPerson(way.object, sight.from);
    aim.seen = aim.seen + how;
    return aim;
  }
  if Equals(verdict.reason, ApexGrappleAimReason.Rider) {
    let rider: ref<GameObject> = verdict.rider;
    aim = ApexGrappleAimAtPerson(rider, sight.from);
    aim.seen = aim.seen + ", riding the motorcycle" + how;
    return aim;
  }
  if Equals(verdict.reason, ApexGrappleAimReason.Vehicle) {
    aim = ApexGrappleAimAtVehicle(way.object, way.hit, sight.from);
    aim.seen = aim.seen + how;
    return aim;
  }
  let who: String = (way.vehicle ? "a vehicle " : "someone ") + ToString(way.at) + " m away" + how;
  if Equals(verdict.reason, ApexGrappleAimReason.QuickMelee) {
    aim.seen = who + ", within quick melee range";
    return aim;
  }
  aim.seen = who + (verdict.surfaceAt >= 0.0 ? ", before the surface at " + ToString(verdict.surfaceAt) + " m" : "");
  return aim;
}

public func ApexGrappleAimNow(scriptInterface: ref<StateGameScriptInterface>, settings: ref<ApexGrappleSettings>) -> ApexGrappleAim {
  return ApexGrappleAimIn(ApexGrappleLook(scriptInterface, settings.range), settings);
}
