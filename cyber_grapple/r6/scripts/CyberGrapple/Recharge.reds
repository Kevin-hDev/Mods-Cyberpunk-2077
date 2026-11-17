// The grapple's charges (D24, Kevin, 16 November 2026): each shot spends one, and they come back one at a time, so
// that there are "des temps morts ou le joueur ne peut pas l'utiliser". How many a tier holds and how long one takes
// are in Tiers.reds.
// The count is kept here, in the grapple's system, and not in the game's own launcher charges: those count the perks
// that add a launcher charge, which this version leaves out (Kevin: "Les competences , pas pour la premiere
// version"), and changing them means laying a stat on V, which the game does not take back from a launcher-type item
// (Implant.reds). Nothing is saved: a load gives the charges back full.
// Kept as the seconds of recharge banked, as the game keeps its own charges: the whole part of seconds / time is the
// charges left, the rest is how far the next one is. Brought up to date when asked, never by a clock of its own.

@addField(CyberGrappleSystem)
public let chargeSeconds: Float;

@addField(CyberGrappleSystem)
public let chargeAt: Float;

@addField(CyberGrappleSystem)
public let chargeCounted: Bool;

// What the game's slots were last told (SlotCharges.reds): the worn tier with the charges left
// (CyberGrappleSlotKey, -1 for nothing yet), whether full, and when.
@addField(CyberGrappleSystem)
public let chargeShown: Int32;

@addField(CyberGrappleSystem)
public let chargeShownFull: Bool;

@addField(CyberGrappleSystem)
public let chargeShownAt: Float;

// The charges the worn implant holds, kept at each copy of the settings (SettingsCopy.reds); 0 without an implant of
// ours.
public func CyberGrappleMostCharges(system: ref<CyberGrappleSystem>) -> Int32 {
  return system.wornCharges;
}

// The seconds banked now, between 0 and most * time. A tier that holds more charges adds none by itself: an upgrade
// in the middle of a fight is no refill. Without an implant of ours nothing is read or written: the time spent
// without one is credited at the next, up to its full.
public func CyberGrappleChargeSeconds(system: ref<CyberGrappleSystem>, now: Float) -> Float {
  let full: Float = Cast<Float>(CyberGrappleMostCharges(system)) * CyberGrappleRechargeTime();
  if full <= 0.0 {
    return 0.0;
  }
  if !system.chargeCounted {
    system.chargeCounted = true;
    system.chargeSeconds = full;
    system.chargeAt = now;
    return full;
  }
  if now > system.chargeAt {
    system.chargeSeconds = MaxF(system.chargeSeconds, 0.0) + (now - system.chargeAt);
  }
  // A tier that holds fewer keeps no more than it holds.
  system.chargeSeconds = MinF(system.chargeSeconds, full);
  system.chargeAt = now;
  return system.chargeSeconds;
}

public func CyberGrappleChargesIn(seconds: Float) -> Int32 {
  // The margin: twelve seconds added frame by frame do not sum to exactly twelve.
  return FloorF(seconds / CyberGrappleRechargeTime() + 0.001);
}

public func CyberGrappleChargesLeft(system: ref<CyberGrappleSystem>, now: Float) -> Int32 {
  return CyberGrappleChargesIn(CyberGrappleChargeSeconds(system, now));
}

// A shot was fired (Shot.reds, by a patch of fabrique/grapple_spec.py): one charge spent, whatever the shot does next.
public func CyberGrappleChargeSpent(system: ref<CyberGrappleSystem>, now: Float) -> Void {
  let seconds: Float = CyberGrappleChargeSeconds(system, now);
  system.chargeSeconds = MaxF(seconds - CyberGrappleRechargeTime(), 0.0);
  let left: Int32 = CyberGrappleChargesIn(system.chargeSeconds);
  let next: Float = Cast<Float>(left + 1) * CyberGrappleRechargeTime() - system.chargeSeconds;
  CyberGrappleLog("charge spent: " + ToString(left) + " left of " + ToString(CyberGrappleMostCharges(system)) + ", the next back in " + FloatToStringPrec(next, 1) + " s");
}
