REBOL [
  Title: {Day 10}
  Date: 10-12-2020
]

data: load %data/10.txt

; --- Part 1 ---
jolts: [0 0 0] data: next append insert sort data 0 3 + last data
forall data [jolts/(index: data/1 - data/-1): jolts/:index + 1]
r1: jolts/1 * jolts/3
print [{Part 1:} r1]

; --- Part 2 ---
change count: array/initial length? data: head data 0 1.0
for i 2 length? data 1 [
  for j max 1 i - 3 i - 1 1 [
    if data/:j >= (data/:i - 3) [count/:i: count/:i + count/:j]
  ]
]
r2: last count
print [{Part 2:} copy/part r2: form r2 find r2 {.}]
