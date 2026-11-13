// Where a person pulled to V is thrown to (Yank.reds): a spot by V, on the person's side. Kevin, 12 and 13 November
// 2026: a person higher or lower than V must come to V all the same ("ca va contre le fonctionnement que le joueur
// choisis"), from a roof they must be drawn up to V, not dragged along the ground below ("le grapin les traine
// sur le sol en bas au lieu de les attire vraiment vers lui"), and the grapple pulls from anywhere ("le grapin tir
// toujours et ca peu importe d'ou on tir"). In that order:
//   1. a place the AI can stand, at V's height;
//   2. V hanging on a ladder or a wall: the ground under it;
//   3. the surface under the way to the person, when it is about at V's height: stairs, a slope;
//   4. by V all the same, on a surface there if there is one. Left off its navigation mesh, the game itself puts a
//      person back toward a place they can stand once they get up (aiStatusEffectTask.script:272-343).
// The trials behind these rules are in releves/apex-grapple/2026-11-12-hauteur.

// V hanging on a ladder or a wall: the ground under V is looked for this far down. Wall Climb holds V on a wall up to
// 3.5 m above where the climb began (Kevin's setting); at V's own height the spot was in the air, and every person
// shot from the wall in game pulled V instead (docs/apex-grapple/echelle/conception.md).
public func ApexGrappleYankGroundBelow() -> Float {
  return 5.0;
}

// The way's ray starts this far above the straight line from V's feet to the person's: stairs bulge above that line
// (0.36 to 0.64 m in the trial of 12 November 2026), and a flight of stairs over V's head must stay above the start.
public func ApexGrappleYankWayAbove() -> Float {
  return 1.5;
}

// A spot on the way is taken this close to the height of V's feet: on stairs it was 1.1 to 1.5 m higher or lower
// 2 m from V (second trial). Further down it is the ground under a roof or a ledge, where the person was dragged
// instead of coming to V (5.1 m at the second trial, 12.8 m at the third). A person within it is at V's height
// (YankWhy.reds).
public func ApexGrappleYankWayHeight() -> Float {
  return 2.0;
}

// The ground under a point, down to ApexGrappleYankGroundBelow(); the point itself when there is none.
public func ApexGrappleGroundUnder(point: Vector4, scriptInterface: ref<StateGameScriptInterface>) -> Vector4 {
  let below: Vector4 = point - DefaultTransition.GetUpVector() * ApexGrappleYankGroundBelow();
  let hit: TraceResult = scriptInterface.RaycastWithASingleGroup(point, below, n"Static");
  if !TraceResult.IsValid(hit) {
    return point;
  }
  return Vector4.Vector3To4(hit.position);
}

// The place the AI can stand under the way to the person. Measured on 12 November 2026, 11 refused pulls: the search
// at V's height takes a spot within 1 m of that height only, and 2 m from V stairs were already 1.1 to 1.6 m higher.
// `onWay`: the point of the straight line from V's feet to the person's, as far from V as the candidate. The ray goes
// down from above it to under the lower of the two.
public func ApexGrappleYankSpotOnWay(person: ref<GameObject>, onWay: Vector4, lowest: Float, navigation: ref<AINavigationSystem>, extents: Vector4, scriptInterface: ref<StateGameScriptInterface>, out spot: Vector4) -> Bool {
  let from: Vector4 = onWay + DefaultTransition.GetUpVector() * ApexGrappleYankWayAbove();
  let to: Vector4 = onWay;
  let hit: TraceResult;
  to.Z = lowest - ApexGrappleYankChestUp();
  hit = scriptInterface.RaycastWithASingleGroup(from, to, n"Static");
  return TraceResult.IsValid(hit) && navigation.IsPointOnNavmesh(person, Vector4.Vector3To4(hit.position), extents, spot);
}

