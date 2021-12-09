REBOL [
  Title: {Day 9}
  Date: 09-12-2021
]

data: read/lines %data/9.txt

; --- Part 1 ---
caves: context [
  risk-level?: basins?: none
  use [sources size lows] [
    sources: copy [] size: as-pair length? data/1 length? data
    lows: collect [
      repeat y size/y [
        repeat x size/x [
          local: data/:y/:x
          all [
            any [x = 1      local < data/:y/(x - 1)]
            any [x = size/x local < data/:y/(x + 1)]
            any [y = 1      local < data/(y - 1)/:x]
            any [y = size/y local < data/(y + 1)/:x]
            append sources as-pair x y
            keep local - #"0"
          ]
        ]
      ]
    ]
    risk-level?: funct [] [
      result: 0 foreach low lows [result: result + low + 1]
    ]
    basins?: funct [] [
      sizes: sort/reverse map-each source sources [
        basin: copy [] do expand: funct [pos] [
          result: 0
          unless find basin pos [
            append basin pos
            if data/(pos/y)/(pos/x) < #"9" [
              result: 1 case/all [
                pos/x > 1      [result: result + expand pos - 1x0]
                pos/x < size/x [result: result + expand pos + 1x0]
                pos/y > 1      [result: result + expand pos - 0x1]
                pos/y < size/y [result: result + expand pos + 0x1]
              ]
            ]
          ]
          result
        ] source
      ]
      sizes/1 * sizes/2 * sizes/3
    ]
  ]
]

r1: caves/risk-level?
print [{Part 1:} r1]

; --- Part 2 ---
r2: caves/basins?
print [{Part 2:} r2]
