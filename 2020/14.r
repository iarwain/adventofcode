REBOL [
  Title: {Day 14}
  Date: 14-12-2020
]

; This one needs Rebol3-core in order to do integer operations on 64 bits.
data: read/lines %data/14.txt

; --- Part 1 ---
ferry: context [
  init: funct [process [function!]] [
    mem: copy []
    foreach line data [
      parse line [
        [ {mask = } copy mask to end
        | {mem[} copy address to {]} thru {=} copy value to end (process mem address load value mask)
        ]
      ]
    ]
    res: 0 foreach [address value] mem [res: res + value]
  ]
]

r1: ferry/init funct [mem address value mask] [
  new-value: 0 bit: 1 mask: reverse copy mask
  forall mask [
    new-value: new-value + switch mask/1 [
      #"0"  [0]
      #"1"  [bit]
      #"X"  [value and bit]
    ]
    bit: shift bit 1
  ]
  either find mem address [mem/:address: new-value] [append mem reduce [address new-value]]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: ferry/init funct [mem address value mask] [
  mask: reverse copy mask new-mask: copy {} address: load address
  forall mask [
    insert new-mask switch mask/1 [
      #"0"  [address and 1]
      #"1"  [1]
      #"X"  [#"X"]
    ]
    address: shift address -1
  ]
  addresses: reduce [new-mask] count: 0 parse new-mask [some [{X} (count: count + 1) | skip]]
  loop count [addresses: collect [foreach entry addresses [keep reduce [replace copy entry {X} {0} replace copy entry {X} {1}]]]]
  foreach address addresses [either find mem address [mem/:address: value] [append mem reduce [address value]]]
]
print [{Part 2:} r2]
