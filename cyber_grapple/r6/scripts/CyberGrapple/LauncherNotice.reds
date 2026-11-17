// Made by fabrique/grapple.py from Apex Grapple's LauncherNotice.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// The game writes "Removed: <item>" in its activity log for any item taken from V (player.script:3344), unless the
// removal event's item data holds SkipActivityLog. On our lent launcher that tag never holds: given at the loan, it was
// gone at the taking back; set on the event's own data, it read back false at once (Kevin's captures and the log,
// 9 November 2026). The game itself only sets it on preview data, never on an item in an inventory. So the line the
// game builds for our launcher is taken out of the activity log's new entries before they are shown: its text is made
// here with the game's own calls, and it is looked for only for a short while after our taking back.

public func CyberGrappleLauncherNoticeWindow() -> Float {
  return 2.0;
}

// Two takings back before the log shows anything is the most seen; the bound keeps a lost line from hiding later ones.
public func CyberGrappleLauncherNoticeMax() -> Int32 {
  return 4;
}

public func CyberGrappleLauncherLoanOf(owner: ref<GameObject>) -> ref<CyberGrappleLauncherLoan> {
  if !IsDefined(owner) {
    return null;
  }
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(owner.GetGame());
  if !IsDefined(system) {
    return null;
  }
  return system.loan;
}

@wrapMethod(PlayerPuppet)
protected cb func OnItemBeingRemovedFromInventory(evt: ref<ItemBeingRemovedEvent>) -> Bool {
  // Only a projectile launcher is ever taken back (Launcher.reds): any other item, dozens at once at a sale, leaves
  // before the system is looked for (audit of 10 November 2026, A12).
  if !CyberGrappleIsLauncherRecord(ItemID.GetTDBID(evt.itemID)) {
    return wrappedMethod(evt);
  }
  let loan: ref<CyberGrappleLauncherLoan> = CyberGrappleLauncherLoanOf(this);
  if IsDefined(loan) && ItemID.IsValid(loan.takenBack) && loan.takenBack == evt.itemID && IsDefined(evt.itemData) {
    let none: ItemID;
    loan.takenBack = none;
    let record: ref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(evt.itemID));
    loan.noticeText = GetLocalizedText("LocKey#26163") + ": " + UIItemsHelper.GetItemName(record, evt.itemData);
    loan.noticeAt = CyberGrappleTime(this.GetGame());
    loan.noticeCount = Min(loan.noticeCount + 1, CyberGrappleLauncherNoticeMax());
  }
  return wrappedMethod(evt);
}

@wrapMethod(activityLogGameController)
protected cb func OnNewEntries(value: Variant) -> Bool {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let loan: ref<CyberGrappleLauncherLoan> = CyberGrappleLauncherLoanOf(player);
  if !IsDefined(loan) || loan.noticeCount == 0 {
    return wrappedMethod(value);
  }
  let after: Float = CyberGrappleTime(player.GetGame()) - loan.noticeAt;
  let entries: array<String> = FromVariant<array<String>>(value);
  if after > CyberGrappleLauncherNoticeWindow() {
    CyberGrappleLog("launcher's removal line not seen in the activity log within " + ToString(CyberGrappleLauncherNoticeWindow()) + " s, " + ToString(loan.noticeCount) + " left; looked for \"" + loan.noticeText + "\"");
    loan.noticeCount = 0;
    return wrappedMethod(value);
  }
  let kept: array<String>;
  let taken: Int32 = 0;
  for entry in entries {
    if loan.noticeCount > 0 && Equals(entry, loan.noticeText) {
      loan.noticeCount -= 1;
      taken += 1;
    } else {
      ArrayPush(kept, entry);
    }
  }
  if taken == 0 {
    CyberGrappleLog("activity log entries without the launcher's removal line, " + ToString(after) + " s after the taking back: " + ToString(ArraySize(entries)) + " entries, looked for \"" + loan.noticeText + "\"");
    return wrappedMethod(value);
  }
  CyberGrappleLog("launcher's removal line taken out of the activity log " + ToString(after) + " s after the taking back: \"" + loan.noticeText + "\", " + ToString(ArraySize(kept)) + " other entries shown");
  return wrappedMethod(ToVariant(kept));
}
