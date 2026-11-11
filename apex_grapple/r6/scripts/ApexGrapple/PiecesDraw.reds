// Each frame: where the rope starts, which shot our pieces show, and every piece put in place. The grapple's phase
// (Hook.reds) is the one authority: a new shot, the bite and the let-go are read off it here, never told twice. Where
// the rope starts: RopeStart.reds, moved on to the frame being drawn by RopeLead.reds; where it bends: RopeBends.reds;
// how it hangs: RopeHang.reds.

// The rotation that turns a piece's +Y, its length in our meshes (fabrique), along `way`: BuildFromDirectionVector
// turns +Y (seen in game, the planted hook's +Y along its way). A way of no length, as the rope's on the frame of the
// shot, leaves the piece unturned rather than normalise nothing. How much the way points up is read off its own Z: the
// same number as its dot with straight up, multiplied by 0 or 1, with no vector made for it (B5).
public func ApexGrappleFacing(way: Vector4) -> Quaternion {
  if Vector4.Length(way) <= ApexGrappleTiny() {
    return new Quaternion(0.0, 0.0, 0.0, 1.0);
  }
  let along: Vector4 = Vector4.Normalize(way);
  if AbsF(along.Z) > 0.99 {
    return Quaternion.BuildFromDirectionVector(way, new Vector4(0.0, 1.0, 0.0, 0.0));
  }
  return Quaternion.BuildFromDirectionVector(way, new Vector4(0.0, 0.0, 1.0, 0.0));
}

public func ApexGrappleLocal(point: Vector4, origin: Vector4) -> Vector4 {
  let local: Vector4 = point - origin;
  local.W = 1.0;
  return local;
}

@if(ModuleExists("Codeware"))
public func ApexGrappleDrawPieces(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, now: Float, frame: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let pieces: ref<ApexGrapplePieces> = system.pieces as ApexGrapplePieces;
  if !IsDefined(pieces) {
    // Switched off, nothing is asked for; the pieces come once the mod is on.
    if !settings.enabled {
      return;
    }
    pieces = ApexGrappleAskForPieces(DefaultTransition.GetPlayerPosition(scriptInterface), now);
    if !IsDefined(pieces) {
      return;
    }
    system.pieces = pieces;
  }
  if pieces.failed {
    return;
  }
  if !pieces.ready {
    ApexGrappleFindPieces(pieces, now);
    if !pieces.ready {
      return;
    }
  }
  if !ApexGrapplePiecesAlive(pieces) {
    ApexGrappleLog("our pieces were taken away by the game: asked for again");
    system.pieces = null;
    return;
  }
  let set: ref<ApexGrapplePiecesSet> = pieces.set;
  // Between shots nothing is read or drawn.
  if system.phase == ApexGrappleIdle() && !IsDefined(set.shot) {
    return;
  }
  let view: Transform = ApexGrappleViewNow(system, scriptInterface);
  let game: Vector4 = ApexGrappleVelocityNow(system, scriptInterface);
  let moving: Vector4 = ApexGrappleMovingWith(system, now, game);
  let here: ApexGrappleRopeStartRead = ApexGrappleRopeStartNow(system, view, scriptInterface);
  let step: Vector4 = ApexGrappleRopeLeadStep(set.lead, here.at, here.from, moving, now, frame);
  let start: Vector4 = here.at + step;
  ApexGrappleFollowShot(system, set, settings, start, now);
  if IsDefined(set.shot) {
    set.mostPushStep = MaxF(set.mostPushStep, Vector4.Length(moving - game) * frame);
    ApexGrappleDrawSet(system, set, start, view, now, scriptInterface);
  }
}

@if(ModuleExists("Codeware"))
public func ApexGrappleFollowShot(system: ref<ApexGrappleSystem>, set: ref<ApexGrapplePiecesSet>, settings: ref<ApexGrappleSettings>, start: Vector4, now: Float) -> Void {
  if system.phase == ApexGrappleFlying() && (!IsDefined(set.shot) || set.shot.firedAt != system.firedAt) {
    set.shot = ApexGrappleHookShot.Create(system.firedAt, system.landsAt - system.firedAt, ApexGrappleHookLength(), ApexGrappleHookSunk(), ApexGrappleHookReturnSpeedOf(settings));
    set.bends = new ApexGrappleRopeBends();
    set.hang = new ApexGrappleRopeHangs();
    set.mostPieces = 0;
    set.mostPushStep = 0.0;
    set.lead.led = 0;
    set.lead.afterMiss = 0;
    set.cut = false;
    return;
  }
  if !IsDefined(set.shot) || set.shot.released {
    return;
  }
  if system.phase == ApexGrapplePulling() && !set.shot.caught {
    ApexGrappleHookCatch(set.shot, start, system.anchor, now);
    return;
  }
  if system.phase == ApexGrappleIdle() {
    ApexGrappleHookRelease(set.shot, start, system.anchor, ApexGrappleBendsFromStart(set.bends), now);
  }
}

