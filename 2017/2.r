REBOL [
  Title: {Day 2}
  Date: 02-12-2017
]

data: map-each line read/lines %data/2.txt [load line]

; --- Part 1 ---
r1: 0
foreach row data [
  r1: r1 + (first maximum-of row) - (first minimum-of row)
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach row data [
  foreach v1 row [
    foreach v2 row [
      all [
        v1 < v2
        0 == mod v2 v1
        r2: r2 + (v2 / v1)
        break
      ]
    ]
  ]
]
print [{Part 2:} r2]
