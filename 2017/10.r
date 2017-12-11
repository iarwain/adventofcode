REBOL [
  Title: {Day 10}
  Date: 10-12-2017
]

data: read %data/10.txt

; --- Part 1 ---
hash: funct [source [block! string!] /full] [
  inc: 0 iteration: 1 cursor: list: collect [repeat i size: 256 [keep i - 1]]
  if full [iteration: 64 source: append to-binary source to-binary [17 31 73 47 23]]
  loop iteration [
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
  if full [list: to-binary collect [loop 16 [value: 0 loop 16 [value: value xor first+ list] keep value]]]
  list
]

value: hash map-each entry parse data {,} [load entry]
r1: value/1 * value/2
print [{Part 1:} r1]

; --- Part 2 ---
r2: hash/full data
print [{Part 2:} r2]
