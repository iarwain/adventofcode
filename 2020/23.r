REBOL [
  Title: {Day 23}
  Date: 23-12-2020
]

data: read %data/23.txt

; --- Part 1 ---
current: first cups: collect [forall data [keep load to-string data/1]]
loop 100 [
  append selection: take/part next find cups current 3 take/part cups 3 - length? selection
  destination: current until [
    if (destination: destination - 1) < first minimum-of cups [destination: first maximum-of cups]
    not find selection destination
  ]
  insert next find cups destination selection
  current: any [select cups current cups/1]
]
r1: load rejoin head insert cups take/part remove find cups 1 tail cups
print [{Part 1:} r1]

; --- Part 2 ---
change back tail neighbors: use [i] [i: 1 array/initial 1'000'000 does [i: i + 1]] current: load to-string data/1
use [previous] [previous: current forall data [neighbors/:previous: previous: load to-string data/1] neighbors/:previous: 1 + length? data]
loop 10'000'000 [
  selection: reduce [neighbors/:current neighbors/(neighbors/:current) neighbors/(neighbors/(neighbors/:current))]
  destination: current until [
    destination: either destination = 1 [length? neighbors] [destination - 1]
    not find selection destination
  ]
  current: neighbors/:current: neighbors/(last selection)
  neighbors/(last selection): neighbors/:destination
  neighbors/:destination: selection/1
]
r2: (to-decimal neighbors/1) * neighbors/(neighbors/1)
print [{Part 2:} copy/part r2: form r2 find r2 {.}]
