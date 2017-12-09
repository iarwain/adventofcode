REBOL [
  Title: {Day 7}
  Date: 07-12-2017
]

data: read/lines %data/7.txt

; --- Part 1 ---
tree: make object! [
  entries: copy []
  get-entry: func [name [string!]] [find/skip entries name 4]
  get-root: does [first back find entries none]
  init: does [
    set-parent: func [name parent] [change next get-entry name parent]
    entries: collect [
      repeat entry data [
        parse entry [
          copy name to { }
          {(} copy weight to {)} (weight: to-integer weight)
          [thru {->} copy list to end (children: parse list {,}) | to end (children: [])]
          (keep reduce [name none weight children])
        ]
      ]
    ]
    foreach [name parent weight children] entries [
      repeat child children [
        set-parent child name
      ]
    ]
  ]
]
tree/init
print [{Part 1:} r1: tree/get-root]

; --- Part 2 ---
tree: make tree [
  correct-weight: 0
  get-correct-weight: does [find-error get-root correct-weight]
  find-error: func [name [string!] /local entry result weights values error delta] [
    entry: tree/get-entry name
    result: entry/3
    weights: collect [
      repeat child entry/4 [result: result + keep find-error child]
    ]
    if all [
      correct-weight == 0
      1 < length? values: unique weights
    ] [
      unless none? find next error: find weights values/1 values/1 [error: find weights values/2]
      delta: error/1 - first exclude values to-block error/1
      correct-weight: (third tree/get-entry pick entry/4 index? error) - delta
    ]
    result
  ]
]
print [{Part 2:} r2: tree/get-correct-weight]
