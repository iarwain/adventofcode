REBOL [
  Title: {Day 1}
  Date: 28-01-2018
]

data: read/lines %data/2.txt

; --- Part 1 ---
r1: 0
foreach gift data [
  parse gift [
    copy l integer! {x} (l: load l)
    copy w integer! {x} (w: load w)
    copy h integer! (h: load h)
  ]
  foreach dim repend dimensions: reduce [l * w l * w l * h l * h w * h w * h] first minimum-of dimensions [
    r1: r1 + dim
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach gift data [
  parse gift [
    copy l integer! {x} (l: load l)
    copy w integer! {x} (w: load w)
    copy h integer! (h: load h)
  ]
  foreach dim repend remove maximum-of reduce [2 * l 2 * w 2 * h] l * w * h [
    r2: r2 + dim
  ]
]
print [{Part 2:} r2]
