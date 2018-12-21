REBOL [
  Title: {Day 20}
  Date: 20-12-2018
]

data: read %data/20.txt

; --- Part 1 ---
map: context [
  longest-path: long-path-count: rooms: none
  use [dirs grid stack pos queue connect step room] [
    dirs: ["N" 0x-1 "E" 1x0 "W" -1x0 "S" 0x1] grid: make hash! reduce [0x0 copy []]
    stack: copy [] pos: copy [0x0] rooms: make hash! [0x0 0] queue: copy [0x0]
    connect: funct [pos dir] [
      forall pos [
        unless find grid newpos: (oldpos: pos/1) + dirs/:dir [
          repend grid [newpos copy []]
        ]
        append grid/:newpos oldpos
        append grid/:oldpos newpos
        pos/1: newpos
      ]
    ]
    parse data [
      some [
        copy step [ #"N" | #"E" | #"W" | #"S"] (connect pos step)
      | #"(" (repend/only stack [copy pos pos])
      | #"|" (insert pos: tail pos first last stack)
      | #")" (change/part pos: second take back tail stack unique pos tail pos)
      | skip
      ]
    ]
    until [
      room: first+ queue
      foreach neighbor grid/:room [
        unless find rooms neighbor [
          repend rooms [neighbor rooms/:room + 1]
          append queue neighbor
        ]
      ]
      empty? queue
    ]
    longest-path: first maximum-of/skip next rooms 2
    long-path-count: 0 foreach [pos distance] rooms [all [distance >= 1000 long-path-count: long-path-count + 1]]
  ]
]
r1: map/longest-path
print [{Part 1:} r1]

; --- Part 2 ---
r2: map/long-path-count
print [{Part 2:} r2]
