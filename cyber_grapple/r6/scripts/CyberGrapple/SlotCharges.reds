// The grapple's charges in the game's own gadget slot, bottom left of the screen. Kevin, 16 November 2026: "on ne
// doit rien ajouter au milieu de l'ecran […] y'a deja un indicateur en jeu pour les couldown des implants en bas a
// gauche , il suffit juste de le reprendre avec ces animations", blue while a charge is left, red at zero.
// The game draws there the item on the gadget key, and for a launcher-type item its charges and their recharge
// (dpadHintItem.script, ChargedHotkeyItemGadgetController). Our implant is such an item: the game puts it on that key
// when it is fitted, as it does its own launcher, and the slot is the game's, animations included. Only its numbers
// are ours, for our implant alone: the charges left, how many it holds, how long one takes (Recharge.reds).
// The game draws its slot again when its own launcher charges change, which never happens for our implant: the slots
// make themselves known here, and the grapple's frame tells them to draw. Kevin's first trial (16 November 2026,
// 22:10) showed a slot stuck on the game's 3 charges: a slot made itself known only once the worn tier was read,
// which comes after the game has drawn it. Now a slot is known as soon as the game makes it, and it is drawn again
// when the worn tier is read or changes.
// The key fires the grapple, never the launcher (D31, GadgetQuickslot.reds): the game is kept from the launcher's shot
// there, and behind that the shot is refused before it starts (LauncherCharges.reds); NoProjectile.reds stays as the
// net under both. The number the game shows for our implant is told there too.
// The key's hint shows only while the key fires the grapple, so the slot never shows a key that does nothing.
// Until D24 the implant was kept off that key (GadgetKey.reds, removed): the slot then showed the grenades.

@addField(ChargedHotkeyItemGadgetController)
private let cyberGrappleHintHidden: Bool;

// Whether the slot's item is our implant, read from its record once an item (CyberGrappleShowsImplant).
@addField(ChargedHotkeyItemGadgetController)
private let cyberGrappleCheckedItem: ItemID;

@addField(ChargedHotkeyItemGadgetController)
private let cyberGrappleCheckedOurs: Bool;

// The gadget slots the game has made, told to draw again while a charge comes back (two are known: on foot, and a
// vehicle's, which never shows our implant).
@addField(CyberGrappleSystem)
public let chargeSlots: array<wref<ChargedHotkeyItemGadgetController>>;

@addField(CyberGrappleSystem)
public let slotLines: Int32;

public func CyberGrappleMostSlots() -> Int32 {
  return 6;
}

// While a charge comes back the slot's bar is drawn again this often, in seconds.
public func CyberGrappleSlotEvery() -> Float {
  return 0.03;
}

// Lines a load on what the slots were told to draw: one a change of the charges left.
public func CyberGrappleSlotMostLines() -> Int32 {
  return 120;
}

// What the slots must show: the worn tier and the charges left. Never what a new slot has been told (-1).
public func CyberGrappleSlotKey(tier: Int32, left: Int32) -> Int32 {
  return tier * 100 + left;
}

public func CyberGrappleSlotSeen(system: ref<CyberGrappleSystem>, slot: ref<ChargedHotkeyItemGadgetController>) -> Void {
  let kept: array<wref<ChargedHotkeyItemGadgetController>>;
  let i: Int32 = 0;
  while i < ArraySize(system.chargeSlots) {
    let known: ref<ChargedHotkeyItemGadgetController> = system.chargeSlots[i];
    if known == slot {
      return;
    }
    if IsDefined(known) {
      ArrayPush(kept, known);
    }
    i += 1;
  }
  if ArraySize(kept) >= CyberGrappleMostSlots() {
    return;
  }
  ArrayPush(kept, slot);
  system.chargeSlots = kept;
  // A new slot has been told nothing yet.
  system.chargeShown = -1;
  CyberGrappleLog("gadget slot known: " + ToString(ArraySize(kept)) + " now, worn tier " + ToString(system.wornTier));
}

