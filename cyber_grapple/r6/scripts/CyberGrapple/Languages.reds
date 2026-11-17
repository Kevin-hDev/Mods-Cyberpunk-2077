// The texts of every language of the game that is none of English, French and Chinese, whose packages each provider
// returns itself: one package a language, holding every key shown, so that whatever order Codeware fills the
// providers in, each of them gives the language's own texts. A language of the game not listed gets English.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public func CyberGrappleTextsIn(language: CName) -> ref<ModLocalizationPackage> {
  if Equals(language, n"de-de") {
    return new CyberGrappleGerman();
  }
  if Equals(language, n"ru-ru") {
    return new CyberGrappleRussian();
  }
  if Equals(language, n"es-es") {
    return new CyberGrappleSpanish();
  }
  if Equals(language, n"es-mx") {
    return new CyberGrappleSpanishLatin();
  }
  if Equals(language, n"it-it") {
    return new CyberGrappleItalian();
  }
  if Equals(language, n"pt-br") {
    return new CyberGrapplePortuguese();
  }
  if Equals(language, n"th-th") {
    return new CyberGrappleThai();
  }
  if Equals(language, n"jp-jp") {
    return new CyberGrappleJapanese();
  }
  return null;
}
