REBOL [
  Title: {Day 3}
  Date: 03-12-2025
]

data: read/lines %data/3.txt

staircase: context [
  batteries: copy data
  turn-on: function [count [integer!]] [
    result: 0
    foreach battery batteries [
      highs: array/initial count 0 index: 0
      repeat j count [
        for i index + 1 (length? battery) - count + j 1 [
          if battery/:i > highs/:j [highs/:j: battery/:i index: i]
        ]
      ]
      result: result + load rejoin highs
    ]
  ]
]

; --- Part 1 ---
r1: staircase/turn-on 2
print [{Part 1:} r1]

; --- Part 2 ---
r2: staircase/turn-on 12
print [{Part 2:} r2]
