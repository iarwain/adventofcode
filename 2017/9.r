REBOL [
  Title: {Day 9}
  Date: 09-12-2017
]

data: read %data/9.txt

; --- Part 1 ---
stream: context [
  depth: score: garbage-load: 0
  cancel:     ["!" skip]
  separator:  [opt ","]

  in-garbage: complement charset ">"
  garbage:    ["<" any [cancel | in-garbage (++ garbage-load)] ">"]

  in-group:   complement charset "}"
  group:      ["{" (++ depth score: score + depth) any [[group | garbage] separator | in-group] "}" (-- depth)]

  check:      func [source [string!]] [depth: score: garbage-load: 0 parse source group reduce [score garbage-load]]
]
set [r1 r2] stream/check data

print [{Part 1:} r1]

; --- Part 2 ---
print [{Part 2:} r2]
