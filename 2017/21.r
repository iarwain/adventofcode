REBOL [
  Title: {Day 21}
  Date: 21-12-2017
]

; This one requires REBOL View, for image manipulation / colors

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

rules: make hash! []
foreach [in out] collect [
  parse data [
    some [
      pattern-rule (keep pattern) {=>} pattern-rule (keep pattern)
      [newline | end]
    ]
  ]
] [
  ; !!! Can't use 180° rotation as REBOL might make an error with the center pixel of an odd-sized image
  foreach fl [0x0 1x0 0x1 1x1] [
    repend rules [to-image layout/tight [image in effect [flip fl]] reduce [out]]
  ]
  foreach rot [90 270] [
    foreach fl [0x0 1x0] [
      repend rules [to-image layout/tight [image in effect [rotate rot flip fl]] reduce [out]]
    ]
  ]
]

image: make-pattern {.#./..#/###}

transform: funct [image [image!]] [
  result: make image! either 0x0 == (image/size // 2) [
    dims: reduce [image/size / 2 2x2 3x3]
    reduce [image/size * 3 / 2]
  ] [
    dims: reduce [image/size / 3 3x3 4x4]
    reduce [image/size * 4 / 3]
  ]
  repeat y dims/1/y [
    repeat x dims/1/x [
      src: dims/2 * as-pair x - 1 y - 1
      dst: dims/3 * as-pair x - 1 y - 1
      pattern: copy/part at image src dims/2
      value: first select rules pattern
      if none? value [print [{ARG} pattern src dst]]
      change at result dst value
    ]
  ]
  result
]

lookup: loop 5 [image: transform image]
r1: 0 while [lookup: find/tail lookup white] [r1: r1 + 1]
print [{Part 1:} r1]

; --- Part 2 ---
lookup: loop 13 [image: transform image]
r2: 0 while [lookup: find/tail lookup white] [r2: r2 + 1]
print [{Part 2:} r2]
