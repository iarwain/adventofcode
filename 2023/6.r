REBOL [
  Title: {Day 6}
  Date: 06-12-2023
]

data: read/lines %data/6.txt

race: funct [/single] [
  solve: funct [time distance] [
    ; Solving the equation -x^2 + time * x - distance = 0 (cf. (time - x) * x >= distance)
    to-integer 1
             + round/floor time + (square-root time ** 2 - (4 * distance)) / 2
             - round/ceiling time - (square-root time ** 2 - (4 * distance)) / 2
  ]
  either single [
    time:     load remove-each char next find data/1 {:} [find whitespace char]
    distance: load remove-each char next find data/2 {:} [find whitespace char]
    solve time distance
  ] [
    times:      load next find data/1 {:}
    distances:  load next find data/2 {:}
    res: 1 forall times [
      res: res * solve times/1 distances/(index? times)
    ]
  ]
]

; --- Part 1 ---
r1: race
print [{Part 1:} r1]

; --- Part 2 ---
r2: race/single
print [{Part 2:} r2]
