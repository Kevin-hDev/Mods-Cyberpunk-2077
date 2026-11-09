// Where the hook would go: one ray from the camera along the view, the length of the range, against the world's
// surfaces (Static, Terrain, and Dynamic: billboards hung on buildings are movable objects, probe of 29 October 2026;
// the hook stays where it was planted even if the object falls). Borderlands 4's rule: a surface takes the hook; someone
// or a vehicle in the way, or nothing in range, leaves the key to the game's quick melee. Someone within quick melee
// range wins over a surface behind them ("Quick melee wins over grapple"). With "Grapple onto vehicles and people", the
// person or vehicle in the way takes the hook instead (Target.reds).

public struct ApexGrappleAim {
  let found: Bool;
  let anchor: Vector4;
  let distance: Float;
  // What the ray met, or why there is no grapple, for the log.
  let seen: String;
  // A vehicle or a person taken by the hook (Target.reds), and the point in the vehicle's own frame.
  let target: wref<GameObject>;
  let person: Bool;
  let local: Vector4;
}

// The nearest person or vehicle before the surface, and where a ray met it (a vehicle is taken at that point).
public struct ApexGrappleInTheWay {
  let object: wref<GameObject>;
  let at: Float;
  let vehicle: Bool;
  let hit: TraceResult;
  let byRay: Bool;
}

// How far a hit is from the eye, or -1 when the ray found nothing.
public func ApexGrappleHitDistance(hit: TraceResult, from: Vector4) -> Float {
  if !TraceResult.IsValid(hit) {
    return -1.0;
  }
  return Vector4.Distance(from, Vector4.Vector3To4(hit.position));
}

public func ApexGrappleNearest(a: TraceResult, b: TraceResult, from: Vector4) -> TraceResult {
  let toA: Float = ApexGrappleHitDistance(a, from);
  let toB: Float = ApexGrappleHitDistance(b, from);
  if toA < 0.0 {
    return b;
  }
  if toB < 0.0 || toA <= toB {
    return a;
  }
  return b;
}

// The person or vehicle the game's targeting says V looks at, or none. Asked as the game asks it (player.script:802,
// focusModeTagging.script:205): through glass and other see-through things.
public func ApexGrappleLookedAt(scriptInterface: ref<StateGameScriptInterface>) -> ref<GameObject> {
  let looked: ref<GameObject> = scriptInterface.GetTargetingSystem().GetLookAtObject(scriptInterface.executionOwner, true, true);
  if !ApexGrappleIsTarget(looked) {
    return null;
  }
  return looked;
}

// How far an object is from the eye, or -1 when there is none.
public func ApexGrappleObjectDistance(object: ref<GameObject>, from: Vector4) -> Float {
  if !IsDefined(object) {
    return -1.0;
  }
  return Vector4.Distance(from, object.GetWorldPosition());
}

// Found (0 or more), and nearer than the other, or the other not found.
public func ApexGrappleCloser(at: Float, other: Float) -> Bool {
  return at >= 0.0 && (other < 0.0 || at < other);
}

public func ApexGrappleWayByRay(object: ref<GameObject>, at: Float, hit: TraceResult, vehicle: Bool) -> ApexGrappleInTheWay {
  let way: ApexGrappleInTheWay;
  way.object = object;
  way.at = at;
  way.vehicle = vehicle;
  way.hit = hit;
  way.byRay = true;
  return way;
}

// For the log: the kind of object and the material the ray met.
public func ApexGrappleMetText(object: ref<GameObject>, hit: TraceResult) -> String {
  if !IsDefined(object) {
    return "";
  }
  return " (" + NameToString(object.GetClassName()) + ", material " + NameToString(hit.material) + ")";
}

