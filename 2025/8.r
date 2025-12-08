REBOL [
  Title: {Day 8}
  Date: 08-12-2025
]

data: collect [
  foreach line read/lines %data/8.txt [
    keep/only load split line {,}
  ]
]

; --- Part 1 ---
boxes: data distances: sort/skip collect [
  forall boxes [
    others: next boxes
    forall others [
      keep reduce [
        sqrt (power (others/1/1 - boxes/1/1) 2)
           + (power (others/1/2 - boxes/1/2) 2)
           + (power (others/1/3 - boxes/1/3) 2)
        others/1
        boxes/1
      ]
    ]
  ]
] 3
next-id: iteration: 0 circuits: copy []
until [
  pair: next take/part distances 3
  ids: reduce [select/only circuits pair/1 select/only circuits pair/2]
  repend circuits case [
    ids = [_ _] [++ next-id [pair/1 next-id pair/2 next-id]]
    none? ids/1 [[pair/1 ids/2]]
    none? ids/2 [[pair/2 ids/1]]
    true [
      forskip circuits 2 [
        all [
          circuits/2 = ids/2
          circuits/2: ids/1
        ]
      ]
      []
    ]
  ]
  counts: array/initial next-id 0
  foreach [box circuit] circuits [
    counts/:circuit: counts/:circuit + 1
  ]
  sort/reverse counts
  if 1000 = iteration: iteration + 1 [
    r1: counts/1 * counts/2 * counts/3
  ]
  counts/1 = length? boxes
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: pair/1/1 * pair/2/1
print [{Part 2:} r2]
