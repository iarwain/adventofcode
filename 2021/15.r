REBOL [
  Title: {Day 15}
  Date: 15-12-2021
]

data: read/lines %data/15.txt

; This is now much faster, thanks to the algorithm proposed by Rémi Veilleux (~8x more inner loop iterations *but* no sorting -> ~90% time reduction)

; --- Part 1 ---
cavern: context [
  cave: map-each line data [collect [foreach char line [keep to-integer char - #"0"]]]
  pathfind: funct [/wrap] [
    either wrap [
      size: as-pair length? cave/1 length? cave
      map: array reduce [5 * size/y 5 * size/x]
      repeat y length? map [
        offset-y: to-integer ((y - 1) / size/y)
        repeat x length? map/1 [
          offset-x: to-integer ((x - 1) / size/x)
          map/:y/:x: cave/((y - 1) // size/y + 1)/((x - 1) // size/x + 1) + offset-x + offset-y - 1 // 9 + 1
        ]
      ]
    ] [
      map: copy/deep cave
    ]
    queue: reduce [end: as-pair length? map/1 length? map] to-flip: copy [] result: 0
    map/(end/y)/(end/x): negate map/(end/y)/(end/x)
    until [
      result: result + 1 clear to-flip
      remove-each pos queue [
        all [
          0 > cost: map/(pos/y)/(pos/x)
          map/(pos/y)/(pos/x): cost + 1
          cost = -1
          foreach dir [-1x0 1x0 0x-1 0x1] [insert tail to-flip pos + dir]
        ]
        cost = -1
      ]
      foreach pos to-flip [
        all [
          pos/x > 0
          pos/x <= end/x
          pos/y > 0
          pos/y <= end/y
          map/(pos/y)/(pos/x) > 0
          map/(pos/y)/(pos/x): negate map/(pos/y)/(pos/x)
          insert tail queue pos
        ]
      ]
      map/1/1 < 0
    ]
    result
  ]
]

r1: cavern/pathfind
print [{Part 1:} r1]

; --- Part 2 ---
r2: cavern/pathfind/wrap
print [{Part 2:} r2]
