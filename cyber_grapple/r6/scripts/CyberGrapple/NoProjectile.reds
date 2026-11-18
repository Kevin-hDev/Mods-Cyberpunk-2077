// The net under the gadget key's locks (lock 3 of "never a projectile", docs/cyber-grapple/conception.md): should our
// implant reach the left hand's shot by a way GadgetQuickslot.reds and LauncherCharges.reds do not cover, no projectile
// leaves. Our records carry the game's explosive round, put back for the arm's look (implants.yaml): a shot that got
// this far would fire it, so the shot is stopped before it leaves. It also covers the copy of the implant lent to the
// left hand during a grapple (Launcher.reds). Each use is written to the log, at most 20 a load: it means a way to the
// gadget key was missed.

@addField(CyberGrappleSystem)
public let netUses: Int32;

@wrapMethod(LeftHandCyberwareTransition)
public final func DetachProjectile(scriptInterface: ref<StateGameScriptInterface>, opt angleOffset: Float) -> Void {
  let held: ref<ItemObject> = scriptInterface.GetTransactionSystem().GetItemInSlot(scriptInterface.executionOwner, t"AttachmentSlots.WeaponLeft");
  if IsDefined(held) && CyberGrappleIsImplant(held.GetItemID()) {
    let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(scriptInterface.executionOwner.GetGame());
    if IsDefined(system) {
      system.netUses = CyberGrappleLogUpTo(system.netUses, 20, "projectile net", "net used: a projectile shot stopped, the left hand held " + TDBID.ToStringDEBUG(ItemID.GetTDBID(held.GetItemID())));
    }
    return;
  }
  wrappedMethod(scriptInterface, angleOffset);
}