// A surface at V's height by a point, whether the AI can stand on it or not: the roof V stands on.
public func ApexGrappleYankSurfaceBy(point: Vector4, scriptInterface: ref<StateGameScriptInterface>, out spot: Vector4) -> Bool {
  let up: Vector4 = DefaultTransition.GetUpVector();
  let hit: TraceResult = scriptInterface.RaycastWithASingleGroup(point + up * ApexGrappleYankWayAbove(), point - up, n"Static");
  if !TraceResult.IsValid(hit) {
    return false;
  }
  spot = Vector4.Vector3To4(hit.position);
  return true;
}

// The fourth rule: by V all the same. On the surface V stands on, toward the person, 2 m then 1 m from V; with none
// (V at the very edge, on a ladder, or on something that is no scenery) the point 2 m from V at the height of V's
// feet.
public func ApexGrappleYankSpotByV(feet: Vector4, toward: Vector4, scriptInterface: ref<StateGameScriptInterface>, out spot: Vector4) -> String {
  if ApexGrappleYankSurfaceBy(feet + toward * ApexGrappleYankStop(), scriptInterface, spot) {
    return "on the surface 2 m from V";
  }
  if ApexGrappleYankSurfaceBy(feet + toward * (ApexGrappleYankStop() - 1.0), scriptInterface, spot) {
    return "on the surface 1 m from V";
  }
  spot = feet + toward * ApexGrappleYankStop();
  return "no surface by V on their side, to the point 2 m from V at the height of V's feet";
}

// False when the person already stands by V: nothing to pull, and V is pulled to them instead (YankWhy.reds). The log
// says when the spot is not the one at V's height.
public func ApexGrappleYankSpot(person: ref<GameObject>, feet: Vector4, hanging: Bool, scriptInterface: ref<StateGameScriptInterface>, out spot: Vector4) -> Bool {
  if ApexGrappleAlreadyByV(person, feet) {
    return false;
  }
  let place: Vector4 = person.GetWorldPosition();
  let away: Vector4 = ApexGrappleFlat(place - feet);
  let far: Float = Vector4.Length(away);
  // A person straight above or under V has no side of their own: V's front then.
  let toward: Vector4 = far > ApexGrappleTiny() ? away / far : Vector4.Normalize(ApexGrappleFlat(scriptInterface.executionOwner.GetWorldForward()));
  let navigation: ref<AINavigationSystem> = GameInstance.GetAINavigationSystem(scriptInterface.GetGame());
  let extents: Vector4 = new Vector4(0.5, 0.5, 1.0, 1.0);
  let distance: Float = ApexGrappleYankStop();
  let how: String;
  while distance <= ApexGrappleYankStop() + 2.0 && distance < far {
    let candidate: Vector4 = feet + toward * distance;
    if navigation.IsPointOnNavmesh(person, candidate, extents, spot) {
      return true;
    }
    if hanging {
      if navigation.IsPointOnNavmesh(person, ApexGrappleGroundUnder(candidate, scriptInterface), extents, spot) {
        return true;
      }
    }
    if ApexGrappleYankSpotOnWay(person, feet + (place - feet) * (distance / far), MinF(feet.Z, place.Z), navigation, extents, scriptInterface, spot) {
      if AbsF(spot.Z - feet.Z) <= ApexGrappleYankWayHeight() {
        ApexGrappleLog("person pulled to V: no spot at V's height, one found on the way to the person " + ToString(distance) + " m from V, " + ToString(spot.Z - feet.Z) + " m above V's feet; the person " + ToString(place.Z - feet.Z) + " m above V's feet and " + ToString(far) + " m away along the ground");
        return true;
      }
    }
    distance += 1.0;
  }
  how = ApexGrappleYankSpotByV(feet, toward, scriptInterface, spot);
  ApexGrappleLog("person pulled to V: no place by V where they could stand, thrown to V all the same, " + how + ", " + ToString(spot.Z - feet.Z) + " m above V's feet; the person " + ToString(place.Z - feet.Z) + " m above V's feet and " + ToString(far) + " m away along the ground");
  return true;
}
