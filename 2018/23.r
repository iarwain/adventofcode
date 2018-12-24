REBOL [
  Title: {Day 23}
  Date: 23-12-2018
]

data: read/lines %data/23.txt

; --- Part 1 ---
teleport: context [
  in-strongest-range?: best-distance?: none
  use [x y z r nanobots strongest distance? in-range?] [
    nanobots: collect [
      foreach line data [
        parse line [
          thru "<" copy x to "," skip copy y to "," skip copy z to ">" thru "=" copy r integer!
          (keep reduce [load r reduce [load x load y load z]])
        ]
      ]
    ]
    strongest: maximum-of/skip nanobots 2
    distance?: funct [pos1 pos2] [
      result: 0 repeat c 3 [result: result + abs (pos1/:c - pos2/:c)]
    ]
    in-range?: funct [position] [
      count: 0 foreach [radius pos] nanobots [
        all [(distance? position pos) <= radius count: count + 1]
      ]
      count
    ]
    in-strongest-range?: has [count] [
      count: 0 foreach [radius pos] nanobots [
        all [(distance? pos strongest/2) <= strongest/1
        count: count + 1]
      ]
      count
    ]
    best-distance?: has [best best-count step-count walk last-count step] [
      best: copy [0.0 0.0 0.0] foreach [radius pos] nanobots [repeat c 3 [best/:c: best/:c + pos/:c]]
      repeat c 3 [best/:c: to-integer best/:c / (0.5 * length? nanobots)]
      best-count: in-range? best
      step-count: shift/left 1 round/ceiling log-2 first maximum-of collect [foreach [radius pos] nanobots [keep pos]]
      walk: func [step /local pos count offset] [
        foreach dir [[1 1 1] [0 1 1] [1 0 1] [1 1 0] [0 0 1] [0 1 0] [1 0 0]] [
          pos: copy offset: copy [0 0 0]
          repeat c 3 [offset/:c: dir/:c * step * negate sign? best/:c]
          until [
            repeat c 3 [pos/:c: best/:c + offset/:c]
            all [
              best-count <= count: in-range? pos
              best-count: count
              best: copy pos
            ]
            best-count > count
          ]
        ]
      ]
      until [
        last-count: best-count step: step-count
        until [
          walk step
          0 = step: shift step 1
        ]
        best-count = last-count
      ]
      distance? [0 0 0] best
    ]
  ]
]
r1: teleport/in-strongest-range?
print [{Part 1:} r1]

; --- Part 2 ---
r2: teleport/best-distance?
print [{Part 2:} r2]
