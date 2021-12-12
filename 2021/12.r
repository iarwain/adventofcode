REBOL [
  Title: {Day 12}
  Date: 12-12-2021
]

data: parse read %data/12.txt {-}

; --- Part 1 ---
subterranean: context [
  caves: path?: none
  use [paths count small? traverse] [
    paths: copy [] count: 0
    foreach cave caves: unique/case data [
      append paths reduce [
        cave collect [
          foreach [src dst] data [
            case [
              src == cave [keep dst]
              dst == cave [keep src]
            ]
          ]
        ]
      ]
    ]
    small?: func [cave] [cave == lowercase copy cave]
    traverse: func [cave path doubled /local doubling] [
      insert path cave
      foreach dst paths/:cave [
        either dst = {end} [
          set 'count count + 1
        ] [
          doubling: doubled
          all [
            dst != {start}
            any [
              not small? dst
              not find path dst
              all [doubled = false doubling: true]
            ]
            traverse dst path doubling
          ]
        ]
      ]
      remove path
    ]
    path?: func [/twice] [count: 0 traverse {start} [] not twice count]
  ]
]

r1: subterranean/path?
print [{Part 1:} r1]

; --- Part 2 ---
r2: subterranean/path?/twice
print [{Part 2:} r2]
