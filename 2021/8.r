REBOL [
  Title: {Day 8}
  Date: 08-12-2021
]

data: read/lines %data/8.txt

; --- Part 1 ---
hud: context [
  displays: map-each line data [reduce [take/part line: map-each entry parse line {|} [sort entry] 10 line]]
  count: funct [] [
    result: 0
    foreach display displays [
      foreach digit display/2 [
        if find [2 3 4 7] length? digit [result: result + 1]
      ]
    ]
    result
  ]
  solve: funct [] [
    result: 0
    foreach display displays [
      digits: array 10 mappings: copy display/1
      find-mapping: func [index conditions] [
        mappings: head mappings
        forall mappings [
          if all conditions [digits/(index + 1): take mappings break]
        ]
      ]
      find-mapping 1 [2 = length? mappings/1]
      find-mapping 4 [4 = length? mappings/1]
      find-mapping 7 [3 = length? mappings/1]
      find-mapping 8 [7 = length? mappings/1]
      find-mapping 3 [5 = length? mappings/1 empty? exclude digits/2 mappings/1]
      find-mapping 9 [6 = length? mappings/1 empty? exclude digits/5 mappings/1]
      find-mapping 0 [6 = length? mappings/1 empty? exclude digits/2 mappings/1]
      find-mapping 6 [6 = length? mappings/1]
      find-mapping 2 [5 = length? mappings/1 2 = length? intersect mappings/1 digits/5]
      find-mapping 5 [true]

      result: result + load to-string map-each digit display/2 [(index? find digits digit) - 1]
    ]
  ]
]

r1: hud/count
print [{Part 1:} r1]

; --- Part 2 ---

r2: hud/solve
print [{Part 2:} r2]
