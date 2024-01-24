#let baseDir = "Runes/"

#let makeLangGlyphs(lang) = {
  let glyphs = json(baseDir + lang + "/index.json")
  let ret = (:)
  for glyph in glyphs {
    ret.insert(glyph, image(baseDir + lang + "/" + glyph + ".png"))
  }
  ret
}

#let glyphs = (
  Devots: makeLangGlyphs("Devots"),
  Guerriers: makeLangGlyphs("Guerriers"),
  Bardes: makeLangGlyphs("Bardes"),
  Alchimistes: makeLangGlyphs("Alchimistes"),
  Reclus: makeLangGlyphs("Reclus"),
)

/// The game _Chants of Sennaar_ has 5 in-game languages and a number of glyphs. They are identified by *internal names*, and a `translation` is a mapping from their names to these internal names.
/// 
/// In general, internal names start with capital letters and names should start with lower case letters.
///
/// This function is used for making custom translations. A default translation @@english is provided and should cover most usecases. See #raw(baseDir + "translations/english.json") for the translation file format.
///
/// - filename (string): The translation file to be loaded.
/// -> translation
#let makeTranslation(filename) = {
  let trans = json(filename)
  let reverse(dict) = {
    let ret = (:)
    for (k, v) in dict {
      ret.insert(v, k)
    }
    ret
  }
  (
    meta: reverse(trans.meta),
    Devots: reverse(trans.Devots),
    Guerriers: reverse(trans.Guerriers),
    Bardes: reverse(trans.Bardes),
    Alchimistes: reverse(trans.Alchimistes),
    Reclus: reverse(trans.Reclus),
  )
}

/// The default translation. It contains the following:
///#let dispLang(lang) = (english.meta.at(lang), lang)
/// #let dispAlphabet(lang) = english.at(english.meta.at(lang)).pairs().map(((en, fr)) => (say(lang)(fr), fr, en)).join()
/// 
/// *Languages:*
/// 
/// #table(
///   columns: 2,
///   align: horizon,
///   [*Internal Language Name*],
///   [*English Language Name*],
///   ..dispLang("devotees"),
///   ..dispLang("warriors"),
///   ..dispLang("bards"),
///   ..dispLang("alchemists"),
///   ..dispLang("anchorites"),
/// )
/// 
/// #for lang in english.meta.keys() {
///   
///   [*The #(lang)' language:*]
/// 
/// block(breakable: true, height: 70%, columns(2, table(
///   columns: (1fr, 1fr, 1fr),
///   align: horizon,
///   [*Glyph*],
///   [*Internal Name*],
///   [*English Name*],
///   ..dispAlphabet(lang),
/// )))
/// }
/// 
/// The following unused or hidden glyphs are *not* in the translation due to not having an in-game name. If needed, refer to them by their internal name directly.
/// 
/// #block(breakable: true, height: 70%, columns(2, table(
///   columns: (1fr, 1fr, 1fr),
///   align: horizon,
///   [*Glyph*], [*English Language Name*], [*Internal Name*],
///   say("Devots")("Question"), [devotees], [Question],
///   say("Devots")("Guerre"), [devotees], [Guerre],
///   say("Devots")("Plusieurs"), [devotees], [Plusieurs],
///   say("Devots")("Boutique"), [devotees], [Boutique],
///   say("Devots")("Maison"), [devotees], [Maison],
///   say("Devots")("Opticien"), [devotees], [Opticien],
///   say("Devots")("Arme"), [devotees], [Arme],
///   box(baseline: 25%, height: 1em, inset: (y: - (1.5em - 1em) / 2), glyphs.Bardes.boutGauche), [bards], [boutGauche],
///   box(baseline: 25%, height: 1em, inset: (y: - (1.5em - 1em) / 2), glyphs.Bardes.boutDroite), [bards], [boutDroite],
/// )))
#let english = makeTranslation(baseDir + "translations/english.json")

/// This function returns another function receiving any number of glyph names in the given language and outputs the glyphs.
///
/// If an language name or glyph name is not present in the translation, it's perceived as an internal name instead.
///
/// Example:
/// #example(`#say("bards")("not", "go", "warrior", "plural", "not") Warriors shall not pass.`, mode: "markup")
///
/// - height (auto, relative): The height of the glyphs.
///     Whatever the height is set to, the glyphs always take 1em in the layout.
/// - baseline (relative): An amount to shift the glyphs' baseline by.
/// - translation (translation, none): Translation from in-game language names and glyph names to their internal names.
/// - lang (string): The language name of the glyphs.
/// -> (..string) -> content
#let say(height: 1.5em, baseline: 25%, translation: english, lang) = (..words) => {
  let Lang = if translation != none { translation.meta.at(default: lang, lang) } else { lang }
  let translate(word) = if translation != none { translation.at(Lang).at(default: word, word) } else { word }

  let b(body) = box(baseline: baseline, height: 1em, inset: (y: - (height - 1em) / 2), body)

  if Lang == "Bardes" {
    b(glyphs.Bardes.boutGauche)
    words.pos().map(word => b(glyphs.Bardes.at(translate(word)))).join()
    b(glyphs.Bardes.boutDroite)
  } else {
    words.pos().map(word => b(glyphs.at(Lang).at(translate(word)))).join(h(height / 10)) 
  }
}
