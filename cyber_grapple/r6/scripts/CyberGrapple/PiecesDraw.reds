// Made by fabrique/grapple.py from Apex Grapple's PiecesDraw.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Each frame: where the rope starts, which shot our pieces show, and every piece put in place. The grapple's phase
// (Hook.reds) is the one authority: a new shot, the bite and the let-go are read off it here, never told twice. Where
// the rope starts: RopeStart.reds, moved on to the frame being drawn by RopeLead.reds; where it bends: RopeBends.reds;
// how it hangs: RopeHang.reds.

// The rotation that turns a piece's +Y, its length in our meshes (fabrique), along `way`: BuildFromDirectionVector
// turns +Y (seen in game, the planted hook's +Y along its way). A way of no length, as the rope's on the frame of the
// shot, leaves the piece unturned rather than normalise nothing. How much the way points up is read off its own Z: the
// same number as its dot with straight up, multiplied by 0 or 1, with no vector made for it (B5).
public func CyberGrappleFacing(way: Vector4) -> Quaternion {
  if Vector4.Length(way) <= CyberGrappleTiny() {
    return new Quaternion(0.0, 0.0, 0.0, 1.0);
  }
  let along: Vector4 = Vector4.Normalize(way);
  if AbsF(along.Z) > 0.99 {
    return Quaternion.BuildFromDirectionVector(way, new Vector4(0.0, 1.0, 0.0, 0.0));
  }
  return Quaternion.BuildFromDirectionVector(way, new Vector4(0.0, 0.0, 1.0, 0.0));
}

public func CyberGrappleLocal(point: Vector4, origin: Vector4) -> Vector4 {
  let local: Vector4 = point - origin;
  local.W = 1.0;
  return local;
}

@if(ModuleExists("Codeware"))
public func CyberGrappleDrawPieces(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, now: Float, frame: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let pieces: ref<CyberGrapplePieces> = system.pieces as CyberGrapplePieces;
  if !IsDefined(pieces) {
    // Switched off, nothing is asked for; the pieces come once the mod is on.
    if !settings.enabled {
      return;
    }
    pieces = CyberGrappleAskForPieces(DefaultTransition.GetPlayerPosition(scriptInterface), now);
    if !IsDefined(pieces) {
      return;
    }
    system.pieces = pieces;
  }
  if pieces.failed {
    return;
  }
  if !pieces.ready {
    CyberGrappleFindPieces(pieces, now);
    if !pieces.ready {
      return;
    }
  }
  if !CyberGrapplePiecesAlive(pieces) {
    CyberGrappleLog("our pieces were taken away by the game: asked for again");
    system.pieces = null;
    return;
  }
  let set: ref<CyberGrapplePiecesSet> = pieces.set;
  // Between shots nothing is read or drawn.
  if system.phase == CyberGrappleIdle() && !IsDefined(set.shot) {
    return;
  }
  let view: Transform = CyberGrappleViewNow(system, scriptInterface);
  let game: Vector4 = CyberGrappleVelocityNow(system, scriptInterface);
  let moving: Vector4 = CyberGrappleMovingWith(system, now, game);
  let here: CyberGrappleRopeStartRead = CyberGrappleRopeStartNow(system, view, scriptInterface);
  let step: Vector4 = CyberGrappleRopeLeadStep(set.lead, here.at, here.from, moving, now, frame);
  let start: Vector4 = here.at + step;
  CyberGrappleFollowShot(system, set, settings, start, now);
  if IsDefined(set.shot) {
    set.mostPushStep = MaxF(set.mostPushStep, Vector4.Length(moving - game) * frame);
    CyberGrappleDrawSet(system, set, start, view, now, scriptInterface);
  }
}

@if(ModuleExists("Codeware"))
public func CyberGrappleFollowShot(system: ref<CyberGrappleSystem>, set: ref<CyberGrapplePiecesSet>, settings: ref<CyberGrappleSettings>, start: Vector4, now: Float) -> Void {
  if system.phase == CyberGrappleFlying() && (!IsDefined(set.shot) || set.shot.firedAt != system.firedAt) {
    set.shot = CyberGrappleHookShot.Create(system.firedAt, system.landsAt - system.firedAt, CyberGrappleHookLength(), CyberGrappleHookSunk(), CyberGrappleHookReturnSpeedOf(settings));
    set.bends = new CyberGrappleRopeBends();
    set.hang = new CyberGrappleRopeHangs();
    set.mostPieces = 0;
    set.mostShort = 0;
    set.mostPushStep = 0.0;
    set.lead.led = 0;
    set.lead.afterMiss = 0;
    set.cut = false;
    return;
  }
  if !IsDefined(set.shot) || set.shot.released {
    return;
  }
  if system.phase == CyberGrapplePulling() && !set.shot.caught {
    CyberGrappleHookCatch(set.shot, start, system.anchor, now);
    return;
  }
  if system.phase == CyberGrappleIdle() {
    CyberGrappleHookRelease(set.shot, start, system.anchor, CyberGrappleBendsFromStart(set.bends), now);
  }
}

