REBOL [
  Title: {Day 2}
  Date: 02-12-2020
]

data: collect [
  foreach entry read/lines %data/2.txt [
    parse/all entry [
      copy low integer! {-} copy high integer! { } copy letter to {:} thru { } copy password to end
      (keep reduce [load low load high to-char letter password])
    ]
  ]
]

; --- Part 1 ---
r1: 0
foreach [low high letter password] data [
  count: length? remove-each check copy password [check != letter]
  all [
    count >= low
    count <= high
    r1: r1 + 1
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach [low high letter password] data [
  if (password/:low = letter) xor (password/:high = letter) [r2: r2 + 1]
]
print [{Part 2:} r2]