// Each frame of the grapple (Frame.reds, by a patch of fabrique/grapple_spec.py): tells the slots to draw when the
// charges left or the worn tier change, and while a charge comes back. Nothing while the charges are full and shown
// full.
public func CyberGrappleSlotFrame(system: ref<CyberGrappleSystem>, now: Float) -> Void {
  if system.wornTier <= 0 || ArraySize(system.chargeSlots) == 0 {
    return;
  }
  let left: Int32 = CyberGrappleChargesLeft(system, now);
  let most: Int32 = CyberGrappleMostCharges(system);
  let key: Int32 = CyberGrappleSlotKey(system.wornTier, left);
  let counted: Bool = key != system.chargeShown;
  let full: Bool = left >= most;
  if !counted && (full && system.chargeShownFull || !full && now - system.chargeShownAt < CyberGrappleSlotEvery()) {
    return;
  }
  system.chargeShown = key;
  system.chargeShownFull = full;
  system.chargeShownAt = now;
  let showing: Int32 = 0;
  let i: Int32 = 0;
  while i < ArraySize(system.chargeSlots) {
    let slot: ref<ChargedHotkeyItemGadgetController> = system.chargeSlots[i];
    if IsDefined(slot) && slot.CyberGrappleDraw(counted) {
      showing += 1;
    }
    i += 1;
  }
  if counted {
    system.slotLines = CyberGrappleLogUpTo(system.slotLines, CyberGrappleSlotMostLines(), "gadget slot", "gadget slot told: " + ToString(left) + " of " + ToString(most) + " charges, " + FloatToStringPrec(system.chargeSeconds, 1) + " s banked, " + ToString(showing) + " of " + ToString(ArraySize(system.chargeSlots)) + " slots show the implant");
  }
}

@wrapMethod(ChargedHotkeyItemGadgetController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  let result: Bool = wrappedMethod(playerPuppet);
  if IsDefined(playerPuppet) {
    let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(playerPuppet.GetGame());
    if IsDefined(system) {
      CyberGrappleSlotSeen(system, this);
    }
  }
  return result;
}

@addMethod(ChargedHotkeyItemGadgetController)
public func CyberGrappleShowsImplant() -> Bool {
  let item: ItemID = this.m_currentItem.ID;
  if item != this.cyberGrappleCheckedItem {
    this.cyberGrappleCheckedItem = item;
    this.cyberGrappleCheckedOurs = CyberGrappleIsImplant(item);
  }
  return this.cyberGrappleCheckedOurs;
}

// Told by the grapple's frame. counted: the charges left changed, and the slot's number with them: the game reads
// the item again and plays its own animation of the number. False when the slot shows something else.
@addMethod(ChargedHotkeyItemGadgetController)
public func CyberGrappleDraw(counted: Bool) -> Bool {
  if !this.CyberGrappleShowsImplant() {
    return false;
  }
  if counted {
    this.UpdateCurrentItem();
  }
  // The values are replaced by ours in UpdateChargeValue, below.
  this.UpdateChargeValue(0.0, 0.0, true);
  return true;
}

// The one place a slot takes its charge from, called by the game with its own launcher charges: for our implant,
// ours are given instead, in the game's own terms (a percentage of the seconds banked, and the seconds a percent is).
// The game calls it as it makes a slot and at each change of its item: the slot makes itself known here too.
@wrapMethod(ChargedHotkeyItemBaseController)
public final func UpdateChargeValue(newValue: Float, percToPoints: Float, valueChanged: Bool) -> Void {
  let slot: ref<ChargedHotkeyItemGadgetController> = this as ChargedHotkeyItemGadgetController;
  if IsDefined(slot) {
    let game: GameInstance = GetGameInstance();
    let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(game);
    if IsDefined(system) {
      CyberGrappleSlotSeen(system, slot);
      let full: Float = Cast<Float>(CyberGrappleMostCharges(system)) * CyberGrappleRechargeTime();
      if full > 0.0 && slot.CyberGrappleShowsImplant() {
        let seconds: Float = CyberGrappleChargeSeconds(system, CyberGrappleTime(game));
        // Exactly 100 when full: the game tests it so.
        wrappedMethod(seconds >= full ? 100.0 : 100.0 * seconds / full, full / 100.0, valueChanged);
        return;
      }
    }
  }
  wrappedMethod(newValue, percToPoints, valueChanged);
}