@if(ModuleExists("Codeware"))
public func CyberGrappleDrawSet(system: ref<CyberGrappleSystem>, set: ref<CyberGrapplePiecesSet>, start: Vector4, view: Transform, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let pose: CyberGrappleHookPose = CyberGrappleHookWhere(set.shot, start, system.anchor, now);
  if !pose.there {
    CyberGrappleLog("hook home " + ToString(now - set.shot.firedAt) + " s after the shot, way back " + ToString(now - set.shot.releasedAt) + " s from " + ToString(set.shot.releasedLength) + " m of rope: " + CyberGrappleRopeBendsText(set.bends) + "; " + CyberGrappleRopeHangsText(set.hang) + "; at most " + ToString(set.mostPieces) + " pieces of rope, " + ToString(set.mostShort) + " of them short" + (set.cut ? ", cut short: more than our pieces" : "") + "; the pull's push moved the rope's start on by at most " + FloatToStringPrec(set.mostPushStep, 3) + " m in a frame; " + CyberGrappleRopeLeadText(set.lead));
    CyberGrappleHideSet(set);
    set.shot = null;
    return;
  }
  // The rays this frame casts for the rope, for the minute's line (Cost.reds).
  let raysBefore: Int32 = set.bends.rays + set.hang.rays;
  // The rope's line: straight to the flying hook; from the bite on, through its bends to where the hook was planted,
  // and on the way back cut where the hook has got to.
  let line: array<Vector4>;
  if pose.phase == CyberGrappleHookOut() {
    ArrayPush(line, start);
    ArrayPush(line, pose.base);
    line = CyberGrappleLauncherExit(system, view, line);
  } else {
    let end: Vector4 = set.shot.released ? set.shot.releasedFrom : CyberGrapplePlantedBase(set.shot, system.anchor, set.shot.plantedWay);
    if set.shot.caught {
      CyberGrappleBendRope(scriptInterface, set.bends, start, end);
    }
    line = CyberGrappleRopeLine(start, CyberGrappleBendsFromStart(set.bends), end);
    line = CyberGrappleLauncherExit(system, view, line);
    if pose.phase == CyberGrappleHookBack() {
      line = CyberGrappleRopeCut(line, pose.left);
      let count: Int32 = ArraySize(line);
      pose.base = line[count - 1];
      pose.way = CyberGrappleToward(line[count - 2], line[count - 1]);
    }
  }
  let root: WorldTransform;
  WorldTransform.SetPosition(root, start);
  WorldTransform.SetOrientation(root, new Quaternion(0.0, 0.0, 0.0, 1.0));
  for held in set.entities {
    let entity: ref<Entity> = held;
    entity.SetWorldTransform(root);
  }
  set.hook.SetLocalTransform(CyberGrappleLocal(pose.base, start), CyberGrappleFacing(pose.way));
  if !set.hookShown {
    set.hook.Toggle(true);
    set.hookShown = true;
  }
  let shown: Float = CyberGrappleRopeSwing(pose.phase, pose.since);
  let piece: Float = CyberGrappleRopePieceFor(line, ArraySize(set.rope.pieces));
  CyberGrappleHungPlaces(scriptInterface, set.hang, set.laid, set.table, line, shown, now - set.shot.firedAt, piece, set.ropeShort.length, ArraySize(set.ropeShort.pieces));
  if IsDefined(system.cost) {
    system.cost.ropeRays = system.cost.ropeRays + set.bends.rays + set.hang.rays - raysBefore;
  }
  CyberGrappleLayRope(set, set.laid, start);
}

// Each piece from one place to the next, stretched alike to its span (visualScale along its length, +Y), long or short
// as its span was laid (RopeHang.reds); pieces shown or hidden only when their number changes. The pieces of a straight
// span lie one after the other on its line, all of a length: they take the first one's turn and stretch rather than
// work their own out again, the gap left to Kevin's eye (10 November 2026, audit B6: "oui"). Where a stock runs out,
// the rope stops there.
@if(ModuleExists("Codeware"))
public func CyberGrappleLayRope(set: ref<CyberGrapplePiecesSet>, laid: ref<CyberGrappleRopeLaid>, start: Vector4) -> Void {
  let pieces: Int32 = ArraySize(laid.places) - 1;
  let stock: ref<CyberGrappleRopeStock> = set.rope;
  let span: Int32 = 0;
  let sharedUntil: Int32 = 0;
  let turn: Quaternion;
  let stretch: Vector3;
  let laying: Bool = true;
  let i: Int32 = 0;
  while laying && i < pieces {
    let from: Vector4 = laid.places[i];
    let to: Vector4 = laid.places[i + 1];
    if i >= sharedUntil {
      while span < ArraySize(laid.spanEnds) - 1 && i >= laid.spanEnds[span] {
        span = span + 1;
      }
      stock = laid.shortSpan[span] ? set.ropeShort : set.rope;
      turn = CyberGrappleFacing(to - from);
      stretch = new Vector3(1.0, Vector4.Distance(from, to) / stock.length, 1.0);
      sharedUntil = laid.straight[span] ? laid.spanEnds[span] : i + 1;
    }
    laying = CyberGrappleStockLay(stock, CyberGrappleLocal(from, start), turn, stretch);
    i = i + 1;
  }
  if !laying {
    set.cut = true;
  }
  set.mostPieces = Max(set.mostPieces, set.rope.taken + set.ropeShort.taken);
  set.mostShort = Max(set.mostShort, set.ropeShort.taken);
  CyberGrappleStockSettle(set.rope);
  CyberGrappleStockSettle(set.ropeShort);
}

@if(!ModuleExists("Codeware"))
public func CyberGrappleDrawPieces(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, now: Float, frame: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {}
