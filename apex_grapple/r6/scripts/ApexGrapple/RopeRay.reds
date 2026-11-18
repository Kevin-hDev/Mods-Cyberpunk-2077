// The rope's line of sight (RopeBends.reds, RopeHang.reds): one ray against the surfaces the hook can take, Static and
// Terrain together. Until the audit of 10 November 2026 it was two rays, one per group, and the nearer hit was kept;
// the filtered ray gives that same hit (B3, Kevin's trial of 10 November 2026: 7 896 lines tested, 1 704 hits, no
// answer or point apart; releves/apex-grapple/2026-11-10-allegement).
public func ApexGrappleRopeRay(scriptInterface: ref<StateGameScriptInterface>, from: Vector4, to: Vector4) -> TraceResult {
  let filter: QueryFilter;
  QueryFilter.AddGroup(filter, n"Static");
  QueryFilter.AddGroup(filter, n"Terrain");
  let spatial: ref<SpatialQueriesSystem> = scriptInterface.GetSpatialQueriesSystem();
  let hit: TraceResult;
  spatial.SyncRaycastByQueryFilter(from, to, filter, hit);
  return hit;
}

// How near the anchor the ray must come to have reached it: the anchor lies on the surface the ray ends on.
public func ApexGrappleRopeClearSlack() -> Float {
  return 0.5;
}

// Nothing solid between a point and the anchor. Asked once, when a blow stops a pull with "Stay hooked" on (in game, V
// stopped under a slab 21 m below the anchor was kept there by a rope going through the slab; Kevin, 18 November
// 2026), and once for the last line of a swing (SwingLog.reds).
public func ApexGrappleRopeClear(system: ref<ApexGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>, from: Vector4, anchor: Vector4) -> Bool {
  if IsDefined(system.cost) {
    system.cost.ropeRays = system.cost.ropeRays + 1;
  }
  let at: Float = ApexGrappleHitDistance(ApexGrappleRopeRay(scriptInterface, from, anchor), from);
  return at < 0.0 || at >= Vector4.Distance(from, anchor) - ApexGrappleRopeClearSlack();
}
