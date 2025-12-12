REBOL [
  Title: {Day 12}
  Date: 12-12-2025
]

data: read/string %data/12.txt

xmas: context [
  presents: copy [] floor: copy []
  do function [] [
    digits: charset [#"0" - #"9"]
    parse data [
      ; Presents
      some [
        copy id some digits thru newline (count: 0)
        3 [copy line to newline skip (forall line [all [line/1 = #"#" ++ count]])]
        newline (append presents count)
      ]
      ; Floor
      some [
        copy area to {:} skip copy counts to [newline | end] (repend floor [load area load counts]) skip
      ]
    ]
  ]
  can-fit?: function [] [
    result: 0
    foreach [area counts] floor [
      size: 0
      forall counts [size: presents/(index? counts) * counts/1 + size]
      all [
        area/x * area/y >= size
        ++ result
      ]
    ]
    result
  ]
]

; --- Part 1 ---
r1: xmas/can-fit?
print [{Part 1:} r1]

; --- Part 2 ---
r2: {There's no part 2! :-)}
print [{Part 2:} r2]
