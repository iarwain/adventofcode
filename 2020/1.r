REBOL [
  Title: {Day 1}
  Date: 01-12-2020
]

data: load %data/1.txt

; --- Part 1 ---
r1: do has [lookup] [
  lookup: copy []
  foreach entry data [
    if find lookup (2020 - entry) [
      return entry * (2020 - entry)
    ]
    append lookup entry
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: do has [data2 data3] [
  data: head data
  forall data [
    data2: next data
    forall data2 [
      data3: next data2
      forall data3 [
        if 2020 = (data/1 + data2/1 + data3/1) [
          return data/1 * data2/1 * data3/1
        ]
      ]
    ]
  ]
]
print [{Part 2:} r2]
