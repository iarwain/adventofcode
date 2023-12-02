REBOL [
  Title: {Day 2}
  Date: 02-12-2023
]

data: read/lines %data/2.txt

games: collect [
  digits: charset {0123456789}
  letters: charset [#"a" - #"z"]
  foreach line data [
    max-colors: context [red: green: blue: 0]
    parse line [
      {Game } some digits {: }
      some [
        (colors: context [red: green: blue: 0])
        some [
          copy value some digits { }
          copy color some letters
          (colors/(to-word color): load value)
          opt {, }
        ]
        opt {; }
        (foreach color [red green blue] [max-colors/:color: max max-colors/:color colors/:color])
      ]
    ]
    keep max-colors
  ]
]

; --- Part 1 ---
r1: 0
forall games [
  all [
    games/1/red   <= 12
    games/1/green <= 13
    games/1/blue  <= 14
    r1: r1 + index? games
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach game games [
  r2: r2 + (game/red * game/green * game/blue)
]
print [{Part 2:} r2]
