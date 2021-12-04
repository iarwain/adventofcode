REBOL [
  Title: {Day 4}
  Date: 04-12-2021
]

data: read/lines %data/4.txt

; --- Part 1 ---
bingo: context [
  play: none
  use [calls table board line] [
    calls: map-each call parse take data {,} [to-integer call]
    table: collect [
      board: none
      until [
        line: take data
        either empty? line [
          if board [keep/only board]
          board: copy []
        ] [
          append/only board map-each number parse line {} [reduce [to-integer number false]]
        ]
        empty? data
      ]
      unless empty? board [keep/only board]
    ]
    play: funct [/last] [
      boards: copy/deep table
      foreach call calls [
        foreach board boards [
          foreach line board [
            foreach entry line [
              if call == entry/1 [entry/2: true]
            ]
          ]
        ]
        win-board: none
        forall boards [
          foreach line boards/1 [
            win: true
            foreach entry line [win: win and entry/2]
            if win [win-board: take boards win-call: call break]
          ]
          unless win-board [
            for column 1 length? boards/1/1 1 [
              win: true
              for line 1 length? boards/1 1 [
                win: win and boards/1/:line/:column/2
              ]
              if win [win-board: take boards win-call: call break]
            ]
          ]
        ]
        if all [win-board any [empty? boards not last]] [break]
      ]
      sum: 0
      foreach line win-board [
        foreach entry line [
          if not entry/2 [
            sum: sum + entry/1
          ]
        ]
      ]
      sum * win-call
    ]
  ]
]

r1: bingo/play
print [{Part 1:} r1]

; --- Part 2 ---
r2: bingo/play/last
print [{Part 2:} r2]
