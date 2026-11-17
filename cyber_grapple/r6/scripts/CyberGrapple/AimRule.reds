// Made by fabrique/grapple.py from Apex Grapple's AimRule.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The grapple's rule, Borderlands 4's: a surface within range takes the hook; someone or a vehicle in the way, or
// nothing in range, leaves the key to the game. Someone within quick melee range wins over a surface
// behind them ("Quick melee wins over grapple"). With "Grapple onto vehicles and people", the person or vehicle in the
// way takes the hook instead (Target.reds). One rule for the shot (Shot.reds) and the crosshair's range indicator
// (CrosshairRange.reds), so that the colour never tells what the key would not do. The shot's log text is made apart
// from the verdict, so that the crosshair asks for no text each frame.

enum CyberGrappleAimReason {
  NothingInRange = 0,
  QuickMelee = 1,
  InTheWay = 2,
  Person = 3,
  Rider = 4,
  Vehicle = 5,
  Surface = 6
}

public struct CyberGrappleVerdict {
  let fires: Bool;
  let reason: CyberGrappleAimReason;
  // The nearest person or vehicle within range (at -1: none), the surface within range (-1: none), and the rider a
  // motorcycle is taken by.
  let way: CyberGrappleInTheWay;
  let surfaceAt: Float;
  let rider: wref<GameObject>;
}

// A distance the rays found, kept within the range and -1 beyond it: judged so, rays cast farther than a profile's
// range give it what rays of its own length would have found.
public func CyberGrappleWithin(at: Float, range: Float) -> Float {
  return at <= range ? at : -1.0;
}

// The surface ray stopped by a person or a vehicle is no surface, and what lies behind them is not known: until
// 2 November 2026 the hook was planted where a passer-by stood when the game's targeting saw no one, and hung there in
// the air as they walked on (Kevin). Codeware tells what a ray hit; without it, the targeting alone, as before.
public func CyberGrappleVerdictOf(sight: CyberGrappleSight, settings: ref<CyberGrappleSettings>) -> CyberGrappleVerdict {
  let verdict: CyberGrappleVerdict;
  let surfaceAt: Float = CyberGrappleWithin(sight.surfaceAt, settings.range);
  let met: ref<GameObject> = sight.met;
  let way: CyberGrappleInTheWay;
  way.at = -1.0;
  if surfaceAt >= 0.0 && CyberGrappleIsTarget(met) {
    way = CyberGrappleWayByRay(met, surfaceAt, sight.surface, IsDefined(met as VehicleObject));
    surfaceAt = -1.0;
  }
  let vehicleAt: Float = CyberGrappleWithin(sight.vehicleAt, settings.range);
  if CyberGrappleCloser(vehicleAt, way.at) && CyberGrappleCloser(vehicleAt, surfaceAt) {
    way = CyberGrappleWayByRay(sight.vehicleObject, vehicleAt, sight.vehicle, true);
  }
  let peopleAt: Float = CyberGrappleWithin(sight.peopleAt, settings.range);
  let body: ref<GameObject> = sight.body;
  if CyberGrappleCloser(peopleAt, way.at) && CyberGrappleCloser(peopleAt, surfaceAt) && (!IsDefined(body) || IsDefined(body as ScriptedPuppet)) {
    way = CyberGrappleWayByRay(body, peopleAt, sight.people, false);
  }
  let looked: ref<GameObject> = sight.looked;
  if CyberGrappleCloser(sight.lookedAt, way.at) && CyberGrappleCloser(sight.lookedAt, surfaceAt) {
    way.object = looked;
    way.at = sight.lookedAt;
    way.vehicle = IsDefined(looked as VehicleObject);
    way.byRay = false;
  }
  verdict.way = way;
  verdict.surfaceAt = surfaceAt;
  if settings.punchWins && way.at >= 0.0 && way.at <= settings.punchRange {
    verdict.reason = CyberGrappleAimReason.QuickMelee;
    return verdict;
  }
  if way.at >= 0.0 {
    verdict.reason = CyberGrappleAimReason.InTheWay;
    if settings.hookTargets && CyberGrappleTargetsAvailable() && IsDefined(way.object) && way.at <= CyberGrappleTargetReach(settings, way) {
      if !way.vehicle {
        verdict.fires = true;
        verdict.reason = CyberGrappleAimReason.Person;
        return verdict;
      }
      // With the motorcycles pulled to V, the ray that meets the motorcycle takes the motorcycle (YankBike.reds): its
      // rider is not looked for.
      let rider: ref<GameObject>;
      if !(settings.pullBikes && way.byRay) {
        rider = CyberGrappleRiderOf(way.object);
      }
      if IsDefined(rider) {
        verdict.fires = true;
        verdict.reason = CyberGrappleAimReason.Rider;
        verdict.rider = rider;
        return verdict;
      }
      if way.byRay {
        verdict.fires = true;
        verdict.reason = CyberGrappleAimReason.Vehicle;
      }
    }
    return verdict;
  }
  if surfaceAt < 0.0 {
    verdict.reason = CyberGrappleAimReason.NothingInRange;
    return verdict;
  }
  verdict.fires = true;
  verdict.reason = CyberGrappleAimReason.Surface;
  return verdict;
}

