REBOL [
  Title: {Day 17}
  Date: 17-12-2017
]

data: load %data/17.txt

; --- Part 1 ---
spin: funct [times [integer!] /after-zero] [
  length: 0 index: 1
  either after-zero [
    after-zero: none
    loop times [
      if (index: ((index + data - 1) // length: length + 1) + 2) == 2 [
        after-zero: length
      ]
    ]
    after-zero
  ] [
    spinlock: make block! [0]
    loop times [
      index: ((index + data - 1) // length: length + 1) + 2
      insert at spinlock index length
    ]
    spinlock
  ]
]

r1: pick find spin 2017 2017 2
print [{Part 1:} r1]

; --- Part 2 ---
r2: spin/after-zero 50'000'000
print [{Part 2:} r2]
