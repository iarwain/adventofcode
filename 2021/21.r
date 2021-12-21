REBOL [
  Title: {Day 21}
  Date: 21-12-2021
]

data: read/lines %data/21.txt

; --- Part 1 ---
game: context [
  play: wins?: none
  use [players] [
    players: map-each line data [parse line [thru {position:} copy val to end] (load val) - 1]
    play: funct [] [
      positions: copy players scores: copy [0 0] die: 0 player: 1
      roll: does [die: die + 1]
      until [
        score: scores/:player: scores/:player + (positions/:player: positions/:player + roll + roll + roll // 10) + 1
        player: 3 - player
        score >= 1000
      ]
      die * scores/:player
    ]
    wins?: funct [] [
      wins: array/initial 10 * 10 * 21 * 21 [0 0]
      process: funct [state] [
        index: state/1 + (10 * state/2) + (100 * state/3) + (2100 * state/4)
        case [
          state/3 >= 21         [return [1.0 0.0]]
          state/4 >= 21         [return [0.0 1.0]]
          wins/:index != [0 0]  [return wins/:index]
        ]
        also win: wins/:index
        repeat i 3 [
          repeat j 3 [
            repeat k 3 [
              new: process reduce [state/2 score: state/1 + i + j + k // 10 state/4 state/3 + score + 1]
              win/1: win/1 + new/2
              win/2: win/2 + new/1
            ]
          ]
        ]
      ]
      win: process reduce [players/1 players/2 0 0]
      copy/part result: form max win/1 win/2 find result {.}
    ]
  ]
]

r1: game/play
print [{Part 1:} r1]

; --- Part 2 ---
r2: game/wins?
print [{Part 2:} r2]
