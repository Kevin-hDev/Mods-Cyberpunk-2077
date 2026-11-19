// Menu texts in French, for the game's fr-fr language. Same keys as ExecutionLinesEnglish in Texts.reds, which says why
// a phrase's label stays in English.

@if(ModuleExists("Codeware.Localization"))
import Codeware.Localization.*

@if(ModuleExists("Codeware.Localization"))
public class ExecutionLinesFrench extends ModLocalizationPackage {
  protected func DefineTexts() {
    this.Text("ExecutionLines-Enabled", "Activé");
    this.Text("ExecutionLines-Enabled-Description", "V dit une réplique quand V exécute une personne : une mise à mort ou un assommage fait par une exécution, jamais par un tir. Demande Audioware, qui joue les répliques. Éteint : ce mod ne dit plus rien.");
    this.Text("ExecutionLines-Voice", "Voix");
    this.Text("ExecutionLines-Voice-Description", "La voix qui dit les répliques. Automatique : celle de votre V. Féminine ou Masculine : toujours cette voix, et c'est la section V femme ou V homme ci-dessous qui compte.");
    this.Text("ExecutionLines-Voice-Auto", "Automatique");
    this.Text("ExecutionLines-Voice-Female", "Féminine");
    this.Text("ExecutionLines-Voice-Male", "Masculine");
    this.Text("ExecutionLines-Chance", "Fréquence des répliques d'exécution");
    this.Text("ExecutionLines-Chance-Description", "À quelle fréquence V dit une réplique lors d'une exécution : 50, c'est exactement cinq fois sur dix, dans un ordre au hasard. 100 : à chaque fois. Mises à mort et assommages comptent dans les mêmes dix.");
    this.Text("ExecutionLines-Style", "Style des répliques d'exécution");
    this.Text("ExecutionLines-Style-Description", "La façon dont V dit les répliques, toutes. Normal : à voix haute. Chuchoté : V les chuchote. Normal + chuchoté : les deux, mêlées au hasard. Une section Personnalisé ne peut que restreindre : une réplique n'est dite que si les deux la permettent.");
    this.Text("ExecutionLines-Style-Normal", "Normal");
    this.Text("ExecutionLines-Style-Whisper", "Chuchoté");
    this.Text("ExecutionLines-Style-Both", "Normal + chuchoté");
    this.Text("ExecutionLines-Choice-Both", "Normal + chuchoté");
    this.Text("ExecutionLines-Choice-Normal", "Normal");
    this.Text("ExecutionLines-Choice-Whisper", "Chuchoté");
    this.Text("ExecutionLines-Choice-None", "Aucune");
    this.Text("ExecutionLines-NoAudioware", "Execution Lines : Audioware n'est pas installé, les répliques de V ne peuvent pas être entendues. Installez Audioware pour les entendre.");

    this.Text("ExecutionLines-Male", "V homme");
    this.Text("ExecutionLines-CustomMale", "Personnalisé");
    this.Text("ExecutionLines-CustomMale-Description", "Choisissez, réplique par réplique, comment V homme dit chacune : à voix haute, en chuchotant, les deux ou jamais. Une réplique n'est dite que si ce choix et le style des répliques d'exécution la permettent tous les deux. Éteint : seul le style des répliques d'exécution compte, et les choix ci-dessous sont ignorés, même changés avant. Ces choix comptent quand la voix masculine parle.");
    this.Text("ExecutionLines-MaleChooses", "A man chooses…");
    this.Text("ExecutionLines-MaleChooses-Description", "V dit : « A man chooses, a slave obeys. » (Un homme choisit, un esclave obéit.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
    this.Text("ExecutionLines-MaleInsanity", "Did I ever tell you…");
    this.Text("ExecutionLines-MaleInsanity-Description", "V dit : « Did I ever tell you what the definition of insanity is? » (Je t'ai déjà dit ce qu'est la définition de la folie ?) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
    this.Text("ExecutionLines-MaleImpunity", "Executed with impunity");
    this.Text("ExecutionLines-MaleImpunity-Description", "V dit : « Executed with impunity! » (Exécuté avec impunité !) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
    this.Text("ExecutionLines-MaleKillOrBeKilled", "In this world…");
    this.Text("ExecutionLines-MaleKillOrBeKilled-Description", "V dit : « In this world, it's kill or be killed. » (Dans ce monde, c'est tuer ou être tué.) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
    this.Text("ExecutionLines-MaleOneOfUs", "One of us must die");
    this.Text("ExecutionLines-MaleOneOfUs-Description", "V dit : « One of us must die. » (L'un de nous doit mourir.) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
    this.Text("ExecutionLines-MaleDeath", "Your death will be swift");
    this.Text("ExecutionLines-MaleDeath-Description", "V dit : « Your death will be swift. » (Ta mort sera rapide.) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
    this.Text("ExecutionLines-MaleSoul", "Your soul is weak");
    this.Text("ExecutionLines-MaleSoul-Description", "V dit : « Your soul is weak. » (Ton âme est faible.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");

    this.Text("ExecutionLines-Female", "V femme");
    this.Text("ExecutionLines-CustomFemale", "Personnalisé");
    this.Text("ExecutionLines-CustomFemale-Description", "Choisissez, réplique par réplique, comment V femme dit chacune : à voix haute, en chuchotant, les deux ou jamais. Une réplique n'est dite que si ce choix et le style des répliques d'exécution la permettent tous les deux. Éteint : seul le style des répliques d'exécution compte, et les choix ci-dessous sont ignorés, même changés avant. Ces choix comptent quand la voix féminine parle.");
    this.Text("ExecutionLines-FemaleInsanity", "Did I ever tell you…");
    this.Text("ExecutionLines-FemaleInsanity-Description", "V dit : « Did I ever tell you what the definition of insanity is? » (Je t'ai déjà dit ce qu'est la définition de la folie ?) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleImpunity", "Executed with impunity");
    this.Text("ExecutionLines-FemaleImpunity-Description", "V dit : « Executed with impunity! » (Exécuté avec impunité !) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleKillOrBeKilled", "In this world…");
    this.Text("ExecutionLines-FemaleKillOrBeKilled-Description", "V dit : « In this world, it's kill or be killed. » (Dans ce monde, c'est tuer ou être tué.) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleRespect", "Nothing is more badass…");
    this.Text("ExecutionLines-FemaleRespect-Description", "V dit : « Nothing is more badass than treating a woman with respect. » (Rien n'est plus badass que de traiter une femme avec respect.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleOneOfUs", "One of us must die");
    this.Text("ExecutionLines-FemaleOneOfUs-Description", "V dit : « One of us must die. » (L'un de nous doit mourir.) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleDeath", "Your death will be swift");
    this.Text("ExecutionLines-FemaleDeath-Description", "V dit : « Your death will be swift. » (Ta mort sera rapide.) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleSoul", "Your soul is weak");
    this.Text("ExecutionLines-FemaleSoul-Description", "V dit : « Your soul is weak. » (Ton âme est faible.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques d'exécution doit aussi la permettre.");
  }
}
