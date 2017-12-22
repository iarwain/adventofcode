REBOL [
  Title: {Day 14}
  Date: 14-12-2017
]

data: read %data/14.txt

; --- Part 1 ---
defrag: context [
  hash: funct [source [string!]] [
    inc: 0 cursor: list: collect [repeat i size: 256 [keep i - 1]]
    source: append to-binary source to-binary [17 31 73 47 23]
    loop 64 [
      foreach length source [
        offset: (index? cursor) - 1
        diff: (copy-offset: (offset + length) // size) - offset
        case [
          diff > 1 [reverse/part cursor diff]
          diff < 0 [
            change cursor copy/part rev: reverse append copy cursor copy/part list copy-offset part-length: length? cursor
            change list skip rev part-length
          ]
        ]
        cursor: skip list (offset + length + inc) // size
        inc: inc + 1
      ]
    ]
    to-binary collect [loop 16 [value: 0 loop 16 [value: value xor first+ list] keep value]]
  ]
  hashes: collect [
    for i 0 127 1 [
      keep make bitset! hash rejoin [data {-} i]
    ]
  ]
  bit-count?: has [result] [
    result: 0
    foreach h hashes [
      repeat i 128 [if find h i - 1 [result: result + 1]]
    ]
  ]
  grid: use [index] [
    make hash! collect [
      forall hashes [
        index: 0
        for j 0 120 8 [
          for i 7 0 -1 [
            if find hashes/1 i + j [keep as-pair index (index? hashes) - 1]
            index: index + 1
          ]
        ]
      ]
    ]
  ]
  print: funct [/into output [string!]] [
    unless output [output: copy {}]
    repeat j 128 [
      repeat i 128 [
        append output pick [{#} {.}] find grid as-pair i - 1 j - 1
      ]
      append output newline
    ]
    either into [output] [system/words/print output]
  ]
  groups: has [grid-copy connect] [
    grid-copy: copy grid
    connect: funct [pos [hash!] /into output [block!]] [
      any [output output: copy []]
      all [
        append output value: take pos
        foreach a [0x1 0x-1 1x0 -1x0] [
          all [
            pos: find grid-copy value + a
            connect/into pos output
          ]
        ]
      ]
      output
    ]
    collect [
      until [
        keep/only connect grid-copy
        empty? grid-copy
      ]
    ]
  ]
]

; defrag/print
r1: defrag/bit-count?
print [{Part 1:} r1]

; --- Part 2 ---
r2: length? defrag/groups
print [{Part 2:} r2]
