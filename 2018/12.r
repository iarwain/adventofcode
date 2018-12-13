REBOL [
  Title: {Day 12}
  Date: 12-12-2018
]

data: read/lines %data/12.txt

; --- Part 1 ---

greenhouse: context [
  patterns: process: none
  use [init rule] [
    parse data/1 [
      thru {state:} copy init to end (trim/all init)
    ]
    patterns: collect [
      foreach line next data [
        parse line [copy rule to {=> #} (keep trim/all rule)]
      ]
    ]
    process: funct [iterations] [
      history: reduce [copy pots: copy init] offset: 0 iteration: none
      for i 1.0 to-decimal iterations 1.0 [
        offset: offset - 2 new-pots: copy {}
        append insert pots {....} {....}
        repeat index (length? pots) - 4 [
          append new-pots pick [{#} {.}] found? find patterns copy/part at pots index 5
        ]
        if first-pot: find pots: new-pots {#} [
          offset: offset + ((index? first-pot) - 1)
          remove/part pots first-pot
        ]
        clear find/last/tail pots {#}
        either found? find history pots [
          iteration: i
          break
        ] [
          append history copy pots
        ]
      ]
      result: count: 0
      forall pots [
        all [
          pots/1 = #"#"
          count: count + 1
          result: result + offset + (index? pots) - 1
        ]
      ]
      all [
        iteration
        result: head clear back back tail form result + (count * (offset + (50'000'000'000 - iteration)))
      ]
      result
    ]
  ]
]
r1: greenhouse/process 20
print [{Part 1:} r1]

; --- Part 2 ---
r2: greenhouse/process 50'000'000'000
print [{Part 2:} r2]
