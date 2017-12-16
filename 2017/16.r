REBOL [
  Title: {Day 16}
  Date: 16-12-2017
]

data: read %data/16.txt

; --- Part 1 ---
dance: func [/times iterations [integer!] /local steps src dst dancers dances init] [
  unless iterations [iterations: 1] dancers: copy init: {abcdefghijklmnop} dances: make block! reduce [init]
  bind steps: collect [
    parse data [
      some [
        [ {s} copy src integer! (keep/only compose [insert dancers take/part skip tail dancers (negate load src) tail dancers])
        | {x} copy src integer! {/} copy dst integer! (keep/only compose [swap at dancers ((load src) + 1) at dancers ((load dst) + 1)])
        | {p} copy src to {/} skip copy dst [to {,} | to end] (keep/only compose [swap find dancers (src) find dancers (dst)])
        ] opt {,}
      ]
    ]
  ] 'dancers
  loop iterations [
    foreach step steps [do step]
    either dancers == init [break] [append dances copy dancers]
  ]
  pick dances iterations // (length? dances) + 1
]

r1: dance
print [{Part 1:} r1]

; --- Part 2 ---
r2: dance/times 1'000'000'000
print [{Part 2:} r2]
