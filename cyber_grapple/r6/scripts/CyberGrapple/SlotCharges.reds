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
// there, and here, behind that, the shot is refused before it starts; NoProjectile.reds stays as the net under both.
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

// The number on the slot, in the inventory and in the quick wheel: the game shows V's launcher charges on any
// launcher-type item. V wears one arm implant: with ours worn, there is no launcher those charges could be for. Judged
// on the arm worn now, as the gadget key below: the tier kept is read from the grapple's frame, twice a second of the
// game's clock at most, and a menu may list an implant fitted a moment ago before that.
@wrapMethod(PlayerPuppet)
public final func GetProjectileLauncherCharges() -> Int32 {
  let worn: ItemID = CyberGrappleWornArm(this);
  if CyberGrappleIsImplant(worn) {
    let game: GameInstance = this.GetGame();
    let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(game);
    if IsDefined(system) {
      CyberGrappleKeepTierOf(system, worn);
      return CyberGrappleChargesLeft(system, CyberGrappleTime(game));
    }
  }
  return wrappedMethod();
}

// The launcher's own question before its shot, in four of the five places that read the gadget key
// (upperBodyTransitions.script:652, :836, :1033, :1756): no for our implant, and the game starts nothing. With our
// implant on the key the game no longer gets this far (GadgetQuickslot.reds); kept behind that answer, in lock 2 of
// "never a projectile" (docs/cyber-grapple/conception.md).
@wrapMethod(LeftHandCyberwareHelper)
public final static func ProjectileLauncherHasCharge(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if CyberGrappleIsImplant(CyberGrappleWornArm(scriptInterface.executionOwner)) {
    return false;
  }
  return wrappedMethod(scriptInterface);
}
