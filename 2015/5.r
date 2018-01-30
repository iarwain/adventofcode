REBOL [
  Title: {Day 5}
  Date: 29-01-2018
]

data: read/lines %data/5.txt

; --- Part 1 ---
r1: 0
foreach string data [
  vowels: 0 double: false current: {}
  all [
    parse string [
      some [
        before: [{ab} | {cd} | {pq} | {xy}] :before break
      | (prev: current) current: [[{a} | {e} | {i} | {o} | {u}] (vowels: vowels + 1) | skip] (double: double or (prev/1 = current/1))
      ]
    ]
    double
    vowels >= 3
    r1: r1 + 1
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach string data [
  nice: reduce [false false]
  forall string [
    either 3 <= length? string [
      nice/1: nice/1 or (not none? find skip string 2 copy/part string 2)
      nice/2: nice/2 or (string/1 = first skip string 2)
    ] [
      break
    ]
  ]
  all [
    nice/1
    nice/2
    r2: r2 + 1
  ]
]
print [{Part 2:} r2]
