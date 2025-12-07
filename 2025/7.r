REBOL [
  Title: {Day 7}
  Date: 07-12-2025
]

data: read/lines %data/7.txt

; --- Part 1 ---
timelines: array/initial length? data/1 0
timelines/(index? find data/1 #"S"): 1
splits: 0
foreach line next data [
  forall timelines [
    if timelines/1 > 0 [
      unless line/(index? timelines) = #"." [
        ++ splits
        timelines/-1: timelines/-1 + timelines/1
        timelines/2: timelines/2 + timelines/1
        timelines/1: 0
      ]
    ]
  ]
]
r1: splits
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach count timelines [r2: r2 + count]
print [{Part 2:} r2]
