REBOL [
  Title: {Day 20}
  Date: 20-12-2021
]

; I tried using a flat 2D array instead of a hash! of points but it is actually slower.

data: read/lines %data/20.txt

; --- Part 1 ---
device: context [
  enhance: none
  use [algorithm bitmap bounds] [
    algorithm: take data remove data
    bitmap: make hash! collect [
      forall data [line: data/1 forall line [if line/1 = #"#" [keep as-pair index? line index? data]]]
    ]
    bounds: context [low: 1x1 high: as-pair length? data/1 length? data]
    enhance: funct [steps] [
      image: bitmap
      repeat step steps [
        prin [{Step} step {: }]
        image: make hash! collect [
          for y bounds/low/y - (steps + 1 * 2) bounds/high/y + (steps + 1 * 2) 1 [
            for x bounds/low/x - (steps + 1 * 2) bounds/high/x + (steps + 1 * 2) 1 [
              value: copy [0 0 0 0 0 0 0]
              for j y - 1 y + 1 1 [
                for i x - 1 x + 1 1 [
                  insert tail value pick [1 0] found? find image as-pair i j
                ]
              ]
              all [algorithm/(1 + to-integer debase/base to-string value 2) = #"#" keep as-pair x y]
            ]
          ]
        ]
        all [
          even? step
          remove-each pixel image [
            any [
              pixel/x < (bounds/low/x - (steps * 2))
              pixel/x > (bounds/high/x + (steps * 2))
              pixel/y < (bounds/low/y - (steps * 2))
              pixel/y > (bounds/high/y + (steps * 2))
            ]
          ]
        ]
        print [{done.}]
      ]
      length? image
    ]
  ]
]

r1: device/enhance 2
print [{Part 1:} r1]

; --- Part 2 ---
r2: device/enhance 50
print [{Part 2:} r2]
