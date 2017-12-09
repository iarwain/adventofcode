REBOL [
  Title: {Day 9}
  Date: 09-12-2017
]

data: read %data/9.txt

; --- Part 1 ---
stream: context [
  cancel:     [#"!" skip]
  separator:  [opt #","]

  in-garbage: complement charset [#">"]
  garbage:    [#"<" any [cancel | in-garbage (++ garbage-load)] #">"]

  in-group:   complement charset [#"{" #"}" #"<"]
  group:      [#"{" (++ depth score: score + depth) any [in-group | [garbage | group] separator] #"}" (-- depth)]

  check:      does [depth: score: garbage-load: 0 parse data group reduce [score garbage-load]]
]
set [r1 r2] stream/check

print [{Part 1:} r1]

; --- Part 2 ---
print [{Part 2:} r2]
