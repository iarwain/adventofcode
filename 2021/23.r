REBOL [
  Title: {Day 23}
  Date: 23-12-2021
]

print {
  I tried to transcribe to Rebol the very basic graph search I wrote last night in V to solve this day.
  Unfortunately, the iteration times are far too long to finish debugging this version (it might even be working in its current state?).
  Using more flat structures might improve the iteration time but I doubt it'd be enough and I've already spent far too much time on this version.
  I leave it as-is and I might revisit one day if I can think or a smarter approach, as after all I was able to solve part #1 manually relatively easily.
}

; For reference, manual solving of part #1:
; #############
; #AA.....D.C.#
; ###C#A#D#D###
;   #B#A#B#C#
;   #########
;
; 2000+300+3000+4000+5+5+60+500+600+50+3+3=10526
;
;    Min          Extra
; A: 10 ->   10 + 6 ->    6
; B: 11 ->  110 + 0 ->    0
; C: 12 -> 1200 + 2 ->  200
; D: 5  -> 5000 + 4 -> 4000
; -------------------------
;          6320        4206 = 10526

comment [
data: remove-each entry parse read %data/23.txt {#} [empty? entry]

; --- Part 1 ---
amphipods: [{A} {B} {C} {D}]
costs: make hash! collect [forall amphipods [keep amphipods/1 keep to-integer power 10 (index? amphipods) - 1]]
exits: make hash! collect [forall amphipods [keep amphipods/1 keep 1 + (2 * index? amphipods)]]
solved?: funct [burrow] [
  all [
    if result: not any burrow/1 [
      rooms: burrow/2
      forall rooms [
        foreach cell rooms/1 [result: all [result cell = amphipods/(index? rooms)]]
      ]
    ]
  ]
]
states: reduce [
  0 reduce [array length? data/1 collect [repeat i 4 [keep/only reverse extract skip data i 4]]]
]
seen: make hash! [] room-size: length? states/2/2/1 corridor-size: length? states/2/1

it: 0
until [
  it: it + 1
  if 0 = (it // 1000) [print it]
;  print [(length? states) / 2]
;  sort/skip states 2
;  foreach [e b] states [print [e mold b]]
;  input
  lowest: minimum-of/skip states 2
  energy: take lowest burrow: take lowest
  all [it != 1 not any burrow/1 print [{RESULT} energy] break]
  unless find/only seen burrow [
    insert/only tail seen copy/deep burrow
    corridor: burrow/1 rooms: burrow/2
    index: 0 foreach room rooms [
      index: index + 1
      unless empty? room [
        amphi: last room
        foreach [corner step] reduce [1 -1 corridor-size 1] [
          for pos (exit: exits/(2 * index)) + step corner step [
            unless find exits pos [
              either corridor/:pos [
                break
              ] [
                new: copy/deep burrow new/1/:pos: amphi
                remove back tail new/2/:index
                unless find/only seen new [
                  insert tail states reduce [
                    energy + (costs/:amphi * (room-size - (length? room) + 1 + abs exit - pos))
                    new
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
    pos: 0 foreach amphi corridor [
      pos: pos + 1
      if all [
        amphi
        room: rooms/(index: index? find amphipods amphi)
        check: true any [empty? room foreach cell room [check: all [check cell = amphipods]]]
        check: true for cell pos + step: sign? (exit: exits/:amphi) - pos exit step [check: all [check not corridor/:cell]]
      ] [
        new: copy/deep burrow new/1/:pos: none
        insert tail new/2/:index amphi
  ;        print [{ENTER} amphi {@} pos newline mold new]
        unless find/only seen new [
          insert tail states reduce [
            energy + (costs/:amphi * ((room-size - length? room) + abs exit - pos))
            new
          ]
        ]
      ]
    ]
  ]
  empty? states
]

r1: energy
print [{Part 1:} r1]
halt
; --- Part 2 ---
r2: solve/unfold
print [{Part 2:} r2]
]
