#import "@preview/tidy:0.2.0"
#import "index.typ": *

#let docs = tidy.parse-module(
  name: "Chants-of-Sennaar.typst",
  read("index.typ"),
  scope: (english: english, say: say, baseDir: baseDir, glyphs: glyphs)
)
#tidy.show-module(docs, style: tidy.styles.default)
