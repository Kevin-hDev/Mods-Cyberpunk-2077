// The game's projectile launcher lent to V's left hand during a grapple seen from the eyes, when the setting "Arm
// implant" chooses it (Implant.reds): the arm plays the launcher's gesture (Arm.reds), and the launcher shows what V
// fires the hook with. Lent as the arm rises; taken back as the arm is put back, at a new shot, when the view leaves
// the eyes, when the game puts something else in the hand, or once the grapple's frame stops (LauncherWatch.reds).
// - A real item given to V and set in the left hand slot: a preview item never showed on V (8 shots of 8, 31 October
//   2026). Its added event is flagged silent, else "Looted" showed in the activity log. Its ID is made as the game
//   makes the items it crafts (ItemID.FromTDBID), and it is taken back by that ID.
// - It carries a tag of our own, given with it as the game's HideInUI is: saving is refused while it is lent (Hook.reds,
//   IsSavingLocked), as the game itself refuses it during an air dash (locomotionTransitions.script), and a save that
//   kept it all the same is cleaned at the next load by that tag.
// - The holstered arms in the slot RightArm are never touched: taken off for the loan and put back, they left the slot
//   empty and V with no arms, which the save kept (31 October). V's own left hand is hidden instead (LauncherHand.reds),
//   which needs Codeware: without it nothing is lent.
// - Nothing is lent while the left hand holds an item of the game's, and only our item is ever taken out of it.
// - Seen from outside nothing is lent: its look from outside was never seen.

public class ApexGrappleLauncherLoan extends IScriptable {
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
}

public func ApexGrappleLauncherRecord() -> TweakDBID {
  return t"Items.AdvancedProjectileLauncherRare";
}

public func ApexGrappleLauncherSlot() -> TweakDBID {
  return t"AttachmentSlots.WeaponLeft";
}

public func ApexGrappleLauncherTag() -> CName {
  return n"ApexGrappleLent";
}

public func ApexGrappleLoanOf(system: ref<ApexGrappleSystem>) -> ref<ApexGrappleLauncherLoan> {
  if !IsDefined(system.loan) {
    system.loan = new ApexGrappleLauncherLoan();
  }
  return system.loan;
}

public func ApexGrappleLauncherOut(system: ref<ApexGrappleSystem>) -> Bool {
  return IsDefined(system.loan) && ItemID.IsValid(system.loan.id);
}

public func ApexGrappleLauncherIsOurs(item: ref<ItemObject>, id: ItemID) -> Bool {
  return IsDefined(item) && item.GetItemID() == id;
}

public func ApexGrappleLauncherLend(system: ref<ApexGrappleSystem>, arm: ref<ApexGrappleArm>, now: Float, player: ref<GameObject>) -> Void {
  ApexGrappleLauncherTakeBack(system, now, player, "a new shot");
  if !arm.sent || !ApexGrappleLauncherCanShow() {
    return;
  }
  let items: ref<TransactionSystem> = GameInstance.GetTransactionSystem(player.GetGame());
  let before: ref<ItemObject> = items.GetItemInSlot(player, ApexGrappleLauncherSlot());
  // The last shot's launcher may still show in the slot just after it was taken back.
  if IsDefined(before) && !items.HasTag(player, ApexGrappleLauncherTag(), before.GetItemID()) {
    ApexGrappleLog("launcher not lent: V's left hand holds " + TDBID.ToStringDEBUG(ItemID.GetTDBID(before.GetItemID())));
    return;
  }
  let loan: ref<ApexGrappleLauncherLoan> = ApexGrappleLoanOf(system);
  let id: ItemID = ItemID.FromTDBID(ApexGrappleLauncherRecord());
  // Known before it is given, so that its added event is recognised wherever the game sends it.
  loan.id = id;
  loan.shotAt = arm.shotAt;
  loan.seen = false;
  loan.wristMissSaid = false;
  loan.crosshairHidden = false;
  if !items.GiveItem(player, id, 1, [n"SkipActivityLog", n"HideInUI", ApexGrappleLauncherTag()]) {
    let none: ItemID;
    loan.id = none;
    ApexGrappleLog("launcher not lent: the game did not give it");
    return;
  }
  let placed: Bool = items.AddItemToSlot(player, ApexGrappleLauncherSlot(), id, true);
  ApexGrappleLog("launcher lent " + ToString(now - loan.shotAt) + " s after the shot, set in the left hand " + ToString(placed));
  ApexGrappleLauncherWatch(system, player.GetGame());
}

