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
    this.Text("ExecutionLines-Voice-Description", "La voix qui dit les répliques. Automatique : celle de votre V. Féminine ou Masculine : toujours cette voix, et ce sont les sections de cette voix ci-dessous (répliques d'exécution et de saisie) qui comptent.");
    this.Text("ExecutionLines-Voice-Auto", "Automatique");
    this.Text("ExecutionLines-Voice-Female", "Féminine");
    this.Text("ExecutionLines-Voice-Male", "Masculine");
    this.Text("ExecutionLines-Chance", "Fréquence des répliques d'exécution");
    this.Text("ExecutionLines-Chance-Description", "À quelle fréquence V dit une réplique lors d'une exécution : 50, c'est exactement cinq fois sur dix, dans un ordre au hasard. 100 : à chaque fois. Mises à mort et assommages comptent dans les mêmes dix.");
    this.Text("ExecutionLines-GrabChance", "Fréquence des répliques de saisie");
    this.Text("ExecutionLines-GrabChance-Description", "V peut dire une réplique pendant que V tient un ennemi, quelques secondes après le début de la saisie : 50, c'est exactement cinq fois sur dix saisies qui durent assez, dans un ordre au hasard. 100 : à chaque fois. 0 : jamais. Après une réplique de saisie, V dit sa conclusion lors de l'exécution, quelle que soit la fréquence, une fois la réplique de saisie terminée et pourvu que l'exécution suive de peu.");
    this.Text("ExecutionLines-Style", "Style des répliques");
    this.Text("ExecutionLines-Style-Description", "La façon dont V dit les répliques, toutes : d'exécution, de saisie et leurs conclusions. Normal : à voix haute. Chuchoté : V les chuchote. Normal + chuchoté : les deux, mêlées au hasard. Une section Personnalisé ne peut que restreindre : une réplique n'est dite que si les deux la permettent. Une conclusion est dite de la même façon que sa réplique de saisie (à voix haute ou chuchotée).");
    this.Text("ExecutionLines-Style-Normal", "Normal");
    this.Text("ExecutionLines-Style-Whisper", "Chuchoté");
    this.Text("ExecutionLines-Style-Both", "Normal + chuchoté");
    this.Text("ExecutionLines-Choice-Both", "Normal + chuchoté");
    this.Text("ExecutionLines-Choice-Normal", "Normal");
    this.Text("ExecutionLines-Choice-Whisper", "Chuchoté");
    this.Text("ExecutionLines-Choice-None", "Aucune");
    this.Text("ExecutionLines-NoAudioware", "Execution Lines : Audioware n'est pas installé, les répliques de V ne peuvent pas être entendues. Installez Audioware pour les entendre.");

    this.Text("ExecutionLines-Male", "V homme, répliques d'exécution");
    this.Text("ExecutionLines-CustomMale", "Personnalisé");
    this.Text("ExecutionLines-CustomMale-Description", "Choisissez, réplique par réplique, comment V homme dit chacune : à voix haute, en chuchotant, les deux ou jamais. Une réplique n'est dite que si ce choix et le style des répliques la permettent tous les deux. Éteint : seul le style des répliques compte, et les choix ci-dessous sont ignorés, même changés avant. Ces choix comptent quand la voix masculine parle.");
    this.Text("ExecutionLines-MaleChooses", "A man chooses…");
    this.Text("ExecutionLines-MaleChooses-Description", "V dit : « A man chooses, a slave obeys. » (Un homme choisit, un esclave obéit.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleInsanity", "Did I ever tell you…");
    this.Text("ExecutionLines-MaleInsanity-Description", "V dit : « Did I ever tell you what the definition of insanity is? » (Je t'ai déjà dit ce qu'est la définition de la folie ?) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleImpunity", "Executed with impunity");
    this.Text("ExecutionLines-MaleImpunity-Description", "V dit : « Executed with impunity! » (Exécuté avec impunité !) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleExitLight", "Exit light, enter night");
    this.Text("ExecutionLines-MaleExitLight-Description", "V dit : « Exit light, enter night. » (La lumière s'en va, la nuit entre.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleKillOrBeKilled", "In this world…");
    this.Text("ExecutionLines-MaleKillOrBeKilled-Description", "V dit : « In this world, it's kill or be killed. » (Dans ce monde, c'est tuer ou être tué.) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleNotPersonal", "It's not personal…");
    this.Text("ExecutionLines-MaleNotPersonal-Description", "V dit : « It's not personal. You were just in my way. » (Rien de personnel. Tu étais juste sur mon chemin.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleOneOfUs", "One of us must die");
    this.Text("ExecutionLines-MaleOneOfUs-Description", "V dit : « One of us must die. » (L'un de nous doit mourir.) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleSweetDreams", "Sweet dreams");
    this.Text("ExecutionLines-MaleSweetDreams-Description", "V dit : « Sweet dreams. » (Fais de beaux rêves.) Dite seulement lors d'un assommage, jamais lors d'une mise à mort. Comme conclusion de « I'm not locked in here… », V la dit quel que soit votre choix ici. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais lors d'une exécution. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleDeath", "Your death will be swift");
    this.Text("ExecutionLines-MaleDeath-Description", "V dit : « Your death will be swift. » (Ta mort sera rapide.) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Comme conclusion de « I'm not locked in here… », V la dit quel que soit votre choix ici. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais lors d'une exécution. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleSoul", "Your soul is weak");
    this.Text("ExecutionLines-MaleSoul-Description", "V dit : « Your soul is weak. » (Ton âme est faible.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");

    this.Text("ExecutionLines-MaleGrab", "V homme, répliques de saisie");
    this.Text("ExecutionLines-CustomMaleGrab", "Personnalisé");
    this.Text("ExecutionLines-CustomMaleGrab-Description", "Choisissez, réplique par réplique, comment V homme dit chaque réplique de saisie : à voix haute, en chuchotant, les deux ou jamais. Une réplique n'est dite que si ce choix et le style des répliques la permettent tous les deux. Éteint : seul le style des répliques compte, et les choix ci-dessous sont ignorés, même changés avant. Ces choix comptent quand la voix masculine parle. Une conclusion n'a pas de choix à elle : elle est dite de la même façon que sa réplique de saisie (à voix haute ou chuchotée).");
    this.Text("ExecutionLines-MaleTicket", "A ticket to heaven…");
    this.Text("ExecutionLines-MaleTicket-Description", "Pendant une saisie, V dit : « A ticket to heaven, or a lullaby? » (Un ticket pour le paradis, ou une berceuse ?) Après une mise à mort : « See you up there. » (On se reverra là-haut.) Après un assommage : « Go to sleep! » (Va dormir !) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleLockedIn", "I'm not locked in here…");
    this.Text("ExecutionLines-MaleLockedIn-Description", "Pendant une saisie, V dit : « I'm not locked in here with you. You're locked in here with me. » (Je ne suis pas enfermé ici avec toi. C'est toi qui es enfermé ici avec moi.) Après une mise à mort : « Your death will be swift. » (Ta mort sera rapide.) Après un assommage : « Sweet dreams. » (Fais de beaux rêves.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleLetYouGo", "Say my name…");
    this.Text("ExecutionLines-MaleLetYouGo-Description", "Pendant une saisie, V dit : « Say my name and I'll let you go. » (Dis mon nom et je te libère.) Après une mise à mort : « You had your chance. » (Tu as eu ta chance.) Après un assommage : « You had your chance. » (Tu as eu ta chance.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleScars", "Wanna know how…");
    this.Text("ExecutionLines-MaleScars-Description", "Pendant une saisie, V dit : « Wanna know how I got these scars? » (Tu veux savoir d'où viennent ces cicatrices ?) Après une mise à mort : « Now you'll have your own. » (Maintenant, tu auras les tiennes.) Après un assommage : « Another time, maybe. » (Une autre fois, peut-être.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-MaleSerious", "Why so serious?");
    this.Text("ExecutionLines-MaleSerious-Description", "Pendant une saisie, V dit : « Why so serious? » (Pourquoi tant de sérieux ?) Après une mise à mort : « Let's put a smile on that face. » (Mettons un sourire sur ce visage.) Après un assommage : « Let's put a smile on that face. » (Mettons un sourire sur ce visage.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");

    this.Text("ExecutionLines-Female", "V femme, répliques d'exécution");
    this.Text("ExecutionLines-CustomFemale", "Personnalisé");
    this.Text("ExecutionLines-CustomFemale-Description", "Choisissez, réplique par réplique, comment V femme dit chacune : à voix haute, en chuchotant, les deux ou jamais. Une réplique n'est dite que si ce choix et le style des répliques la permettent tous les deux. Éteint : seul le style des répliques compte, et les choix ci-dessous sont ignorés, même changés avant. Ces choix comptent quand la voix féminine parle.");
    this.Text("ExecutionLines-FemaleInsanity", "Did I ever tell you…");
    this.Text("ExecutionLines-FemaleInsanity-Description", "V dit : « Did I ever tell you what the definition of insanity is? » (Je t'ai déjà dit ce qu'est la définition de la folie ?) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleImpunity", "Executed with impunity");
    this.Text("ExecutionLines-FemaleImpunity-Description", "V dit : « Executed with impunity! » (Exécuté avec impunité !) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleExitLight", "Exit light, enter night");
    this.Text("ExecutionLines-FemaleExitLight-Description", "V dit : « Exit light, enter night. » (La lumière s'en va, la nuit entre.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleKillOrBeKilled", "In this world…");
    this.Text("ExecutionLines-FemaleKillOrBeKilled-Description", "V dit : « In this world, it's kill or be killed. » (Dans ce monde, c'est tuer ou être tué.) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleNotPersonal", "It's not personal…");
    this.Text("ExecutionLines-FemaleNotPersonal-Description", "V dit : « It's not personal. You were just in my way. » (Rien de personnel. Tu étais juste sur mon chemin.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleRespect", "Nothing is more badass…");
    this.Text("ExecutionLines-FemaleRespect-Description", "V dit : « Nothing is more badass than treating a woman with respect. » (Rien n'est plus badass que de traiter une femme avec respect.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleOneOfUs", "One of us must die");
    this.Text("ExecutionLines-FemaleOneOfUs-Description", "V dit : « One of us must die. » (L'un de nous doit mourir.) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleSweetDreams", "Sweet dreams");
    this.Text("ExecutionLines-FemaleSweetDreams-Description", "V dit : « Sweet dreams. And don't forget to dream of me. » (Fais de beaux rêves. Et n'oublie pas de rêver de moi.) Dite seulement lors d'un assommage, jamais lors d'une mise à mort. Comme conclusion de « I'm not locked in here… », V la dit quel que soit votre choix ici. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais lors d'une exécution. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleDeath", "Your death will be swift");
    this.Text("ExecutionLines-FemaleDeath-Description", "V dit : « Your death will be swift. » (Ta mort sera rapide.) Dite seulement lors d'une mise à mort, jamais lors d'un assommage. Comme conclusion de « I'm not locked in here… », V la dit quel que soit votre choix ici. Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais lors d'une exécution. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleSoul", "Your soul is weak");
    this.Text("ExecutionLines-FemaleSoul-Description", "V dit : « Your soul is weak. » (Ton âme est faible.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");

    this.Text("ExecutionLines-FemaleGrab", "V femme, répliques de saisie");
    this.Text("ExecutionLines-CustomFemaleGrab", "Personnalisé");
    this.Text("ExecutionLines-CustomFemaleGrab-Description", "Choisissez, réplique par réplique, comment V femme dit chaque réplique de saisie : à voix haute, en chuchotant, les deux ou jamais. Une réplique n'est dite que si ce choix et le style des répliques la permettent tous les deux. Éteint : seul le style des répliques compte, et les choix ci-dessous sont ignorés, même changés avant. Ces choix comptent quand la voix féminine parle. Une conclusion n'a pas de choix à elle : elle est dite de la même façon que sa réplique de saisie (à voix haute ou chuchotée).");
    this.Text("ExecutionLines-FemaleTicket", "A ticket to heaven…");
    this.Text("ExecutionLines-FemaleTicket-Description", "Pendant une saisie, V dit : « A ticket to heaven, or a lullaby? » (Un ticket pour le paradis, ou une berceuse ?) Après une mise à mort : « See you up there. » (On se reverra là-haut.) Après un assommage : « Go to sleep! » (Va dormir !) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleLockedIn", "I'm not locked in here…");
    this.Text("ExecutionLines-FemaleLockedIn-Description", "Pendant une saisie, V dit : « I'm not locked in here with you. You're locked in here with me. » (Je ne suis pas enfermée ici avec toi. C'est toi qui es enfermé ici avec moi.) Après une mise à mort : « Your death will be swift. » (Ta mort sera rapide.) Après un assommage : « Sweet dreams. And don't forget to dream of me. » (Fais de beaux rêves. Et n'oublie pas de rêver de moi.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleLetYouGo", "Say my name…");
    this.Text("ExecutionLines-FemaleLetYouGo-Description", "Pendant une saisie, V dit : « Say my name and I'll let you go. » (Dis mon nom et je te libère.) Après une mise à mort : « You had your chance. » (Tu as eu ta chance.) Après un assommage : « You had your chance. » (Tu as eu ta chance.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleScars", "Wanna know how…");
    this.Text("ExecutionLines-FemaleScars-Description", "Pendant une saisie, V dit : « Wanna know how I got these scars? » (Tu veux savoir d'où viennent ces cicatrices ?) Après une mise à mort : « Now you'll have your own. » (Maintenant, tu auras les tiennes.) Après un assommage : « Another time, maybe. » (Une autre fois, peut-être.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
    this.Text("ExecutionLines-FemaleSerious", "Why so serious?");
    this.Text("ExecutionLines-FemaleSerious-Description", "Pendant une saisie, V dit : « Why so serious? » (Pourquoi tant de sérieux ?) Après une mise à mort : « Let's put a smile on that face. » (Mettons un sourire sur ce visage.) Après un assommage : « Let's put a smile on that face. » (Mettons un sourire sur ce visage.) Normal + chuchoté : à voix haute ou en chuchotant, au hasard. Normal : à voix haute seulement. Chuchoté : en chuchotant seulement. Aucune : V ne la dit jamais. Le style des répliques doit aussi la permettre.");
  }
}