// The surface ray stopped by a person or a vehicle is no surface, and what lies behind them is not known: until
// 2 November 2026 the hook was planted where a passer-by stood when the game's targeting saw no one, and hung there in
// the air as they walked on (Kevin). Codeware tells what a ray hit; without it, the targeting alone, as before.
public func ApexGrappleAimNow(scriptInterface: ref<StateGameScriptInterface>, settings: ref<ApexGrappleSettings>) -> ApexGrappleAim {
  let aim: ApexGrappleAim;
  let view: Transform = scriptInterface.GetCameraWorldTransform();
  let from: Vector4 = Transform.GetPosition(view);
  let to: Vector4 = from + Transform.GetForward(view) * settings.range;
  let statics: TraceResult = scriptInterface.RaycastWithASingleGroup(from, to, n"Static");
  let terrain: TraceResult = scriptInterface.RaycastWithASingleGroup(from, to, n"Terrain");
  let dynamics: TraceResult = scriptInterface.RaycastWithASingleGroup(from, to, n"Dynamic");
  let surface: TraceResult = ApexGrappleNearest(ApexGrappleNearest(statics, terrain, from), dynamics, from);
  let surfaceAt: Float = ApexGrappleHitDistance(surface, from);
  let met: ref<GameObject> = ApexGrappleHitObject(surface);
  let way: ApexGrappleInTheWay;
  way.at = -1.0;
  if ApexGrappleIsTarget(met) {
    way = ApexGrappleWayByRay(met, surfaceAt, surface, IsDefined(met as VehicleObject));
    surfaceAt = -1.0;
  }
  let vehicle: TraceResult = scriptInterface.RaycastWithASingleGroup(from, to, n"Vehicle");
  let vehicleAt: Float = ApexGrappleHitDistance(vehicle, from);
  if ApexGrappleCloser(vehicleAt, way.at) && ApexGrappleCloser(vehicleAt, surfaceAt) {
    way = ApexGrappleWayByRay(ApexGrappleHitObject(vehicle), vehicleAt, vehicle, true);
  }
  // People's bodies: standing in the AI group, fallen in Ragdoll (engine\physics\collision_presets.json, game 2.5).
  let people: TraceResult = ApexGrappleNearest(scriptInterface.RaycastWithASingleGroup(from, to, n"AI"), scriptInterface.RaycastWithASingleGroup(from, to, n"Ragdoll"), from);
  let peopleAt: Float = ApexGrappleHitDistance(people, from);
  let body: ref<GameObject> = ApexGrappleHitObject(people);
  if ApexGrappleCloser(peopleAt, way.at) && ApexGrappleCloser(peopleAt, surfaceAt) && (!IsDefined(body) || IsDefined(body as ScriptedPuppet)) {
    way = ApexGrappleWayByRay(body, peopleAt, people, false);
  }
  let looked: ref<GameObject> = ApexGrappleLookedAt(scriptInterface);
  let lookedAt: Float = ApexGrappleObjectDistance(looked, from);
  if ApexGrappleCloser(lookedAt, way.at) && ApexGrappleCloser(lookedAt, surfaceAt) {
    way.object = looked;
    way.at = lookedAt;
    way.vehicle = IsDefined(looked as VehicleObject);
    way.byRay = false;
  }
  let how: String = way.byRay ? ", met by the ray" + ApexGrappleMetText(way.object, way.hit) : ", seen by the game's targeting";
  let who: String = (way.vehicle ? "a vehicle " : "someone ") + ToString(way.at) + " m away" + how;
  if settings.punchWins && way.at >= 0.0 && way.at <= settings.punchRange {
    aim.seen = who + ", within quick melee range";
    return aim;
  }
  if way.at >= 0.0 {
    if settings.hookTargets && ApexGrappleTargetsAvailable() && IsDefined(way.object) && way.at <= settings.range {
      if !way.vehicle {
        aim = ApexGrappleAimAtPerson(way.object, from);
        aim.seen = aim.seen + how;
        return aim;
      }
      let rider: ref<GameObject> = ApexGrappleRiderOf(way.object);
      if IsDefined(rider) {
        aim = ApexGrappleAimAtPerson(rider, from);
        aim.seen = aim.seen + ", riding the motorcycle" + how;
        return aim;
      }
      if way.byRay {
        aim = ApexGrappleAimAtVehicle(way.object, way.hit, from);
        aim.seen = aim.seen + how;
        return aim;
      }
    }
    aim.seen = who + (surfaceAt >= 0.0 ? ", before the surface at " + ToString(surfaceAt) + " m" : "");
    return aim;
  }
  if surfaceAt < 0.0 {
    aim.seen = "no surface within " + ToString(settings.range) + " m";
    return aim;
  }
  aim.found = true;
  aim.anchor = Vector4.Vector3To4(surface.position);
  aim.distance = surfaceAt;
  aim.seen = "surface " + ToString(surfaceAt) + " m away" + ApexGrappleMetText(met, surface);
  return aim;
}
