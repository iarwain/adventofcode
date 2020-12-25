REBOL [
  Title: {Day 25}
  Date: 25-12-2020
]

data: load %data/25.txt

; --- Part 1 ---
rfid: context [
  divider: 20201227.0
  find-loop: funct [goal] [
    value: 1 subject: 7 res: 0 until [
      res: res + 1
      value: (value * subject) // divider
      value = goal
    ]
    res
  ]
  get-key: funct [subject count] [
    value: 1 loop count [value: (value * subject) // divider]
    to-integer value
  ]
]

r1: rfid/get-key data/2 rfid/find-loop data/1
print [{Part 1:} r1]

; --- Part 2 ---
r2: {There's no part 2, Merry Christmas! :-)}
print [{Part 2:} r2]
