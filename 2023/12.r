REBOL [
  Title: {Day 12}
  Date: 12-12-2023
]

data: read/lines %data/12.txt

records: context [
  check: use [records cache count] [
    records: map-each line data [
      context [
        springs: first split line whitespace
        pattern: load split second split line whitespace {,}
      ]
    ]
    cache: map []
    count: funct [springs pattern] [
      unless res: select cache key: rejoin [springs "_" pattern] [
        cache/:key: res: switch/default springs/1 [
          #"?" [
            (count back change copy springs #"." pattern) + (count back change copy springs #"#" pattern)
          ]
          #"." [
            count any [find springs charset {?#} tail springs] pattern
          ]
          #"#" [
            either empty? pattern [
              0
            ] [
              remainder: pattern/1
              until [any [not find {#?} first+ springs 0 = remainder: remainder - 1]]
              either all [remainder = 0 springs/1 != #"#"] [
                count do pick [[back change copy springs #"."] springs] springs/1 = #"?" next pattern
              ] [
                0
              ]
            ]
          ]
        ] [
          pick [1 0] empty? pattern
        ]
      ]
      res
    ]
    funct [/unfold] [
      res: 0
      foreach record records [
        springs: do pick [[head remove back tail insert/dup copy {} join record/springs #"?" 5] [record/springs]] to-logic unfold
        pattern: do pick [[head insert/dup copy [] record/pattern 5] [record/pattern]] to-logic unfold
        res: res + count springs pattern
      ]
      res
    ]
  ]
]

; --- Part 1 ---
r1: records/check
print [{Part 1:} r1]

; --- Part 2 ---
r2: records/check/unfold
print [{Part 2:} r2]
