REBOL [
  Title: {Day 21}
  Date: 21-12-2017
]

; This one requires REBOL View, for image manipulation / colors

data: read %data/21.txt

; --- Part 1 ---
fractal: context [
  rules: make hash! []
  use [pattern-rule pattern content size pix sep key] [
    pix: [{.} | {#}] sep: [opt {/}]
    pattern-rule: [
      (content: copy [] pattern: none) [
        4 [copy p [pix pix pix pix] sep (size: 4x4 forall p [append content pick [black white] p/1 = #"."])]
      | 3 [copy p [pix pix pix] sep (size: 3x3 forall p [append content pick [black white] p/1 = #"."])]
      | 2 [copy p [pix pix] sep (size: 2x2 forall p [append content pick [black white] p/1 = #"."])]
      ] (pattern: make image! reduce [size reduce content])
    ]
    foreach [in out] collect [
      parse data [
        some [pattern-rule (keep pattern) {=>} pattern-rule (keep pattern) [newline | end]]
      ]
    ] [
      ; !!! Can't use 180° rotation as REBOL might make an error with the center pixel of an odd-sized image
      foreach fl [0x0 1x0 0x1 1x1] [
        unless find rules key: to-image layout/tight [image in effect [flip fl]] [repend rules [key reduce [out]]]
      ]
      foreach rot [90 270] [
        foreach fl [0x0 1x0] [
          unless find rules key: to-image layout/tight [image in effect [rotate rot flip fl]] [repend rules [key reduce [out]]]
        ]
      ]
    ]
    make-pattern: funct [input [string!]] [parse input [pattern-rule] pattern]
  ]
  image: make-pattern {.#./..#/###}
  transform: func [interations [integer!] /local new-image dims src dst lookup count] [
    loop interations [
      new-image: make image! either 0x0 = (image/size // 2) [
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
          change at new-image dst first select rules copy/part at image src dims/2
        ]
      ]
      image: new-image
    ]
    lookup: image count: 0
    while [lookup: find/tail lookup white] [count: count + 1]
    count
  ]
]

r1: fractal/transform 5
print [{Part 1:} r1]

; --- Part 2 ---
r2: fractal/transform 13
print [{Part 2:} r2]
