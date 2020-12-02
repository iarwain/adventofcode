REBOL [
  Title: {Day 2}
  Date: 02-12-2020
]

data: collect [
  use [entry mini maxi letter password] [
    foreach entry read/lines %data/2.txt [
      parse/all entry [
        copy mini integer! {-} copy maxi integer! { } copy letter to {:} thru { } copy password to end
        (keep reduce [load mini load maxi to-char letter password])
      ]
    ]
  ]
]

; --- Part 1 ---
r1: 0
foreach [mini maxi letter password] data [
  use [count] [
    count: 0 forall password [if password/1 = letter [count: count + 1]]
    all [
      count >= mini
      count <= maxi
      r1: r1 + 1
    ]
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach [mini maxi letter password] data [
  if (password/:mini = letter) xor (password/:maxi = letter) [r2: r2 + 1]
]
print [{Part 2:} r2]
