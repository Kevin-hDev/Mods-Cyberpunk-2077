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

// A ray's hit and its distance from the eye, worked out once: the nearer of two is then chosen without working either
// distance out again (A5).
public struct ApexGrappleRayHit {
  let hit: TraceResult;
  let at: Float;
}

public func ApexGrappleRayHitOf(hit: TraceResult, from: Vector4) -> ApexGrappleRayHit {
  let ray: ApexGrappleRayHit;
  ray.hit = hit;
  ray.at = ApexGrappleHitDistance(hit, from);
  return ray;
}

// The nearer of two hits, the first when they are as near; a ray that found nothing loses.
public func ApexGrappleNearerHit(a: ApexGrappleRayHit, b: ApexGrappleRayHit) -> ApexGrappleRayHit {
  if a.at < 0.0 {
    return b;
  }
  if b.at < 0.0 || a.at <= b.at {
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
// the profiles that can fire, for the crosshair (CrosshairRange.reds). The rays for vehicles and people go only as far
// as the surface found, the whole length without one: the rule keeps them only nearer than the surface (AimRule.reds).
// Until the audit of 10 November 2026 they went the whole length (A3, Kevin's trial of 10 November 2026: 27 shots and
// 22 212 verdicts of the range indicator alike, no distance more than 1 mm apart; releves/apex-grapple/
// 2026-11-10-allegement).
public func ApexGrappleLook(scriptInterface: ref<StateGameScriptInterface>, length: Float) -> ApexGrappleSight {
  let sight: ApexGrappleSight;
  let view: Transform = scriptInterface.GetCameraWorldTransform();
  let from: Vector4 = Transform.GetPosition(view);
  let forward: Vector4 = Transform.GetForward(view);
  let to: Vector4 = from + forward * length;
  sight.from = from;
  let statics: ApexGrappleRayHit = ApexGrappleRayHitOf(scriptInterface.RaycastWithASingleGroup(from, to, n"Static"), from);
  let terrain: ApexGrappleRayHit = ApexGrappleRayHitOf(scriptInterface.RaycastWithASingleGroup(from, to, n"Terrain"), from);
  let dynamics: ApexGrappleRayHit = ApexGrappleRayHitOf(scriptInterface.RaycastWithASingleGroup(from, to, n"Dynamic"), from);
  let surface: ApexGrappleRayHit = ApexGrappleNearerHit(ApexGrappleNearerHit(statics, terrain), dynamics);
  sight.surface = surface.hit;
  sight.surfaceAt = surface.at;
  sight.met = ApexGrappleHitObject(sight.surface);
  let near: Vector4 = surface.at >= 0.0 ? from + forward * surface.at : to;
  sight.vehicle = scriptInterface.RaycastWithASingleGroup(from, near, n"Vehicle");
  sight.vehicleAt = ApexGrappleHitDistance(sight.vehicle, from);
  sight.vehicleObject = ApexGrappleHitObject(sight.vehicle);
  let standing: ApexGrappleRayHit = ApexGrappleRayHitOf(scriptInterface.RaycastWithASingleGroup(from, near, n"AI"), from);
  let fallen: ApexGrappleRayHit = ApexGrappleRayHitOf(scriptInterface.RaycastWithASingleGroup(from, near, n"Ragdoll"), from);
  let people: ApexGrappleRayHit = ApexGrappleNearerHit(standing, fallen);
  sight.people = people.hit;
  sight.peopleAt = people.at;
  sight.body = ApexGrappleHitObject(sight.people);
  let looked: ref<GameObject> = ApexGrappleLookedAt(scriptInterface);
  sight.looked = looked;
  sight.lookedAt = ApexGrappleObjectDistance(looked, from);
  return sight;
}

// A look counted for the log's cost line (Cost.reds) and kept for the rest of its frame: the range indicator, last in
// the frame, takes the decision's when it would look as far, rather than cast the same six rays again from the same
// camera (A10). Judged in the frame it was cast, as any sight.
public func ApexGrappleLookFor(system: ref<ApexGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>, length: Float) -> ApexGrappleSight {
  let sight: ApexGrappleSight = ApexGrappleLook(scriptInterface, length);
  system.sightKept = sight;
  system.sightKeptIn = system.frames;
  system.sightKeptLength = length;
  let cost: ref<ApexGrappleCost> = system.cost;
  if IsDefined(cost) {
    cost.aimRays = cost.aimRays + ApexGrappleLookRays();
  }
  return sight;
}
