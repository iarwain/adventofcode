REBOL [
  Title: {Day 1}
  Date: 28-01-2018
]

data: read %data/4.txt

; --- Part 1 ---
r1: 0
until [
  r1: r1 + 1
  hash: checksum/method append copy data r1 'md5
  all [
    0 = hash/1
    0 = hash/2
    0 = shift hash/3 4
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
until [
  r2: r2 + 1
  hash: checksum/method append copy data r2 'md5
  #{000000} = copy/part hash 3
]
print [{Part 2:} r2]