// Each frame of a raised arm (Arm.reds), after the view was judged.
public func ApexGrappleLauncherFrame(system: ref<ApexGrappleSystem>, arm: ref<ApexGrappleArm>, now: Float, player: ref<GameObject>) -> Void {
  if !ApexGrappleLauncherOut(system) {
    return;
  }
  let loan: ref<ApexGrappleLauncherLoan> = system.loan;
  if !arm.sent {
    ApexGrappleLauncherTakeBack(system, now, player, "V seen from outside");
    return;
  }
  ApexGrappleLauncherCrosshairHide(loan);
  let held: ref<ItemObject> = GameInstance.GetTransactionSystem(player.GetGame()).GetItemInSlot(player, ApexGrappleLauncherSlot());
  let ours: Bool = ApexGrappleLauncherIsOurs(held, loan.id);
  if loan.seen {
    // An empty hand is left alone: only an item of the game's own in it ends the loan.
    if IsDefined(held) && !ours {
      ApexGrappleLauncherTakeBack(system, now, player, "the game put " + TDBID.ToStringDEBUG(ItemID.GetTDBID(held.GetItemID())) + " in V's left hand");
      return;
    }
    ApexGrappleLauncherHideHand(loan, false, now, player);
    return;
  }
  if ours {
    loan.seen = true;
    ApexGrappleLauncherHideHand(loan, true, now, player);
  }
}

public func ApexGrappleLauncherTakeBack(system: ref<ApexGrappleSystem>, now: Float, player: ref<GameObject>, why: String) -> Void {
  if !ApexGrappleLauncherOut(system) {
    return;
  }
  let loan: ref<ApexGrappleLauncherLoan> = system.loan;
  let id: ItemID = loan.id;
  let none: ItemID;
  loan.id = none;
  let items: ref<TransactionSystem> = GameInstance.GetTransactionSystem(player.GetGame());
  let held: ref<ItemObject> = items.GetItemInSlot(player, ApexGrappleLauncherSlot());
  let fromHand: Bool = false;
  if !IsDefined(held) || ApexGrappleLauncherIsOurs(held, id) {
    fromHand = items.RemoveItemFromSlot(player, ApexGrappleLauncherSlot(), true);
  }
  let removed: Bool = items.RemoveItem(player, id, 1);
  let back: Int32 = ApexGrappleLauncherShowHand(loan);
  ApexGrappleLauncherCrosshairRestore(loan);
  ApexGrappleLog("launcher taken back " + ToString(now - loan.shotAt) + " s after the shot, " + why + ": from the hand " + ToString(fromHand) + ", from the inventory " + ToString(removed) + ", still owned " + ToString(items.HasItem(player, id)) + ", " + ToString(back) + " pieces of V's left arm switched back on");
}

// Once a load, at the grapple's first frame, before any loan. Only items given with our tag are looked at.
public func ApexGrappleLauncherLeftInSave(system: ref<ApexGrappleSystem>, player: ref<GameObject>) -> Void {
  let loan: ref<ApexGrappleLauncherLoan> = ApexGrappleLoanOf(system);
  if loan.saveChecked {
    return;
  }
  loan.saveChecked = true;
  let items: ref<TransactionSystem> = GameInstance.GetTransactionSystem(player.GetGame());
  let kept: array<wref<gameItemData>>;
  if !items.GetItemListByTag(player, ApexGrappleLauncherTag(), kept) {
    return;
  }
  for data in kept {
    if IsDefined(data) {
      let id: ItemID = data.GetID();
      if ApexGrappleLauncherIsOurs(items.GetItemInSlot(player, ApexGrappleLauncherSlot()), id) {
        items.RemoveItemFromSlot(player, ApexGrappleLauncherSlot(), true);
      }
      let removed: Bool = items.RemoveItem(player, id, 1);
      ApexGrappleLog("a lent launcher kept by the save, taken back: from the inventory " + ToString(removed) + ", still owned " + ToString(items.HasItem(player, id)));
    }
  }
}

public func ApexGrappleLauncherIs(owner: ref<GameObject>, id: ItemID) -> Bool {
  if ItemID.GetTDBID(id) != ApexGrappleLauncherRecord() || !IsDefined(owner) {
    return false;
  }
  let system: ref<ApexGrappleSystem> = ApexGrappleSystemOf(owner.GetGame());
  return IsDefined(system) && ApexGrappleLauncherOut(system) && system.loan.id == id;
}

@wrapMethod(PlayerPuppet)
protected cb func OnItemAddedToInventory(evt: ref<ItemAddedEvent>) -> Bool {
  if ApexGrappleLauncherIs(this, evt.itemID) {
    evt.flaggedAsSilent = true;
  }
  return wrappedMethod(evt);
}
