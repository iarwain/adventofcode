REBOL [
  Title: {Day 7}
  Date: 07-12-2018
]

data: read/lines %data/7.txt

; --- Part 1 ---
sleigh: context [
  plan: parallel: none
  use [steps init chain roots value] [
    steps: copy [] init: copy [] chain: unique collect [
      foreach line data [
        parse line [
          "step" copy src to "must" (src: trim/all src)
          thru "step" copy dst to "can" (dst: trim/all dst)
          (
            keep dst
            either value: select steps src [sort append value dst] [repend steps [src reduce [dst]]]
            either find init dst [init/:dst: init/:dst + 1] [repend init [dst 1]]
          )
        ]
      ]
    ]
    roots: sort collect [
      foreach [src dsts] steps [
        any [find chain src keep src]
      ]
    ]
    use [deps stack] [
      process: funct [step] [
        if children: select steps step [
          foreach child children [
            either 1 = deps/:child [
              append stack child
            ] [
              deps/:child: deps/:child - 1
            ]
          ]
          sort stack
        ]
      ]
      plan: does [
        deps: copy init stack: copy roots
        to-string collect [
          until [
            process keep take stack
            empty? stack
          ]
        ]
      ]
      parallel: has [time free-time worker workers delta] [
        time: 0 deps: copy init stack: copy roots free-time: 100 workers: head insert/dup copy [] reduce [free-time none] 5
        until [
          while [all [not empty? stack worker: find workers free-time]] [
            worker/2: take stack
            worker/1: 61 + worker/2/1 - #"A"
          ]
          time: time + delta: first minimum-of/skip workers 2
          forskip workers 2 [
            if workers/1 != free-time [
              workers/1: workers/1 - delta
              if workers/1 = 0 [
                process workers/2
                workers/1: free-time
                workers/2: none
              ]
            ]
          ]
          all [empty? stack free-time = first minimum-of/skip workers 2]
        ]
        time
      ]
    ]
  ]
]
r1: sleigh/plan
print [{Part 1:} r1]

; --- Part 2 ---
r2: sleigh/parallel
print [{Part 2:} r2]
