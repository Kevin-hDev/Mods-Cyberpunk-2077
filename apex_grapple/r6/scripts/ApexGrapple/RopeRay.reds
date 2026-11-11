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
