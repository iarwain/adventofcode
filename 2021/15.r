REBOL [
  Title: {Day 15}
  Date: 15-12-2021
]

data: read/lines %data/15.txt

; This would greatly benefit from optimization: 90+% of the time is spent sorting the queue

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
          map/:y/:x: (cave/((y - 1) // size/y + 1)/((x - 1) // size/x + 1) + offset-x + offset-y - 1) // 9 + 1
        ]
      ]
    ] [
      map: cave
    ]
    end: as-pair length? map/1 length? map costs: array/initial reduce [end/y end/x] 1000000 queue: reduce [cost: 0 pos: 1x1]
    until [
      set [cost pos] take/part queue 2
      touched: false
      foreach dir [-1x0 1x0 0x-1 0x1] [
        new: pos + dir
        all [
          new/x > 0
          new/x <= end/x
          new/y > 0
          new/y <= end/y
          costs/(new/y)/(new/x) > (new-cost: cost + map/(new/y)/(new/x))
          costs/(new/y)/(new/x): new-cost
          append queue reduce [new-cost new]
          touched: true
        ]
      ]
      all [touched sort/skip queue 2]
      empty? queue
    ]
    cost
  ]
]

r1: cavern/pathfind
print [{Part 1:} r1]

; --- Part 2 ---
r2: cavern/pathfind/wrap
print [{Part 2:} r2]
