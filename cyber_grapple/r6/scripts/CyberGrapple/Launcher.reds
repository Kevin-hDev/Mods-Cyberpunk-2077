// Made by fabrique/grapple.py from Apex Grapple's Launcher.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The game's projectile launcher lent to V's left hand during a grapple seen from the eyes, when the setting "Arm
// implant" chooses it (Implant.reds): the arm plays the launcher's gesture (Arm.reds), and the launcher shows what V
// fires the hook with. Lent as the arm rises; taken back as the arm is put back, at a new shot, when the view leaves
// the eyes, when the game puts something else in the hand, or once the grapple's frame stops (LauncherWatch.reds).
// - A real item given to V and set in the left hand slot: a preview item never showed on V (8 shots of 8, 31 October
//   2026). Its added event is flagged silent, else "Looted" showed in the activity log, and the game's "Removed" line
//   for it is taken out of that log (LauncherNotice.reds). Its ID is made as the game
//   makes the items it crafts (ItemID.FromTDBID), and it is taken back by that ID. It copies V's own launcher's record
//   when one is installed, so that it shows its tier (LauncherStyle.reds), never with the ID of an item V owns.
// - It carries a tag of our own, given with it as the game's HideInUI is: saving is refused while it is lent (Hook.reds,
//   IsSavingLocked), as the game itself refuses it during an air dash (locomotionTransitions.script), and a save that
//   kept it all the same is cleaned at the next load by that tag.
// - The holstered arms in the slot RightArm are never touched: taken off for the loan and put back, they left the slot
//   empty and V with no arms, which the save kept (31 October). V's own left hand is hidden instead (LauncherHand.reds),
//   which needs Codeware: without it nothing is lent.
// - Nothing is lent while the left hand holds an item of the game's, and only our item is ever taken out of it.
// - Seen from outside nothing is lent: its look from outside was never seen.

public class CyberGrappleLauncherLoan extends IScriptable {
  // Valid while lent.
  public let id: ItemID;
  // The shot it serves, by the time it was fired.
  public let shotAt: Float;
  public let seen: Bool;
  public let wristMissSaid: Bool;
  public let hiddenHand: array<wref<IComponent>>;
  public let watched: Bool;
  // Kept from load to the next (LauncherCrosshair.reds).
  public let crosshair: wref<inkGameController>;
  public let crosshairHidden: Bool;
  public let crosshairWasVisible: Bool;
  public let noCrosshairSaid: Bool;
  // A save that kept the launcher, looked for once a load.
  public let saveChecked: Bool;
  // The launcher last taken back, until the game's removal event for it is seen (LauncherNotice.reds).
  public let takenBack: ItemID;
  // The activity log line the game builds for that removal, still to be taken out of the log.
  public let noticeText: String;
  public let noticeAt: Float;
  public let noticeCount: Int32;
}

public func CyberGrappleLauncherRecord() -> TweakDBID {
  return t"Items.CyberGrappleCommon";
}

public func CyberGrappleLauncherSlot() -> TweakDBID {
  return t"AttachmentSlots.WeaponLeft";
}

public func CyberGrappleLauncherTag() -> CName {
  return n"CyberGrappleLent";
}

public func CyberGrappleLoanOf(system: ref<CyberGrappleSystem>) -> ref<CyberGrappleLauncherLoan> {
  if !IsDefined(system.loan) {
    system.loan = new CyberGrappleLauncherLoan();
  }
  return system.loan;
}

public func CyberGrappleLauncherOut(system: ref<CyberGrappleSystem>) -> Bool {
  return IsDefined(system.loan) && ItemID.IsValid(system.loan.id);
}

public func CyberGrappleLauncherIsOurs(item: ref<ItemObject>, id: ItemID) -> Bool {
  return IsDefined(item) && item.GetItemID() == id;
}

public func CyberGrappleLauncherLend(system: ref<CyberGrappleSystem>, arm: ref<CyberGrappleArm>, now: Float, player: ref<GameObject>) -> Void {
  CyberGrappleLauncherTakeBack(system, now, player, "a new shot");
  if !arm.sent || !CyberGrappleLauncherCanShow() {
    return;
  }
  let items: ref<TransactionSystem> = GameInstance.GetTransactionSystem(player.GetGame());
  let before: ref<ItemObject> = items.GetItemInSlot(player, CyberGrappleLauncherSlot());
  // The last shot's launcher may still show in the slot just after it was taken back.
  if IsDefined(before) && !items.HasTag(player, CyberGrappleLauncherTag(), before.GetItemID()) {
    CyberGrappleLog("launcher not lent: V's left hand holds " + TDBID.ToStringDEBUG(ItemID.GetTDBID(before.GetItemID())));
    return;
  }
  let installed: ItemID = CyberGrappleInstalledLauncher(player);
  let id: ItemID = ItemID.FromTDBID(CyberGrappleLauncherRecordFor(installed));
  // Never an ID V already owns: taken back by its ID, V's own launcher would leave with it.
  if items.HasItem(player, id) || (ItemID.IsValid(installed) && id == installed) {
    CyberGrappleLog("launcher not lent: its copy of " + TDBID.ToStringDEBUG(ItemID.GetTDBID(id)) + " has the ID of an item V owns");
    return;
  }
  let loan: ref<CyberGrappleLauncherLoan> = CyberGrappleLoanOf(system);
  // Known before it is given, so that its added event is recognised wherever the game sends it.
  loan.id = id;
  loan.shotAt = arm.shotAt;
  loan.seen = false;
  loan.wristMissSaid = false;
  loan.crosshairHidden = false;
  if !items.GiveItem(player, id, 1, [n"SkipActivityLog", n"HideInUI", CyberGrappleLauncherTag()]) {
    let none: ItemID;
    loan.id = none;
    CyberGrappleLog("launcher not lent: the game did not give it");
    return;
  }
  let placed: Bool = items.AddItemToSlot(player, CyberGrappleLauncherSlot(), id, true);
  CyberGrappleLog("launcher lent " + ToString(now - loan.shotAt) + " s after the shot, set in the left hand " + ToString(placed) + ", " + CyberGrappleLauncherLook(player, installed, id));
  CyberGrappleLauncherWatch(system, player.GetGame());
}

