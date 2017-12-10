REBOL [
  Title: {Day 10}
  Date: 10-12-2017
]

data: read %data/10.txt

; --- Part 1 ---
hash: funct [source [block! string!] /full] [
  offset: 0 iteration: 1 cursor: list: collect [repeat i size: 256 [keep i - 1]]
  if full [iteration: 64 source: append to-binary source to-binary [17 31 73 47 23]]
  loop iteration [
    foreach length source [
      pos: (index? cursor) - 1
      if length > 1 [
        copy-to: (pos + length) // size
        case [
          (diff: copy-to - pos) > 1 [reverse/part cursor diff]
          diff < 1 [
            change cursor copy/part rev: reverse append copy cursor copy/part list copy-to part-length: length? cursor
            change list skip rev part-length
          ]
        ]
      ]
      cursor: skip list (pos + length + offset) // size
      offset: offset + 1
    ]
  ]
  if full [
    list: to-binary collect [loop 16 [value: 0 loop 16 [value: list/1 xor value list: next list] keep value]]
  ]
  list
]

value: hash map-each entry parse data {,} [load entry]
r1: value/1 * value/2
print [{Part 1:} r1]

; --- Part 2 ---
r2: hash/full data
print [{Part 2:} r2]
