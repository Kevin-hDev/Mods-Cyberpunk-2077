// How often V speaks (Voice.reds), as a bag of ten occasions, the same draw as Cyber Grapple's: at 50 %, exactly five
// lines in each ten occasions, in a random order. A draw at each occasion left silent six executions in seven at 50 %
// in Kevin's trial of 18 November 2026, who took the setting for broken ("oui on va partir la dessus"). One bag per
// kind (a pull, an execution) and per profile since the audit of 19 November 2026: a single bag of each kind, filled
// again whenever the chance it was filled for changes, went back to a draw at each occasion for a player moving between
// profiles of different chances. fabrique/test_voice_logic.py runs this draw.

public class ApexGrappleVoiceBag {
  public let left: Int32;
  public let says: Int32;
  public let filledFor: Float;
}

public func ApexGrappleVoiceBagSize() -> Int32 {
  return 10;
}

// The lines a full bag holds for this setting, in percent (30 to 100 in the menu).
public func ApexGrappleVoiceBagSays(chance: Float) -> Int32 {
  return Clamp(RoundF(chance * Cast<Float>(ApexGrappleVoiceBagSize()) / 100.0), 0, ApexGrappleVoiceBagSize());
}

// The profile whose grapple brought the person, set with its settings at the shot (Shot.reds); profile 1 before any
// shot, as for its settings (ApexGrappleGrappleSettings in Profiles.reds).
public func ApexGrappleVoiceBagProfile(system: ref<ApexGrappleSystem>) -> Int32 {
  if system.profile < 1 || system.profile > ApexGrappleProfileCount() {
    return 1;
  }
  return system.profile;
}

// The bag of this kind for that profile, made at its first use: two at most per profile.
public func ApexGrappleVoiceBagOf(system: ref<ApexGrappleSystem>, pull: Bool) -> ref<ApexGrappleVoiceBag> {
  let index: Int32 = 2 * (ApexGrappleVoiceBagProfile(system) - 1);
  if !pull {
    index = index + 1;
  }
  while ArraySize(system.voiceBags) <= index {
    ArrayPush(system.voiceBags, new ApexGrappleVoiceBag());
  }
  return system.voiceBags[index];
}

// Whether V speaks at this occasion: one of the occasions left, the lines left among them. The bag fills again once
// empty, or when its profile's setting moved since it was filled, the first occasion after a load included. Called only
// for an occasion where the line could be said: the voice lines on, Audioware there, a kill or a knock-out of ours.
public func ApexGrappleVoiceBagDraw(bag: ref<ApexGrappleVoiceBag>, chance: Float) -> Bool {
  if bag.left <= 0 || bag.filledFor != chance {
    bag.left = ApexGrappleVoiceBagSize();
    bag.says = ApexGrappleVoiceBagSays(chance);
    bag.filledFor = chance;
  }
  let speaks: Bool = RandRange(0, bag.left) < bag.says;
  bag.left = bag.left - 1;
  if speaks {
    bag.says = bag.says - 1;
  }
  return speaks;
}

// Where the bag stands, for the log of a line left out.
public func ApexGrappleVoiceBagText(system: ref<ApexGrappleSystem>, bag: ref<ApexGrappleVoiceBag>) -> String {
  return "silent this time at " + ToString(bag.filledFor) + " % of profile " + ToString(ApexGrappleVoiceBagProfile(system)) + ", " + ToString(bag.says) + " lines left in the " + ToString(bag.left) + " occasions left of this ten";
}