// The shot's aim, with what the rays met for the log.
public func CyberGrappleAimIn(sight: CyberGrappleSight, settings: ref<CyberGrappleSettings>) -> CyberGrappleAim {
  let verdict: CyberGrappleVerdict = CyberGrappleVerdictOf(sight, settings);
  let way: CyberGrappleInTheWay = verdict.way;
  let aim: CyberGrappleAim;
  if Equals(verdict.reason, CyberGrappleAimReason.Surface) {
    let met: ref<GameObject> = sight.met;
    aim.found = true;
    aim.anchor = Vector4.Vector3To4(sight.surface.position);
    aim.distance = verdict.surfaceAt;
    aim.seen = "surface " + ToString(verdict.surfaceAt) + " m away" + CyberGrappleMetText(met, sight.surface);
    return aim;
  }
  if Equals(verdict.reason, CyberGrappleAimReason.NothingInRange) {
    aim.seen = "no surface within " + ToString(settings.range) + " m";
    return aim;
  }
  let how: String = way.byRay ? ", met by the ray" + CyberGrappleMetText(way.object, way.hit) : ", seen by the game's targeting";
  if Equals(verdict.reason, CyberGrappleAimReason.Person) {
    aim = CyberGrappleAimAtPerson(way.object, sight.from);
    aim.seen = aim.seen + how;
    return aim;
  }
  if Equals(verdict.reason, CyberGrappleAimReason.Rider) {
    let rider: ref<GameObject> = verdict.rider;
    aim = CyberGrappleAimAtPerson(rider, sight.from);
    aim.seen = aim.seen + ", riding the motorcycle" + how;
    return aim;
  }
  if Equals(verdict.reason, CyberGrappleAimReason.Vehicle) {
    aim = CyberGrappleAimAtVehicle(way.object, way.hit, sight.from);
    aim.seen = aim.seen + how;
    return aim;
  }
  let who: String = (way.vehicle ? "a vehicle " : "someone ") + ToString(way.at) + " m away" + how;
  if Equals(verdict.reason, CyberGrappleAimReason.QuickMelee) {
    aim.seen = who + ", within quick melee range";
    return aim;
  }
  aim.seen = who + (verdict.surfaceAt >= 0.0 ? ", before the surface at " + ToString(verdict.surfaceAt) + " m" : "");
  return aim;
}

public func CyberGrappleAimNow(system: ref<CyberGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>, settings: ref<CyberGrappleSettings>) -> CyberGrappleAim {
  return CyberGrappleAimIn(CyberGrappleLookFor(system, scriptInterface, settings.range), settings);
}
