REBOL [
  Title: {Day 16}
  Date: 16-12-2020
]

data: read %data/16.txt

; --- Part 1 ---
format: collect [
  parse/all data [
    some [
      copy class to {:} thru { } copy low to {-} skip copy high to { } (values: copy [] for i load low load high 1 [append values i])
      thru {or } copy low to {-} skip copy high to newline skip (for i load low load high 1 [append values i] keep reduce [class unique values])
    ]
    thru {your ticket:^/} copy mine to {nearby} (mine: map-each value parse mine {,} [load value])
    thru {nearby tickets:^/} copy nearby to end (nearby: map-each line parse nearby {^/} [map-each value parse line {,} [load value]])
  ]
]
correct: unique collect [foreach [class values] format [keep values]]
r1: 0 foreach value collect [foreach ticket nearby [keep ticket]] [unless find correct value [r1: r1 + value]]
print [{Part 1:} r1]

; --- Part 2 ---
remove-each ticket nearby [foreach value ticket [unless find correct value [break/return true]]]
fields: extract format 2 classes: array/initial length? fields funct [] [copy fields]
forall classes [foreach ticket nearby [remove-each class classes/1 [not find format/:class ticket/(index? classes)]]]
until [
  stop: true forall classes [
    if 1 = length? classes/1 [
      check: head classes forall check [all [check != classes remove find check/1 classes/1/1 stop: false]]
    ]
  ]
  stop
]
r2: 1.0 forall classes [if find classes/1/1 {departure} [r2: r2 * mine/(index? classes)]]
print [{Part 2:} copy/part r2: form r2 find r2 {.}]