@if(ModuleExists("Codeware"))
public func ApexGrappleDrawSet(system: ref<ApexGrappleSystem>, set: ref<ApexGrapplePiecesSet>, start: Vector4, view: Transform, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let pose: ApexGrappleHookPose = ApexGrappleHookWhere(set.shot, start, system.anchor, now);
  if !pose.there {
    ApexGrappleLog("hook home " + ToString(now - set.shot.firedAt) + " s after the shot, way back " + ToString(now - set.shot.releasedAt) + " s from " + ToString(set.shot.releasedLength) + " m of rope: " + ApexGrappleRopeBendsText(set.bends) + "; " + ApexGrappleRopeHangsText(set.hang) + "; at most " + ToString(set.mostPieces) + " pieces of rope" + (set.cut ? ", cut short: more than our pieces" : "") + "; the pull's push moved the rope's start on by at most " + FloatToStringPrec(set.mostPushStep, 3) + " m in a frame; " + ApexGrappleRopeLeadText(set.lead));
    ApexGrappleHideSet(set);
    set.shot = null;
    return;
  }
  // The rays this frame casts for the rope, for the minute's line (Cost.reds).
  let raysBefore: Int32 = set.bends.rays + set.hang.rays;
  // The rope's line: straight to the flying hook; from the bite on, through its bends to where the hook was planted,
  // and on the way back cut where the hook has got to.
  let line: array<Vector4>;
  if pose.phase == ApexGrappleHookOut() {
    ArrayPush(line, start);
    ArrayPush(line, pose.base);
    line = ApexGrappleLauncherExit(system, view, line);
  } else {
    let end: Vector4 = set.shot.released ? set.shot.releasedFrom : ApexGrapplePlantedBase(set.shot, system.anchor, set.shot.plantedWay);
    if set.shot.caught {
      ApexGrappleBendRope(scriptInterface, set.bends, start, end);
    }
    line = ApexGrappleRopeLine(start, ApexGrappleBendsFromStart(set.bends), end);
    line = ApexGrappleLauncherExit(system, view, line);
    if pose.phase == ApexGrappleHookBack() {
      line = ApexGrappleRopeCut(line, pose.left);
      let count: Int32 = ArraySize(line);
      pose.base = line[count - 1];
      pose.way = ApexGrappleToward(line[count - 2], line[count - 1]);
    }
  }
  let root: WorldTransform;
  WorldTransform.SetPosition(root, start);
  WorldTransform.SetOrientation(root, new Quaternion(0.0, 0.0, 0.0, 1.0));
  for held in set.entities {
    let entity: ref<Entity> = held;
    entity.SetWorldTransform(root);
  }
  set.hook.SetLocalTransform(ApexGrappleLocal(pose.base, start), ApexGrappleFacing(pose.way));
  if !set.hookShown {
    set.hook.Toggle(true);
    set.hookShown = true;
  }
  let shown: Float = ApexGrappleRopeSwing(pose.phase, pose.since);
  let piece: Float = ApexGrappleRopePieceFor(line, ArraySize(set.rope));
  ApexGrappleHungPlaces(scriptInterface, set.hang, set.laid, set.table, line, shown, now - set.shot.firedAt, piece);
  if IsDefined(system.cost) {
    system.cost.ropeRays = system.cost.ropeRays + set.bends.rays + set.hang.rays - raysBefore;
  }
  ApexGrappleLayRope(set, set.laid, start);
}

// Each piece from one place to the next, stretched alike to its span (visualScale along its length, +Y); pieces shown
// or hidden only when their number changes. The pieces of a straight span lie one after the other on its line, all of
// a length: they take the first one's turn and stretch rather than work their own out again, the gap left to Kevin's
// eye (10 November 2026, audit B6: "oui").
@if(ModuleExists("Codeware"))
public func ApexGrappleLayRope(set: ref<ApexGrapplePiecesSet>, laid: ref<ApexGrappleRopeLaid>, start: Vector4) -> Void {
  let wanted: Int32 = ArraySize(laid.places) - 1;
  let count: Int32 = Max(Min(wanted, ArraySize(set.rope)), 0);
  if wanted > count {
    set.cut = true;
  }
  let length: Float = ApexGrappleRopePieceLength();
  let span: Int32 = 0;
  let sharedUntil: Int32 = 0;
  let turn: Quaternion;
  let stretch: Vector3;
  let i: Int32 = 0;
  while i < count {
    let from: Vector4 = laid.places[i];
    let to: Vector4 = laid.places[i + 1];
    if i >= sharedUntil {
      while span < ArraySize(laid.spanEnds) - 1 && i >= laid.spanEnds[span] {
        span = span + 1;
      }
      turn = ApexGrappleFacing(to - from);
      stretch = new Vector3(1.0, Vector4.Distance(from, to) / length, 1.0);
      sharedUntil = laid.straight[span] ? laid.spanEnds[span] : i + 1;
    }
    let piece: ref<MeshComponent> = set.rope[i];
    piece.SetLocalTransform(ApexGrappleLocal(from, start), turn);
    piece.visualScale = stretch;
    if i >= set.shown {
      piece.Toggle(true);
    }
    i = i + 1;
  }
  while i < set.shown {
    let extra: ref<MeshComponent> = set.rope[i];
    extra.Toggle(false);
    i = i + 1;
  }
  set.shown = count;
  set.mostPieces = Max(set.mostPieces, count);
}

@if(!ModuleExists("Codeware"))
public func ApexGrappleDrawPieces(system: ref<ApexGrappleSystem>, settings: ref<ApexGrappleSettings>, now: Float, frame: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {}
