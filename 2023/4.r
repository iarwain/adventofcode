REBOL [
  Title: {Day 4}
  Date: 04-12-2023
]

data: read/lines %data/4.txt

scratch: funct [/newrules] [
  res: 0
  all [newrules cards: array/initial length? data 1]
  foreach line data [
    parse line [
      thru {:} copy winning to {|} skip (winning: load winning)
      copy nums to end (nums: load nums)
    ]
    wins: length? intersect nums winning
    either newrules [
      ++ cards
      for i 1 wins 1 [
        cards/:i: cards/-1 + cards/:i
      ]
      res: res + cards/-1
    ] [
      res: res + to-integer power 2 wins - 1
    ]
  ]
]

; --- Part 1 ---
r1: scratch
print [{Part 1:} r1]

; --- Part 2 ---
r2: scratch/newrules
print [{Part 2:} r2]
