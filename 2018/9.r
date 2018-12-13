REBOL [
  Title: {Day 9}
  Date: 09-12-2018
]

data: read %data/9.txt

; --- Part 1 ---
game: context [
  players: marbles: ring: none
  parse data [
    copy players integer! thru {worth} copy marbles integer! (players: load players marbles: load marbles)
  ]
  process: has [current scores player] [
    current: insert ring: make block! 2 * marbles 0 scores: array/initial players 0.0
    repeat i marbles [
      either 0 = (i // 23) [
        scores/(player: i - 1 // players + 1): scores/:player + i + take back current: skip current -7
        until [tail? current: insert next current i: i + 1]
      ] [
        current: insert current reduce [first+ ring i]
      ]
    ]
    head clear skip tail to-string first maximum-of scores -2
  ]
]
r1: game/process
print [{Part 1:} r1]

; --- Part 2 ---
game/marbles: game/marbles * 100
r2: game/process
print [{Part 2:} r2]