// The family name a slot reads on its item (dpadHintItem.script:1050-1052) picks the charge pool it listens to, the
// most charges, the recharge time, the charge threshold and the key hint's hold indicator. Our implant's own family
// (implants.yaml) is one the slot does not know: its default branches would listen to the grenades' pool and drop the
// hold indicator (:1318-1324, :1353-1375). The slot reads for our implant the launcher's family it read up to 1.0.0, so
// it draws as then; any other item, and the other slots of this base (healing, cyberware, charge indicators), read
// their own.
@wrapMethod(ChargedHotkeyItemBaseController)
protected final func GetItemType(itemID: ItemID, defaultValue: CName) -> CName {
  let slot: ref<ChargedHotkeyItemGadgetController> = this as ChargedHotkeyItemGadgetController;
  if IsDefined(slot) && itemID == this.m_currentItem.ID && slot.CyberGrappleShowsImplant() {
    return slot.CyberGrappleLauncherFamily();
  }
  return wrappedMethod(itemID, defaultValue);
}

@addMethod(ChargedHotkeyItemGadgetController)
public func CyberGrappleLauncherFamily() -> CName {
  return this.c_projectileLauncherKey;
}

@wrapMethod(ChargedHotkeyItemGadgetController)
protected func GetRechargeDuration() -> Float {
  if this.CyberGrappleShowsImplant() {
    return CyberGrappleRechargeTime();
  }
  return wrappedMethod();
}

@wrapMethod(ChargedHotkeyItemGadgetController)
protected func GetMaxCharges() -> Float {
  if this.CyberGrappleShowsImplant() {
    let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(GetGameInstance());
    if IsDefined(system) && CyberGrappleMostCharges(system) > 0 {
      return Cast<Float>(CyberGrappleMostCharges(system));
    }
  }
  return wrappedMethod();
}

// The key's hint under the slot, for our implant: shown only while the gadget key fires the grapple
// (GadgetQuickslot.reds). Shown again only if hidden here, and then as the game shows it (dpadHintItem.script:963-965).
@addMethod(ChargedHotkeyItemGadgetController)
public func CyberGrappleHint() -> Void {
  let hide: Bool = false;
  if this.CyberGrappleShowsImplant() {
    let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(GetGameInstance());
    hide = !IsDefined(system) || !CyberGrappleGadgetKeyGrapples(system);
  }
  if hide {
    this.m_buttonHintController.SetVisible(false);
    this.cyberGrappleHintHidden = true;
    return;
  }
  if this.cyberGrappleHintHidden {
    this.cyberGrappleHintHidden = false;
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    this.m_buttonHintController.SetVisible(!IsDefined(player) || !StatusEffectSystem.ObjectHasStatusEffect(player, t"GameplayRestriction.BlockAllInputHintKey"));
  }
}

@wrapMethod(ChargedHotkeyItemGadgetController)
protected final func UpdateButtonHint() -> Void {
  wrappedMethod();
  this.CyberGrappleHint();
}

// The slot's making reads its item, through UpdateButtonHint, then shows the hint itself (dpadHintItem.script:958, then
// 965): the hint is set again once the making is over (1189-1194).
@wrapMethod(ChargedHotkeyItemGadgetController)
protected cb func OnInitialize() -> Bool {
  let result: Bool = wrappedMethod();
  this.CyberGrappleHint();
  return result;
}

// The game shows the hint again itself when its restriction on hints ends (dpadHintItem.script:167-171), past
// UpdateButtonHint: a hint hidden for our implant is hidden again at once.
@wrapMethod(GenericHotkeyController)
public final func OnRestrictionUpdate(statusEffect: wref<StatusEffect_Record>, effectApplied: Bool) -> Void {
  wrappedMethod(statusEffect, effectApplied);
  let slot: ref<ChargedHotkeyItemGadgetController> = this as ChargedHotkeyItemGadgetController;
  if IsDefined(slot) {
    slot.CyberGrappleHint();
  }
}

// After each new copy of the settings (SettingsCopy.reds): the hint follows Own key and the switch at once.
public func CyberGrappleSlotHints(system: ref<CyberGrappleSystem>) -> Void {
  let i: Int32 = 0;
  while i < ArraySize(system.chargeSlots) {
    let slot: ref<ChargedHotkeyItemGadgetController> = system.chargeSlots[i];
    if IsDefined(slot) {
      slot.CyberGrappleHint();
    }
    i += 1;
  }
}
