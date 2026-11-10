// What lies along the view: rays from the camera, as far as asked, against the world's surfaces (Static, Terrain, and
// Dynamic: billboards hung on buildings are movable objects, probe of 29 October 2026; the hook stays where it was
// planted even if the object falls), vehicles and people, and what the game's targeting looks at. The rule that judges
// it for a profile, the shot's and the crosshair's alike, is in AimRule.reds.

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

// What the rays met, the nearest in each group, and how far (-1: nothing within the length). Its objects are those of
// this frame: a sight is judged in the frame it is cast, never kept.
public struct ApexGrappleSight {
  let from: Vector4;
  let surface: TraceResult;
  let surfaceAt: Float;
  // What the surface belongs to, which may be a person or a vehicle (Codeware tells; none without it).
  let met: wref<GameObject>;
  let vehicle: TraceResult;
  let vehicleAt: Float;
  let vehicleObject: wref<GameObject>;
  // People's bodies: standing in the AI group, fallen in Ragdoll (engine\physics\collision_presets.json, game 2.5).
  let people: TraceResult;
  let peopleAt: Float;
  let body: wref<GameObject>;
  // Not held to the length: the targeting sees as far as it sees.
  let looked: wref<GameObject>;
  let lookedAt: Float;
}

// Six rays and one question to the targeting. length: the range of the profile that shoots, or the longest range of
// the profiles that can fire, for the crosshair (CrosshairRange.reds).
public func ApexGrappleLook(scriptInterface: ref<StateGameScriptInterface>, length: Float) -> ApexGrappleSight {
  let sight: ApexGrappleSight;
  let view: Transform = scriptInterface.GetCameraWorldTransform();
  let from: Vector4 = Transform.GetPosition(view);
  let to: Vector4 = from + Transform.GetForward(view) * length;
  sight.from = from;
  let statics: TraceResult = scriptInterface.RaycastWithASingleGroup(from, to, n"Static");
  let terrain: TraceResult = scriptInterface.RaycastWithASingleGroup(from, to, n"Terrain");
  let dynamics: TraceResult = scriptInterface.RaycastWithASingleGroup(from, to, n"Dynamic");
  sight.surface = ApexGrappleNearest(ApexGrappleNearest(statics, terrain, from), dynamics, from);
  sight.surfaceAt = ApexGrappleHitDistance(sight.surface, from);
  sight.met = ApexGrappleHitObject(sight.surface);
  sight.vehicle = scriptInterface.RaycastWithASingleGroup(from, to, n"Vehicle");
  sight.vehicleAt = ApexGrappleHitDistance(sight.vehicle, from);
  sight.vehicleObject = ApexGrappleHitObject(sight.vehicle);
  sight.people = ApexGrappleNearest(scriptInterface.RaycastWithASingleGroup(from, to, n"AI"), scriptInterface.RaycastWithASingleGroup(from, to, n"Ragdoll"), from);
  sight.peopleAt = ApexGrappleHitDistance(sight.people, from);
  sight.body = ApexGrappleHitObject(sight.people);
  let looked: ref<GameObject> = ApexGrappleLookedAt(scriptInterface);
  sight.looked = looked;
  sight.lookedAt = ApexGrappleObjectDistance(looked, from);
  return sight;
}
