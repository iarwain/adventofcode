REBOL [
  Title: {Day 18}
  Date: 18-12-2018
]

data: read/lines %data/18.txt

; --- Part 1 ---
terrain: context [
  resources?: show: none
  use [resource-count process open trees lumberyard forest init] [
    resource-count: reduce [open: #"." 0 trees: #"|" 0 lumberyard: #"#" 0] init: copy data
    process: has [output update] [
      output: copy/deep forest
      update: func [x y /local resources x-check y-check current] [
        resources: copy resource-count
        for j -1 1 1 [
          for i -1 1 1 [
            all [
              any [i != 0 j != 0]
              forest/(y-check: y + j)
              forest/:y-check/(x-check: x + i)
              resources/(current: forest/:y-check/:x-check): resources/:current + 1
            ]
          ]
        ]
        case [
          all [forest/:y/:x = #"." resources/:trees >= 3]                                [output/:y/:x: #"|"]
          all [forest/:y/:x = #"|" resources/:lumberyard >= 3]                           [output/:y/:x: #"#"]
          all [forest/:y/:x = #"#" any [resources/:lumberyard < 1 resources/:trees < 1]] [output/:y/:x: #"."]
        ]
      ]
      repeat y length? forest [
        repeat x length? forest/1 [
          update x y
        ]
      ]
      output
    ]
    resources?: func [iterations /local tick history resources check key loop-start] [
      tick: 0 forest: init history: make hash! []
      loop iterations [
        tick: tick + 1
        forest: process
        either check: find history key: mold forest [
          forest: load history/((loop-start: index? check) + ((iterations - tick) // (tick - loop-start)))
          break
        ] [
          append history key
        ]
      ]
      resources: copy resource-count
      repeat row forest [
        repeat resource row [
          resources/:resource: resources/:resource + 1
        ]
      ]
      resources/:trees * resources/:lumberyard
    ]
    show: does [repeat row forest [print row]]
  ]
]
r1: terrain/resources? 10
print [{Part 1:} r1]

; --- Part 2 ---
r2: terrain/resources? 1'000'000'000
print [{Part 2:} r2]
