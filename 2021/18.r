REBOL [
  Title: {Day 18}
  Date: 18-12-2021
]

data: load replace/all read %data/18.txt {,} { }

; --- Part 1 ---
snailfish: context [
  sum: largest: none
  use [carry done last explode split process magnitude] [
    carry: done: last: false
    explode: func [data depth] [
      forall data [
        case/all [
          done [return]
          all [
            not carry
            depth >= 4
            block? data/1
            not block? data/1/1
            not block? data/1/2
          ] [
            carry: data/1/2
            all [last last/1: last/1 + data/1/1]
            data: insert remove data 0
          ]
          not tail? data [
            case [
              block? data/1 [explode data/1 depth + 1]
              carry         [data/1: data/1 + carry done: true]
              true          [last: data]
            ]
          ]
        ]
      ]
      any [done carry]
    ]
    split: func [data] [
      forall data [
        case [
          done          [return head data]
          block? data/1 [split data/1]
          data/1 >= 10  [
            change/part/only data reduce [round/floor (data/1 / 2) round/ceiling (data/1 / 2)] 1
            done: true
          ]
        ]
      ]
      done
    ]
    process: func [data] [
      until [
        carry: done: last: false
        any [
          explode data 1
          split data
        ]
        all [not done not carry]
      ]
      data
    ]
    magnitude: func [data] [(3 * either block? data/1 [magnitude data/1] [data/1]) + (2 * either block? data/2 [magnitude data/2] [data/2])]
    sum: funct [] [
      result: take fishes: copy/deep data
      until [
        process result: reduce [result take fishes]
        empty? fishes
      ]
      magnitude result
    ]
    largest: funct [] [
      best: 0
      foreach a data [
        foreach b data [
          if a != b [best: max best magnitude process copy/deep reduce [a b]]
        ]
      ]
      best
    ]
  ]
]

r1: snailfish/sum
print [{Part 1:} r1]

; --- Part 2 ---
r2: snailfish/largest
print [{Part 2:} r2]
