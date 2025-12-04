REBOL [
  Title: {Day 4}
  Date: 04-12-2025
]

data: read/lines %data/4.txt

grab-rolls: function [room] [
  result: reduce [0 copy []]
  for y 1 length? room 1 [
    append result/2 copy {}
    for x 1 length? room/:y 1 [
      tile: #"."
      if room/:y/:x = #"@" [
        count: 0
        for j -1 1 1 [
          for i -1 1 1 [
            attempt [if room/(y + j)/(x + i) = #"@" [++ count]]
          ]
        ]
        unless all [count <= 4 result/1: result/1 + 1] [
          tile: #"@"
        ]
      ]
      append last result/2 tile
    ]
  ]
  result
]

; --- Part 1 ---
r1: first grab-rolls data
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0 room: data
until [
  result: grab-rolls room
  r2: r2 + result/1
  room: result/2
  result/1 = 0
]
print [{Part 2:} r2]