// Each frame of a raised arm (Arm.reds), after the view was judged.
public func CyberGrappleLauncherFrame(system: ref<CyberGrappleSystem>, arm: ref<CyberGrappleArm>, now: Float, player: ref<GameObject>) -> Void {
  if !CyberGrappleLauncherOut(system) {
    return;
  }
  let loan: ref<CyberGrappleLauncherLoan> = system.loan;
  if !arm.sent {
    CyberGrappleLauncherTakeBack(system, now, player, "V seen from outside");
    return;
  }
  CyberGrappleLauncherCrosshairHide(loan);
  let held: ref<ItemObject> = GameInstance.GetTransactionSystem(player.GetGame()).GetItemInSlot(player, CyberGrappleLauncherSlot());
  let ours: Bool = CyberGrappleLauncherIsOurs(held, loan.id);
  if loan.seen {
    // An empty hand is left alone: only an item of the game's own in it ends the loan.
    if IsDefined(held) && !ours {
      CyberGrappleLauncherTakeBack(system, now, player, "the game put " + TDBID.ToStringDEBUG(ItemID.GetTDBID(held.GetItemID())) + " in V's left hand");
      return;
    }
    CyberGrappleLauncherHideHand(loan, false, now, player);
    return;
  }
  if ours {
    loan.seen = true;
    CyberGrappleLauncherHideHand(loan, true, now, player);
    CyberGrappleLauncherStyle(player);
  }
}

public func CyberGrappleLauncherTakeBack(system: ref<CyberGrappleSystem>, now: Float, player: ref<GameObject>, why: String) -> Void {
  if !CyberGrappleLauncherOut(system) {
    return;
  }
  let loan: ref<CyberGrappleLauncherLoan> = system.loan;
  let id: ItemID = loan.id;
  let none: ItemID;
  loan.id = none;
  let items: ref<TransactionSystem> = GameInstance.GetTransactionSystem(player.GetGame());
  let held: ref<ItemObject> = items.GetItemInSlot(player, CyberGrappleLauncherSlot());
  let fromHand: Bool = false;
  if !IsDefined(held) || CyberGrappleLauncherIsOurs(held, id) {
    fromHand = items.RemoveItemFromSlot(player, CyberGrappleLauncherSlot(), true);
  }
  loan.takenBack = id;
  // Only an item V still owns is removed: given an ID that is gone, the game's native removal might fall back on the
  // record, now V's own implant's (LauncherStyle.reds). Audit of 15 November 2026.
  let removed: Bool = false;
  if items.HasItem(player, id) {
    removed = items.RemoveItem(player, id, 1);
  }
  let back: Int32 = CyberGrappleLauncherShowHand(loan);
  CyberGrappleLauncherCrosshairRestore(loan);
  CyberGrappleLog("launcher taken back " + ToString(now - loan.shotAt) + " s after the shot, " + why + ": from the hand " + ToString(fromHand) + ", from the inventory " + ToString(removed) + ", still owned " + ToString(items.HasItem(player, id)) + ", " + ToString(back) + " pieces of V's left arm switched back on");
}

// Once a load, at the grapple's first frame, before any loan. Only items given with our tag are looked at.
public func CyberGrappleLauncherLeftInSave(system: ref<CyberGrappleSystem>, player: ref<GameObject>) -> Void {
  let loan: ref<CyberGrappleLauncherLoan> = CyberGrappleLoanOf(system);
  if loan.saveChecked {
    return;
  }
  loan.saveChecked = true;
  let items: ref<TransactionSystem> = GameInstance.GetTransactionSystem(player.GetGame());
  let kept: array<wref<gameItemData>>;
  if !items.GetItemListByTag(player, CyberGrappleLauncherTag(), kept) {
    return;
  }
  for data in kept {
    if IsDefined(data) {
      let id: ItemID = data.GetID();
      if CyberGrappleLauncherIsOurs(items.GetItemInSlot(player, CyberGrappleLauncherSlot()), id) {
        items.RemoveItemFromSlot(player, CyberGrappleLauncherSlot(), true);
      }
      loan.takenBack = id;
      let removed: Bool = items.RemoveItem(player, id, 1);
      CyberGrappleLog("a lent launcher kept by the save, taken back: from the inventory " + ToString(removed) + ", still owned " + ToString(items.HasItem(player, id)));
    }
  }
}

public func CyberGrappleLauncherIs(owner: ref<GameObject>, id: ItemID) -> Bool {
  if !IsDefined(owner) || !CyberGrappleIsLauncherRecord(ItemID.GetTDBID(id)) {
    return false;
  }
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(owner.GetGame());
  return IsDefined(system) && CyberGrappleLauncherOut(system) && system.loan.id == id;
}

@wrapMethod(PlayerPuppet)
protected cb func OnItemAddedToInventory(evt: ref<ItemAddedEvent>) -> Bool {
  if CyberGrappleLauncherIs(this, evt.itemID) {
    evt.flaggedAsSilent = true;
  }
  return wrappedMethod(evt);
}
