REBOL [
  Title: {Day 21}
  Date: 21-12-2017
]

data: read %data/21.txt

; --- Part 1 ---

pix: [{.} | {#}] sep: [opt {/}]
pattern-rule: [
  (content: copy [] pattern: none) [
    4 [copy p [pix pix pix pix] sep (size: 4x4 forall p [append content pick [black white] p/1 = #"."])]
  | 3 [copy p [pix pix pix] sep (size: 3x3 forall p [append content pick [black white] p/1 = #"."])]
  | 2 [copy p [pix pix] sep (size: 2x2 forall p [append content pick [black white] p/1 = #"."])]
  ] (pattern: make image! reduce [size reduce content])
]

make-pattern: funct [input [string!]] [
  parse input [pattern-rule]
  pattern
]

rules2: make hash! []
rules3: make hash! []
foreach [in out] collect [
  parse data [
    some [
      pattern-rule (keep pattern) {=>} pattern-rule (keep pattern)
      [newline | end]
    ]
  ]
] [
  dest: either 2x2 == in/size [rules2] [rules3]
  foreach rot [0 90 270] [
    use [new] [
      repend dest [new: to-image layout/tight [image in effect [rotate rot]] out]
      repend dest [to-image layout/tight [image new effect [flip 1x0]] out]
    ]
  ]
  repend dest [to-image layout/tight [image in effect [flip 0x1]] out]
  repend dest [to-image layout/tight [image in effect [flip 1x1]] out]
]

canvas: make-pattern {.#./..#/###}

transform: func [image [image!]] [
  result: make image! either 0x0 == (image/size // 2) [
    dims: reduce [image/size / 2 2x2 3x3 rules2]
    reduce [image/size * 3 / 2]
  ] [
    dims: reduce [image/size / 3 3x3 4x4 rules3]
    reduce [image/size * 4 / 3]
  ]
  repeat y dims/1/y [
    repeat x dims/1/x [
      src: dims/2 * as-pair x - 1 y - 1
      dst: dims/3 * as-pair x - 1 y - 1
      pattern: copy/part at image src dims/2
      value: select dims/4 pattern
      if none? value [print [{ARG} pattern src dst]]
      change at result dst value
    ]
  ]
  result
]

repeat i 5 [canvas: transform canvas]
lookup: canvas
r1: 0 while [lookup: find/tail lookup white] [r1: r1 + 1]
print [{Part 1:} r1]

; --- Part 2 ---
repeat i 13 [canvas: transform canvas]
lookup: canvas
r2: 0 while [lookup: find/tail lookup white] [r2: r2 + 1]
print [{Part 2:} r2]
