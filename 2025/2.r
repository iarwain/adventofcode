REBOL [
  Title: {Day 2}
  Date: 02-12-2025
]

digits: charset {0123456789}
data: collect [
  foreach range split read/string %data/2.txt {,} [
    parse trim/all range [copy start some digits {-} copy stop some digits]
    keep start keep stop
  ]
]

; --- Part 1 ---
r1: 0
foreach [start stop] data [
  prefix: 0 attempt [prefix: to-integer copy/part start 0.5 * length? start]
  start: load start stop: load stop
  until [
    value: load rejoin array/initial 2 prefix
    ++ prefix
    all [value >= start value <= stop r1: r1 + value]
    value >= stop
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach [start stop] data [
  start: load start stop: load s-stop: stop history: copy []
  repeat prefix 1 + load copy/part s-stop 0.5 * (1 + length? s-stop) [
    value: 0 until [
      value: load rejoin [value prefix]
      all [value >= start value > 10]
    ]
    until [
      all [
        value <= stop
        not find history value
        r2: r2 + value
        append history value
      ]
      any [
        test: try [(value: load rejoin [value prefix]) >= stop]
        error? test
      ]
    ]
  ]
]
print [{Part 2:} r2]
