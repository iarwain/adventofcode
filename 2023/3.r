REBOL [
  Title: {Day 3}
  Date: 03-12-2023
]

data: read/lines %data/3.txt

list-parts: funct [/gears] [
  numbers: charset {0123456789}
  symbols: either gears [charset {*}] [complement union numbers charset {.}]
  parts: map []

  for y 1 length? data 1 [
    valid: false value: copy {} x: 1
    until [
      if find numbers data/:y/:x [
        symbol: none
        until [
          append value data/:y/:x
          foreach delta [-1x-1 -1x0 -1x1 0x-1 0x1 1x-1 1x0 1x1] [
            test: as-pair x + delta/x y + delta/y
            if attempt [find symbols data/(test/y)/(test/x)] [
              valid: true
              symbol: test
              break
            ]
          ]
          ++ x
          any [attempt [not find numbers data/:y/:x] x > length? data/:y]
        ]
        -- x
        if all [valid not empty? value] [
          list: any [parts/:symbol parts/:symbol: copy []]
          append list load value
        ]
        valid: false value: copy {}
      ]
      ++ x
      x > length? data/:y
    ]
  ]
  parts
]

; --- Part 1 ---

r1: 0
foreach [symbol parts] list-parts [
  foreach part parts [
    r1: r1 + part
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach [symbol parts] list-parts/gears [
  all [
    2 = length? parts
    r2: parts/1 * parts/2 + r2
  ]
]
print [{Part 2:} r2]
